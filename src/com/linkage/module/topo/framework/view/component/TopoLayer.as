package com.linkage.module.topo.framework.view.component
{
	import com.adobe.utils.ArrayUtil;
	import com.linkage.module.topo.framework.controller.event.CanvasEvent;
	import com.linkage.module.topo.framework.controller.menu.IMenuManager;
	import com.linkage.module.topo.framework.core.DataBounds;
	import com.linkage.module.topo.framework.core.Feature;
	import com.linkage.module.topo.framework.core.IGetProperty;
	import com.linkage.module.topo.framework.core.LayerManager;
	import com.linkage.module.topo.framework.core.ViewBounds;
	import com.linkage.module.topo.framework.core.model.AlarmFactory;
	import com.linkage.module.topo.framework.core.model.IAlarmFactory;
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.model.element.line.ILayerLink;
	import com.linkage.module.topo.framework.core.model.element.line.ILink;
	import com.linkage.module.topo.framework.core.model.element.line.ITPLine;
	import com.linkage.module.topo.framework.core.model.element.line.LayerLink;
	import com.linkage.module.topo.framework.core.model.element.line.Line;
	import com.linkage.module.topo.framework.core.model.element.line.Link;
	import com.linkage.module.topo.framework.core.model.element.line.TPLine;
	import com.linkage.module.topo.framework.core.model.element.plane.HLinkTopo;
	import com.linkage.module.topo.framework.core.model.element.plane.HLinkUrl;
	import com.linkage.module.topo.framework.core.model.element.plane.IHLinkLayer;
	import com.linkage.module.topo.framework.core.model.element.plane.IHLinkTopo;
	import com.linkage.module.topo.framework.core.model.element.plane.IHLinkUrl;
	import com.linkage.module.topo.framework.core.model.element.plane.ITPComplex;
	import com.linkage.module.topo.framework.core.model.element.plane.ITPGrid;
	import com.linkage.module.topo.framework.core.model.element.plane.ITPGroup;
	import com.linkage.module.topo.framework.core.model.element.plane.ITPShape;
	import com.linkage.module.topo.framework.core.model.element.plane.ITPView;
	import com.linkage.module.topo.framework.core.model.element.plane.TPGrid;
	import com.linkage.module.topo.framework.core.model.element.plane.TPGroup;
	import com.linkage.module.topo.framework.core.model.element.plane.TPShape;
	import com.linkage.module.topo.framework.core.model.element.plane.TPView;
	import com.linkage.module.topo.framework.core.model.element.point.INode;
	import com.linkage.module.topo.framework.core.model.element.point.ISegment;
	import com.linkage.module.topo.framework.core.model.element.point.ITPObject;
	import com.linkage.module.topo.framework.core.model.element.point.ITPPoint;
	import com.linkage.module.topo.framework.core.model.element.point.ITPText;
	import com.linkage.module.topo.framework.core.model.element.point.Node;
	import com.linkage.module.topo.framework.core.model.element.point.Segment;
	import com.linkage.module.topo.framework.core.model.element.point.TPObject;
	import com.linkage.module.topo.framework.core.model.element.point.TPText;
	import com.linkage.module.topo.framework.core.parser.ElementProperties;
	import com.linkage.module.topo.framework.core.parser.IParserFactory;
	import com.linkage.module.topo.framework.core.style.IStyleFactory;
	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;
	import com.linkage.system.structure.map.IMap;
	import com.linkage.system.structure.map.ISet;
	import com.linkage.system.structure.map.Map;
	import com.linkage.system.structure.map.Set;
	
	import flash.display.BitmapData;
	import flash.errors.IllegalOperationError;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.events.FlexEvent;
	
	import spark.components.Group;
	
	/**
	 * 拓扑层次(拓扑数据的载体)
	 * @author duangr
	 *
	 */
	public class TopoLayer extends Group implements IGetProperty
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.view.component.TopoLayer");
		
		// 内置属性容器(切换层次时不会删除)
		private var _internalProperties:IMap = new Map();
		// 扩展属性容器
		private var _extendProperties:IMap = new Map();
		
		// 拓扑图内部变量
		private var _topoDataVersion:String = null;
		[Bindable]
		private var _topoId:String = null;
		[Bindable]
		private var _topoViewName:String = null;
		// 拓扑数据源的名称
		[Bindable]
		private var _topoName:String = null;
		[Bindable]
		private var _port:String = null;
		[Bindable]
		private var _topoType:String = null;
		// 显示区域
		private var _viewBounds:ViewBounds = null;
		// 数据区域
		private var _dataBounds:DataBounds = null;
		
		// zindex修正添加到画布的顺序
		private var _layerManager:LayerManager = new LayerManager();
		// 是否处于选择状态
		private var _selectEnabled:Boolean = false;
		// 是否处于显示全部状态
		private var _viewAllEnabled:Boolean = false;
		// 是否允许刷新告警
		private var _alarmEnabled:Boolean = true;
		// 保持不被
		private var _keeyProperties:Array = [];
		
		// ------------------- 分布加载 ------------------------//
		/**
		 * 分步渲染,单次的最大渲染对象数量
		 */
		private var _stepRenderMaxSize:int = 70;
		/**
		 * 分步渲染,两次间的休眠毫秒数
		 */
		private var _stepRenderSleepMS:int = 200;
		
		/**
		 * 由于是分步加载,标识当前是否处于对象渲染中
		 */
		private var _rendering:Boolean = false;
		
		// ----------------- 元素容器 --------------------//
		// 元素容器
		protected var _elementMap:IMap = new Map();
		private var _nodeMap:IMap = new Map();
		private var _segmentMap:IMap = new Map();
		private var _groupMap:IMap = new Map();
		private var _linkMap:IMap = new Map();
		protected var _objectMap:IMap = new Map(); // Object对象都在里面
		// 下面的都在 _objectMap 里面
		private var _tpLineMap:IMap = new Map();
		private var _shapeMap:IMap = new Map();
		private var _tpTextMap:IMap = new Map();
		private var _hlinkUrlMap:IMap = new Map();
		private var _hlinkTopoMap:IMap = new Map();
		protected var _hlinkLayerMap:IMap = new Map();
		private var _tpViewMap:IMap = new Map();
		private var _tpObjectMap:IMap = new Map();
		private var _tpGridMap:IMap = new Map();
		
		// 选择容器
		private var _selectedMap:IMap = new Map();
		
		// 为了解决多个 topoName 分别刷新告警的问题,将 元素的id 按照topoName分别存储,而且只存储需要刷新告警的元素id(Node,Segment,HlinkTopo,Link,TpView)
		private var _topoName2refreshAlarmElementIdArray:IMap = new Map();
		private var _topoName2refreshAlarmLinkIdArray:IMap = new Map();
		//extInfo:100[普通拓扑不用调用接口] 99[CMNET端口流量] 98 1[CMNET队列流量]
		private var _extInfo:String = "100";
		
		// ----------------- 告警容器 --------------------//
		// 存在告警的对象集合
		private var _alarmElements:ISet = new Set();
		// 上一次存在告警的数组
		private var _lastAlarmElements:ISet = new Set();
		
		// -----------------  工厂类  --------------------//
		private var _parserFactory:IParserFactory = null;
		private var _styleFactory:IStyleFactory = null;
		private var _alarmFactory:IAlarmFactory = null;
		
		//与后台交互xml中的KEY: 网元id
		public const XML_KEY_MO_ID1:String = "mo_id1";
		public const XML_KEY_MO_ID2:String = "mo_id2";
		
		// -----------------  菜单管理器 --------------------//
		private var _menuManager:IMenuManager = null;
		
		// -----------------  拓扑图画布 --------------------//
		private var _topoCanvas:TopoCanvas = null;
		private var _showWidth:Number = 0;
		private var _showHeight:Number = 0;
		
		public var alarmArrayCollection:ArrayCollection = new ArrayCollection();
		
		public function TopoLayer(topoCanvas:TopoCanvas)
		{
			super();
			this.percentWidth = 100;
			this.percentHeight = 100;
			_topoCanvas = topoCanvas;
			_viewBounds = new ViewBounds(this);
			_dataBounds = new DataBounds(this);
			_alarmFactory = new AlarmFactory(this);
			
//			this.addEventListener(FlexEvent.UPDATE_COMPLETE, function(event:FlexEvent):void
//			{
//				log.info(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
//				dispatchEvent(new CanvasEvent(CanvasEvent.DATA_CHANGED));
//			});
		}
		
		/**
		 * 初始化容器的大小
		 * @param width
		 * @param height
		 *
		 */
		public function initTopoLayerSize(width:Number, height:Number):void
		{
			this._showWidth = width;
			this._showHeight = height;
			_viewBounds.updateByWidthHeight(_showWidth, _showHeight);
		}
		
		/**
		 * 分步渲染,单次的最大渲染对象数量
		 */
		public function get stepRenderMaxSize():int
		{
			// 缩略图中的元素,慢慢的渲染,释放出cpu给页面操作
			return _stepRenderMaxSize;
		}
		
		public function set stepRenderMaxSize(value:int):void
		{
			_stepRenderMaxSize = value;
		}
		
		/**
		 * 分步渲染,两次间的休眠毫秒数
		 */
		public function get stepRenderSleepMS():int
		{
			return _stepRenderSleepMS;
		}
		
		public function set stepRenderSleepMS(value:int):void
		{
			_stepRenderSleepMS = value;
		}
		
		/**
		 * 画布中对象是否处于渲染中
		 */
		public function get rendering():Boolean
		{
			return _rendering;
		}
		
		public function set rendering(value:Boolean):void
		{
			_rendering = value;
		}
		
		public function get showWidth():Number
		{
			return _showWidth;
		}
		
		public function get showHeight():Number
		{
			return _showHeight;
		}
		
		public function set menuManager(value:IMenuManager):void
		{
			_menuManager = value;
			_menuManager.menuOwner = this;
			
		}
		
		public function get menuManager():IMenuManager
		{
			return _menuManager;
		}
		
		override public function toString():String
		{
			return topoId + "/" + topoViewName + "@" + topoName + ", " + _dataBounds + ", " + _viewBounds + ", 鼠标坐标:(" + this.mouseX + "," + this.mouseY + ") 元素数量:" + elementSize;
		}
		
		/**
		 * 启动前执行环境检查,确保必要参数已经初始化
		 *
		 */
		public function doValidate():void
		{
			if (_parserFactory == null)
			{
				throw new ArgumentError("请先设置参数[parserFactory]后再启动拓扑!");
			}
			if (_styleFactory == null)
			{
				throw new ArgumentError("请先设置参数[styleFactory]后再启动拓扑!");
			}
			
		}
		
		public function get topoId():String
		{
			return this._topoId;
		}
		
		public function get topoViewName():String
		{
			return this._topoViewName;
		}
		
		public function get topoName():String
		{
			return _topoName;
		}
		
		public function get port():String
		{
			return _port;
		}
		
		public function get topoType():String
		{
			return this._topoType;
		}
		
		public function get weight():uint
		{
			throw new IllegalOperationError("方法 get weight() 未实现!");
		}
		
		/**
		 * 是否允许选择对象
		 *
		 */
		public function get selectEnabled():Boolean
		{
			return _selectEnabled;
		}
		
		public function set selectEnabled(value:Boolean):void
		{
			_selectEnabled = value;
		}
		
		public function get viewAllEnabled():Boolean
		{
			return _viewAllEnabled;
		}
		
		public function set viewAllEnabled(value:Boolean):void
		{
			_viewAllEnabled = value;
		}
		
		public function get alarmEnabled():Boolean
		{
			return _alarmEnabled;
		}
		
		public function set alarmEnabled(value:Boolean):void
		{
			_alarmEnabled = value;
		}
		
		/**
		 * 给画布添加内置属性
		 * @param key
		 * @param value
		 *
		 */
		public function addInternalProperty(key:String, value:String):void
		{
			_internalProperties.put(key, value);
		}
		
		/**
		 * 删除内置属性
		 * @param key
		 *
		 */
		public function removeInternalProperty(key:String):void
		{
			_internalProperties.remove(key);
		}
		
		/**
		 * 给画布添加扩展属性
		 * @param key
		 * @param value
		 *
		 */
		public function addExtendProperty(key:String, value:String):void
		{
			_extendProperties.put(key, value);
		}
		
		/**
		 * 删除扩展属性
		 * @param key
		 *
		 */
		public function removeExtendProperty(key:String):void
		{
			_extendProperties.remove(key);
		}
		
		public function getProperty(key:String):String
		{
			var returnValue:String = null;
			
			switch (key)
			{
				case "topoId":
					returnValue = topoId;
					break;
				case "topoName":
					returnValue = topoName;
					break;
				case "topoViewName":
					returnValue = topoViewName;
					break;
				case "topoType":
					returnValue = topoType;
					break;
				case "selectEnabled":
					returnValue = String(selectEnabled);
					break;
				case "selectedNum":
					returnValue = selectedNum().toString();
					break;
				case "viewAllEnabled":
					returnValue = String(viewAllEnabled);
					break;
				default:
					// 从属性容器里面取数据
					returnValue = _internalProperties.get(key);
					if (returnValue == null)
					{
						returnValue = _extendProperties.get(key);
					}
					break;
			}
			return returnValue;
		}
		
		public function eachProperty(callback:Function, thisObject:* = null):void
		{
			callback.call(thisObject, "topoId", topoId);
			callback.call(thisObject, "topoName", topoName);
			callback.call(thisObject, "port", port);
			callback.call(thisObject, "topoViewName", topoViewName);
			callback.call(thisObject, "topoType", topoType);
			callback.call(thisObject, "selectEnabled", selectEnabled);
			callback.call(thisObject, "selectedNum", selectedNum().toString());
			callback.call(thisObject, "viewAllEnabled", viewAllEnabled);
			
			_internalProperties.forEach(function(key:*, value:*):void
			{
				callback.call(thisObject, key, value);
			});
			_extendProperties.forEach(function(key:*, value:*):void
			{
				callback.call(thisObject, key, value);
			});
		}
		
		/**
		 * 解析器工厂
		 * @param value
		 *
		 */
		public function set parserFactory(value:IParserFactory):void
		{
			this._parserFactory = value;
		}
		
		public function get parserFactory():IParserFactory
		{
			return this._parserFactory;
		}
		
		/**
		 * 样式工厂
		 * @param value
		 *
		 */
		public function set styleFactory(value:IStyleFactory):void
		{
			this._styleFactory = value;
		}
		
		public function get styleFactory():IStyleFactory
		{
			return this._styleFactory;
		}
		
		/**
		 * 显示范围
		 */
		public function get viewBounds():ViewBounds
		{
			return _viewBounds;
		}
		
		/**
		 * 数据范围
		 */
		public function get dataBounds():DataBounds
		{
			return _dataBounds;
		}
		
		/**
		 * 将画布中内容导成位图数据
		 * @param canvas
		 * @return
		 *
		 */
		public function exportAllCanvasAsBitmapData():BitmapData
		{
			// log.debug("数据边界:{0}", dataBounds.rectangle);
			var dataWidth:Number = dataBounds.rectangle.width;
			var dataHeight:Number = dataBounds.rectangle.height;
			if (isNaN(dataWidth) || !(dataWidth > 0))
			{
				dataWidth = viewBounds.rectangle.width;
			}
			if (isNaN(dataHeight) || !(dataHeight > 0))
			{
				dataHeight = viewBounds.rectangle.height;
			}
			// 位图数据的宽高不能多于 8191,此处拿 4000 作为最大值
			// 要实现等比例的缩放
			var scaleX:Number = Math.min(8191, dataWidth) / dataWidth;
			var scaleY:Number = Math.min(8191, dataHeight) / dataHeight;
			var scale:Number = Math.min(scaleX, scaleY);
			var bitDataWidth:Number = dataWidth * scale;
			var bitDataHeight:Number = dataHeight * scale;
			
			//宽*高不能大于16,777,215
			if(bitDataWidth * bitDataHeight > 16777215)
			{
				bitDataHeight = 16777215 / bitDataWidth;
			}
			// log.debug("dataWidth:{0} dataHeight:{1}  scale:{2}", dataWidth, dataHeight, scale);
			// log.debug("bitDataWidth:{0} bitDataHeight:{1}", bitDataWidth, bitDataHeight);
			if (isNaN(bitDataWidth) || isNaN(bitDataHeight))
			{
				// 数据没有边界,直接返回空的位图数据
				return null;
			}
			
			var bmpData:BitmapData = new BitmapData(bitDataWidth, bitDataHeight, true, 0);
			log.info("画布大小:" + bitDataWidth + "," + bitDataHeight);
			// 导出前先取消展现区域矩形限制
			this.scrollRect = null; //dataBounds.rectangle;
			var matrix:Matrix = new Matrix();
			matrix.scale(scale, scale); // 等比例缩放
			// matrix.tx = -dataBounds.rectangle.x;
			// matrix.ty = -dataBounds.rectangle.y;
			// log.debug("tx:{0} ty:{1}", matrix.tx, matrix.ty);
			bmpData.draw(this, matrix);
			this.scrollRect = viewBounds.rectangle;
			return bmpData;
		}
		
		// -----------------  id数组  ------------------ //
		/**
		 * 获取 topoName与刷新告警的idArray的映射
		 * @return
		 *
		 */
		public function get topoName2refreshAlarmElementIdArray():IMap
		{
			return _topoName2refreshAlarmElementIdArray;
		}
		
		/**
		 * 获取 topoName与刷新告警的链路idArray的映射
		 * @return
		 *
		 */
		public function get topoName2refreshAlarmLinkIdArray():IMap
		{
			return _topoName2refreshAlarmLinkIdArray;
		}
		
		// -----------------  元素查找  ------------------ //
		
		/**
		 * 拓扑中元素的个数
		 */
		public function get elementSize():int
		{
			return _elementMap.size;
		}
		
		/**
		 * 根据id查找元素对象
		 * @param id
		 * @return
		 *
		 */
		public function findElementById(id:String):IElement
		{
			return _elementMap.get(id);
		}
		
		/**
		 * 根据id查找节点
		 * @param id
		 * @return
		 *
		 */
		public function findNodeById(id:String):INode
		{
			return _nodeMap.get(id);
		}
		
		/**
		 * 根据id查找网段
		 * @param id
		 * @return
		 *
		 */
		public function findSegmentById(id:String):ISegment
		{
			return _segmentMap.get(id);
		}
		
		/**
		 * 根据id查找链路
		 * @param id
		 * @return
		 *
		 */
		public function findLinkById(id:String):ILink
		{
			return _linkMap.get(id);
		}
		
		/**
		 * 根据id查找分组
		 * @param id
		 * @return
		 *
		 */
		public function findGroupById(id:String):ITPGroup
		{
			return _groupMap.get(id);
		}
		
		/**
		 * 根据id查找Object对象
		 * @param id
		 * @return
		 *
		 */
		public function findObjectById(id:String):IElement
		{
			return _objectMap.get(id);
		}
		
		/**
		 *  遍历每一个对象
		 * @param callback 回调函数,格式为: function callback(id:String, element:IElement):void{ ... }
		 *
		 */
		public function eachElement(callback:Function):void
		{
			if (callback == null)
			{
				return;
			}
			_elementMap.forEach(callback);
		}
		
		/**
		 * 遍历每一个点对象(包括面,没有线对象)
		 * @param callback 回调函数,格式为: function callback(id:String, point:ITPPoint):void{ ... }
		 *
		 */
		public function eachPoint(callback:Function):void
		{
			if (callback == null)
			{
				return;
			}
			_nodeMap.forEach(callback);
			_segmentMap.forEach(callback);
			_groupMap.forEach(callback);
			_shapeMap.forEach(callback);
			_tpTextMap.forEach(callback);
			_hlinkUrlMap.forEach(callback);
			_hlinkTopoMap.forEach(callback);
			_hlinkLayerMap.forEach(callback);
			_tpViewMap.forEach(callback);
			_tpObjectMap.forEach(callback);
			_tpGridMap.forEach(callback);
		}
		
		/**
		 * 遍历每一个线对象
		 * @param callback  回调函数,格式为: function callback(id:String, line:ITPLine):void{ ... }
		 *
		 */
		public function eachTPLine(callback:Function):void
		{
			if (callback == null)
			{
				return;
			}
			_tpLineMap.forEach(callback);
		}
		
		
		/**
		 * 遍历每一个节点
		 * @param callback 回调函数,格式为: function callback(id:String, node:INode):void{ ... }
		 *
		 */
		public function eachNode(callback:Function):void
		{
			if (callback == null)
			{
				return;
			}
			_nodeMap.forEach(callback);
		}
		
		/**
		 * 遍历每一个节点,直到找到第一个符合条件的为止
		 * @param callback 回调函数,格式为: function callback(id:String, node:INode):Boolean{ ... }
		 *
		 */
		public function someNode(callback:Function):Boolean
		{
			if (callback == null)
			{
				return false;
			}
			return _nodeMap.some(callback);
		}
		
		/**
		 * 遍历每一个网段
		 * @param callback 回调函数,格式为: function callback(id:String, segment:ISegment):void{ ... }
		 *
		 */
		public function eachSegment(callback:Function):void
		{
			if (callback == null)
			{
				return;
			}
			_segmentMap.forEach(callback);
		}
		
		/**
		 * 遍历每一个节点和网段
		 * @param callback 回调函数,格式为: function callback(id:String, element:IElement):void{ ... }
		 *
		 */
		public function eachNodeSegment(callback:Function):void
		{
			if (callback == null)
			{
				return;
			}
			_nodeMap.forEach(callback);
			_segmentMap.forEach(callback);
		}
		
		/**
		 * 遍历每一个链路
		 * @param callback 回调函数,格式为: function callback(id:String, link:ILink):void{ ... }
		 *
		 */
		public function eachLink(callback:Function):void
		{
			if (callback == null)
			{
				return;
			}
			_linkMap.forEach(callback);
		}
		
		/**
		 * 遍历每一个分组
		 * @param callback 回调函数,格式为: function callback(id:String, group:ITPGroup):void{ ... }
		 *
		 */
		public function eachGroup(callback:Function):void
		{
			if (callback == null)
			{
				return;
			}
			_groupMap.forEach(callback);
		}
		
		/**
		 * 遍历每一个Object对象
		 * @param callback callback 回调函数,格式为: function callback(id:String, element:IElement):void{ ... }
		 *
		 */
		public function eachObject(callback:Function):void
		{
			if (callback == null)
			{
				return;
			}
			_objectMap.forEach(callback);
		}
		
		/**
		 * 遍历每一个缩略图对象
		 * @param callback 回调函数,格式为: function callback(id:String, hlinkLayer:IHLinkLayer):void{ ... }
		 *
		 */
		public function eachHLinkLayer(callback:Function):void
		{
			if (callback == null)
			{
				return;
			}
			_hlinkLayerMap.forEach(callback);
		}
		
		/**
		 * 遍历每一个ITPGrid对象
		 * @param callback 回调函数,格式为: function callback(id:String, tpGrid:ITPGrid):void{ ... }
		 *
		 */
		public function eachTPGrid(callback:Function):void
		{
			if (callback == null)
			{
				return;
			}
			_tpGridMap.forEach(callback);
		}
		
		/**
		 * 遍历每一个变化的元素
		 * @param callback 回调函数,格式为: function callback(id:String, element:IElement):void{ ... }
		 *
		 */
		public function eachChanged(callback:Function):void
		{
			if (callback == null)
			{
				return;
			}
			eachPoint(function(id:String, point:ITPPoint):void
			{
				if (point.changed)
				{
					callback.call(null, id, point);
				}
			});
			eachTPLine(function(id:String, line:ITPLine):void
			{
				if (line.changed)
				{
					callback.call(null, id, line);
				}
			});
		}
		
		// -----------------  选中对象 ------------------ //
		/**
		 * 将此元素加入到选中缓存中.<br/>
		 * 若此元素已在选中缓存中,无操作;若不在选中缓存,则先清空已有的选中缓存,再把自身加入
		 * @param element
		 *
		 */
		public function setToSelect(element:IElement):void
		{
			if (!selectEnabled)
			{
				return;
			}
			
			var obj:IElement = _selectedMap.get(element.id);
			if (obj == null)
			{
				clearAllSelect();
				addToSelect(element);
			}
			else
			{
				element.feature.unSelect();
				addToSelect(element);
			}
			this.dispatchEvent(new CanvasEvent(CanvasEvent.SET_TO_SELECTED, element.feature));
		}
		
		/**
		 * 添加新元素到选中缓存中(不影响已有的选中元素)
		 * @param element
		 *
		 */
		public function addToSelect(element:IElement):void
		{
			if (!selectEnabled)
			{
				return;
			}
			// 绘制选中的渲染效果,并且添加到选中容器
			_selectedMap.put(element.id, element);
			element.feature.select();
		}
		
		/**
		 * 清空已有的选中对象
		 */
		public function clearAllSelect():void
		{
			_selectedMap.forEach(function(id:String, element:IElement):void
			{
				element.feature.unSelect();
			});
			_selectedMap.clear();
		}
		
		/**
		 * 遍历每一个选中对象
		 * @param callback 回调函数,格式为: function callback(id:String, element:IElement):void{ ... }
		 *
		 */
		public function eachSelect(callback:Function):void
		{
			if (callback == null)
			{
				return;
			}
			_selectedMap.forEach(callback);
		}
		
		public function set extInfo(value:String):void
		{
			_extInfo = value;
		}
		
		public function get extInfo():String
		{
			return _extInfo;
		}
		
		/**
		 * 判断是否存在选中的元素
		 * @return
		 *
		 */
		public function hasFeatureSelected():Boolean
		{
			return _selectedMap.size > 0;
		}
		
		/**
		 * 选中元素的个数
		 * @return
		 *
		 */
		public function selectedNum():uint
		{
			return _selectedMap.size;
		}
		
		/**
		 * 全选当前拓扑中的网元(链路除外)
		 *
		 */
		public function selectAll():void
		{
			if (!selectEnabled)
			{
				return;
			}
			clearAllSelect();
			eachPoint(function(id:String, point:ITPPoint):void
			{
				addToSelect(point);
			});
			eachTPLine(function(id:String, line:ITPLine):void
			{
				addToSelect(line);
			});
			dispatchEvent(new CanvasEvent(CanvasEvent.SELECTED_CHANGED));
		}
		
		/**
		 * 反选当前拓扑中的网元 (链路除外)
		 *
		 */
		public function selectUnSelected():void
		{
			if (!selectEnabled)
			{
				return;
			}
			var idMap:IMap = new Map();
			eachSelect(function(id:String, element:IElement):void
			{
				idMap.put(id, element);
			});
			clearAllSelect();
			eachPoint(function(id:String, point:ITPPoint):void
			{
				if (idMap.get(id) == null)
				{
					addToSelect(point);
				}
			});
			dispatchEvent(new CanvasEvent(CanvasEvent.SELECTED_CHANGED));
		}
		
		
		
		/**
		 * 存储的坐标转换为相对父对象的坐标
		 * @param feature 拓扑要素
		 * @param x X坐标
		 * @param y Y坐标
		 * @return
		 *
		 */
		public function xyToLocal(feature:Feature, x:Number, y:Number):Point
		{
			try
			{
				if (feature.parent is TopoLayer)
				{
					return new Point(x + dataBounds.offsetX, y + dataBounds.offsetY);
				}
				else
				{
					var pf:Feature = feature.parent as Feature;
					var pp:ITPPoint = pf.element as ITPPoint;
					// 两个对象中心点之差,还要加上父对象的宽高的一半进行修正,这样才是中心点
					return new Point(x - pp.x + pf.width / 2, y - pp.y + pf.height / 2);
				}
			}
			catch (e:Error)
			{
				log.debug("xyToLocal Error {0}  ({1},{2})", feature, x, y);
			}
			return new Point(x + dataBounds.offsetX, y + dataBounds.offsetY);
		}
		
		/**
		 * 相对父对象的坐标转换为相对画布的坐标
		 * @param feature
		 * @param x
		 * @param y
		 * @return
		 *
		 */
		public function localToLayer(feature:Feature):Point
		{
			var point:Point = new Point(feature.x, feature.y);
			if (feature.parent is TopoLayer)
			{
				return point;
			}
			else
			{
				return findFeatureInLayer(feature.parent, point);
			}
			
			/**
			 * 层层递归,直到找到直接在画布中的Feature为止,坐标要一直累计
			 */
			function findFeatureInLayer(feature:Feature, point:Point):Point
			{
				point.x += feature.x;
				point.y += feature.y;
				if (feature.parent is TopoLayer)
				{
					return point;
				}
				else
				{
					return findFeatureInLayer(feature.parent, point);
				}
			}
		}
		
		/**
		 * 画布的坐标转换为db中的坐标
		 * @param x
		 * @param y
		 * @return
		 *
		 */
		public function globalToXY(x:Number, y:Number):Point
		{
			return new Point(x - dataBounds.offsetX, y - dataBounds.offsetY);
		}
		
		
		/**
		 * 重置拓扑图容器,将已有内部对象全部删除,容器都清空
		 */
		public function resetContianer():void
		{
			// 清除扩展属性
			_extendProperties.clear();
			
			// 清空元素容器
			_elementMap.clear();
			_nodeMap.clear();
			_segmentMap.clear();
			_groupMap.clear();
			_linkMap.clear();
			_objectMap.clear();
			_shapeMap.clear();
			_tpLineMap.clear();
			_tpTextMap.clear();
			_hlinkUrlMap.clear();
			_hlinkTopoMap.clear();
			_hlinkLayerMap.clear();
			_tpViewMap.clear();
			_tpObjectMap.clear();
			_tpGridMap.clear();
			
			// 清空topoName与待刷新告警的元素id数组的映射
			_topoName2refreshAlarmElementIdArray.forEach(function(topoName:String, idArray:Array):void
			{
				idArray.length = 0;
			});
			_topoName2refreshAlarmElementIdArray.clear();
			
			_topoName2refreshAlarmLinkIdArray.forEach(function(topoName:String, idArray:Array):void
			{
				idArray.length = 0;
			});
			_topoName2refreshAlarmLinkIdArray.clear();
			
			clearAllSelect();
			_layerManager.clear();
			_menuManager.clear();
			
			removeAllElements();
			
			_topoDataVersion = null;
			_topoName = null;
			_topoId = null;
			_topoViewName = null;
			_topoType = null;
			
			// 重新加载数据,将缩放比例还原
			this.scaleX = 1;
			this.scaleY = 1;
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			_viewBounds.refresh();
			log.debug("unscaledWidth: {0} unscaledHeight:{1}", unscaledWidth, unscaledHeight);
			log.debug("scrollRect: {0} center:{1}", this.scrollRect, _viewBounds.center);
			
		}
		
		// -----------------  画对象 ------------------ //
		/**
		 * 构造自身的属性
		 * @param data
		 *
		 */
		private function initSelfAttrs(data:XML):void
		{
			_topoDataVersion = data.@version;
			_topoName = data.@toponame;
			
			var netView:Object = data.child("NetView")[0];
			_topoId = netView.@id;
			_topoViewName = netView.@name;
			_topoType = netView.@type;
			
			for each (var o:Object in netView.p)
			{
				addExtendProperty(o.@k, o.toString());
			}
			log.info("m");
			log.debug("version={0} topoName={1} id={2} name={3} type={4}", _topoDataVersion, _topoName, _topoId, _topoViewName, _topoType);
			
		}
		
		/**
		 * 拓扑图当前层次的拓扑数据(不绘制)
		 * @param data
		 *
		 */
		public function set dataXMLWithoutDraw(data:XML):void
		{
			if (!checkDataXML(data))
			{
				return;
			}
			resetContianer();
			initSelfAttrs(data);
			
			// 解析数据
			parserDataXML(data);
		}
		
		/**
		 * 将元素绘制在拓扑上面
		 * @param restatBound 是否需要重新统计边界
		 *
		 */
		public function drawOnCanvas(restatBound:Boolean = false):void
		{
			// 开始绘制到画布上
			_layerManager.drawOnCanvas(this, restatBound);
			dispatchEvent(new CanvasEvent(CanvasEvent.DATA_CHANGED));
		}
		
		/**
		 * 拓扑图当前层次的拓扑数据
		 */
		public function set dataXML(data:XML):void
		{
			if (!checkDataXML(data))
			{
				return;
			}
			
			resetContianer();
			initSelfAttrs(data);
			
			// 解析数据
			parserDataXML(data);
			// 开始绘制到画布上
			drawOnCanvas();
		}
		
		/**
		 * 在当前拓扑图中增加数据
		 * @param data
		 *
		 */
		public function addDataXML(data:XML):void
		{
			if (!checkDataXML(data))
			{
				return;
			}
			// 解析数据
			parserDataXML(data);
			// 开始绘制到画布上
			appendOnCanvas();
		}
		
		/**
		 * 在当前拓扑图中增加数据(不绘制)
		 * @param data
		 *
		 */
		public function addDataXMLWithoutDraw(data:XML):void
		{
			if (!checkDataXML(data))
			{
				return;
			}
			// 解析数据
			parserDataXML(data);
		}
		
		/**
		 * 添加对象到画布中,并且绘制
		 * @param element
		 *
		 */
		public function addElementToCanvas(element:IElement):void
		{
			log.debug("添加对象到画布中 " + element);
			_layerManager.addFeature(generateFeature(element));
			// 开始绘制到画布上
			_layerManager.appendOnCanvas(this, true);
		}
		
		/**
		 * 将增量添加的数据画到画布上
		 * @param restatBound
		 *
		 */
		public function appendOnCanvas(restatBound:Boolean = false):void
		{
			// 开始绘制到画布上
			_layerManager.appendOnCanvas(this, restatBound);
		}
		
		/**
		 * 验证数据
		 * @param data
		 * @return
		 *
		 */
		private function checkDataXML(data:XML):Boolean
		{
			if (data == null || data.child("NetView").length() == 0)
			{
				log.error("拓扑图增加数据(addDataXML)为空!");
				return false;
			}
			else
			{
				return true;
			}
		}
		
		/**
		 * 解析数据XML
		 * @param data
		 *
		 */
		private function parserDataXML(data:XML):void
		{
			var netView:Object = data.child("NetView")[0];
			var obj:Object = null;
			// Nodes
			var nodes:Object = netView.Nodes;
			for each (obj in nodes.Node)
			{
				_layerManager.addFeature(drawNode(obj));
				
			}
			// Segments
			var segments:Object = netView.Segments;
			for each (obj in segments.Segment)
			{
				_layerManager.addFeature(drawSegment(obj));
			}
			
			// Objects
			var objects:Object = netView.Objects;
			for each (obj in objects.Object)
			{
				_layerManager.addFeature(drawObject(obj));
			}
			// Groups
			var groups:Object = netView.Groups;
			for each (obj in groups.Group)
			{
				_layerManager.addFeature(drawGroup(obj));
			}
			// 处理一开始没有加载好的子对象
			reInitGroup();
			
			// Links
			var links:Object = netView.Links;
			for each (obj in links.Link)
			{
				_layerManager.addFeature(drawLink(obj));
				
			}
			
			
			//			dispatchEvent(new CanvasEvent(CanvasEvent.LAYER_CHANGED));
			
			//			Alert.show("-dsdsdsd----------->");
		}
		
		/**
		 * 在当前拓扑图中增加单个元素的XML数据
		 * @param data
		 *
		 */
		public function addElementXML(data:XML):void
		{
			if (data == null)
			{
				return;
			}
			var name:String = String(data.name());
			switch (name)
			{
				case "Node":
					_layerManager.addFeature(drawNode(data));
					break;
				case "Segment":
					_layerManager.addFeature(drawSegment(data));
					break;
				case "Group":
					_layerManager.addFeature(drawGroup(data));
					break;
				case "Object":
					_layerManager.addFeature(drawObject(data));
					break;
				case "Link":
					_layerManager.addFeature(drawLink(data));
					break;
			}
			// 开始绘制到画布上
			_layerManager.appendOnCanvas(this);
		}
		
		/**
		 * 重新构造因一开始分组中的分组没有实例化而导致的无法嵌套绘制的问题
		 *
		 */
		private function reInitGroup():void
		{
			eachGroup(function(id:String, group:ITPGroup):void
			{
				group.eachCacheChildId(function(childId:String):void
				{
					group.addChild(childId, findGroupById(childId));
				});
			});
		}
		
		/**
		 * 根据元素对象,生成对应的Feature对象
		 * @param element
		 * @return
		 *
		 */
		private function generateFeature(element:IElement):Feature
		{
			// 设置告警
			addRefreshAlarmElement(element);
			// 放入映射容器
			_elementMap.put(element.id, element);
			
			// 面
			if (element is IHLinkLayer)
			{
				_hlinkLayerMap.put(element.id, element);
				_objectMap.put(element.id, element);
			}
			else if (element is IHLinkUrl)
			{
				_hlinkUrlMap.put(element.id, element);
				_objectMap.put(element.id, element);
			}
			else if (element is IHLinkTopo)
			{
				_hlinkTopoMap.put(element.id, element);
				_objectMap.put(element.id, element);
			}
			else if (element is ITPView)
			{
				_tpViewMap.put(element.id, element);
				_objectMap.put(element.id, element);
			}
			else if (element is ITPGroup)
			{
				_groupMap.put(element.id, element);
			}
			else if (element is ITPComplex)
			{
				// 暂时没有独立使用此对象
			}
			else if (element is ITPShape)
			{
				_shapeMap.put(element.id, element);
				_objectMap.put(element.id, element);
			}
			else if (element is ITPGrid)
			{
				_tpGridMap.put(element.id, element);
				_objectMap.put(element.id, element);
			}
				// 点
			else if (element is ITPText)
			{
				_tpTextMap.put(element.id, element);
				_objectMap.put(element.id, element);
			}
			else if (element is ITPObject)
			{
				_tpObjectMap.put(element.id, element);
				_objectMap.put(element.id, element);
			}
			else if (element is ISegment)
			{
				_segmentMap.put(element.id, element);
			}
			else if (element is INode)
			{
				_nodeMap.put(element.id, element);
			}
				// 线
			else if (element is ILayerLink)
			{
				_linkMap.put(element.id, element);
			}
			else if (element is ILink)
			{
				_linkMap.put(element.id, element);
			}
			else if (element is ITPLine)
			{
				_tpLineMap.put(element.id, element);
				_objectMap.put(element.id, element);
			}
			
			// 生成拓扑要素
			var feature:Feature = new Feature(this, _topoCanvas, element, this._styleFactory.buildStyle(element));
			menuManager.menuOwner = feature;
			return feature;
		}
		
		/**
		 * 画 Node
		 * @param data
		 * @return
		 *
		 */
		private function drawNode(data:Object):Feature
		{
			var node:INode = new Node();
			if (!node.parseData(this._parserFactory.buildElementParser(node), data, this))
			{
				return null;
			}
			// 设置告警
			addRefreshAlarmElement(node);
			// 放入映射容器
			_nodeMap.put(node.id, node);
			_elementMap.put(node.id, node);
			// 生成拓扑要素
			var feature:Feature = new Feature(this, _topoCanvas, node, this._styleFactory.buildStyle(node));
			menuManager.menuOwner = feature;
			return feature;
		}
		
		/**
		 * 画 Segment
		 * @param data
		 * @return
		 *
		 */
		private function drawSegment(data:Object):Feature
		{
			var segment:ISegment = new Segment();
			//			log.info("drawSegment");
			//			log.info(data);
			if (!segment.parseData(this._parserFactory.buildElementParser(segment), data, this))
			{
				return null;
			}
			log.debug("segment.alarmEnabled:{0}",segment.alarmEnabled);
			// 设置告警
			addRefreshAlarmElement(segment);
			// 放入映射容器
			_segmentMap.put(segment.id, segment);
			_elementMap.put(segment.id, segment);
			// 生成拓扑要素
			var feature:Feature = new Feature(this, _topoCanvas, segment, this._styleFactory.buildStyle(segment));
			menuManager.menuOwner = feature;
			return feature;
		}
		
		/**
		 * 画 Link
		 * @param data
		 * @return
		 *
		 */
		private function drawLink(data:Object):Feature
		{
			var feature:Feature = null;
			var type:String = String(data.@type);
			//			log.info("drawLink");
			//			log.info(data);
			switch (type)
			{
				case ElementProperties.PROPERTYVALUE_LINK_TYPE_LAYER:
					feature = drawLayerLink(data);
					break;
				case ElementProperties.PROPERTYVALUE_LINK_TYPE_NORMAL:
				default:
					feature = drawNormalLink(data);
					break;
			}
			return feature;
		}
		
		/**
		 * 画普通的Link
		 * @param data
		 * @return
		 *
		 */
		private function drawNormalLink(data:Object):Feature
		{
			var link:ILink = new Link();
			//			log.info("drawNormalLink");
			//			log.info(data);
			if (!link.parseData(this._parserFactory.buildElementParser(link), data, this))
			{
				return null;
			}
			// 设置告警
			addRefreshAlarmElement(link);
			// 放入映射容器
			_linkMap.put(link.id, link);
			_elementMap.put(link.id, link);
			// 生成拓扑要素
			var feature:Feature = new Feature(this, _topoCanvas, link, this._styleFactory.buildStyle(link));
			menuManager.menuOwner = feature;
			
			return feature;
		}
		
		/**
		 * 画缩略图之间的 Link
		 * @param data
		 * @return
		 *
		 */
		private function drawLayerLink(data:Object):Feature
		{
			var layerLink:ILayerLink = new LayerLink();
			if (!layerLink.parseData(this._parserFactory.buildElementParser(layerLink), data, this))
			{
				return null;
			}
			// 设置告警
			addRefreshAlarmElement(layerLink);
			// 放入映射容器
			_linkMap.put(layerLink.id, layerLink);
			_elementMap.put(layerLink.id, layerLink);
			// 生成拓扑要素
			var feature:Feature = new Feature(this, _topoCanvas, layerLink, this._styleFactory.buildStyle(layerLink));
			menuManager.menuOwner = feature;
			
			return feature;
		}
		
		/**
		 * 在当前拓扑图中增加添加元素
		 * @param feature
		 * @param menuEnable 是否画菜单
		 * @param drawEnable 是否立即绘制
		 *
		 */
		public function appendNormalLink(link:ILink, menuEnable:Boolean = true, drawEnable:Boolean = false):void
		{
			// 设置告警
			addRefreshAlarmElement(link);
			// 放入映射容器
			_linkMap.put(link.id, link);
			_elementMap.put(link.id, link);
			// 生成拓扑要素
			var feature:Feature = new Feature(this, _topoCanvas, link, this._styleFactory.buildStyle(link));
			if (menuEnable)
			{
				menuManager.menuOwner = feature;
			}
			
			if (drawEnable)
			{
				addElement(feature);
				feature.drawWithStyle();
			}
			else
			{
				_layerManager.addFeature(feature);
			}
		}
		
		/**
		 * 画对象
		 * @param data
		 * @return
		 *
		 */
		private function drawObject(data:Object):Feature
		{
			var feature:Feature = null;
			var type:String = String(data.@type);
			//			log.info("drawObject");
			//			log.info(data); 
			switch (type)
			{
				case ElementProperties.PROPERTYVALUE_OBJECT_TYPE_SHAPE:
					feature = drawShape(data);
					break;
				case ElementProperties.PROPERTYVALUE_OBJECT_TYPE_LINE:
					feature = drawTPLine(data);
					break;
				case ElementProperties.PROPERTYVALUE_OBJECT_TYPE_TEXT:
					feature = drawText(data);
					break;
				case ElementProperties.PROPERTYVALUE_OBJECT_TYPE_HLINK_URL:
					feature = drawHLinkUrl(data);
					break;
				case ElementProperties.PROPERTYVALUE_OBJECT_TYPE_HLINK_TOPO:
					feature = drawHLinkTopo(data);
					break;
				case ElementProperties.PROPERTYVALUE_OBJECT_TYPE_HLINK_LAYER:
					feature = drawHLinkLayer(data);
					break;
				case ElementProperties.PROPERTYVALUE_OBJECT_TYPE_VIEW:
					feature = drawTPView(data);
					break;
				case ElementProperties.PROPERTYVALUE_OBJECT_TYPE_OBJECT:
					feature = drawTPObject(data);
					break;
				case ElementProperties.PROPERTYVALUE_OBJECT_TYPE_GRID:
					feature = drawTPGrid(data);
					break;
			}
			return feature;
		}
		
		/**
		 * 画线对象
		 * @param data
		 * @return
		 *
		 */
		private function drawTPLine(data:Object):Feature
		{
			var line:ITPLine = new TPLine();
			if (!line.parseData(this._parserFactory.buildElementParser(line), data, this))
			{
				return null;
			}
			// 设置告警
			addRefreshAlarmElement(line);
			// 放入映射容器
			_tpLineMap.put(line.id, line);
			_elementMap.put(line.id, line);
			_objectMap.put(line.id, line);
			// 生成拓扑要素
			var feature:Feature = new Feature(this, _topoCanvas, line, this._styleFactory.buildStyle(line));
			menuManager.menuOwner = feature;
			return feature;
		}
		
		/**
		 * 画形状
		 * @param data
		 * @return
		 *
		 */
		private function drawShape(data:Object):Feature
		{
			var shape:ITPShape = new TPShape();
			if (!shape.parseData(this._parserFactory.buildElementParser(shape), data, this))
			{
				return null;
			}
			// 设置告警
			addRefreshAlarmElement(shape);
			// 放入映射容器
			_shapeMap.put(shape.id, shape);
			_elementMap.put(shape.id, shape);
			_objectMap.put(shape.id, shape);
			// 生成拓扑要素
			var feature:Feature = new Feature(this, _topoCanvas, shape, this._styleFactory.buildStyle(shape));
			menuManager.menuOwner = feature;
			return feature;
		}
		
		/**
		 * 画分组
		 * @param data
		 * @return
		 *
		 */
		private function drawGroup(data:Object):Feature
		{
			var group:ITPGroup = new TPGroup();
			if (!group.parseData(this._parserFactory.buildElementParser(group), data, this))
			{
				return null;
			}
			log.debug("group.alarmEnabled:{0}",group.alarmEnabled);
			// 设置告警
			addRefreshAlarmElement(group);
			// 放入映射容器
			_groupMap.put(group.id, group);
			_elementMap.put(group.id, group);
			// 生成拓扑要素
			var feature:Feature = new Feature(this, _topoCanvas, group, this._styleFactory.buildStyle(group));
			menuManager.menuOwner = feature;
			return feature;
		}
		
		/**
		 * 在当前拓扑图中增加添加分组
		 * @param feature
		 * @param menuEnable 是否画菜单
		 * @param drawEnable 是否立即绘制
		 *
		 */
		public function appendGroup(group:ITPGroup, menuEnable:Boolean = true, drawEnable:Boolean = false):void
		{
			// 设置告警
			addRefreshAlarmElement(group);
			// 放入映射容器
			_groupMap.put(group.id, group);
			_elementMap.put(group.id, group);
			// 生成拓扑要素
			var feature:Feature = new Feature(this, _topoCanvas, group, this._styleFactory.buildStyle(group));
			if (menuEnable)
			{
				menuManager.menuOwner = feature;
			}
			
			if (drawEnable)
			{
				addElement(feature);
				feature.drawWithStyle();
			}
			else
			{
				_layerManager.addFeature(feature);
			}
		}
		
		/**
		 * 画文本对象
		 * @param data
		 * @return
		 *
		 */
		private function drawText(data:Object):Feature
		{
			var text:ITPText = new TPText();
			if (!text.parseData(this._parserFactory.buildElementParser(text), data, this))
			{
				return null;
			}
			// 设置告警
			addRefreshAlarmElement(text);
			// 放入映射容器
			_tpTextMap.put(text.id, text);
			_elementMap.put(text.id, text);
			_objectMap.put(text.id, text);
			// 生成拓扑要素
			var feature:Feature = new Feature(this, _topoCanvas, text, this._styleFactory.buildStyle(text));
			menuManager.menuOwner = feature;
			return feature;
		}
		
		/**
		 * 画超链接对象
		 * @param data
		 * @return
		 *
		 */
		private function drawHLinkUrl(data:Object):Feature
		{
			var hlinkUrl:IHLinkUrl = new HLinkUrl();
			if (!hlinkUrl.parseData(this._parserFactory.buildElementParser(hlinkUrl), data, this))
			{
				return null;
			}
			// 设置告警
			addRefreshAlarmElement(hlinkUrl);
			// 放入映射容器
			_hlinkUrlMap.put(hlinkUrl.id, hlinkUrl);
			_elementMap.put(hlinkUrl.id, hlinkUrl);
			_objectMap.put(hlinkUrl.id, hlinkUrl);
			// 生成拓扑要素
			var feature:Feature = new Feature(this, _topoCanvas, hlinkUrl, this._styleFactory.buildStyle(hlinkUrl));
			menuManager.menuOwner = feature;
			return feature;
		}
		
		/**
		 * 画拓扑内部链接对象
		 * @param data
		 * @return
		 *
		 */
		private function drawHLinkTopo(data:Object):Feature
		{
			var hlinkTopo:IHLinkTopo = new HLinkTopo();
			if (!hlinkTopo.parseData(this._parserFactory.buildElementParser(hlinkTopo), data, this))
			{
				return null;
			}
			// 设置告警
			addRefreshAlarmElement(hlinkTopo);
			// 放入映射容器
			_hlinkTopoMap.put(hlinkTopo.id, hlinkTopo);
			_elementMap.put(hlinkTopo.id, hlinkTopo);
			_objectMap.put(hlinkTopo.id, hlinkTopo);
			// 生成拓扑要素
			var feature:Feature = new Feature(this, _topoCanvas, hlinkTopo, this._styleFactory.buildStyle(hlinkTopo));
			menuManager.menuOwner = feature;
			return feature;
		}
		
		/**
		 * 画缩略图
		 * @param data
		 * @return
		 *
		 */
		protected function drawHLinkLayer(data:Object):Feature
		{
			// 空方法, 防止缩略图嵌套
			return null;
		}
		
		/**
		 * 画视图对象
		 * @param data
		 * @return
		 *
		 */
		private function drawTPView(data:Object):Feature
		{
			var tpView:ITPView = new TPView();
			if (!tpView.parseData(this._parserFactory.buildElementParser(tpView), data, this))
			{
				return null;
			}
			// 设置告警
			addRefreshAlarmElement(tpView);
			// 放入映射容器
			_tpViewMap.put(tpView.id, tpView);
			_elementMap.put(tpView.id, tpView);
			_objectMap.put(tpView.id, tpView);
			// 生成拓扑要素
			var feature:Feature = new Feature(this, _topoCanvas, tpView, this._styleFactory.buildStyle(tpView));
			menuManager.menuOwner = feature;
			return feature;
		}
		
		/**
		 * 画拓扑内置简单对象
		 * @param data
		 * @return
		 *
		 */
		private function drawTPObject(data:Object):Feature
		{
			var tpObject:ITPObject = new TPObject();
			if (!tpObject.parseData(this._parserFactory.buildElementParser(tpObject), data, this))
			{
				return null;
			}
			// 设置告警
			addRefreshAlarmElement(tpObject);
			// 放入映射容器
			_tpObjectMap.put(tpObject.id, tpObject);
			_elementMap.put(tpObject.id, tpObject);
			_objectMap.put(tpObject.id, tpObject);
			// 生成拓扑要素
			var feature:Feature = new Feature(this, _topoCanvas, tpObject, this._styleFactory.buildStyle(tpObject));
			menuManager.menuOwner = feature;
			return feature;
		}
		
		/**
		 * 画网格对象
		 * @param data
		 * @return
		 *
		 */
		private function drawTPGrid(data:Object):Feature
		{
			var tpGrid:ITPGrid = new TPGrid();
			if (!tpGrid.parseData(this._parserFactory.buildElementParser(tpGrid), data, this))
			{
				return null;
			}
			// 设置告警
			addRefreshAlarmElement(tpGrid);
			// 放入映射容器
			_tpGridMap.put(tpGrid.id, tpGrid);
			_elementMap.put(tpGrid.id, tpGrid);
			_objectMap.put(tpGrid.id, tpGrid);
			// 生成拓扑要素
			var feature:Feature = new Feature(this, _topoCanvas, tpGrid, this._styleFactory.buildStyle(tpGrid));
			menuManager.menuOwner = feature;
			return feature;
		}
		
		
		// ----------------------- 移除元素  ---------------------
		
		/**
		 * 移除拓扑中的元素
		 * @param element
		 * @return
		 *
		 */
		public function removeTopoElement(element:IElement):IElement
		{
			if (element == null)
			{
				return null;
			}
			// 面
			if (element is IHLinkLayer)
			{
				return removeHLinkLayer(element as IHLinkLayer);
			}
			else if (element is IHLinkTopo)
			{
				return removeHLinkTopo(element as IHLinkTopo);
			}
			else if (element is ITPGroup)
			{
				return removeGroup(element as ITPGroup);
			}
			else if (element is ITPShape)
			{
				return removeShape(element as ITPShape);
			}
			else if (element is ITPGrid)
			{
				return removeTPGrid(element as ITPGrid);
			}
				// 点
			else if (element is IHLinkUrl)
			{
				return removeHLinkUrl(element as IHLinkUrl);
			}
			else if (element is ITPText)
			{
				return removeText(element as ITPText);
			}
			else if (element is ITPObject)
			{
				return removeTPObject(element as ITPObject);
			}
			else if (element is ISegment)
			{
				return removeSegment(element as ISegment);
			}
			else if (element is INode)
			{
				return removeNode(element as INode);
			}
				// 线
			else if (element is ILink)
			{
				return removeLink(element as ILink);
			}
			else if (element is ITPLine)
			{
				return removeTPLine(element as ITPLine);
			}
			return element;
		}
		
		/**
		 * 移除关联的
		 * @param node
		 *
		 */
		private function removeConnectLinks(node:INode):void
		{
			// 注意: 此处需要复制已有链路的数组后再遍历.因为遍历时会从数组中删除,若不复制对导致遍历时数组越界.
			node.inLines.concat().forEach(function(inLink:ILink, index:int, arr:Array):void
			{
				removeLink(inLink);
			});
			node.outLines.concat().forEach(function(outLink:ILink, index:int, arr:Array):void
			{
				removeLink(outLink);
			});
		}
		
		/**
		 * 移除 Node
		 * @param node
		 * @return
		 *
		 */
		private function removeNode(node:INode):INode
		{
			removeConnectLinks(node);
			removeElement(node.feature);
			_nodeMap.remove(node.id);
			_elementMap.remove(node.id);
			removeRefreshAlarmElement(node);
			return node;
		}
		
		/**
		 * 移除 Segment
		 * @param segment
		 * @return
		 *
		 */
		private function removeSegment(segment:ISegment):ISegment
		{
			removeConnectLinks(segment);
			removeElement(segment.feature);
			_segmentMap.remove(segment.id);
			_elementMap.remove(segment.id);
			removeRefreshAlarmElement(segment);
			return segment;
		}
		
		/**
		 * 移除 Link
		 * @param link
		 * @return
		 *
		 */
		private function removeLink(link:ILink):ILink
		{
			if (link == null)
			{
				return link;
			}
			if (link is ILayerLink)
			{
				// 缩略图间的链路
				var layerLink:ILayerLink = link as ILayerLink;
				if (layerLink.fromLayer)
				{
					layerLink.fromLayer.removeOutLine(layerLink);
				}
				if (layerLink.toLayer)
				{
					layerLink.toLayer.removeInLine(layerLink);
				}
			}
			else
			{
				// 删除链路两端网元对于链路的引用
				if (link.fromElement)
				{
					link.fromElement.removeOutLine(link);
				}
				if (link.toElement)
				{
					link.toElement.removeInLine(link);
				}
			}
			
			// 从画布中删除链路
			removeElement(link.feature);
			_linkMap.remove(link.id);
			_elementMap.remove(link.id);
			removeRefreshAlarmElement(link);
			return link;
		}
		
		/**
		 * 移除 ITPLine
		 * @param line
		 * @return
		 *
		 */
		private function removeTPLine(line:ITPLine):ITPLine
		{
			// 线没有关联链路,无需移除
			removeElement(line.feature);
			_tpLineMap.remove(line.id);
			_objectMap.remove(line.id);
			_elementMap.remove(line.id);
			return line;
		}
		
		/**
		 * 移除 Shape
		 * @param shape
		 * @return
		 *
		 */
		private function removeShape(shape:ITPShape):ITPShape
		{
			removeConnectLinks(shape);
			removeElement(shape.feature);
			_shapeMap.remove(shape.id);
			_objectMap.remove(shape.id);
			_elementMap.remove(shape.id);
			return shape;
		}
		
		/**
		 * 移除 Group (需要完善,里面的对象怎么办?)
		 * @param shape
		 * @return
		 *
		 */
		private function removeGroup(group:ITPGroup):ITPGroup
		{
			removeConnectLinks(group);
			removeElement(group.feature);
			_groupMap.remove(group.id);
			_elementMap.remove(group.id);
			return group;
		}
		
		/**
		 * 移除 文本对象
		 * @param text
		 * @return
		 *
		 */
		private function removeText(text:ITPText):ITPText
		{
			removeConnectLinks(text);
			removeElement(text.feature);
			_tpTextMap.remove(text.id);
			_objectMap.remove(text.id);
			_elementMap.remove(text.id);
			return text;
		}
		
		/**
		 * 移除 拓扑内置简单对象
		 * @param tpObject
		 * @return
		 *
		 */
		private function removeTPObject(tpObject:ITPObject):ITPObject
		{
			removeConnectLinks(tpObject);
			removeElement(tpObject.feature);
			_tpObjectMap.remove(tpObject.id);
			_objectMap.remove(tpObject.id);
			_elementMap.remove(tpObject.id);
			return tpObject;
		}
		
		/**
		 * 移除 超链接对象
		 * @param hlinkUrl
		 * @return
		 *
		 */
		private function removeHLinkUrl(hlinkUrl:IHLinkUrl):IHLinkUrl
		{
			removeConnectLinks(hlinkUrl);
			removeElement(hlinkUrl.feature);
			_hlinkUrlMap.remove(hlinkUrl.id);
			_objectMap.remove(hlinkUrl.id);
			_elementMap.remove(hlinkUrl.id);
			return hlinkUrl;
		}
		
		/**
		 * 移除 拓扑内部链接对象
		 * @param hlinkTopo
		 * @return
		 *
		 */
		private function removeHLinkTopo(hlinkTopo:IHLinkTopo):IHLinkTopo
		{
			removeConnectLinks(hlinkTopo);
			removeElement(hlinkTopo.feature);
			_hlinkTopoMap.remove(hlinkTopo.id);
			_objectMap.remove(hlinkTopo.id);
			_elementMap.remove(hlinkTopo.id);
			removeRefreshAlarmElement(hlinkTopo);
			return hlinkTopo;
		}
		
		/**
		 * 移除 立体层次 (需要完善,里面的对象怎么办?)
		 * @param hlinkLayer
		 * @return
		 *
		 */
		private function removeHLinkLayer(hlinkLayer:IHLinkLayer):IHLinkLayer
		{
			removeConnectLinks(hlinkLayer);
			removeElement(hlinkLayer.feature);
			_hlinkLayerMap.remove(hlinkLayer.id);
			_objectMap.remove(hlinkLayer.id);
			_elementMap.remove(hlinkLayer.id);
			return hlinkLayer;
		}
		
		/**
		 * 移除 拓扑视图对象
		 * @param tpView
		 * @return
		 *
		 */
		private function removeTpView(tpView:ITPView):ITPView
		{
			removeConnectLinks(tpView);
			removeElement(tpView.feature);
			_tpViewMap.remove(tpView.id);
			_objectMap.remove(tpView.id);
			_elementMap.remove(tpView.id);
			removeRefreshAlarmElement(tpView);
			return tpView;
		}
		
		/**
		 * 移除 网格对象
		 * @param tpGrid
		 * @return
		 *
		 */
		private function removeTPGrid(tpGrid:ITPGrid):ITPGrid
		{
			removeConnectLinks(tpGrid);
			removeElement(tpGrid.feature);
			_tpGridMap.remove(tpGrid.id);
			_objectMap.remove(tpGrid.id);
			_elementMap.remove(tpGrid.id);
			return tpGrid;
		}
		
		// ----------------------- 告警  ---------------------
		
		/**
		 * 添加需要刷新告警的元素<br/>
		 * 此方法会判断哪些类型的对象需要刷新告警
		 *
		 * @param element
		 *
		 */
		private function addRefreshAlarmElement(element:IElement):void
		{
			if (!element.alarmEnabled)
			{
				return;
			}
			// 设置告警对象
			element.alarm = _alarmFactory.buildNullAlarm(element);
			
			var elementTopoName:String = element.getExtendProperty(ElementProperties.OBJECT_TOPO_TOPONAME);
			if (elementTopoName == null)
			{
				elementTopoName = topoName;
			}
			var idArray:Array = _topoName2refreshAlarmElementIdArray.get(elementTopoName);
			if (idArray == null)
			{
				idArray = [];
				_topoName2refreshAlarmElementIdArray.put(elementTopoName, idArray);
			}
			idArray.push(element.id);
			
			
			//增加链路告警渲染
			if(element is Line)
			{
				var idArray1:Array = _topoName2refreshAlarmLinkIdArray.get(elementTopoName);
				if (idArray1 == null)
				{
					idArray1 = [];
					_topoName2refreshAlarmLinkIdArray.put(elementTopoName, idArray1);
				}
				idArray1.push(element.id+"|@|"+element.getExtendProperty(XML_KEY_MO_ID1)+"|@|"+element.getExtendProperty(XML_KEY_MO_ID2));
			}
		}
		
		/**
		 * 移除需要刷新告警的元素
		 * @param element
		 *
		 */
		private function removeRefreshAlarmElement(element:IElement):void
		{
			var elementTopoName:String = element.getExtendProperty(ElementProperties.OBJECT_TOPO_TOPONAME);
			if (elementTopoName == null)
			{
				elementTopoName = topoName;
			}
			var idArray:Array = _topoName2refreshAlarmElementIdArray.get(elementTopoName);
			if (idArray)
			{
				ArrayUtil.removeValueFromArray(idArray, element.id);
			}
			
			//增加链路告警渲染
			if(element is Line)
			{
				var idArray1:Array = _topoName2refreshAlarmLinkIdArray.get(elementTopoName);
				if (idArray1)
				{
					ArrayUtil.removeValueFromArray(idArray1, element.id+"|@|"+element.getExtendProperty(XML_KEY_MO_ID1)+"|@|"+element.getExtendProperty(XML_KEY_MO_ID2));
				}
			}
		}
		
		/**
		 * 清空告警
		 *
		 */
		public function clearAlarm():void
		{
			// 将之前有告警的元素缓存起来
			_lastAlarmElements.clear();
			// 只清空告警的数据,暂时不清空渲染的效果,后续触发刷新时再重新渲染
			_alarmElements.forEach(function(element:IElement):void
			{
				element.alarm.reset();
				element.feature.clearAllChildLevel();
				_lastAlarmElements.add(element);
			});
			_alarmElements.clear();
			alarmArrayCollection.removeAll();
		}
		
		/**
		 * 增量的添加告警数据<br/>
		 * 格式为: {node:[{id:elementId, type:1~3, 1:num, 2:num, 3:num, 4:num},...]}
		 *
		 * @param data
		 *
		 */
		public function appendAlarms(data:Object):void
		{
			// 【2】刷新新告警
			if (data != null)
			{
				// 节点
				if (data.node)
				{
					var element:IElement = null;
					// 设备+云图+云图镜像+链路
					for each (var node:Object in data.node)
					{
						element = findElementById(node.id);
						if (element)
						{
							element.alarm.data = node;
							_alarmElements.add(element);
							alarmArrayCollection.addItem(element);
						}
					}
				}
				// 链路
				if (data.link)
				{
					var link:IElement = null;
					// 链路
					for each (var linkNode:Object in data.link)
					{
						link = findElementById(linkNode.id);
						if (link)
						{
							link.feature.addFeatureLevel(linkNode);
							_alarmElements.add(link);
						}
					}
				}
			}
		}
		
		/**
		 * 触发告警渲染刷新
		 *
		 */
		public function triggerAlarmRender():void
		{
			// 遍历完成后，再渲染告警
			_alarmElements.forEach(function(element:IElement):void
			{
				element.feature.refreshAlarm();
				_lastAlarmElements.remove(element);
			});
			// 将之前有告警,现在没有告警的对象刷新
			_lastAlarmElements.forEach(function(element:IElement):void
			{
				element.feature.refreshAlarm();
			});
		}
		
		/**
		 * 注入告警数据
		 * @param data
		 *
		 */
		public function set alarms(data:Object):void
		{
			// 【1】清除之前的告警
			clearAlarm();
			
			// 【2】刷新新告警
			appendAlarms(data);
			
			// 【3】触发告警的渲染
			triggerAlarmRender();
		}
		
	}
}