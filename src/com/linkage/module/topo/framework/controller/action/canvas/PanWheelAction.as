package com.linkage.module.topo.framework.controller.action.canvas
{
	import com.linkage.module.topo.framework.controller.event.CanvasEvent;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;

	import flash.events.MouseEvent;
	import flash.geom.Point;

	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	/**
	 * 滚轮画布移动 Action
	 * @author duangr
	 *
	 */
	public class PanWheelAction extends CanvasAction
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.controller.action.canvas.PanWheelAction");
		private var _panStartMouseX:Number = 0;
		private var _panStartMouseY:Number = 0;
		private var _panStartViewBoundsX:Number = 0;
		private var _panStartViewBoundsY:Number = 0;

		public function PanWheelAction(canvas:TopoCanvas)
		{
			super(canvas);
		}

		override public function get name():String
		{
			return "滚轮移动模式";
		}

		override public function onMouseWheelCanvas(event:MouseEvent, mouseCanvasPoint:Point):void
		{
			// 只处理鼠标滚轮滚动事件
			var delta:int = event.delta;

			// 向上滚(delta为正),说明想看上面的(y值要变小)
			_canvas.viewBounds.updateByXY(_canvas.viewBounds.rectangle.x, _canvas.viewBounds.rectangle.y - delta * 10);
			_canvas.viewBounds.refresh();
		}

		/**
		 * 画布开始拖动
		 * @param mouseCanvasPoint
		 *
		 */
		private function panDragStart(mouseCanvasPoint:Point):void
		{
			_panStartMouseX = mouseCanvasPoint.x;
			_panStartMouseY = mouseCanvasPoint.y;
			_panStartViewBoundsX = _canvas.viewBounds.rectangle.x;
			_panStartViewBoundsY = _canvas.viewBounds.rectangle.y;
		}

		/**
		 * 画布拖动中
		 * @param mouseCanvasPoint
		 *
		 */
		private function panDraging(mouseCanvasPoint:Point):void
		{
			var addX:Number = mouseCanvasPoint.x - _panStartMouseX;
			var addY:Number = mouseCanvasPoint.y - _panStartMouseY;

			_canvas.viewBounds.updateByXY(_panStartViewBoundsX - addX, _panStartViewBoundsY - addY);
		}

		/**
		 * 提交展现区域
		 *
		 */
		private function commitViewBounds():void
		{
			_canvas.viewBounds.refresh();
		}
	}
}