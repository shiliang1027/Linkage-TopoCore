package com.linkage.module.topo.framework.view.component.hawkeye
{
	import com.linkage.module.topo.framework.controller.event.CanvasEvent;
	import com.linkage.module.topo.framework.core.ViewBounds;
	import com.linkage.module.topo.framework.service.core.mo.TopoPath;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;
	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.UIComponent;

	/**
	 * 鹰眼
	 * @author duangr
	 *
	 */
	public class HawkEye extends UIComponent
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.view.component.HawkEye");

		// 鹰眼对应的拓扑层次
		private var _path:TopoPath = null;
		// 画布
		private var _topoCanvas:TopoCanvas;
		// 是否首次创建完成
		private var _creationComplete:Boolean = false;

		// 鹰眼中背景拓扑图区域
		private var _bgShape:Shape;
		// 当前显示拓扑相对鹰眼中的框框
		private var _eyeShape:Sprite;
		// 是否移动的标志
		private var isMove:Boolean = false;
		// 监听器是否启用
		private var _linstenerEnable:Boolean = false;
		
		//数据视图与显示视图宽比率
		private var _dvwRate:Number=1;
		//数据视图与显示视图高比率
		private var _dvhRate:Number=1;
		//数据视图与鹰眼视图宽比率
		private var _dewRate:Number=1;
		//数据视图与鹰眼视图高比率
		private var _deHRate:Number=1;
		
		private var isFirst:Boolean=true;

		public function HawkEye(path:TopoPath)
		{
			super();
			this.percentWidth = 100;
			this.percentHeight = 100;
			_bgShape = new Shape();
			_bgShape.x = _bgShape.y = 0;
			this.addChild(_bgShape);
			_eyeShape = new Sprite();
			_eyeShape.x = _eyeShape.y = 0;
			this.addChild(_eyeShape);

			_path = path;
		}

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if (!_creationComplete)
			{
				drawBorder();
				_creationComplete = true;
			}
		}

		/**
		 * 画鹰眼的边框
		 *
		 */
		private function drawBorder():void
		{
			var color:uint = getStyle("borderColor");
			var alpha:Number = getStyle("borderAlpha");
			var border:Shape = new Shape();
			border.graphics.lineStyle(1, color, alpha);
			border.graphics.drawRect(0, 0, this.width, this.height);
			border.graphics.endFill();
			this.addChild(border);
		}

		/**
		 * 拓扑path
		 *
		 */
		public function get path():TopoPath
		{
			return _path;
		}

		/**
		 * 销毁对象
		 *
		 */
		public function destroy():void
		{
			removeCanvasListeners();
			removeChangeCanvasListeners();
			_topoCanvas = null;
			_bgShape = null;
			_eyeShape = null;
		}

		/**
		 * 拓扑画布
		 */
		public function set topoCanvas(topoCanvas:TopoCanvas):void
		{
			this._topoCanvas = topoCanvas;

		}

		/**
		 * 显示|隐藏 状态切换
		 *
		 */
		public function toggle():void
		{
			this.visible = !this.visible;
		}

		/**
		 * 注册画布监听器
		 */
		private function addCanvasListeners():void
		{
			if (_linstenerEnable == false)
			{
				this._topoCanvas.addEventListener(CanvasEvent.DATA_CHANGED, canvasEventHandler_DataChanged);
				this._topoCanvas.addEventListener(CanvasEvent.ALARM_CHANGED, canvasEventHandler_DataChanged);
				this._topoCanvas.addEventListener(CanvasEvent.VIEWBOUNDS_CHANGED, canvasEventHandler_ViewBoundsChanged);

				_eyeShape.addEventListener(MouseEvent.MOUSE_DOWN, eyeMouseDown) 
				_eyeShape.addEventListener(MouseEvent.MOUSE_UP, eyeMouseReleased);
				_eyeShape.addEventListener(MouseEvent.MOUSE_OUT, eyeMouseReleased);
				_eyeShape.visible = true;
				_linstenerEnable = true;
			}
		}
		
		/**
		 * 移除画布监听器
		 */
		private function removeCanvasListeners():void
		{
			if (_linstenerEnable == true)
			{
				this._topoCanvas.removeEventListener(CanvasEvent.DATA_CHANGED, canvasEventHandler_DataChanged);
				this._topoCanvas.removeEventListener(CanvasEvent.ALARM_CHANGED, canvasEventHandler_DataChanged);
				this._topoCanvas.removeEventListener(CanvasEvent.VIEWBOUNDS_CHANGED, canvasEventHandler_ViewBoundsChanged);

				_eyeShape.removeEventListener(MouseEvent.MOUSE_DOWN, eyeMouseDown) 
				_eyeShape.removeEventListener(MouseEvent.MOUSE_UP, eyeMouseReleased);
				_eyeShape.removeEventListener(MouseEvent.MOUSE_OUT, eyeMouseReleased);
				_eyeShape.visible = false;

				_linstenerEnable = false;
			}
		}
		
		/**
		 * 添加画布切换的监听器(鹰眼不是当前层次时,点击时需要切换到鹰眼指定层次)
		 *
		 */
		private function addChangeCanvasListeners():void
		{
			if (!this.hasEventListener(MouseEvent.CLICK))
			{
				this.addEventListener(MouseEvent.CLICK, handleDisableStatusMouseClick);
				this.buttonMode = true;
				this.toolTip = "点击切换至:" + _path.name;
			}
		}

		/**
		 * 移除画布切换的监听器
		 *
		 */
		private function removeChangeCanvasListeners():void
		{
			if (this.hasEventListener(MouseEvent.CLICK))
			{
				this.removeEventListener(MouseEvent.CLICK, handleDisableStatusMouseClick);
				this.buttonMode = false;
				this.toolTip = null;
			}
		}


		/**
		 * 启用鹰眼
		 */
		public function enable():void
		{
			addCanvasListeners();
			removeChangeCanvasListeners();

		}

		/**
		 * 禁用鹰眼
		 */
		public function disable():void
		{
			removeCanvasListeners();
			addChangeCanvasListeners();

		}


		/**
		 * 捕获拓扑画布中数据变更刷新通知
		 * @param event
		 *
		 */
		private function canvasEventHandler_DataChanged(event:CanvasEvent):void
		{
			loadData();
//			refresh();
		}

		/**
		 * 捕获拓扑画布中显示区域位置变化后的通知事件
		 * @param event
		 *
		 */
		private function canvasEventHandler_ViewBoundsChanged(event:CanvasEvent):void
		{
			loadData();
//			refresh();
		}

		/**
		 *重新加载 位图数据
		 *
		 */
		public function loadData():void
		{
			log.debug("鹰眼开始装载数据");
//			if (_topoCanvas.dataBounds.rectangle.width == 0 || _topoCanvas.dataBounds.rectangle.height == 0)
//			{
//				return;
//			}
			var bitmapData:BitmapData = _topoCanvas.exportAllCanvasAsBitmapData();
			if (bitmapData == null)
			{
				return;
			}
			// 画鹰眼
			_bgShape.graphics.clear();
			var matrix:Matrix = new Matrix();
			matrix.identity();
			matrix.scale(this.width / bitmapData.width, this.height / bitmapData.height);
			_bgShape.graphics.beginBitmapFill(bitmapData, matrix, false);
			_bgShape.graphics.drawRect(0, 0, this.width, this.height);
			_bgShape.graphics.endFill();
			// 画鹰眼中的视图框框
			_eyeShape.graphics.clear();
			_eyeShape.graphics.lineStyle(2, 0x00ff00);
			_eyeShape.graphics.beginFill(0xffffff, 0.4);
			
			// 计算显示框占数据框的比例
			this._dvwRate = _topoCanvas.dataBounds.rectangle.width / _topoCanvas.viewBounds.rectangle.width;
			this._dvhRate =  _topoCanvas.dataBounds.rectangle.height /_topoCanvas.viewBounds.rectangle.height;
			this._dewRate = _topoCanvas.dataBounds.rectangle.width/this.width;
			this._deHRate = _topoCanvas.dataBounds.rectangle.height/this.height;
			
			var eyeWidth:Number = this.width / this._dvwRate;
			var eyeHeight:Number = this.height / this._dvhRate;

			_eyeShape.graphics.drawRect(0, 0, Math.min(this.width, eyeWidth), Math.min(this.height, eyeHeight));
			_eyeShape.graphics.endFill();
			
			if(!isFirst){
				return;
			}
			isFirst=false;
			_eyeShape.x = Math.max(_topoCanvas.dataBounds.rectangle.width-_topoCanvas.viewBounds.rectangle.width,0)/2/this._dewRate;
			_eyeShape.y = Math.max(_topoCanvas.dataBounds.rectangle.height-_topoCanvas.viewBounds.rectangle.height,0)/2/this._deHRate;
			
			_topoCanvas.viewBounds.updateByXY(this._dvwRate>1?_eyeShape.x*this._dewRate:_topoCanvas.viewBounds.rectangle.x,this._dvhRate>1? _eyeShape.y*this._deHRate:_topoCanvas.viewBounds.rectangle.y);
			_topoCanvas.viewBounds.refresh();
		}


		/**
		 *刷新鹰眼位置
		 *
		 */
