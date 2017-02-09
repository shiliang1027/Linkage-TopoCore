package com.linkage.module.topo.framework.view.component
{
	import com.linkage.module.topo.framework.Constants;
	import com.linkage.module.topo.framework.controller.action.IAction;
	import com.linkage.module.topo.framework.controller.event.ActionEvent;
	import com.linkage.module.topo.framework.controller.event.CanvasEvent;
	import com.linkage.module.topo.framework.controller.menu.ExtendMenuManager;
	import com.linkage.module.topo.framework.core.Feature;
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.model.element.plane.HLinkLayer;
	import com.linkage.module.topo.framework.core.model.element.plane.IHLinkLayer;
	import com.linkage.module.topo.framework.core.model.element.point.ITPPoint;
	import com.linkage.module.topo.framework.service.ServiceContainer;
	import com.linkage.module.topo.framework.service.core.TopoInternalService;
	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;
	import com.linkage.system.structure.map.IMap;
	import com.linkage.system.structure.map.Map;
	
	import flash.geom.Point;
	
	import mx.events.FlexEvent;

	/**
	 * 拓扑图画布(核心)
	 * @author duangr
	 *
	 */
	public class TopoCanvas extends TopoLayer
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.view.component.TopoCanvas");
		// -----------------  Action --------------------//
		private var _action:IAction = null;
		// -----------------  业务容器 --------------------//
		private var _serviceContainer:ServiceContainer = null;

		// --------------- 扩展的参数配置 -----------------//
		// 是否允许渲染告警数量
		private var _renderAlarmNumEnabled:Boolean = false;

		public function TopoCanvas()
		{
			super(this);
			stepRenderMaxSize = 200;
			this.addEventListener(FlexEvent.CREATION_COMPLETE,onCreationComplete);
		}
		
		private function onCreationComplete(event:FlexEvent):void{
			log.debug("-------->{0}",this.parent);
			menuManager = new ExtendMenuManager(this);
		}

		override public function toString():String
		{
			return _action + ", " + super.toString();
		}

		public function get renderAlarmNumEnabled():Boolean
		{
			return _renderAlarmNumEnabled;
		}

		public function set renderAlarmNumEnabled(value:Boolean):void
		{
			_renderAlarmNumEnabled = value;
		}

		override public function doValidate():void
		{
			super.doValidate();
			if (_action == null)
			{
				throw new ArgumentError("请先设置参数[action]后再启动拓扑!");
			}
		}

		override public function get weight():uint
		{
			return Constants.WEIGHT_CANVAS;
		}

		/**
		 * 画布的Action对象
		 */
		public function set action(value:IAction):void
		{
			// 删除旧的监听器,添加新的监听器
			var oldAction:IAction = _action;
			if (_action)
			{
				_action.removeCanvasListeners();
			}
			_action = value;
			_action.addCanvasListeners();
			this.dispatchEvent(new ActionEvent(ActionEvent.ACTION_CHANGED, oldAction, _action));
		}

		public function get action():IAction
		{
			return _action;
		}

		/**
		 * 业务容器
		 */
		public function set serviceContainer(value:ServiceContainer):void
		{
			_serviceContainer = value;
		}

		/**
		 * 内置业务逻辑
		 * @return
		 *
		 */
		private function get internalService():TopoInternalService
		{
			return _serviceContainer.internalService;
		}

		/**
		 * 调整画布宽高
		 *
		 */
		public function resizeCanvas(width:Number, height:Number):void
		{
			log.debug("调整画布宽高 w:{0} h:{1}", width, height);
			viewBounds.updateByWidthHeight(width, height);
			viewBounds.refresh();
		}

		// ======================= 比例尺变化 ====================

		/**
		 * 一屏显示(按比例缩放)
		 *
		 */
		public function oneScreenViewProportional():void
		{
			// 先缓存下之前的比例尺
			var scaleX_before:Number = this.scaleX;
			var scaleY_before:Number = this.scaleY;

			// 若存在缩放,先还原
			if (this.scaleX != 1 || this.scaleY != 1)
			{
				this.viewBounds.afterViewZoom(1 / this.scaleX, 1 / this.scaleY);
				this.scaleX = 1;
				this.scaleY = 1;
				this.viewBounds.updateByCenter(this.dataBounds.rectangle.width / 2, this.dataBounds.rectangle.height / 2);
			}
			// 如果数据的边界本来就比显示的边界小,则不需要缩放
			if (this.viewBounds.rectangle.width >= this.dataBounds.rectangle.width && this.viewBounds.rectangle.height >= this.dataBounds.rectangle.height)
			{
				// 显示不需要缩放
			}
			else
			{
				// 计算显示的宽度在数据宽度比例,然后执行缩小操作
				var scaleX:Number = this.parent.width / (this.dataBounds.rectangle.width);
				var scaleY:Number = this.parent.height / (this.dataBounds.rectangle.height);
				// 此处仅允许缩小,不允许放大
				scaleX = scaleX > 1 ? 1 : scaleX;
				scaleY = scaleY > 1 ? 1 : scaleY;

				var scaleFinel:Number = Math.min(scaleX, scaleY);

				this.viewBounds.afterViewZoom(scaleFinel / this.scaleX, scaleFinel / this.scaleY);
				this.scaleX = scaleFinel;
				this.scaleY = scaleFinel;

			}
			this.viewBounds.updateByDataBoundsCenter(this.dataBounds);
			this.viewBounds.refresh();

			// 抛出scale变化事件
			dispatchScaleChangeEvent(scaleX_before, scaleY_before, this.scaleX, this.scaleY);
		}

		/**
		 * 一屏显示
		 *
		 */
		public function oneScreenView():void
		{
			// 先缓存下之前的比例尺
			var scaleX_before:Number = this.scaleX;
			var scaleY_before:Number = this.scaleY;

			// 若存在缩放,先还原
			if (this.scaleX != 1 || this.scaleY != 1)
			{
				this.viewBounds.afterViewZoom(1 / this.scaleX, 1 / this.scaleY);
				this.scaleX = 1;
				this.scaleY = 1;
				this.viewBounds.updateByCenter(this.dataBounds.rectangle.width / 2, this.dataBounds.rectangle.height / 2);
			}
			// 如果数据的边界本来就比显示的边界小,则不需要缩放
			if (this.viewBounds.rectangle.width >= this.dataBounds.rectangle.width && this.viewBounds.rectangle.height >= this.dataBounds.rectangle.height)
			{
				// 显示不需要缩放
			}
			else
			{
				// 计算显示的宽度在数据宽度比例,然后执行缩小操作
				var scaleX:Number = this.parent.width / (this.dataBounds.rectangle.width);
				var scaleY:Number = this.parent.height / (this.dataBounds.rectangle.height);
				// 此处仅允许缩小,不允许放大
				scaleX = scaleX > 1 ? 1 : scaleX;
				scaleY = scaleY > 1 ? 1 : scaleY;

				this.viewBounds.afterViewZoom(scaleX / this.scaleX, scaleY / this.scaleY);
				this.scaleX = scaleX;
				this.scaleY = scaleY;

			}
			this.viewBounds.updateByDataBoundsCenter(this.dataBounds);
			this.viewBounds.refresh();

			// 抛出scale变化事件
			dispatchScaleChangeEvent(scaleX_before, scaleY_before, this.scaleX, this.scaleY);

		}

		/**
		 * 原始尺寸显示
		 *
		 */
		public function originalView():void
		{
			// 先缓存下之前的比例尺
			var scaleX_before:Number = this.scaleX;
			var scaleY_before:Number = this.scaleY;

			if (this.scaleX != 1 || this.scaleY != 1)
			{
				this.viewBounds.afterViewZoom(1 / this.scaleX, 1 / this.scaleY);
				this.scaleX = 1;
				this.scaleY = 1;
				this.viewBounds.updateByCenter(this.dataBounds.rectangle.width / 2, this.dataBounds.rectangle.height / 2);

				this.viewBounds.refresh();

				// 抛出scale变化事件
				dispatchScaleChangeEvent(scaleX_before, scaleY_before, this.scaleX, this.scaleY);
			}
		}

		/**
		 * 通过某比例尺的变化率,以某个固定点缩放
		 *
		 * @param pointX
		 * @param pointY
		 * @param iscaleX x轴放大缩小比例的变化率 (新的scale = 之前的scale * 变化率)
		 * @param iscaleY y轴放大缩小比例的变化率 (新的scale = 之前的scale * 变化率)
		 *
		 */
		public function zoomAtPointByScale(pointX:Number, pointY:Number, iscaleX:Number, iscaleY:Number):void
		{
			// 先缓存下之前的比例尺
			var scaleX_before:Number = this.scaleX;
			var scaleY_before:Number = this.scaleY;

			// 计算缩放之前,固定点在平面的长宽比例
			var widthPercent:Number = (pointX - this.viewBounds.rectangle.x) / this.viewBounds.rectangle.width;
			var heightPercent:Number = (pointY - this.viewBounds.rectangle.y) / this.viewBounds.rectangle.height;

			var beforeScaleX:Number = this.scaleX;
			var beforeScaleY:Number = this.scaleY;
			// 下面是缩放逻辑
			this.scaleX = beforeScaleX * iscaleX;
			this.scaleY = beforeScaleY * iscaleY;
			this.viewBounds.afterViewZoom(iscaleX, iscaleY);

			// 缩放后,按照之前的比例,计算出固定点距左上角的长宽距离,然后计算出展示矩形左上角的(x,y)
			var width:Number = this.viewBounds.rectangle.width * widthPercent;
			var height:Number = this.viewBounds.rectangle.height * heightPercent;
			this.viewBounds.updateByXY(pointX - width, pointY - height);

			// 刷新显示区域
			this.viewBounds.refresh();

			// 抛出scale变化事件
			dispatchScaleChangeEvent(scaleX_before, scaleY_before, this.scaleX, this.scaleY);
		}

		/**
		 * 缩放到指定比例尺,以某个固定点缩放
		 *
		 * @param pointX
		 * @param pointY
		 * @param iscaleX
		 * @param iscaleY
		 *
		 */
		public function zoomAtPointToScale(pointX:Number, pointY:Number, iscaleX:Number, iscaleY:Number):void
		{
			zoomAtPointByScale(pointX, pointY, iscaleX / this.scaleX, iscaleY / this.scaleY);
		}

		/**
		 * 抛出比例尺变化事件
		 *
		 * @param scaleX_before
		 * @param scaleY_before
		 * @param scaleX_after
		 * @param scaleY_after
		 *
		 */
		private function dispatchScaleChangeEvent(scaleX_before:Number, scaleY_before:Number, scaleX_after:Number, scaleY_after:Number):void
		{
			// 比例尺变化后抛出事件
			if (scaleX_before != scaleX_after || scaleY_before != scaleY_after)
			{
				var map:IMap = new Map();
				map.put(Constants.MAP_KEY_SCALEX_BEFORE, scaleX_before);
				map.put(Constants.MAP_KEY_SCALEY_BEFORE, scaleY_before);
				map.put(Constants.MAP_KEY_SCALEX_AFTER, scaleX_after);
				map.put(Constants.MAP_KEY_SCALEY_AFTER, scaleY_after);
				this.dispatchEvent(new CanvasEvent(CanvasEvent.SCALE_CHANGED, null, map));
			}
		}


		// ======================= 坐标转换 ====================
		/**
		 * 存储的坐标转换为相对父对象的坐标
		 * @param feature 拓扑要素
		 * @param x X坐标
		 * @param y Y坐标
		 * @return
		 *
		 */
		override public function xyToLocal(feature:Feature, x:Number, y:Number):Point
		{

			try
			{
				if (feature.parent is TopoCanvas)
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
				log.debug("xyToLocal Error {0} feature={1}  ({2},{3})  StackTrace:{4}", e.message, feature, x, y, e.getStackTrace());
			}
			return new Point(x + dataBounds.offsetX, y + dataBounds.offsetY);

		}

		/**
		 * 鼠标的数据位置
		 */
		public function get mousePoint():Point
		{
			return new Point(this.mouseX - dataBounds.offsetX, this.mouseY - dataBounds.offsetY);
		}


		/**
		 * 重置拓扑图容器,将已有内部对象全部删除,容器都清空
		 */
		override public function resetContianer():void
		{
			super.resetContianer();
		}

		override public function set dataXML(data:XML):void
		{
			if (data == null || data.child("NetView").length() == 0)
			{
				log.error("拓扑图数据为空,不能绘制拓扑!");
				this.dispatchEvent(new CanvasEvent(CanvasEvent.LOAD_LAYER_ERROR));
				return;
			}
			originalView();
			initTopoLayerSize(this.parent.width, this.parent.height);
			super.dataXML = data;
		}

		override public function set dataXMLWithoutDraw(data:XML):void
		{
			if (data == null || data.child("NetView").length() == 0)
			{
				log.error("拓扑图数据为空,不能绘制拓扑!");
				this.dispatchEvent(new CanvasEvent(CanvasEvent.LOAD_LAYER_ERROR));
				return;
			}
			initTopoLayerSize(this.parent.width, this.parent.height);
			super.dataXMLWithoutDraw = data;
		}

		override public function drawOnCanvas(restatBound:Boolean = false):void
		{
			super.drawOnCanvas(restatBound);
			// 抛出层次切换事件
			this.dispatchEvent(new CanvasEvent(CanvasEvent.LAYER_CHANGED));
		}

		override public function triggerAlarmRender():void
		{
			super.triggerAlarmRender();
			// 抛出告警变化事件
			this.dispatchEvent(new CanvasEvent(CanvasEvent.ALARM_CHANGED));
		}


		// -----------------  画对象 ------------------ //


		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}

		override protected function drawHLinkLayer(data:Object):Feature
		{
			var hlinkLayer:IHLinkLayer = new HLinkLayer();
			if (!hlinkLayer.parseData(this.parserFactory.buildElementParser(hlinkLayer), data, this))
			{
				return null;
			}
			// 放入映射容器
			_hlinkLayerMap.put(hlinkLayer.id, hlinkLayer);
			_elementMap.put(hlinkLayer.id, hlinkLayer);
			_objectMap.put(hlinkLayer.id, hlinkLayer);
			// 生成拓扑要素
			var feature:Feature = new Feature(this, this, hlinkLayer, this.styleFactory.buildStyle(hlinkLayer));
			menuManager.menuOwner = feature;
			return feature;
		}

		/**
		 * 添加对象到画布中,绘制并且保存
		 * @param element
		 *
		 */
		public function addElementsAndSave(elements:Array):void
		{
			internalService.saveElements(topoId, topoName, elements, false, true);
		}

		// -----------------  一些基本的操作 ------------------ //
		/**
		 * 重载当前层拓扑
		 *
		 */
		public function loadCurrentTopo():void
		{
			internalService.loadCurrentTopo();
		}

		/**
		 * 加载后退层次拓扑
		 *
		 */
		public function loadBackTopo():void
		{
			internalService.loadBackTopo();
		}

		/**
		 * 加载指定层次的拓扑
		 *
		 * @param id 拓扑对象id
		 * @param topoName 拓扑数据源
		 * @param useCanvasTopoName topoName为空时是否使用画布的topoName
		 * @param type 类型:segment / view
		 *
		 */
		public function loadTopo(id:String, topoName:String = null, useCanvasTopoName:Boolean = true, type:String = "segment"):void
		{
			internalService.loadTopo(id, topoName, useCanvasTopoName, type);
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
			internalService.loadViewModelTopo(modelId, modelParams, topoName);
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
			internalService.loadParentTopo(id, topoName, useCanvasTopoName, type);
		}

		/**
		 * 获取拓扑数据,并将返回数据回调
		 * @param callback
		 * @param id 拓扑对象id
		 * @param topoName 拓扑数据源
		 * @param useCanvasTopoName topoName为空时是否使用画布的topoName
		 * @param type 类型:segment / view
		 *
		 */
		public function loadTopoData(callback:Function, id:String, topoName:String = null, useCanvasTopoName:Boolean = true, type:String = "segment"):void
		{
			internalService.loadTopoData(callback, id, topoName, useCanvasTopoName, type);
		}

		/**
		 * 加载指定的拓扑数据
		 * @param data
		 *
		 */
		public function loadTopoXML(data:XML):void
		{
			internalService.loadTopoXML(data);
		}

		/**
		 * 清空后退的路径
		 *
		 */
		public function clearGoBackPaths():void
		{
			internalService.clearGoBackPaths();
		}

		/**
		 * 定位网元
		 *
		 * @param id 拓扑中唯一id
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
			internalService.locateElement(id, name, topoName == null ? this.topoName : topoName, confirm, path, success);
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
		public function saveTopoLayerAsNew(newId:String, newName:String, pid:String, topoName:String, properties:IMap, curidEnabled:Boolean = false, resultToCanvas:Boolean = false):void
		{
			internalService.saveTopoLayerAsNew(newId, newName, pid, topoName == null ? this.topoName : topoName, properties, curidEnabled, resultToCanvas);
		}

		/**
		 * 将当前层的拓扑数据重新全部保存(认为之前数据支撑模块中没有数据)
		 *
		 * @param topoName
		 * @param curidEnabled 是否使用当前数据中的id作为保存的id
		 * @param resultToCanvas 成功返回的结果是否入库
		 *
		 */
		public function saveTopoLayerAsCurrent(topoName:String, curidEnabled:Boolean = false, resultToCanvas:Boolean = false):void
		{
			internalService.saveTopoLayerAsCurrent(topoName == null ? this.topoName : topoName, curidEnabled, resultToCanvas);
		}

		/**
		 * 保存拓扑(同步对象坐标并且通知数据支撑模块保存)
		 *
		 */
		public function saveTopo():void
		{
			internalService.saveTopo();
		}

	}
}