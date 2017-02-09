package com.linkage.module.topo.framework.controller.action.canvas
{
	import com.linkage.module.topo.framework.core.Feature;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;

	import flash.errors.IllegalOperationError;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	/**
	 * 抽象缩放模式
	 * @author duangr
	 *
	 */
	public class AbstractZoomAction extends CanvasAction
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.controller.action.canvas.AbstractZoomAction");

		public function AbstractZoomAction(canvas:TopoCanvas)
		{
			super(canvas);
		}

		override public function get name():String
		{
			return "抽象缩放模式";
		}

		protected function get scale():Number
		{
			throw new IllegalOperationError("缩放比例必须在子类中实现!");
			return 1;
		}

		override public function onDblClick(event:MouseEvent):void
		{
			// 缩放模式下,禁用双击事件,此方法置空
		}

		override public function onDownFeature(event:MouseEvent, mouseCanvasPoint:Point, downFeature:Feature):void
		{
			doZoom(mouseCanvasPoint, scale);
		}

		override public function onDownCanvas(event:MouseEvent, mouseCanvasPoint:Point):void
		{
			doZoom(mouseCanvasPoint, scale);
		}

		protected function doZoom(mouseCanvasPoint:Point, iScale:Number):void
		{
			_canvas.zoomAtPointByScale(mouseCanvasPoint.x, mouseCanvasPoint.y, iScale, iScale);
		}
	}
}