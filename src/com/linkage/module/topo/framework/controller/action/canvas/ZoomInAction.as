package com.linkage.module.topo.framework.controller.action.canvas
{
	import com.linkage.module.topo.framework.view.component.TopoCanvas;

	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	/**
	 * 缩小 Action
	 * @author duangr
	 *
	 */
	public class ZoomInAction extends AbstractZoomAction
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.controller.action.canvas.ZoomInAction");

		public function ZoomInAction(canvas:TopoCanvas)
		{
			super(canvas);
		}

		override public function get name():String
		{
			return "缩小模式";
		}

		override protected function get scale():Number
		{
			return 0.9;
		}
	}
}