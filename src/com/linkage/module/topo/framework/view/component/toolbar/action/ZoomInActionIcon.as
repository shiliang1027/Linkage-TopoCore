package com.linkage.module.topo.framework.view.component.toolbar.action
{
	import com.linkage.module.topo.framework.Constants;
	import com.linkage.module.topo.framework.controller.action.IAction;
	import com.linkage.module.topo.framework.controller.action.canvas.CanvasActionWrapper;
	import com.linkage.module.topo.framework.controller.action.canvas.ZoomInAction;
	import com.linkage.module.topo.framework.controller.action.canvas.ZoomWheelAction;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;

	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	/**
	 * 缩小模式下 Action图标
	 * @author duangr
	 *
	 */
	public class ZoomInActionIcon extends TopoActionIcon
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.view.component.toolbar.action.ZoomInActionIcon");

		public function ZoomInActionIcon()
		{
			super();
			this.toolTip = "缩小";
			authKey = "ZoomIn";
		}

		override protected function initAction(topoCanvas:TopoCanvas):IAction
		{
			var action:IAction = new CanvasActionWrapper(topoCanvas, new ZoomInAction(topoCanvas), new ZoomWheelAction(topoCanvas));
			action.weight = Constants.WEIGHT_ACTION_SELECT;
			return action;
		}

	}
}