package com.linkage.module.topo.framework.controller.action.canvas
{
	import com.linkage.module.topo.framework.Constants;
	import com.linkage.module.topo.framework.controller.event.TopoEvent;
	import com.linkage.module.topo.framework.core.Feature;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;
	import com.linkage.system.structure.map.IMap;
	import com.linkage.system.structure.map.Map;

	import flash.display.Graphics;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;

	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	import spark.components.Group;

	/**
	 * 创建形状模式
	 * @author duangr
	 *
	 */
	public class CreateShapeAction extends CanvasAction
	{
		// log
		private static const log:ILogger = Log.getLogger("com.linkage.module.topo.framework.controller.action.canvas.CreateShapeAction");

		// 框选区域
		private var _selectArea:Group = new Group();
		private var _selectAreaStartX:Number = 0;
		private var _selectAreaStartY:Number = 0;

		public function CreateShapeAction(canvas:TopoCanvas)
		{
			super(canvas);
		}

		override public function get name():String
		{
			return "创建形状模式";
		}

		override public function onDownCanvas(event:MouseEvent, mouseCanvasPoint:Point):void
		{
			selectAreaStart(mouseCanvasPoint.x, mouseCanvasPoint.y);
		}

		override public function onMoveWithDownCanvas(event:MouseEvent, mouseCanvasPoint:Point):void
		{
			selectAreaMoving(mouseCanvasPoint.x, mouseCanvasPoint.y);
		}

		override public function onMoveWithDownCanvasButUp(event:MouseEvent, mouseCanvasPoint:Point):void
		{
			selectAreaClear();
		}

		override public function onUpWithDownCanvasNoMove(event:MouseEvent, mouseCanvasPoint:Point, upFeature:Feature):void
		{
			selectAreaClear();
		}

		override public function onUpWithDownCanvasAndMove(event:MouseEvent, mouseCanvasPoint:Point, upFeature:Feature):void
		{
			selectAreaEnd(mouseCanvasPoint.x, mouseCanvasPoint.y);
		}

		/**
		 * 开始绘制框选区域
		 * @param x 相对画布的X坐标
		 * @param y 相对画布的Y坐标
		 *
		 */
		private function selectAreaStart(x:Number, y:Number):void
		{
			if (!_canvas.contains(_selectArea))
			{
				_canvas.addElement(_selectArea);
			}
			_selectArea.visible = true;
			_selectAreaStartX = x;
			_selectAreaStartY = y;
			var g:Graphics = _selectArea.graphics;
			g.lineStyle(selectAreaLineThickness, selectAreaLineColor);

		}

		/**
		 * 框选区域移动变化中
		 * @param x 相对画布的X坐标
		 * @param y 相对画布的Y坐标
		 *
		 */
		private function selectAreaMoving(x:Number, y:Number):void
		{
			var g:Graphics = _selectArea.graphics;
			g.clear();
			g.lineStyle(selectAreaLineThickness, selectAreaLineColor);
			g.drawRect(_selectAreaStartX, _selectAreaStartY, x - _selectAreaStartX, y - _selectAreaStartY);
		}

		/**
		 * 框选区域绘制结束
		 * @param x 相对画布的X坐标
		 * @param y 相对画布的Y坐标
		 *
		 */
		private function selectAreaEnd(x:Number, y:Number):void
		{
			selectAreaClear();
			triggerCreateEvent(_selectAreaStartX, _selectAreaStartY, x, y);
		}

		/**
		 * 清除框选区域
		 *
		 */
		private function selectAreaClear():void
		{
			_selectArea.graphics.clear();
			_selectArea.visible = false;
		}

		/**
		 * 触发创建事件
		 * @param sx 框选开始点x坐标
		 * @param sy 框选开始点y坐标
		 * @param ex 框选结束点x坐标
		 * @param ey 框选结束点y坐标
		 *
		 */
		private function triggerCreateEvent(sx:Number, sy:Number, ex:Number, ey:Number):void
		{
			if (sx == ex && sy == ey)
			{
				return;
			}
			// 找到框选区域左上和右下的坐标
			var minX:Number = Math.min(sx, ex);
			var minY:Number = Math.min(sy, ey);
			var maxX:Number = Math.max(sx, ex);
			var maxY:Number = Math.max(sy, ey);

			var properties:IMap = new Map();
			var width:Number = maxX - minX;
			var height:Number = maxY - minY;
			var x:Number = minX + width / 2;
			var y:Number = minY + height / 2;
			properties.put("x", x);
			properties.put("y", y);
			properties.put("width", width);
			properties.put("height", height);
			var event:TopoEvent = new TopoEvent(eventType, null, properties, null, new Point(x, y));
			_canvas.dispatchEvent(event);
		}

		/**
		 * 抛出创建事件的事件类型
		 *
		 */
		protected function get eventType():String
		{
			return TopoEvent.CREATE_SHAPE;
		}

		/**
		 * 选择框的粗细
		 * @return
		 *
		 */
		protected function get selectAreaLineThickness():uint
		{
			return Constants.DEFAULT_CREATESHAPE_SELECTAREA_LINE_SIZE;
		}

		/**
		 * 选择框的颜色
		 * @return
		 *
		 */
		protected function get selectAreaLineColor():uint
		{
			return Constants.DEFAULT_CREATESHAPE_SELECTAREA_LINE_COLOR;
		}
	}
}