//		public function refresh():void
//		{
			// 要找到数据的中心点
			//var viewCenter:Point = _topoCanvas.viewBounds.center;
//			var viewCenter:Point = _topoCanvas.viewBounds.front;
//
//			var eyeX:Number = this.width * viewCenter.x / _topoCanvas.dataBounds.rectangle.width;
//			var eyeY:Number = this.height * viewCenter.y / _topoCanvas.dataBounds.rectangle.height;

//			log.debug("刷新鹰眼位置,eyeX:{0},eyeY:{1}",eyeX,eyeY);
			
//			var point:Point = getValidPoint(eyeX, eyeY);
//			_eyeShape.x = point.x;
//			_eyeShape.y = point.y;
//			//后加
//			var dataBounds:DataBounds = _topoCanvas.dataBounds;
//			var viewBounds:ViewBounds = _topoCanvas.viewBounds;
//			var viewX:Number = _eyeShape.x / this.width * dataBounds.rectangle.width;
//			if (viewBounds.rectangle.width > dataBounds.rectangle.width)
//			{
//				viewX = dataBounds.rectangle.width / 2 - viewBounds.rectangle.width / 2; 
//				//dataBounds.rectangle.x + dataBounds.rectangle.width / 2 - viewBounds.rectangle.width / 2;
//			}
//			viewBounds.updateByXY(viewX, 0);
			
