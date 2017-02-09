package com.linkage.module.topo.framework.controller.action.canvas
{
	import com.linkage.module.topo.framework.controller.event.CanvasEvent;
	import com.linkage.module.topo.framework.core.Feature;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;

	import flash.events.MouseEvent;
	import flash.geom.Point;

	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	/**
	 * 移动画布 Action
	 * @author duangr
	 *
	 */
	public class PanAction extends CanvasAction
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.controller.action.canvas.PanAction");
		private var _panStartMouseX:Number = 0;
		private var _panStartMouseY:Number = 0;
		private var _panStartViewBoundsX:Number = 0;
		private var _panStartViewBoundsY:Number = 0;

		public function PanAction(canvas:TopoCanvas)
		{
			super(canvas);
		}

		override public function get name():String
		{
			return "画布平移模式";
		}


		override public function onDownFeature(event:MouseEvent, mouseCanvasPoint:Point, downFeature:Feature):void
		{
			panDragStart(mouseCanvasPoint);
		}

		override public function onDownCanvas(event:MouseEvent, mouseCanvasPoint:Point):void
		{
			panDragStart(mouseCanvasPoint);
		}

		override public function onMoveWithDownFeature(event:MouseEvent, mouseCanvasPoint:Point, downFeature:Feature):void
		{
			panDraging(mouseCanvasPoint);
		}

		override public function onMoveWithDownCanvas(event:MouseEvent, mouseCanvasPoint:Point):void
		{
			panDraging(mouseCanvasPoint);
		}


		override public function onUpWithDownFeatureAndMove(event:MouseEvent, mouseCanvasPoint:Point, downFeature:Feature, upFeature:Feature):void
		{
			commitViewBounds();
		}


		override public function onUpWithDownCanvasAndMove(event:MouseEvent, mouseCanvasPoint:Point, upFeature:Feature):void
		{
			commitViewBounds();
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