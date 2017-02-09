package com.linkage.module.topo.framework.controller.action.canvas
{
	import com.linkage.module.topo.framework.core.Feature;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;

	import flash.events.MouseEvent;
	import flash.geom.Point;

	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	/**
	 * 滚轮的缩放模式
	 * @author duangr
	 *
	 */
	public class ZoomWheelAction extends AbstractZoomAction
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.controller.action.canvas.ZoomWheelAction");

		public function ZoomWheelAction(canvas:TopoCanvas)
		{
			super(canvas);
		}

		override public function get name():String
		{
			return "滚轮缩放模式";
		}

		override public function onDownFeature(event:MouseEvent, mouseCanvasPoint:Point, downFeature:Feature):void
		{
			// 自身不实现鼠标点击的缩放效果
		}

		override public function onDownCanvas(event:MouseEvent, mouseCanvasPoint:Point):void
		{
			// 自身不实现鼠标点击的缩放效果
		}

		override public function onMouseWheelCanvas(event:MouseEvent, mouseCanvasPoint:Point):void
		{
			// 只处理鼠标滚轮滚动事件
			var delta:int = event.delta;
			doZoom(mouseCanvasPoint, delta > 0 ? 1.1 : 0.9);
		}
	}
}