//			var viewCenter:Point = _topoCanvas.viewBounds.front;
//			log.debug("刷新鹰眼位置,viewCenter.x:{0},_topoCanvas.dataBounds.rectangle.width:{1},viewBounds.rectangle.width:{2},_topoCanvas.dataBounds.rectangle.x:{3},_topoCanvas.viewBounds.rectangle.x:{4}",viewCenter.x,_topoCanvas.dataBounds.rectangle.width,_topoCanvas.viewBounds.rectangle.width,_topoCanvas.dataBounds.rectangle.x,_topoCanvas.viewBounds.rectangle.x);
//			
//			_eyeShape.x = Math.max(_topoCanvas.dataBounds.rectangle.width-_topoCanvas.viewBounds.rectangle.width,0)/2/this._dewRate;
//			_eyeShape.y = Math.max(_topoCanvas.dataBounds.rectangle.height-_topoCanvas.viewBounds.rectangle.height,0)/2/this._deHRate;
//		}

		/**
		 *移动鹰眼
		 * @param event
		 *
		 */
//		private function eyeShapeChang(event:MouseEvent):void
//		{
//			var point:Point = getValidPoint(event.localX, event.localY);
//			_eyeShape.x = point.x;
//			_eyeShape.y = point.y;
//			var dataBounds:DataBounds = _topoCanvas.dataBounds;
//			var viewBounds:ViewBounds = _topoCanvas.viewBounds;

			// 如果 view的宽度 > data的宽度, view的x坐标不用变化
