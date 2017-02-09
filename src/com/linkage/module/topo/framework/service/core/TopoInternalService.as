
package com.linkage.module.topo.framework.service.core
{
	import com.linkage.module.topo.framework.Constants;
	import com.linkage.module.topo.framework.Version;
	import com.linkage.module.topo.framework.controller.event.CanvasEvent;
	import com.linkage.module.topo.framework.controller.event.PathChangeEvent;
	import com.linkage.module.topo.framework.controller.event.TopoEvent;
	import com.linkage.module.topo.framework.core.Feature;
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.model.element.line.ILayerLink;
	import com.linkage.module.topo.framework.core.model.element.line.ILink;
	import com.linkage.module.topo.framework.core.model.element.line.ITPLine;
	import com.linkage.module.topo.framework.core.model.element.plane.HLinkTopo;
	import com.linkage.module.topo.framework.core.model.element.plane.IHLinkLayer;
	import com.linkage.module.topo.framework.core.model.element.plane.IHLinkTopo;
	import com.linkage.module.topo.framework.core.model.element.plane.IHLinkUrl;
	import com.linkage.module.topo.framework.core.model.element.plane.ITPComplex;
	import com.linkage.module.topo.framework.core.model.element.plane.ITPGrid;
	import com.linkage.module.topo.framework.core.model.element.plane.ITPGroup;
	import com.linkage.module.topo.framework.core.model.element.plane.ITPShape;
	import com.linkage.module.topo.framework.core.model.element.plane.ITPView;
	import com.linkage.module.topo.framework.core.model.element.point.INode;
	import com.linkage.module.topo.framework.core.model.element.point.ISegment;
	import com.linkage.module.topo.framework.core.model.element.point.ITPObject;
	import com.linkage.module.topo.framework.core.model.element.point.ITPPoint;
	import com.linkage.module.topo.framework.core.model.element.point.ITPText;
	import com.linkage.module.topo.framework.core.model.element.point.Segment;
	import com.linkage.module.topo.framework.core.parser.ElementProperties;
	import com.linkage.module.topo.framework.core.parser.IParserFactory;
	import com.linkage.module.topo.framework.service.Service;
	import com.linkage.module.topo.framework.service.core.mo.TopoPath;
	import com.linkage.module.topo.framework.util.AlarmConstants;
	import com.linkage.module.topo.framework.util.DataUtil;
	import com.linkage.module.topo.framework.util.MessageUtil;
	import com.linkage.module.topo.framework.util.TopoUtil;
	import com.linkage.module.topo.framework.util.loading.ILoadingInfo;
	import com.linkage.module.topo.framework.util.loading.LoadingManager;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;
	import com.linkage.module.topo.framework.view.component.TopoLayer;
	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;
	import com.linkage.system.structure.map.IMap;
	import com.linkage.system.structure.map.Map;
	import com.linkage.system.utils.StringUtils;

	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.setTimeout;

	import mx.effects.IEffectInstance;

	/**
	 * 拓扑内置核心业务类
	 * @author duangr
	 *
	 */
	public class TopoInternalService extends Service
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.service.core.TopoInternalService");
		// loading
		private var _loading:ILoadingInfo = null;
		// 图层切换的业务类
		private var _dataService:IDataService = null;
		// 当前图层之前的图层缓存(后退使用) (含当前图层)
		private var _pathBuffer:Array = [];
		// 当前打开的图层 {id:,name:,type:}
		private var _currentPath:TopoPath = null;

		// ----- 告警相关 -----
		// 告警常量
		private var _alarmConstants:AlarmConstants = AlarmConstants.getInstance();

		// --------- 剪切/复制 容器 ---------
		// 剪切元素id->元素对象的映射
		private var _cutElementMap:IMap = new Map();
		// 复制元素id->元素对象映射
		private var _copyElementMap:IMap = new Map();

		public function TopoInternalService()
		{
			super();
		}

		/**
		 * 图层切换的业务类
		 */
		public function set dataService(service:IDataService):void
		{
			_dataService = service;
		}

		override public function get name():String
		{
			return "拓扑内置核心业务类";
		}

		override public function set attributes(attr:Object):void
		{
		}

		override public function start():void
		{
			if (_dataService == null)
			{
				throw new ArgumentError("TopoInternalService参数异常,必须设置[IDataService]参数!");
			}

			_loading = LoadingManager.getInstance().loadingInfo;

			// 添加扩展属性/删除扩展属性
			topoCanvas.addEventListener(TopoEvent.DEBUG, topoEventHandler_Debug);
			topoCanvas.addEventListener(TopoEvent.SAVE_TEMP_PROPERTY, topoEventHandler_SaveTempProperty);
			topoCanvas.addEventListener(TopoEvent.SAVE_PROPERTY, topoEventHandler_SaveProperty);
			topoCanvas.addEventListener(TopoEvent.CLEAR_PROPERTY, topoEventHandler_ClearProperty);

			// 定位
			topoCanvas.addEventListener(TopoEvent.LOCATE_LAYER_ELEMENT, topoEventHandler_LocateLayerElement);

			// 基本操作
			topoCanvas.addEventListener(TopoEvent.GO_UP, topoEventHandler_GoUp);
			topoCanvas.addEventListener(TopoEvent.GO_DOWN, topoEventHandler_GoDown);
			topoCanvas.addEventListener(TopoEvent.GO_BACK, topoEventHandler_GoBack);
			topoCanvas.addEventListener(TopoEvent.GO_MODEL_VIEW, topoEventHandler_GoModelView);
			topoCanvas.addEventListener(TopoEvent.OPEN_URL, topoEventHandler_OpenUrl);
			topoCanvas.addEventListener(TopoEvent.OPEN_TOPO, topoEventHandler_OpenTopo);
			topoCanvas.addEventListener(TopoEvent.SELECT_ALL, topoEventHandler_SelectAll);
			topoCanvas.addEventListener(TopoEvent.SELECT_UNSELECTED, topoEventHandler_SelectUnSelected);

			topoCanvas.addEventListener(TopoEvent.GROUP_EXPANDED_TOGGLE, topoEventHandler_GroupExpandedToggle);
			topoCanvas.addEventListener(TopoEvent.LINK_EXPANDED_TOGGLE, topoEventHandler_LinkExpandedToggle);
			// 编辑操作
			topoCanvas.addEventListener(TopoEvent.SAVE_TOPO, topoEventHandler_SaveTopo);
			topoCanvas.addEventListener(TopoEvent.CUT, topoEventHandler_Cut);
			topoCanvas.addEventListener(TopoEvent.CANCAL_CUT, topoEventHandler_CancelCut);
			topoCanvas.addEventListener(TopoEvent.PASTE, topoEventHandler_Paste);
			topoCanvas.addEventListener(TopoEvent.COPY, topoEventHandler_Copy);
			topoCanvas.addEventListener(TopoEvent.CANCAL_COPY, topoEventHandler_CancelCopy);
			topoCanvas.addEventListener(TopoEvent.PASTE_COPY, topoEventHandler_PasteCopy);

			topoCanvas.addEventListener(TopoEvent.LOCK_LAYER, topoEventHandler_LockLayer);
			topoCanvas.addEventListener(TopoEvent.UNLOCK_LAYER, topoEventHandler_UnLockLayer);

			topoCanvas.addEventListener(TopoEvent.DELETE_ELEMENTS, topoEventHandler_DeleteElements);
			topoCanvas.addEventListener(TopoEvent.DELETE_CONNECT_LINKS, topoEventHandler_DeleteConnectLinks);
			topoCanvas.addEventListener(TopoEvent.ADD_TO_GROUP, topoEventHandler_AddToGroup);
			topoCanvas.addEventListener(TopoEvent.REMOVE_FROM_GROUP, topoEventHandler_RemoveFromGroup);
			topoCanvas.addEventListener(TopoEvent.DELETE_GROUP, topoEventHandler_DeleteGroup);
			topoCanvas.addEventListener(TopoEvent.CREATE_SEGMENT_MIRROR, topoEventHandler_CreateSegmentMirror);

			// 显示隐藏
			topoCanvas.addEventListener(TopoEvent.VIEW_ELEMENT_ALL, topoEventHandler_ViewElementAll);
			topoCanvas.addEventListener(TopoEvent.VIEW_ELEMENT_VISIABLE, topoEventHandler_ViewElementVisiable);
			topoCanvas.addEventListener(TopoEvent.ELEMENT_VISIABLE_TRUE, topoEventHandler_ElementVisiableTrue);
			topoCanvas.addEventListener(TopoEvent.ELEMENT_VISIABLE_FALSE, topoEventHandler_ElementVisiableFalse);


			_dataService.loadDefaultTopoData(loadTopoReady);
		}

		/**
		 * 保存元素属性
		 * @param topoName
		 * @param element
		 * @param success
		 * @param complete
		 * @param error
		 *
		 */
		private function saveElementExtendProperties(topoName:String, element:IElement, success:Function, complete:Function = null, error:Function = null):void
		{
			var properties:Array = [];
			element.eachExtendProperty(function(key:String, value:String):void
				{
					properties.push(DataUtil.buildPropertyXML(key, value));
				});

			var data:String = DataUtil.buildMapXML(Constants.XML_KEY_ELEMENTXML, "<Elements><Element>" + properties.join("") + "</Element></Elements>");
			data += DataUtil.buildListXML(Constants.XML_KEY_ID, [element.id]);
			data = DataUtil.buildXML(Constants.TP_MC_MODIFY_ELEMENTATTRIBUTE, data);

			loadingStart();
			_dataService.notify(topoName, data, function(result:String):void
				{
					loadingEnd();
					success.call(null, DataUtil.getActionResultMap(new XML(result)));
				}, function():void
				{
					TopoUtil.noParamCallBack(complete);
				}, function():void
				{
					loadingEnd();
					TopoUtil.noParamCallBack(error);
				});
		}

		/**
		 * 加载中提示开始
		 *
		 */
		private function loadingStart():void
		{
			_loading.loadingStart();
		}

		/**
		 * 加载中提示结束
		 *
		 */
		private function loadingEnd():void
		{
			_loading.loadingEnd();
		}

		/**
		 * 重载当前拓扑层次
		 */
		public function loadCurrentTopo():void
		{
			loadingStart();
			_dataService.modifyPosition(function():void
				{
					_dataService.loadTopoData(topoCanvas.topoName, topoCanvas.topoId, topoCanvas.topoType, loadTopoReady, loadingEnd);
				}, null, loadingEnd);
		}

		/**
		 * 后退拓扑层次
		 */
		public function loadBackTopo():void
		{
			var backPath:TopoPath = findBackPath();
			log.debug("图层后退到 {0}", backPath);
			if (backPath)
			{
				loadingStart();
				_dataService.modifyPosition(function():void
					{
						_dataService.loadTopoData(backPath.topoName, backPath.id, backPath.type, loadTopoReady, loadingEnd);
					}, null, loadingEnd);
			}
			else
			{
				MessageUtil.showMessage("已经至顶级视图");
			}
		}

		/**
		 * 校验拓扑数据源的名称
		 * @param topoName 拓扑数据源
		 * @param useCanvasTopoName topoName为空时是否使用画布的topoName
		 * @param type 类型:segment / view
		 * @return
		 *
		 */
		public function checkTopoName(topoName:String, useCanvasTopoName:Boolean = true, type:String = "segment"):String
		{
			if (StringUtils.isNullStr(topoName))
			{
				// 如果当前画布topoName也为空,直接返回空字符串
				if (StringUtils.isNullStr(topoCanvas.topoName))
				{
					topoName = "";
					return topoName;
				}
				// 不使用画布topoName情况下才会置空topoName
				if (useCanvasTopoName)
				{
					topoName = topoCanvas.topoName;
				}
				else
				{
					if (type == "segment")
					{
						topoName = "";
					}
					else
					{
						// 如果时视图,还是要使用 画布的topoName
						topoName = topoCanvas.topoName;
					}
				}

			}
			return topoName;
		}

		/**
		 * 加载指定层次的拓扑
		 * @param id 拓扑对象id
		 * @param topoName 拓扑数据源
		 * @param useCanvasTopoName topoName为空时是否使用画布的topoName
		 * @param type 类型:segment / view
		 *
		 */
		public function loadTopo(id:String, topoName:String = null, useCanvasTopoName:Boolean = true, type:String = "segment"):void
		{
			topoName = checkTopoName(topoName, useCanvasTopoName, type);
			loadingStart();
			_dataService.modifyPosition(function():void
				{
					_dataService.loadTopoData(topoName, id, type, loadTopoReady, loadingEnd);
				}, null, loadingEnd);
		}

		/**
		 * 根据视图模板和参数加载拓扑
		 * @param modelId 模板id
		 * @param modelParams 模板参数,格式为:  key:value#key:value#key:value
		 * @param topoName
		 *
		 */
		public function loadViewModelTopo(modelId:String, modelParams:String, topoName:String = null):void
		{
			topoName = checkTopoName(topoName);
			loadingStart();

			_dataService.modifyPosition(function():void
				{
					_dataService.loadViewModelTopoData(topoName, modelId, modelParams, loadTopoReady, loadingEnd);
				}, null, loadingEnd);
		}

		/**
		 * 加载指定对象的父层拓扑
		 * @param id 拓扑对象id
		 * @param topoName 拓扑数据源
		 * @param useCanvasTopoName topoName为空时是否使用画布的topoName
		 * @param type 类型:segment / view
		 *
		 */
		public function loadParentTopo(id:String, topoName:String = null, useCanvasTopoName:Boolean = true, type:String = "segment"):void
		{
			topoName = checkTopoName(topoName, useCanvasTopoName, type);
			loadingStart();
			_dataService.modifyPosition(function():void
				{
					_dataService.loadParentTopoData(topoName, id, type, loadTopoReady, loadingEnd);
				}, null, loadingEnd);
		}

		/**
		 * 加载指定的拓扑数据
		 * @param data
		 *
		 */
		public function loadTopoXML(data:XML):void
		{
			loadingStart();
			_dataService.modifyPosition(function():void
				{
					loadingEnd();
					loadTopoReady(data);
				});
		}

		/**
		 * 加载指定层次拓扑数据,将返回的数据回调给callback函数
		 * @param callback 参数为 data:XML <br/> 格式为: functin(data:XML):void{ ... }
		 * @param id
		 * @param topoName 拓扑数据源
		 * @param useCanvasTopoName topoName为空时是否使用画布的topoName
		 * @param type
		 *
		 */
		public function loadTopoData(callback:Function, id:String, topoName:String = null, useCanvasTopoName:Boolean = true, type:String = "segment"):void
		{
			topoName = checkTopoName(topoName, useCanvasTopoName, type);
			_dataService.loadTopoData(topoName, id, type, callback);
		}

		/**
		 * 定位网元
		 *
		 * @param id
		 * @param name
		 * @param topoName
		 * @param confirm 切换层次时是否确认提示
		 * @param path 网元的路径
		 * @param success 定位成功后的回调函数,参数为: feature:Feature <br/>
		 * 		例如: function(feature:Feature):void{...}
		 *
		 */
		public function locateElement(id:String, name:String, topoName:String, confirm:Boolean = false, path:String = null, success:Function = null):void
		{
			log.debug("定位元素 id:{0}  name:{1} topoName:{2} path:{3}", id, name, topoName, path);
			// 判断对象是否在当前层次中
			var element:IElement = topoCanvas.findElementById(id);
			if (element != null)
			{
				// 在当前层次中,直接定位
				extrudeElement(element);
			}
			else
			{
				// 不在当前层次,需要切换层次
				if (confirm)
				{
					path = (path == null) ? "" : path + " ";
					MessageUtil.confirm("对象(" + path + name + ")不在当前拓扑层次中,确认要切换层次定位对象吗?", function():void
						{
							loadLocateTopo(id, topoName);
						});
				}
				else
				{
					loadLocateTopo(id, topoName);
				}
			}

			// 加载搜索出来的网元的拓扑
			function loadLocateTopo(id:String, topoName:String):void
			{
				// TODO:对于集客,做特殊处理 (临时性的,对核心代码侵入太大,容易出bug)
				if (StringUtils.startsWith(id, "1/jtkh/custId/") && id.indexOf("/prod/") == -1)
				{
					// 若是集客,直接进入集客网段定位
					topoCanvas.loadTopo(id, topoName);
				}
				else
				{
					topoCanvas.addEventListener(CanvasEvent.LAYER_CHANGED, canvasEventHandler_LayerChanged);
					topoCanvas.loadParentTopo(id, topoName);
				}
			}

			function canvasEventHandler_LayerChanged(event:CanvasEvent):void
			{
				topoCanvas.removeEventListener(CanvasEvent.LAYER_CHANGED, canvasEventHandler_LayerChanged);
				var element:IElement = topoCanvas.findElementById(id);
				if (element != null)
				{
					extrudeElement(element);
				}
				else
				{
					log.error("定位元素[{0}]时未知异常,在 [{1}: {2}] 下没有找到对应元素", id, topoCanvas.topoId, topoCanvas.topoViewName);
				}
			}

			// 突出元素
			function extrudeElement(element:IElement):void
			{
				// 为了解决定位对象后框选不住的情况,若元素还没有完成初始化好,延时定位
				if (!element.feature.creationComplete || topoCanvas.rendering)
				{
					setTimeout(function():void
						{
							extrudeElement(element);
						}, 500);
					return;
				}
				if (element is ITPPoint)
				{
					var tpPoint:ITPPoint = element as ITPPoint;
					// 居中,然后选中
					topoCanvas.viewBounds.updateByCenter(tpPoint.x + topoCanvas.dataBounds.offsetX, tpPoint.y + topoCanvas.dataBounds.offsetY);
					topoCanvas.viewBounds.refresh();
					topoCanvas.setToSelect(tpPoint);
					// ------- 对象还要有发光效果 --------
					var feature:Feature = element.feature;
					var effect:IEffectInstance = feature.effectInstance;
					if (effect)
					{
						effect.end();
					}
					effect = _alarmConstants.searchGlow.createInstance(feature.icon);
					if (effect)
					{
						effect.end();
						effect.play();
					}
					feature.effectInstance = effect;
					// ------- 对象还要有发光效果 end --------
					if (success != null)
					{
						success.call(null, feature);
					}
//					if (highlight)
//					{
//						topoCanvas.dispatchEvent(new TopoEvent(TopoEvent.HIGHTLIGHT_CONNECT, feature));
//					}
				}
				else if (element is ILink)
				{
					var link:ILink = element as ILink;
					topoCanvas.viewBounds.updateByCenter((link.fromElement.x + link.toElement.x) / 2 + topoCanvas.dataBounds.offsetX, (link.fromElement.y + link.toElement.y) / 2 + topoCanvas.dataBounds.
						offsetY);

					topoCanvas.viewBounds.refresh();
					topoCanvas.setToSelect(link);
					if (success != null)
					{
						success.call(null, feature);
					}
				}
				else
				{
					log.error("突出显示对象时异常: {0}", element);
				}
			}
		}

		/**
		 * 保存拓扑(同步对象坐标并且通知数据支撑模块保存)
		 *
		 */
		public function saveTopo():void
		{
			log.info("通知保存拓扑(同步对象坐标并且通知数据支撑模块保存)");
			loadingStart();
			_dataService.modifyPosition(function():void
				{
					_dataService.saveTopo(topoCanvas.topoName, function(flag:Boolean):void
						{
							if (flag)
							{
								// 成功
								topoCanvas.dispatchEvent(new CanvasEvent(CanvasEvent.SAVE_TOPO_SUCCESS));
							}
							else
							{
								// 失败
								var msg:IMap = new Map();
								msg.put(Constants.MAP_KEY_MSG, "保存拓扑失败!");
								topoCanvas.dispatchEvent(new CanvasEvent(CanvasEvent.SAVE_TOPO_FAILURE, null, msg));
							}
						}, loadingEnd, function():void
						{
							// 失败,通信异常
							var msg:IMap = new Map();
							msg.put(Constants.MAP_KEY_MSG, "保存拓扑失败!(通信异常)");
							topoCanvas.dispatchEvent(new CanvasEvent(CanvasEvent.SAVE_TOPO_FAILURE, null, msg));
						});
				});
		}

		/**
		 * 将当前层的拓扑数据重新全部保存(认为之前数据支撑模块中没有数据)
		 * @param topoName
		 * @param curidEnabled 是否使用当前数据中的id作为保存的id
		 * @param resultToCanvas 成功返回的结果是否入库
		 *
		 */
		public function saveTopoLayerAsCurrent(topoName:String, curidEnabled:Boolean = false, resultToCanvas:Boolean = false):void
		{
			topoName = checkTopoName(topoName);

			log.info("将当前层(" + topoCanvas.topoId + ")的拓扑数据重新全部保存(认为之前数据支撑模块中没有数据) @topoName:" + topoName);

			loadingStart();
			saveTopoLayer(topoCanvas.topoId, topoName, topoCanvas, curidEnabled, resultToCanvas, function():void
				{
					topoCanvas.dispatchEvent(new CanvasEvent(CanvasEvent.SAVELAYER_ASCURRENT_SUCCESS));
				}, function():void
				{
					loadingEnd();
				}, function(info:String):void
				{
					var msg:IMap = new Map();
					msg.put(Constants.MAP_KEY_MSG, "保存拓扑数据作为当前层次时失败!" + info);
					topoCanvas.dispatchEvent(new CanvasEvent(CanvasEvent.SAVELAYER_ASCURRENT_FAILURE, null, msg));
				});

		}

		/**
		 * 将当前层的拓扑数据保存到指定pid下面,并且给新层次定义id和name
		 *
		 * @param newId 新定义的层次id
		 * @param newName 新定义的层次名称
		 * @param pid 已经存在的pid
		 * @param topoName 拓扑名称
		 * @param properties 新层次的一些扩展属性
		 * @param curidEnabled 是否使用当前数据中的id作为保存的id
		 * @param resultToCanvas 成功返回的结果是否入库
		 *
		 */
		public function saveTopoLayerAsNew(newId:String, newName:String, pid:String, topoName:String, properties:IMap = null, curidEnabled:Boolean = false, resultToCanvas:Boolean = false):void
		{
			topoName = checkTopoName(topoName);
			log.info("将当前层的拓扑数据保存到指定pid(" + pid + ")下面,并且给新层次定义id(" + newId + ")和name(" + newName + ") @topoName:" + topoName);

			// 【1】先创建一个网段
			var segment:ISegment = new Segment();
			segment.visible = 1;
			segment.x = 600 * Math.random();
			segment.y = 400 * Math.random();
			segment.id = newId;
			segment.name = newName;
			segment.icon = Constants.DEFAULT_SEGMENT_ICON;
			if (properties != null)
			{
				properties.forEach(function(key:*, value:*):void
					{
						segment.addExtendProperty(String(key), String(value));
					});
			}

			var data:String = DataUtil.buildMapXML(Constants.XML_KEY_ELEMENTXML, DataUtil.buildOutputSegments([segment], topoCanvas.parserFactory));
			data += DataUtil.buildMapXML(Constants.XML_KEY_PID, pid);
			data = DataUtil.buildXML(Constants.TP_MC_ADD_SEGMENT, data);
			log.debug("saveAs createSegment: {0}", data);
			loadingStart();
			var msg:IMap = null;
			_dataService.notify(topoName, data, function(result:String):void
				{
					var map:IMap = DataUtil.getActionResultMap(new XML(result));
					if (map.get(Constants.XML_KEY_SUCCESS) == "1")
					{
						// 【2】再把数据保存到网段中
						saveTopoLayer(newId, topoName, topoCanvas, curidEnabled, resultToCanvas, function():void
							{
								topoCanvas.dispatchEvent(new CanvasEvent(CanvasEvent.SAVELAYER_ASNEW_SUCCESS));
							}, function():void
							{
								loadingEnd();
							}, function(info:String):void
							{
								msg = new Map();
								msg.put(Constants.MAP_KEY_MSG, "保存拓扑数据作为新层次时失败! " + info);
								topoCanvas.dispatchEvent(new CanvasEvent(CanvasEvent.SAVELAYER_ASNEW_FAILURE, null, msg));
							});
					}
					else
					{
						loadingEnd();
						msg = new Map();
						msg.put(Constants.MAP_KEY_MSG, "保存拓扑数据作为新层次时失败! " + map.get(Constants.XML_KEY_MSG));
						topoCanvas.dispatchEvent(new CanvasEvent(CanvasEvent.SAVELAYER_ASNEW_FAILURE, null, msg));
					}

				}, function():void
				{
				}, function():void
				{
					loadingEnd();
					msg = new Map();
					msg.put(Constants.MAP_KEY_MSG, "保存拓扑数据作为新层次时失败!(通信异常)");
					topoCanvas.dispatchEvent(new CanvasEvent(CanvasEvent.SAVELAYER_ASNEW_FAILURE, null, msg));
				});
		}

		/**
		 * 将整个拓扑层次中的数据保存到指定pid下面
		 *
		 * @param pid 指定的存放新保存数据的pid
		 * @param topoName 拓扑名称
		 * @param topoLayer 拓扑画布
		 * @param curidEnabled 是否使用当前数据中的id作为保存的id
		 * @param resultToCanvas 成功返回的结果是否入库
		 * @param success 成功后回调函数,无参数<br/> 格式为: functin():void{ ... }
		 * @param complete 不管成功还是失败,都要回调的函数,无参数 <br/> 格式为: functin():void{ ... }
		 * @param error 失败后回调函数,参数为:msg:String<br/> 格式为: functin(msg:String):void{ ... }
		 *
		 */
		private function saveTopoLayer(pid:String, topoName:String, topoLayer:TopoLayer, curidEnabled:Boolean = false, resultToCanvas:Boolean = false, success:Function = null, complete:Function = null,
			error:Function = null):void
		{
			if (topoCanvas.elementSize == 0)
			{
				// 拓扑图中没有要保存的对象,直接返回成功
				log.debug("拓扑图中没有要保存的对象,saveTopoLayer直接返回成功.");
				TopoUtil.noParamCallBack(success);
				TopoUtil.noParamCallBack(complete);
				return;
			}
			var data:String = DataUtil.buildMapXML(Constants.XML_KEY_ELEMENTXML, DataUtil.buildOutputWebtopo(topoLayer, pid));
			data += DataUtil.buildMapXML(Constants.XML_KEY_CURID_ENABLED, String(curidEnabled));
			data = DataUtil.buildXML(Constants.TP_MC_ADD_WEBTOPO, data);
			log.debug("saveTopoLayer " + data);
			_dataService.notify(topoName, data, function(result:String):void
				{
					var map:IMap = DataUtil.getActionResultMap(new XML(result));
					if (map.get(Constants.XML_KEY_SUCCESS) == "1")
					{
						if (resultToCanvas)
						{
							topoCanvas.addDataXML(new XML(map.get(Constants.XML_KEY_ELEMENTXML)));
						}
						TopoUtil.noParamCallBack(success);
					}
					else
					{
						if (error != null)
						{
							error.call(null, map.get(Constants.XML_KEY_MSG));
						}
					}

				}, function():void
				{
					TopoUtil.noParamCallBack(complete);
				}, function():void
				{
					if (error != null)
					{
						error.call(null, "通信异常");
					}
				});
		}

		/**
		 * 将指定列表中的拓扑数据保存到指定的层次下面
		 *
		 * @param pid 指定的层次
		 * @param topoName 拓扑名称
		 * @param elements 待保存的元素列表
		 * @param curidEnabled 是否使用当前数据中的id作为保存的id
		 * @param resultToCanvas 成功返回的结果是否入库
		 *
		 */
		public function saveElements(pid:String, topoName:String, elements:Array, curidEnabled:Boolean = false, resultToCanvas:Boolean = false):void
		{
			log.info("将指定列表(size:" + elements.length + ")中拓扑数据保存到指定pid(" + pid + ")下面 @topoName:" + topoName + " curidEnabled:" + curidEnabled + " resultToCanvas:" + resultToCanvas);
			var nodes:Array = [];
			var segments:Array = [];
			var groups:Array = [];
			var links:Array = [];
			var objects:Array = [];

			elements.forEach(function(element:IElement, index:int, array:Array):void
				{
					// 面
					if (element is IHLinkLayer)
					{
						objects.push(element);
					}
					else if (element is IHLinkUrl)
					{
						objects.push(element);
					}
					else if (element is IHLinkTopo)
					{
						objects.push(element);
					}
					else if (element is ITPView)
					{
						objects.push(element);
					}
					else if (element is ITPGroup)
					{
						groups.push(element);
					}
					else if (element is ITPComplex)
					{
						// 暂时没有独立使用此对象
					}
					else if (element is ITPShape)
					{
						objects.push(element);
					}
					else if (element is ITPGrid)
					{
						objects.push(element);
					}
					// 点
					else if (element is ITPText)
					{
						objects.push(element);
					}
					else if (element is ITPObject)
					{
						objects.push(element);
					}
					else if (element is ISegment)
					{
						segments.push(element);
					}
					else if (element is INode)
					{
						nodes.push(element);
					}
					// 线
					else if (element is ILayerLink)
					{
						links.push(element);
					}
					else if (element is ILink)
					{
						links.push(element);
					}
					else if (element is ITPLine)
					{
						objects.push(element);
					}
				});

			var pf:IParserFactory = topoCanvas.parserFactory;
			var data:String = DataUtil.buildOutputNodes(nodes, pf) + DataUtil.buildOutputSegments(segments, pf) + DataUtil.buildOutputObjects(objects, pf) + DataUtil.buildOutputGroups(groups, pf) + DataUtil.
				buildOutputLinks(links, pf);
			data = DataUtil.buildMapXML(Constants.XML_KEY_ELEMENTXML, DataUtil.buildOutputWebtopoWrapper(data, pid));
			data += DataUtil.buildMapXML(Constants.XML_KEY_CURID_ENABLED, String(curidEnabled));
			data = DataUtil.buildXML(Constants.TP_MC_ADD_WEBTOPO, data);
			loadingStart();
			log.debug("saveElements " + data);
			_dataService.notify(topoName, data, function(result:String):void
				{
					var map:IMap = DataUtil.getActionResultMap(new XML(result));
					if (map.get(Constants.XML_KEY_SUCCESS) == "1")
					{
						if (resultToCanvas)
						{
							topoCanvas.addDataXML(new XML(map.get(Constants.XML_KEY_ELEMENTXML)));
						}
						topoCanvas.dispatchEvent(new CanvasEvent(CanvasEvent.SAVE_ELEMENT_SUCCESS));
					}
					else
					{
						var msg:IMap = new Map();
						msg.put("msg", "保存对象失败!" + map.get(Constants.XML_KEY_MSG));
						topoCanvas.dispatchEvent(new CanvasEvent(CanvasEvent.SAVE_ELEMENT_FAILURE, null, msg));
					}

				}, function():void
				{
					loadingEnd();
				}, function():void
				{
					var msg:IMap = new Map();
					msg.put("msg", "保存对象失败(通信异常)");
					topoCanvas.dispatchEvent(new CanvasEvent(CanvasEvent.SAVE_ELEMENT_FAILURE, null, msg));
				});


		}

		/**
		 * 保存TopoLayer中的Node节点
		 * @param pid
		 * @param topoName
		 * @param topoLayer
		 * @param callback 回调方法,function(succNum:int,failNum:int):void{ ... }
		 *
		 */
		private function saveTopoLayerNodes(pid:String, topoName:String, topoLayer:TopoLayer, callback:Function):void
		{
			var nodes:Vector.<INode> = new Vector.<INode>();
			topoLayer.eachNode(function(id:String, node:INode):void
				{
					nodes.push(node);
				});
			saveNodes(pid, topoName, nodes, callback);
		}

		/**
		 * 保存Node节点
		 *
		 * @param pid
		 * @param topoName
		 * @param nodes
		 * @param callback 回调方法,function(succNum:int,failNum:int):void{ ... }
		 *
		 */
		public function saveNodes(pid:String, topoName:String, nodes:Vector.<INode>, callback:Function):void
		{
			var succNum:int = 0;
			var failNum:int = 0;
			if (nodes == null || nodes.length == 0)
			{
				callback.call(null, succNum, failNum);
				return;
			}

			saveNode(0, afterCallback);

			function afterCallback(index:int, flag:Boolean):void
			{
				if (flag)
				{
					succNum++;
				}
				else
				{
					failNum++;
				}
				// 索引递增,继续处理下一个
				index++;
				if (index == nodes.length)
				{
					// 已经全部保存完成,可以执行后面的回调
					callback.call(null, succNum, failNum);
					return;
				}
				saveNode(index, afterCallback);
			}

			/**
			 * 保存节点
			 * @param index 当前处理到的索引下标
			 * @param callback 回调方法,function(index:int,flag:Boolean):void{ ... }
			 */
			function saveNode(index:int, callback:Function):void
			{
				var node:INode = nodes[index];
				var data:String = DataUtil.buildMapXML(Constants.XML_KEY_ELEMENTXML, DataUtil.buildOutputNodes([node], topoCanvas.parserFactory));
				data += DataUtil.buildMapXML(Constants.XML_KEY_PID, pid);
				data = DataUtil.buildXML(Constants.TP_MC_ADD_DEVICE, data);
				_dataService.notify(topoName, data, function(result:String):void
					{
						var map:IMap = DataUtil.getActionResultMap(new XML(result));
						if (map.get(Constants.XML_KEY_SUCCESS) == "1")
						{
							topoCanvas.addDataXML(new XML(map.get(Constants.XML_KEY_ELEMENTXML)));
							callback.call(null, index, true);
						}
						else
						{
							callback.call(null, index, false);
						}

					}, function():void
					{
					}, function():void
					{
						callback.call(null, index, false);
					});
			}
		}

		/**
		 * 保存TopoLayer中的Segment节点
		 *
		 * @param pid
		 * @param topoName
		 * @param topoLayer
		 * @param callback 回调方法,function(succNum:int,failNum:int):void{ ... }
		 *
		 */
		private function saveTopoLayerSegments(pid:String, topoName:String, topoLayer:TopoLayer, callback:Function):void
		{
			var segments:Vector.<ISegment> = new Vector.<ISegment>();
			topoLayer.eachNode(function(id:String, segment:ISegment):void
				{
					segments.push(segment);
				});
			saveSegments(pid, topoName, segments, callback);
		}

		/**
		 * 保存Segment节点
		 *
		 * @param pid
		 * @param topoName
		 * @param segments
		 * @param callback 回调方法,function(succNum:int,failNum:int):void{ ... }
		 *
		 */
		public function saveSegments(pid:String, topoName:String, segments:Vector.<ISegment>, callback:Function):void
		{
			var succNum:int = 0;
			var failNum:int = 0;
			if (segments == null || segments.length == 0)
			{
				callback.call(null, succNum, failNum);
				return;
			}

			saveSegment(0, afterCallback);

			function afterCallback(index:int, flag:Boolean):void
			{
				if (flag)
				{
					succNum++;
				}
				else
				{
					failNum++;
				}
				// 索引递增,继续处理下一个
				index++;
				if (index == segments.length)
				{
					// 已经全部保存完成,可以执行后面的回调
					callback.call(null, succNum, failNum);
					return;
				}
				saveSegment(index, afterCallback);
			}

			/**
			 * 保存网段
			 * @param index 当前处理到的索引下标
			 * @param callback 回调方法,function(index:int,flag:Boolean):void{ ... }
			 */
			function saveSegment(index:int, callback:Function):void
			{
				var segment:ISegment = segments[index];
				var data:String = DataUtil.buildMapXML(Constants.XML_KEY_ELEMENTXML, DataUtil.buildOutputSegments([segment], topoCanvas.parserFactory));
				data += DataUtil.buildMapXML(Constants.XML_KEY_PID, pid);
				data = DataUtil.buildXML(Constants.TP_MC_ADD_SEGMENT, data);
				_dataService.notify(topoName, data, function(result:String):void
					{
						var map:IMap = DataUtil.getActionResultMap(new XML(result));
						if (map.get(Constants.XML_KEY_SUCCESS) == "1")
						{
							topoCanvas.addDataXML(new XML(map.get(Constants.XML_KEY_ELEMENTXML)));
							callback.call(null, index, true);
						}
						else
						{
							callback.call(null, index, false);
						}

					}, function():void
					{
					}, function():void
					{
						callback.call(null, index, false);
					});
			}
		}

		/**
		 * 保存 TopoLayer中的 Object节点
		 *
		 * @param pid
		 * @param topoName
		 * @param topoLayer
		 * @param callback 回调方法,function(succNum:int,failNum:int):void{ ... }
		 *
		 */
		private function saveTopoLayerObjects(pid:String, topoName:String, topoLayer:TopoLayer, callback:Function):void
		{
			var objects:Vector.<IElement> = new Vector.<IElement>();
			topoLayer.eachObject(function(id:String, element:IElement):void
				{
					objects.push(element);
				});
			saveObjects(pid, topoName, objects, callback);
		}

		/**
		 * 保存 Object 节点
		 * @param pid
		 * @param topoName
		 * @param objects
		 * @param callback 回调方法,function(succNum:int,failNum:int):void{ ... }
		 *
		 */
		public function saveObjects(pid:String, topoName:String, objects:Vector.<IElement>, callback:Function):void
		{
			var succNum:int = 0;
			var failNum:int = 0;
			if (objects == null || objects.length == 0)
			{
				callback.call(null, succNum, failNum);
				return;
			}

			saveObject(0, afterCallback);

			function afterCallback(index:int, flag:Boolean):void
			{
				if (flag)
				{
					succNum++;
				}
				else
				{
					failNum++;
				}
				// 索引递增,继续处理下一个
				index++;
				if (index == objects.length)
				{
					// 已经全部保存完成,可以执行后面的回调
					callback.call(null, succNum, failNum);
					return;
				}
				saveObject(index, afterCallback);
			}

			/**
			 * 保存object对象
			 * @param index 当前处理到的索引下标
			 * @param callback 回调方法,function(index:int,flag:Boolean):void{ ... }
			 */
			function saveObject(index:int, callback:Function):void
			{
				var object:IElement = objects[index];
				var data:String = DataUtil.buildMapXML(Constants.XML_KEY_ELEMENTXML, DataUtil.buildOutputObjects([object], topoCanvas.parserFactory));
				data += DataUtil.buildMapXML(Constants.XML_KEY_PID, pid);
				data = DataUtil.buildXML(Constants.TP_MC_ADD_OBJECT, data);
				_dataService.notify(topoName, data, function(result:String):void
					{
						var map:IMap = DataUtil.getActionResultMap(new XML(result));
						if (map.get(Constants.XML_KEY_SUCCESS) == "1")
						{
							topoCanvas.addDataXML(new XML(map.get(Constants.XML_KEY_ELEMENTXML)));
							callback.call(null, index, true);
						}
						else
						{
							callback.call(null, index, false);
						}

					}, function():void
					{
					}, function():void
					{
						callback.call(null, index, false);
					});
			}
		}

		/**
		 * 保存 TopoLayer 中的 Group 节点
		 * @param pid
		 * @param topoName
		 * @param topoLayer
		 * @param callback 回调方法,function(succNum:int,failNum:int):void{ ... }
		 *
		 */
		private function saveTopoLayerGroups(pid:String, topoName:String, topoLayer:TopoLayer, callback:Function):void
		{
			var groups:Vector.<ITPGroup> = new Vector.<ITPGroup>();
			topoLayer.eachGroup(function(id:String, group:ITPGroup):void
				{
					groups.push(group);
				});
			saveGroups(pid, topoName, groups, callback);
		}

		/**
		 * 保存 Group节点
		 * @param pid
		 * @param topoName
		 * @param groups
		 * @param callback 回调方法,function(succNum:int,failNum:int):void{ ... }
		 *
		 */
		public function saveGroups(pid:String, topoName:String, groups:Vector.<ITPGroup>, callback:Function):void
		{
			var succNum:int = 0;
			var failNum:int = 0;
			if (groups == null || groups.length == 0)
			{
				callback.call(null, succNum, failNum);
				return;
			}

			saveGroup(0, afterCallback);

			function afterCallback(index:int, flag:Boolean):void
			{
				if (flag)
				{
					succNum++;
				}
				else
				{
					failNum++;
				}
				// 索引递增,继续处理下一个
				index++;
				if (index == groups.length)
				{
					// 已经全部保存完成,可以执行后面的回调
					callback.call(null, succNum, failNum);
					return;
				}
				saveGroup(index, afterCallback);
			}

			/**
			 * 保存Group
			 * @param index 当前处理到的索引下标
			 * @param callback 回调方法,function(index:int,flag:Boolean):void{ ... }
			 */
			function saveGroup(index:int, callback:Function):void
			{
				var group:ITPGroup = groups[index];
				var data:String = DataUtil.buildMapXML(Constants.XML_KEY_ELEMENTXML, DataUtil.buildOutputGroups([group], topoCanvas.parserFactory));
				data += DataUtil.buildMapXML(Constants.XML_KEY_PID, pid);
				data = DataUtil.buildXML(Constants.TP_MC_ADD_GROUP, data);
				_dataService.notify(topoName, data, function(result:String):void
					{
						var map:IMap = DataUtil.getActionResultMap(new XML(result));
						if (map.get(Constants.XML_KEY_SUCCESS) == "1")
						{
							topoCanvas.addDataXML(new XML(map.get(Constants.XML_KEY_ELEMENTXML)));
							callback.call(null, index, true);
						}
						else
						{
							callback.call(null, index, false);
						}

					}, function():void
					{
					}, function():void
					{
						callback.call(null, index, false);
					});
			}
		}

		/**
		 * 保存 TopoLayer中的 Link节点
		 * @param pid
		 * @param topoName
		 * @param topoLayer
		 * @param callback 回调方法,function(succNum:int,failNum:int):void{ ... }
		 *
		 */
		private function saveTopoLayerLinks(pid:String, topoName:String, topoLayer:TopoLayer, callback:Function):void
		{
			var links:Vector.<ILink> = new Vector.<ILink>();
			topoLayer.eachLink(function(id:String, link:ILink):void
				{
					links.push(link);
				});
			saveLinks(pid, topoName, links, callback);
		}

		/**
		 * 保存 Link 对象
		 * @param pid
		 * @param topoName
		 * @param links
		 * @param callback 回调方法,function(succNum:int,failNum:int):void{ ... }
		 *
		 */
		public function saveLinks(pid:String, topoName:String, links:Vector.<ILink>, callback:Function):void
		{
			var succNum:int = 0;
			var failNum:int = 0;
			if (links == null || links.length == 0)
			{
				callback.call(null, succNum, failNum);
				return;
			}

			saveLink(0, afterCallback);

			function afterCallback(index:int, flag:Boolean):void
			{
				if (flag)
				{
					succNum++;
				}
				else
				{
					failNum++;
				}
				// 索引递增,继续处理下一个
				index++;
				if (index == links.length)
				{
					// 已经全部保存完成,可以执行后面的回调
					callback.call(null, succNum, failNum);
					return;
				}
				saveLink(index, afterCallback);
			}

			/**
			 * 保存 链路
			 * @param index 当前处理到的索引下标
			 * @param callback 回调方法,function(index:int,flag:Boolean):void{ ... }
			 */
			function saveLink(index:int, callback:Function):void
			{
				var link:ILink = links[index];
				var data:String = DataUtil.buildMapXML(Constants.XML_KEY_ELEMENTXML, DataUtil.buildOutputLinks([link], topoCanvas.parserFactory));
				data += DataUtil.buildMapXML(Constants.XML_KEY_PID, pid);
				data = DataUtil.buildXML(Constants.TP_MC_ADD_LINK, data);
				_dataService.notify(topoName, data, function(result:String):void
					{
						var map:IMap = DataUtil.getActionResultMap(new XML(result));
						if (map.get(Constants.XML_KEY_SUCCESS) == "1")
						{
							topoCanvas.addDataXML(new XML(map.get(Constants.XML_KEY_ELEMENTXML)));
							callback.call(null, index, true);
						}
						else
						{
							callback.call(null, index, false);
						}

					}, function():void
					{
					}, function():void
					{
						callback.call(null, index, false);
					});
			}
		}

		// --------------------------- 捕获事件 ----------------------------- //

		// 【调试信息】
		private function topoEventHandler_Debug(event:TopoEvent):void
		{
			var info:Array = [];
			if (event.feature)
			{
				event.feature.element.eachProperty(eachProperty);
				info.push("------------");
				info.push("拓扑要素 = " + event.feature);
			}
			else
			{
				topoCanvas.eachProperty(eachProperty);
				info.push("------------");
				info.push("Version = " + Version.info);
				info.push("画布 = " + topoCanvas);
			}

			MessageUtil.showMessage(info.join("\n"));

			function eachProperty(key:String, value:String):void
			{
				info.push(key + " = " + value);
			}

		}

		// 【将临时属性保存到画布中】
		private function topoEventHandler_SaveTempProperty(event:TopoEvent):void
		{
			event.properties.forEach(function(key:String, value:String):void
				{
					topoCanvas.addExtendProperty(key, value);
				});
		}

		// 【将属性保存到画布中】
		private function topoEventHandler_SaveProperty(event:TopoEvent):void
		{
			event.properties.forEach(function(key:String, value:String):void
				{
					topoCanvas.addInternalProperty(key, value);
				});
		}

		// 【从画布中删除指定的属性】
		private function topoEventHandler_ClearProperty(event:TopoEvent):void
		{
			log.debug("清除指定的属性..: {0}", event.properties);
			event.properties.forEach(function(key:String, value:String):void
				{
					log.debug("清除指定的属性: {0}", key);
					topoCanvas.removeInternalProperty(key);
					topoCanvas.removeExtendProperty(key);
				});
		}

		// 【定位缩略图中的对象】
		private function topoEventHandler_LocateLayerElement(event:TopoEvent):void
		{
			var layerId:String = event.getProperty("layerId");
			var elementId:String = event.getProperty("elementId");
			var layer:IHLinkLayer = topoCanvas.findElementById(layerId) as IHLinkLayer;
			if (layer)
			{
				// 先切换拓扑,再定位对象
				topoCanvas.addEventListener(CanvasEvent.LAYER_CHANGED, afterTopoLoaded);
				loadTopo(layer.linkId, layer.getExtendProperty(ElementProperties.OBJECT_TOPO_TOPONAME));
			}

			// 拓扑加载完毕之后,定位网元
			function afterTopoLoaded(event:CanvasEvent):void
			{
				topoCanvas.removeEventListener(CanvasEvent.LAYER_CHANGED, afterTopoLoaded);
				var element:IElement = topoCanvas.findElementById(elementId);
				if (element)
				{
					locateElement(element.id, element.name, topoCanvas.topoName);
				}
			}
		}

		// 【返回上一层】
		private function topoEventHandler_GoUp(event:TopoEvent):void
		{
			loadParentTopo(event.getProperty("id"), event.getProperty("type"));
		}

		// 【进入下一层】
		private function topoEventHandler_GoDown(event:TopoEvent):void
		{
			loadTopo(event.getProperty("id"), event.getProperty("topoName"), event.getProperty("type"));
		}

		// 【返回上一级(后退)】
		private function topoEventHandler_GoBack(event:TopoEvent):void
		{
			loadBackTopo();
		}

		// 【根据视图模板加载拓扑数据】
		private function topoEventHandler_GoModelView(event:TopoEvent):void
		{
			loadViewModelTopo(event.getProperty("modelId"), event.getProperty("params"), event.getProperty("topoName"));
		}

		// 【保存拓扑】
		private function topoEventHandler_SaveTopo(event:TopoEvent):void
		{
			MessageUtil.confirm("确认要保存拓扑吗?", function():void
				{
					saveTopo();
				});
		}

		// 【剪切】
		private function topoEventHandler_Cut(event:TopoEvent):void
		{
			var features:Array = event.features;
			if (features == null || features.length == 0)
			{
				return;
			}
			features.forEach(function(feature:Feature, index:int, array:Array):void
				{
					_cutElementMap.put(feature.element.id, feature.element);
				});
			topoCanvas.addInternalProperty(Constants.PROPERTY_CANVAS_HASCUT, "true");
		}

		// 【取消粘帖】
		private function topoEventHandler_CancelCut(event:TopoEvent):void
		{
			_cutElementMap.clear();
			topoCanvas.addInternalProperty(Constants.PROPERTY_CANVAS_HASCUT, "false");
		}

		// 【粘帖】
		private function topoEventHandler_Paste(event:TopoEvent):void
		{
			var ids:Array = [];
			_cutElementMap.forEach(function(id:String, element:IElement):void
				{
					ids.push(id);
					// 此处要判断是否是分组,若是分组,需要将里面的对象都一起剪切过去
					if (element is ITPGroup)
					{
						(element as ITPGroup).eachChild(function(childId:String, childElement:ITPPoint):void
							{
								ids.push(childId);
							});
					}
				});
			_cutElementMap.clear();
			topoCanvas.addInternalProperty(Constants.PROPERTY_CANVAS_HASCUT, "false");
			if (ids.length == 0)
			{
				return;
			}
			_dataService.modifyLayer(topoCanvas.topoName, topoCanvas.topoId, event.mousePoint, ids.join(","), function():void
				{
					loadCurrentTopo();
				});
		}

		// 【复制】
		private function topoEventHandler_Copy(event:TopoEvent):void
		{
			var features:Array = event.features;
			if (features == null || features.length == 0)
			{
				return;
			}
			features.forEach(function(feature:Feature, index:int, array:Array):void
				{
					_copyElementMap.put(feature.element.id, feature.element);
				});
			topoCanvas.addInternalProperty(Constants.PROPERTY_CANVAS_HASCOPY, "true");
		}

		// 【取消复制】
		private function topoEventHandler_CancelCopy(event:TopoEvent):void
		{
			_copyElementMap.clear();
			topoCanvas.addInternalProperty(Constants.PROPERTY_CANVAS_HASCOPY, "false");
		}

		// 【粘贴复制】
		private function topoEventHandler_PasteCopy(event:TopoEvent):void
		{
			var ids:Array = [];
			_copyElementMap.forEach(function(id:String, element:IElement):void
				{
					ids.push(id);
					// 此处要判断是否是分组,若是分组,需要将里面的对象都一起剪切过去
					if (element is ITPGroup)
					{
						(element as ITPGroup).eachChild(function(childId:String, childElement:ITPPoint):void
							{
								ids.push(childId);
							});
					}
				});
			_copyElementMap.clear();
			topoCanvas.addInternalProperty(Constants.PROPERTY_CANVAS_HASCOPY, "false");
			if (ids.length == 0)
			{
				return;
			}

			var data:String = DataUtil.buildMapXML(Constants.XML_KEY_PID, topoCanvas.topoId);
			data += DataUtil.buildMapXML(Constants.XML_KEY_X, int(event.mousePoint.x));
			data += DataUtil.buildMapXML(Constants.XML_KEY_Y, int(event.mousePoint.y));
			data += DataUtil.buildListXML(Constants.XML_KEY_OBJIDS, ids);
			// 此处要判断下是否在视图中复制,主题不同
			switch (topoCanvas.topoType)
			{
				case ElementProperties.PROPERTYVALUE_NETVIEW_TYPE_VIEW:
					data = DataUtil.buildXML(Constants.TP_MC_PASTE_COPY_INVIEW, data);
					break;
				case ElementProperties.PROPERTYVALUE_NETVIEW_TYPE_SEGMENT:
				default:
					data = DataUtil.buildXML(Constants.TP_MC_PASTE_COPY, data);
					break;
			}
			log.debug("pasteCopy: {0}", data);
			loadingStart();
			_dataService.notify(topoCanvas.topoName, data, function(result:String):void
				{
					var map:IMap = DataUtil.getActionResultMap(new XML(result));
					if (map.get(Constants.XML_KEY_SUCCESS) == "1")
					{
						loadCurrentTopo();
					}
					else
					{
						MessageUtil.showMessage("复制对象失败!\n\n(" + map.get(Constants.XML_KEY_MSG) + ")");
					}
				}, function():void
				{
					loadingEnd();
				}, function():void
				{
					MessageUtil.showMessage("复制对象失败!(通信异常)");
				});
		}

		// 【锁定当前层】
		private function topoEventHandler_LockLayer(event:TopoEvent):void
		{
			var element:IElement = event.feature.element;

			MessageUtil.confirm("锁定后云图中的对象将不能拖动和布局\n是否继续锁定?", function():void
				{
					element.addExtendProperty(Constants.PROPERTY_CANVAS_ISLOCKED, "true");

					saveElementExtendProperties(topoCanvas.topoName, element, function(map:IMap):void
						{
							if (map.get(Constants.XML_KEY_SUCCESS) == "1")
							{
								MessageUtil.showMessage("锁定云图成功!");
							}
							else
							{
								MessageUtil.showMessage("锁定云图失败!\n\n(" + map.get(Constants.XML_KEY_MSG) + ")");
							}
						}, function():void
						{
						}, function():void
						{
							MessageUtil.showMessage("锁定云图失败!(通信异常)");
						});
				});
		}

		// 【解锁当前层】
		private function topoEventHandler_UnLockLayer(event:TopoEvent):void
		{
			var element:IElement = event.feature.element;
			MessageUtil.confirm("解锁后云图中的对象将可以拖动和布局\n是否继续解锁?", function():void
				{
					element.addExtendProperty(Constants.PROPERTY_CANVAS_ISLOCKED, "false");

					saveElementExtendProperties(topoCanvas.topoName, element, function(map:IMap):void
						{
							if (map.get(Constants.XML_KEY_SUCCESS) == "1")
							{
								MessageUtil.showMessage("解锁云图成功!");
							}
							else
							{
								MessageUtil.showMessage("解锁云图失败!\n\n(" + map.get(Constants.XML_KEY_MSG) + ")");
							}
						}, function():void
						{
						}, function():void
						{
							MessageUtil.showMessage("解锁云图失败!(通信异常)");
						});
				});
		}

		// 【打开URL】
		private function topoEventHandler_OpenUrl(event:TopoEvent):void
		{
			navigateToURL(new URLRequest(event.getProperty("url")));
		}

		// 【打开拓扑内部链接】
		private function topoEventHandler_OpenTopo(event:TopoEvent):void
		{
			var id:String = event.getProperty("id");
			var topoName:String = event.getProperty("topoName");
			var type:String = event.getProperty("type");
			var openType:String = event.getProperty("openType");
			var urlPrefix:String = event.getProperty("urlPrefix");

			switch (openType)
			{
				case ElementProperties.PROPERTYVALUE_OBJECT_TOPO_OPENTYPE_NEW:
					navigateToURL(new URLRequest(urlContext + urlPrefix + "?id=" + id + "&topoName=" + topoName + "&type=" + type))
					break;
				case ElementProperties.PROPERTYVALUE_OBJECT_TOPO_OPENTYPE_THIS:
				default:
					topoEventHandler_GoDown(event);
					break;
			}
		}

		// 【全选网元】
		private function topoEventHandler_SelectAll(event:TopoEvent):void
		{
			topoCanvas.selectAll();
		}

		// 【反选网元】
		private function topoEventHandler_SelectUnSelected(event:TopoEvent):void
		{
			topoCanvas.selectUnSelected();
		}

		// 【分组展开闭合切换】
		private function topoEventHandler_GroupExpandedToggle(event:TopoEvent):void
		{
			var group:ITPGroup = event.feature.element as ITPGroup;
			if (group)
			{
				group.expanded = !group.expanded;
				group.feature.refresh();
			}

		}

		// 【链路展开闭合切换】
		private function topoEventHandler_LinkExpandedToggle(event:TopoEvent):void
		{
			var link:ILink = event.feature.element as ILink;
			if (link)
			{
				link.expanded = !link.expanded;
				link.feature.refresh();
			}
		}

		// 【删除元素】
		private function topoEventHandler_DeleteElements(event:TopoEvent):void
		{
			var features:Array = event.features;
			if (features == null || features.length == 0)
			{
				return;
			}
			var elements:IMap = new Map();
			features.forEach(function(feature:Feature, index:int, array:Array):void
				{
					elements.put(feature.element.id, feature.element);
				});
			MessageUtil.confirm("确认要删除对象吗?", function():void
				{
					deleteElements(elements);
				});

		}

		// 【删除一批对象之间相互关联的链路,若只有一个对象的话删除对象的全部关联链路】
		private function topoEventHandler_DeleteConnectLinks(event:TopoEvent):void
		{
			var features:Array = event.features;
			if (features == null || features.length == 0)
			{
				return;
			}
			var delLinks:IMap = new Map();
			if (features.length == 1)
			{
				// 只有一个对象,删除这一个对象的全部关联链路
				var element:ITPPoint = (features[0] as Feature).element as ITPPoint;
				if (element)
				{
					element.eachLinks(function(link:ILink):void
						{
							delLinks.put(link.id, link);
						});
				}
				if (delLinks.isEmpty())
				{
					MessageUtil.showMessage("此对象没有关联链路.");
				}
				else
				{
					MessageUtil.confirm("确认要删除与此对象关联的全部链路吗(数量:" + delLinks.size + ")?", function():void
						{
							deleteElements(delLinks);
						});
				}
			}
			else
			{
				//删除两两对象间的链路
				var tpPointMap:IMap = new Map();
				features.forEach(function(feature:Feature, index:int, array:Array):void
					{
						var element:IElement = feature.element;
						if (element is ITPPoint)
						{
							tpPointMap.put(element.id, element);
						}
					});
				// 找到两两网元之间的链路
				tpPointMap.forEach(function(id:String, tpPoint:ITPPoint):void
					{
						tpPoint.outLines.forEach(function(link:ILink, index:int, array:Array):void
							{
								if (tpPointMap.get(link.toElement.id) != null)
								{
									delLinks.put(link.id, link);
								}
							});
						tpPoint.inLines.forEach(function(link:ILink, index:int, array:Array):void
							{
								if (tpPointMap.get(link.fromElement.id) != null)
								{
									delLinks.put(link.id, link);
								}
							});
					});
				if (delLinks.isEmpty())
				{
					MessageUtil.showMessage("两两对象之间没有关联链路.");
				}
				else
				{
					MessageUtil.confirm("确认要删除两两对象之间的链路吗(数量:" + delLinks.size + ")?", function():void
						{
							deleteElements(delLinks);
						});
				}
			}
		}

		// 删除一批对象
		private function deleteElements(elements:IMap):void
		{
			if (elements == null || elements.isEmpty())
			{
				log.warn("无对象可供删除.");
				return;
			}
			var ids:Array = [];

			elements.forEach(function(id:String, element:IElement):void
				{
					ids.push(id);
				});

			var data:String = DataUtil.buildListXML(Constants.XML_KEY_ID, ids);
			data += DataUtil.buildMapXML(Constants.XML_KEY_PID, topoCanvas.topoId);
			// 此处要判断下是否在视图中复制,主题不同
			switch (topoCanvas.topoType)
			{
				case ElementProperties.PROPERTYVALUE_NETVIEW_TYPE_VIEW:
					data = DataUtil.buildXML(Constants.TP_MC_REMOVE_ELEMENTS_FROM_TOPOVIEW, data);
					break;
				case ElementProperties.PROPERTYVALUE_NETVIEW_TYPE_SEGMENT:
				default:
					data = DataUtil.buildXML(Constants.TP_MC_REMOVE_ELEMENTS, data);
					break;
			}
			loadingStart();
			_dataService.notify(topoCanvas.topoName, data, function(result:String):void
				{
					var map:IMap = DataUtil.getActionResultMap(new XML(result));
					if (map.get(Constants.XML_KEY_SUCCESS) == "1")
					{
						elements.forEach(function(id:String, element:IElement):void
							{
								topoCanvas.removeTopoElement(element);
							});
					}
					else
					{
						MessageUtil.showMessage("删除对象失败!\n\n(" + map.get(Constants.XML_KEY_MSG) + ")");
					}
				}, loadingEnd, function():void
				{
					MessageUtil.showMessage("删除对象失败!(通信异常)");
				});
		}

		// 【添加元素到分组中】
		private function topoEventHandler_AddToGroup(event:TopoEvent):void
		{
			var tpGroup:ITPGroup = event.feature.element as ITPGroup;
			if (tpGroup == null)
			{
				return;
			}
			var elements:Array = event.getProperty("elements");
			MessageUtil.confirm("是否移动元素到组里面?", function():void
				{
					var objids:Array = [];
					elements.forEach(function(item:ITPPoint, index:int, array:Array):void
						{
							objids.push(item.id);
						});
					log.debug("group = {0} objids = {1}", tpGroup, objids);

					var data:String = DataUtil.buildMapXML(Constants.XML_KEY_ID, tpGroup.id);
					data += DataUtil.buildListXML(Constants.XML_KEY_OBJIDS, objids);
					data = DataUtil.buildXML(Constants.TP_MC_ADD_ELEMENTS_TO_GROUP, data);
					log.debug("AddToGroup: {0}", data);

					loadingStart();
					_dataService.notify(topoCanvas.topoName, data, function(result:String):void
						{
							loadingEnd();
							var map:IMap = DataUtil.getActionResultMap(new XML(result));
							if (map.get(Constants.XML_KEY_SUCCESS) == "1")
							{
								elements.forEach(function(item:ITPPoint, index:int, array:Array):void
									{
										tpGroup.addChild(item.id, item);
										topoCanvas.removeElement(item.feature);
										item.feature.refresh();
									});
								tpGroup.feature.refresh();
							}
							else
							{
								MessageUtil.showMessage("移动元素到分组失败!\n\n(" + map.get(Constants.XML_KEY_MSG) + ")");
							}
						}, function():void
						{
							loadingEnd();
						}, function():void
						{
							MessageUtil.showMessage("移动元素到分组失败!(通信异常)");
						});
				});
		}

		// 【从分组中移除元素】
		private function topoEventHandler_RemoveFromGroup(event:TopoEvent):void
		{
			var group:ITPGroup = null;
			var elements:Array = [];
			var elementIds:Array = [];
			if (event.features.every(function(feature:Feature, index:int, array:Array):Boolean
				{
					var tpPoint:ITPPoint = feature.element as ITPPoint;
					if (tpPoint == false)
					{
						return true;
					}
					if (index == 0)
					{
						group = tpPoint.groupOwner;
					}
					elements.push(tpPoint);
					elementIds.push(tpPoint.id);
					return group.id == tpPoint.groupOwner.id;
				}) == false)
			{
				MessageUtil.showMessage("请选择同一个分组中的对象进行移除");
				return;
			}
			if (elements.length == 0)
			{
				MessageUtil.showMessage("请先选择对象");
				return;
			}
			MessageUtil.confirm("确认是否将节点从组中删除?", function():void
				{
					var data:String = DataUtil.buildMapXML(Constants.XML_KEY_ID, group.id);
					data += DataUtil.buildListXML(Constants.XML_KEY_OBJIDS, elementIds);
					data = DataUtil.buildXML(Constants.TP_MC_REMOVE_ELEMENTS_FROM_GROUP, data);
					log.debug("RemoveFromGroup: {0}", data);

					loadingStart();
					_dataService.notify(topoCanvas.topoName, data, function(result:String):void
						{
							loadingEnd();
							var map:IMap = DataUtil.getActionResultMap(new XML(result));
							if (map.get(Constants.XML_KEY_SUCCESS) == "1")
							{
								elements.forEach(function(element:IElement, index:int, array:Array):void
									{
										group.removeChild(element.id);
										topoCanvas.addElement(element.feature);
										element.feature.refresh();
									});
								group.feature.refresh();
							}
							else
							{
								MessageUtil.showMessage("从组中删除节点失败!\n\n(" + map.get(Constants.XML_KEY_MSG) + ")");
							}
						}, function():void
						{
							loadingEnd();
						}, function():void
						{
							MessageUtil.showMessage("从组中删除节点失败!(通信异常)");
						});
				});
		}

		// 【解散分组】
		private function topoEventHandler_DeleteGroup(event:TopoEvent):void
		{
			var features:Array = event.features;
			if (features == null || features.length == 0)
			{
				return;
			}
			var elementIds:Array = new Array();
			features.forEach(function(feature:Feature, index:int, array:Array):void
				{
					elementIds.push(feature.element.id);
				});
			MessageUtil.confirm("确认要解散分组吗?", function():void
				{
					var data:String = DataUtil.buildListXML(Constants.XML_KEY_ID, elementIds);
					loadingStart();
					_dataService.notify(topoCanvas.topoName, DataUtil.buildXML(Constants.TP_MC_REMOVE_ELEMENTS, data), function(result:String):void
						{
							var map:IMap = DataUtil.getActionResultMap(new XML(result));
							if (map.get(Constants.XML_KEY_SUCCESS) == "1")
							{
								features.forEach(function(feature:Feature, index:int, array:Array):void
									{
										loadCurrentTopo();
									});
							}
							else
							{
								MessageUtil.showMessage("解散分组失败!\n\n(" + map.get(Constants.XML_KEY_MSG) + ")");
							}
						}, loadingEnd, function():void
						{
							MessageUtil.showMessage("解散分组失败!(通信异常)");
						});
				});

		}

		// 【创建云图(网段)镜像】
		private function topoEventHandler_CreateSegmentMirror(event:TopoEvent):void
		{
			if (event.feature == null)
			{
				return;
			}
			var sourceSegment:ISegment = event.feature.element as ISegment;
			if (sourceSegment == null)
			{
				log.error("创建云图(网段)镜像是云图菜单,配置错误,请检查: {0}", event.feature);
				return;
			}
			MessageUtil.confirm("确认要创建云图镜像吗?", function():void
				{
					var hlinkTopo:IHLinkTopo = new HLinkTopo();
					hlinkTopo.visible = 1;
					hlinkTopo.x = sourceSegment.x + 60;
					hlinkTopo.y = sourceSegment.y + 60;
					hlinkTopo.name = sourceSegment.name;
					hlinkTopo.icon = sourceSegment.icon;
					hlinkTopo.zindex = sourceSegment.zindex;
					hlinkTopo.linkId = sourceSegment.id;
					hlinkTopo.linkName = sourceSegment.name;
					hlinkTopo.linkTopoName = topoCanvas.topoName; // 使用当前拓扑的toponame
					hlinkTopo.showType = ElementProperties.PROPERTYVALUE_OBJECT_SHOW_TYPE_ICON;

					var data:String = DataUtil.buildMapXML(Constants.XML_KEY_ELEMENTXML, DataUtil.buildOutputObjects([hlinkTopo], topoCanvas.parserFactory));
					data += DataUtil.buildMapXML(Constants.XML_KEY_PID, topoCanvas.topoId);
					data = DataUtil.buildXML(Constants.TP_MC_ADD_OBJECT, data);
					log.debug("CreateSegmentMirror: {0}", data);

					loadingStart();
					_dataService.notify(topoCanvas.topoName, data, function(result:String):void
						{
							var map:IMap = DataUtil.getActionResultMap(new XML(result));
							if (map.get(Constants.XML_KEY_SUCCESS) == "1")
							{
								topoCanvas.addDataXML(new XML(map.get(Constants.XML_KEY_ELEMENTXML)));
							}
							else
							{
								MessageUtil.showMessage("创建云图失败!\n\n(" + map.get(Constants.XML_KEY_MSG) + ")");
							}

						}, loadingEnd, function():void
						{
							MessageUtil.showMessage("创建云图失败!(通信异常)");
						});
				});
		}

		// 【显示全部对象】
		private function topoEventHandler_ViewElementAll(event:TopoEvent):void
		{
			topoCanvas.viewAllEnabled = true;

			topoCanvas.eachPoint(function(id:String, point:ITPPoint):void
				{
					point.feature.refresh();
				});
			topoCanvas.eachTPLine(function(id:String, line:ITPLine):void
				{
					line.feature.refresh();
				});
			topoCanvas.eachLink(function(id:String, link:ILink):void
				{
					link.feature.refresh();
				});

		}

		// 【显示可见对象】
		private function topoEventHandler_ViewElementVisiable(event:TopoEvent):void
		{
			topoCanvas.viewAllEnabled = false;

			topoCanvas.eachPoint(function(id:String, point:ITPPoint):void
				{
					point.feature.refresh();
				});
			topoCanvas.eachTPLine(function(id:String, line:ITPLine):void
				{
					line.feature.refresh();
				});
			topoCanvas.eachLink(function(id:String, link:ILink):void
				{
					link.feature.refresh();
				});
		}

		// 【对象设为可见】
		private function topoEventHandler_ElementVisiableTrue(event:TopoEvent):void
		{
			var ids:Array = [];
			event.features.forEach(function(feature:Feature, index:int, array:Array):void
				{
					feature.element.visible = 1;
					ids.push(feature.element.id);
					feature.refresh();
				});
			saveVisibleElements(ids, true);
			topoCanvas.clearAllSelect();
		}

		// 【对象设为隐藏】
		private function topoEventHandler_ElementVisiableFalse(event:TopoEvent):void
		{
			var ids:Array = [];
			event.features.forEach(function(feature:Feature, index:int, array:Array):void
				{
					feature.element.visible = 0;
					ids.push(feature.element.id);
					feature.refresh();
				});
			saveVisibleElements(ids, false);
			topoCanvas.clearAllSelect();
		}

		// 保存显示隐藏的设置
		private function saveVisibleElements(ids:Array, visible:Boolean):void
		{
			var data:String = DataUtil.buildListXML(Constants.XML_KEY_OBJIDS, ids);
			data += DataUtil.buildMapXML(Constants.XML_KEY_VISIBLE, visible ? 1 : 0);
			data = DataUtil.buildXML(Constants.TP_MC_MD_VISIBLE_ELEMENTS, data);
			log.debug("对象设为显示/隐藏 {0}", data);

			_dataService.notify(topoCanvas.topoName, data, function(result:String):void
				{
					var map:IMap = DataUtil.getActionResultMap(new XML(result));
					if (map.get(Constants.XML_KEY_SUCCESS) == "1")
					{
						// 成功
					}
					else
					{
						log.error("对象设为可见保存失败! {0}", map.get(Constants.XML_KEY_MSG));
					}

				}, function():void
				{
				}, function():void
				{
					log.error("对象设为可见保存失败!(通信异常)");
				});
		}

		/**
		 * 获取拓扑图之后,开始绘制拓扑和告警
		 * @param xml
		 *
		 */
		private function loadTopoReady(xml:XML):void
		{
			// 准备加载新的拓扑层次数据
			topoCanvas.dispatchEvent(new CanvasEvent(CanvasEvent.PREPARE_LOAD_LAYER));
			// 如果之前的图层不在forward里面,将forward清空,将之前的图层压入back
			// 如果之前的图层在forward里面,无需压入back
			var oldPath:TopoPath = buildPath(topoCanvas);
			topoCanvas.dispatchEvent(new PathChangeEvent(PathChangeEvent.PREPARE_CHANGE_PATH, oldPath));
			topoCanvas.dataXML = xml;
			var newPath:TopoPath = buildPath(topoCanvas);
			if (oldPath.id == null)
			{
				// 说明是首次进来,之前没有打开过拓扑图
//				log.debug("首次打开拓扑图: {0}", newPath.id);
				_pathBuffer.push(newPath);
				topoCanvas.dispatchEvent(new PathChangeEvent(PathChangeEvent.NEW_PATH, newPath));
			}
			else if (isPathInBuffer(newPath))
			{
				// 新路径已经在缓存中,说明已经是跳转功能
//				log.debug("新路径已经在缓存中: {0}", newPath.id);
				topoCanvas.dispatchEvent(new PathChangeEvent(PathChangeEvent.LOCATE_PATH, newPath));
			}
			else
			{
				// 新路径不在缓存中,要将老路径之后的path全部清空
//				log.debug("新路径不在缓存中,要将老路径之后的path全部清空 old:{0}  new:{1}", oldPath.id, newPath.id);
				clearAfterPath(oldPath);
				topoCanvas.dispatchEvent(new PathChangeEvent(PathChangeEvent.CLEAR_AFTER_PATH, oldPath));
				_pathBuffer.push(newPath);
				topoCanvas.dispatchEvent(new PathChangeEvent(PathChangeEvent.NEW_PATH, newPath));
			}
			_currentPath = newPath;

//			log.debug("当前图层路径: {0}", _currentPath.id);
//			log.debug("缓存图层路径容量 {0}:  {1}", _pathBuffer.length, _pathBuffer);

			topoCanvas.addExtendProperty(Constants.PROPERTY_CANVAS_GOBACKENABLE, isPathFirst(_currentPath) ? "false" : "true");

		}

		/**
		 * 清空后退的路径
		 *
		 */
		public function clearGoBackPaths():void
		{
			_pathBuffer.length = 0;
			topoCanvas.addExtendProperty(Constants.PROPERTY_CANVAS_GOBACKENABLE, "false");
			topoCanvas.dispatchEvent(new PathChangeEvent(PathChangeEvent.CLEAR_ALL_PATH, null));
		}

		/**
		 * 构造Path对象
		 * @param canvas
		 * @return
		 *
		 */
		private function buildPath(canvas:TopoCanvas):TopoPath
		{
			return new TopoPath(canvas);
		}

		/**
		 * 查找后退的图层路径
		 * @return
		 *
		 */
		private function findBackPath():TopoPath
		{
			var backPath:TopoPath = null;
			_pathBuffer.some(function(path:TopoPath, index:int, array:Array):Boolean
				{
					if (_currentPath.equals(path))
					{
						return true;
					}
					backPath = path;
					return false;
				});
			return backPath;
		}

		/**
		 * 判断目标path是否在缓存中
		 * @param targetPath
		 * @return
		 *
		 */
		private function isPathInBuffer(targetPath:TopoPath):Boolean
		{
			return _pathBuffer.some(function(path:TopoPath, index:int, array:Array):Boolean
				{
					return targetPath.equals(path);
				});

		}

		/**
		 * 验证path是否是第一个(是否可以后退)
		 * @param path
		 * @return
		 *
		 */
		private function isPathFirst(path:TopoPath):Boolean
		{
			return _pathBuffer[0].id == path.id;
		}

		/**
		 * 清空缓存中指定path之后的path对象
		 * @param path
		 *
		 */
		private function clearAfterPath(path:TopoPath):void
		{
			var index:int = -1;
			if (_pathBuffer.some(function(bufpath:TopoPath, index1:int, arr:Array):Boolean
				{
					index = index1;
					return bufpath.equals(path);
				}))
			{
				_pathBuffer.splice(index + 1, _pathBuffer.length - (index + 1));
			}

		}

	}
}