package com.linkage.module.topo.framework.view.component.toolbar.action
{
	import com.linkage.module.topo.framework.Constants;
	import com.linkage.module.topo.framework.controller.action.IAction;
	import com.linkage.module.topo.framework.controller.action.canvas.CanvasActionWrapper;
	import com.linkage.module.topo.framework.controller.action.canvas.GroupMonitorAction;
	import com.linkage.module.topo.framework.controller.action.canvas.MoveAction;
	import com.linkage.module.topo.framework.controller.action.canvas.MultSelectAction;
	import com.linkage.module.topo.framework.controller.action.canvas.PanWheelAction;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;

	/**
	 * 移动(编辑)模式 Action图标
	 * @author duangr
	 *
	 */
	public class MoveActionIcon extends TopoActionIcon
	{
		public function MoveActionIcon()
		{
			super();
			this.toolTip = "移动拓扑";
			authKey = "Move";
		}

		override protected function initAction(topoCanvas:TopoCanvas):IAction
		{
			var action:IAction = new CanvasActionWrapper(topoCanvas, new MultSelectAction(topoCanvas), new MoveAction(topoCanvas), new PanWheelAction(topoCanvas), new GroupMonitorAction(topoCanvas));
			action.weight = Constants.WEIGHT_ACTION_EDIT;
			return action;
		}

	}
}