//			var viewX:Number = _eyeShape.x / this.width * dataBounds.rectangle.width; //+ dataBounds.rectangle.x;
//			var viewY:Number = _eyeShape.y / this.height * dataBounds.rectangle.height; //+ dataBounds.rectangle.y;
//			if (viewBounds.rectangle.width > dataBounds.rectangle.width)
//			{
//				viewX = dataBounds.rectangle.width / 2 - viewBounds.rectangle.width / 2; //dataBounds.rectangle.x + dataBounds.rectangle.width / 2 - viewBounds.rectangle.width / 2;
//			}
//			if (viewBounds.rectangle.height > dataBounds.rectangle.height)
//			{
//				viewY = dataBounds.rectangle.height / 2 - viewBounds.rectangle.height / 2; //dataBounds.rectangle.y + dataBounds.rectangle.height / 2 - viewBounds.rectangle.height / 2;
//			}
//			viewBounds.updateByXY(viewX, viewY);
//			viewBounds.refresh();
//		}


		/**
		 * 捕获禁用状态下鼠标点击事件
		 * @param event
		 *
		 */
		private function handleDisableStatusMouseClick(event:MouseEvent):void
		{
			_topoCanvas.loadTopo(path.id, path.topoName, true, path.type);
		}

		/**
		 * 鼠标事件MouseDown
		 * @param event
		 *
		 */
//		private function handleMouseDown(event:MouseEvent):void
//		{
//			isMove = true;
//			eyeShapeChang(event);
//		}

		/**
		 * 鼠标事件MouseMove
		 * @param event
		 *
		 */
//		private function handleMouseMove(event:MouseEvent):void
//		{
//			if (isMove && event.buttonDown)
//			{
//				eyeShapeChang(event);
//			}
//			else
//			{
//				isMove = false;
//			}
//		}



		/**
		 *鼠标事件MouseUp
		 * @param event
		 *
		 */
//		private function handleMouseUp(event:MouseEvent):void
//		{
//			isMove = false;
//			eyeShapeChang(event);
//		}

		/**
		 * 鼠标事件DoubleClick
		 * @param event
		 *
		 */
		private function handleDoubleClick(event:MouseEvent):void
		{

		}

		/**
		 *根据鼠标坐标获取有效坐标点
		 * @param x
		 * @param y
		 * @return
		 *
		 */
//		private function getValidPoint(x:Number, y:Number):Point
//		{
//			var a:Number = _eyeShape.width / 2;
//			var b:Number = _eyeShape.height / 2;
//			if (x <= a && y <= b)
//			{
//				return new Point(0, 0);
//			}
//			else if (x <= a && y + b >= _bgShape.height)
//			{
//				return new Point(0, _bgShape.height - _eyeShape.height + 2);
//			}
//			else if (x + a >= _bgShape.width && y <= b)
//			{
//				return new Point(_bgShape.width - _eyeShape.width + 2, 0);
//			}
//			else if (x + a >= _bgShape.width && y + b >= _bgShape.height)
//			{
//				return new Point(_bgShape.width - _eyeShape.width + 2, _bgShape.height - _eyeShape.height + 2);
//			}
//			else if (x <= a)
//			{
//				return new Point(0, y - b);
//			}
//			else if (x + a >= _bgShape.width)
//			{
//				return new Point(_bgShape.width - _eyeShape.width + 2, y - b);
//			}
//			else if (y <= b)
//			{
//				return new Point(x - a, 0);
//			}
//			else if (y + b >= _bgShape.height)
//			{
//				return new Point(x - a, _bgShape.height - _eyeShape.height + 2);
//			}
//			else
//			{
//				return new Point(x - a, y - b);
//			}
//			return new Point(0, 0);
//		}
		
		
		private function eyeMouseDown(event:MouseEvent):void {
			_eyeShape.addEventListener(MouseEvent.MOUSE_MOVE, eyeMouseMoveHandler);
			_eyeShape.startDrag(false,new Rectangle(0, 0, this.width - _eyeShape.width, this.height - _eyeShape.height));
		}
		private function eyeMouseReleased(event:MouseEvent):void {
			_eyeShape.removeEventListener(MouseEvent.MOUSE_MOVE, eyeMouseMoveHandler);
			_eyeShape.stopDrag();
		}
		
		private function eyeMouseMoveHandler(event:MouseEvent):void {
			var viewBounds:ViewBounds = _topoCanvas.viewBounds;
			viewBounds.updateByXY(this._dvwRate>1?_eyeShape.x*this._dewRate:_topoCanvas.viewBounds.rectangle.x,this._dvhRate>1? _eyeShape.y*this._deHRate:_topoCanvas.viewBounds.rectangle.y);
			viewBounds.refresh();
		}

	}
}