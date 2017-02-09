package com.linkage.module.topo.framework.view.component.toolbar.action
{
	import com.linkage.module.topo.framework.Constants;
	import com.linkage.module.topo.framework.controller.action.IAction;
	import com.linkage.module.topo.framework.controller.action.canvas.PanAction;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;

	/**
	 * 画布移动模式下 Action图标
	 * @author duangr
	 *
	 */
	public class PanActionIcon extends TopoActionIcon
	{
		public function PanActionIcon()
		{
			super();
			this.toolTip = "拖动";
			authKey = "Pan";
		}

		override protected function initAction(topoCanvas:TopoCanvas):IAction
		{
			var action:IAction = new PanAction(topoCanvas);
			action.weight = Constants.WEIGHT_ACTION_SELECT;
			return action;
		}

	}
}