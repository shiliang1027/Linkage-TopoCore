package com.linkage.module.topo.framework.controller.action.canvas
{
	import com.linkage.module.topo.framework.core.Feature;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;

	import flash.events.MouseEvent;
	import flash.geom.Point;

	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	/**
	 * 放大 Action
	 * @author duangr
	 *
	 */
	public class ZoomOutAction extends AbstractZoomAction
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.controller.action.canvas.ZoomOutAction");

		public function ZoomOutAction(canvas:TopoCanvas)
		{
			super(canvas);
		}

		override public function get name():String
		{
			return "放大模式";
		}

		override protected function get scale():Number
		{
			return 1.1;
		}

	}
}