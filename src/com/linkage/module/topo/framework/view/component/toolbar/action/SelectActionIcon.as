package com.linkage.module.topo.framework.view.component.toolbar.action
{
	import com.linkage.module.topo.framework.Constants;
	import com.linkage.module.topo.framework.controller.action.IAction;
	import com.linkage.module.topo.framework.controller.action.canvas.CanvasActionWrapper;
	import com.linkage.module.topo.framework.controller.action.canvas.MultSelectAction;
	import com.linkage.module.topo.framework.controller.action.canvas.PanWheelAction;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;

	/**
	 * 选择模式 Action图标类
	 * @author duangr
	 *
	 */
	public class SelectActionIcon extends TopoActionIcon
	{
		public function SelectActionIcon()
		{
			super();
			this.toolTip = "选择";
			authKey = "Select";
		}

		override protected function initAction(topoCanvas:TopoCanvas):IAction
		{
			var action:IAction = new CanvasActionWrapper(topoCanvas, new MultSelectAction(topoCanvas), new PanWheelAction(topoCanvas));
			action.weight = Constants.WEIGHT_ACTION_SELECT;

			return action;
		}

	}
}