package com.linkage.module.topo.framework.view.component.toolbar.action
{
	import com.linkage.module.topo.framework.Constants;
	import com.linkage.module.topo.framework.controller.action.IAction;
	import com.linkage.module.topo.framework.controller.action.canvas.CanvasActionWrapper;
	import com.linkage.module.topo.framework.controller.action.canvas.CreateHLinkLayerAction;
	import com.linkage.module.topo.framework.controller.action.canvas.PanWheelAction;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;

	import flash.events.MouseEvent;

	/**
	 * 创建缩略图模式下 Action图标
	 * @author duangr
	 *
	 */
	public class CreateHLinkLayerActionIcon extends TopoActionIcon
	{
		public function CreateHLinkLayerActionIcon()
		{
			super();
			this.toolTip = "创建缩略图";
			authKey = "CreateHLinkLayer";
		}

		override protected function initAction(topoCanvas:TopoCanvas):IAction
		{
			var action:IAction = new CanvasActionWrapper(topoCanvas, new CreateHLinkLayerAction(topoCanvas), new PanWheelAction(topoCanvas));
			action.weight = Constants.WEIGHT_ACTION_EDIT;
			return action;
		}

		override public function onMouseClick(event:MouseEvent = null):void
		{
			super.onMouseClick(event);
			// 切换到此模式时,清空选中容器
			_topoCanvas.clearAllSelect();
		}

	}
}