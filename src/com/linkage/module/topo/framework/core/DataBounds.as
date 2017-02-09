package com.linkage.module.topo.framework.core
{
	import com.linkage.module.topo.framework.Constants;
	import com.linkage.module.topo.framework.core.model.element.point.ITPPoint;
	import com.linkage.module.topo.framework.view.component.TopoLayer;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	/**
	 * 画布数据的边界
	 * @author duangr
	 *
	 */
	public class DataBounds
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.core.DataBounds");

		private var _rectangle:Rectangle = null;
		private var _canvas:TopoLayer = null;
		// 偏移量
		private var _offsetX:Number = 0;
		private var _offsetY:Number = 0;
		// 默认偏移量
		private var _DEFAULT_OFFSET_X:Number = 0;
		private var _DEFAULT_OFFSET_Y:Number = 0;

		public function DataBounds(canvas:TopoLayer)
		{
			this._canvas = canvas;
			this._rectangle = new Rectangle(0, 0, 0, 0);
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
			if (minX > maxX)
			{
				minX = maxX = 0;
			}
			if (minY > maxY)
			{
				minY = maxY = 0;
			}
			_rectangle.x = minX - Constants.DEFAULT_CANVAS_PADDING;
			_rectangle.y = minY - Constants.DEFAULT_CANVAS_PADDING;
			_rectangle.width = maxX - minX + 2 * Constants.DEFAULT_CANVAS_PADDING;
			_rectangle.height = maxY - minY + 2 * Constants.DEFAULT_CANVAS_PADDING;

			_offsetX = _DEFAULT_OFFSET_X - _rectangle.x;
			_offsetY = _DEFAULT_OFFSET_Y - _rectangle.y;
			resetCanvasWidthandHeight();

		}

		/**
		 * 根据最大最小点增量更新(要考虑到已有的数据)
		 * @param minX
		 * @param minY
		 * @param maxX
		 * @param maxY
		 *
		 */
		public function updateByAppendMinMaxPoint(minX:Number, minY:Number, maxX:Number, maxY:Number):void
		{
			if (minX > maxX || minY > maxY)
			{
				return
			}
			_rectangle.x = Math.min(_rectangle.x, minX - Constants.DEFAULT_CANVAS_PADDING);
			_rectangle.y = Math.min(_rectangle.y, minY - Constants.DEFAULT_CANVAS_PADDING);
			_rectangle.width = Math.max(_rectangle.width, maxX - minX + 2 * Constants.DEFAULT_CANVAS_PADDING);
			_rectangle.height = Math.max(_rectangle.height, maxY - minY + 2 * Constants.DEFAULT_CANVAS_PADDING);

			// 注意,此处不能修改偏移量,要修改的话需要刷新已有的全部网元
			if (_rectangle.x + _offsetX < _DEFAULT_OFFSET_X || _rectangle.y + _offsetY < _DEFAULT_OFFSET_Y)
			{
				log.info("增量更新数据范围时,新数据已经越界,需要刷新全部对象.");

				var oldOffsetX:Number = _offsetX;
				var oldOffsetY:Number = _offsetY;
				var oldViewX:Number = _canvas.viewBounds.rectangle.x;
				var oldViewY:Number = _canvas.viewBounds.rectangle.y;

				// 修改偏移量
				_offsetX = Math.max(_offsetX, _DEFAULT_OFFSET_X - _rectangle.x);
				_offsetY = Math.max(_offsetY, _DEFAULT_OFFSET_Y - _rectangle.y);

				// 刷新全部网元
				_canvas.eachPoint(function(id:String, point:ITPPoint):void
					{
						point.feature.refresh();
					});

				// 修改视野范围
				_canvas.viewBounds.updateByXY(oldViewX - oldOffsetX + _offsetX, oldViewY - oldOffsetY + _offsetY);
				_canvas.viewBounds.refresh();

			}

			resetCanvasWidthandHeight();
		}

		/**
		 * X偏移量
		 * @return
		 *
		 */
		public function get offsetX():Number
		{
			return _offsetX;
		}

		/**
		 * Y偏移量
		 * @return
		 *
		 */
		public function get offsetY():Number
		{
			return _offsetY;
		}

		/**
		 * 重置画布的宽高
		 *
		 */
		private function resetCanvasWidthandHeight():void
		{
			// TODO: 如果有必要,取 数据 和 显示范围的最大值
			log.debug("画布的  {0},{1},{2},{3}", _rectangle.width, _rectangle.height,_canvas.showWidth, _canvas.showHeight);
			_canvas.width = Math.max(_rectangle.width, _canvas.showWidth);
			_canvas.height = Math.max(_rectangle.height, _canvas.showHeight);
			log.debug("画布的  宽:{0}  高:{1}", _canvas.width, _canvas.height);
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

		public function toString():String
		{
			return "数据范围: " + _rectangle + ", 画布宽高:" + _canvas.width + "/" + _canvas.height;
		}
	}
}