package com.linkage.module.topo.framework.core
{
	import com.linkage.module.topo.framework.controller.event.CanvasEvent;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;
	import com.linkage.module.topo.framework.view.component.TopoLayer;
	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.controls.Alert;

	/**
	 * 画布可视范围
	 * @author duangr
	 *
	 */
	public class ViewBounds
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.core.ViewBounds");

		private var _rectangle:Rectangle = null;
		private var _canvas:TopoLayer = null;

		public function ViewBounds(canvas:TopoLayer)
		{
			this._canvas = canvas;
			this._rectangle = new Rectangle(0, 0, 0, 0);
		}

		/**
		 * 刷新画布的显示区域
		 *
		 */
		public function refresh():void
		{
			_canvas.scrollRect = _rectangle;

			_canvas.dispatchEvent(new CanvasEvent(CanvasEvent.VIEWBOUNDS_CHANGED));   
//			log.debug("refresh viewBounds: {0}", _rectangle);
		}

		/**
		 * 根据宽高更新宽高
		 * @param width
		 * @param height
		 *
		 */
		public function updateByWidthHeight(width:Number, height:Number):void
		{
//			log.debug("显示范围  width:{0} height:{1}", width, height);
			_rectangle.width = width;
			_rectangle.height = height;
			if (_canvas.scaleX != 1 || _canvas.scaleY != 1)
			{
				afterViewZoom(_canvas.scaleX, _canvas.scaleY);
			}
		}

		/**
		 * 根据最小,最大点更新
		 * @param minX
		 * @param minY
		 * @param maxX
		 * @param maxY
		 *
		 */
		public function updateByMinMaxPoint(minX:Number, minY:Number, maxX:Number, maxY:Number):void
		{
			_rectangle.x = minX;
			_rectangle.y = minY;
			_rectangle.width = maxX - minX;
			_rectangle.height = maxY - minY;
		}

		/**
		 * 根据坐标更新
		 * @param x
		 * @param y
		 *
		 */
		public function updateByXY(x:Number, y:Number):void
		{
			log.info("updateByXY  x="+x+"==y===="+y);
			_rectangle.x = x;
//			江苏
			_rectangle.y = y;
			
		}

		/**
		 * 根据数据的中心点作为视图的中心点更新坐标
		 * @param dataBounds
		 *
		 */
		public function updateByDataBoundsCenter(dataBounds:DataBounds):void
		{
			log.info("根据数据的中心点作为视图的中心点更新坐标");
			log.info(dataBounds.rectangle.y +"--"+ dataBounds.offsetY +"--"+ dataBounds.rectangle.height*1/2);
			
//			updateByCenter(dataBounds.rectangle.x + dataBounds.offsetX + dataBounds.rectangle.width/2, dataBounds.rectangle.y + dataBounds.offsetY + dataBounds.rectangle.height*1/2);
			updateByCenter(dataBounds.rectangle.x + dataBounds.offsetX + dataBounds.rectangle.width/2, dataBounds.rectangle.y*1.27 + dataBounds.offsetY + dataBounds.rectangle.height*1/2);

			
			//			这个没用啊
//			updateByCenter(dataBounds.rectangle.x + dataBounds.offsetX + dataBounds.rectangle.width/2, dataBounds.rectangle.y + dataBounds.offsetY);
		}  

		/**
		 * 根据中心点坐标更新
		 * @param x
		 * @param y
		 *
		 */
		public function updateByCenter(x:Number, y:Number):void
		{
			
			_rectangle.x = x - _rectangle.width / 2;
			log.info("updateByCenter");
			log.info("x="+x +"~~~~~  y="+y);
			_rectangle.y = y - _rectangle.height / 2;
			

		/*	if(x == 751)
			{
				log.info("751");
				_rectangle.y = y - _rectangle.height / 2 - 100;
			}else if(x == 534){
				log.info("534");
				_rectangle.y = y - _rectangle.height / 2 + 70;
			}else if(x == 768){
				log.info("768");
				_rectangle.y = y - _rectangle.height / 2 - 100;
			}else if(x > 100 && x < 200 ){
				_rectangle.x = -248.5;
				_rectangle.y = -83.9;
			}else{
				//江苏
				_rectangle.y = y - _rectangle.height / 2;
			}
			*/
//			_rectangle.y = y; 
			/*Alert.show("_rectangle.x="+_rectangle.x +"  _rectangle.y="+_rectangle.y);
			log.info("_rectangle.x="+_rectangle.x +"  _rectangle.y="+_rectangle.y);*/
			//_rectangle.y = y - _rectangle.height*3 / 8; 
		}

		/**
		 * 对应的矩形区域
		 */
		public function get rectangle():Rectangle
		{
			return _rectangle;
		}

		/**
		 * 中心点
		 */
		public function get center():Point
		{
			return new Point(_rectangle.x + _rectangle.width / 2, _rectangle.y + _rectangle.height / 2);
		}
		
		/**
		 * 前端点
		 */
		public function get front():Point
		{
			return new Point(_rectangle.x + _rectangle.width / 2, _rectangle.y); 
			log.info("front");
			log.info("_rectangle.x="+_rectangle.x+"rectangle.y="+rectangle.y);
		}

		/**
		 * 画布 缩小/放大 指定系数后同步可视边界
		 * @param scaleXCoef X缩放变化的系数 = 新scaleX/旧scaleX
		 * @param scaleYCoef X缩放变化的系数 = 新scaleX/旧scaleX
		 */
		public function afterViewZoom(scaleXCoef:Number, scaleYCoef:Number):void
		{
			_rectangle.width /= scaleXCoef; 
			_rectangle.height /= scaleYCoef;
		}

		public function toString():String
		{
			return "显示范围: " + _rectangle;
		}


	}
}