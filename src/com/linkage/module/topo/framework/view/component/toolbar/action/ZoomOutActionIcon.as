package com.linkage.module.topo.framework.view.component.toolbar.action
{
	import com.linkage.module.topo.framework.Constants;
	import com.linkage.module.topo.framework.controller.action.IAction;
	import com.linkage.module.topo.framework.controller.action.canvas.CanvasActionWrapper;
	import com.linkage.module.topo.framework.controller.action.canvas.ZoomOutAction;
	import com.linkage.module.topo.framework.controller.action.canvas.ZoomWheelAction;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;

	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	/**
	 * 放大模式下 Action图标
	 * @author duangr
	 *
	 */
	public class ZoomOutActionIcon extends TopoActionIcon
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.view.component.toolbar.action.ZoomOutActionIcon");

		public function ZoomOutActionIcon()
		{
			super();
			this.toolTip = "放大";
			authKey = "ZoomOut";
		}

		override protected function initAction(topoCanvas:TopoCanvas):IAction
		{
			var action:IAction = new CanvasActionWrapper(topoCanvas, new ZoomOutAction(topoCanvas), new ZoomWheelAction(topoCanvas));
			action.weight = Constants.WEIGHT_ACTION_SELECT;
			return action;
		}

	}
}