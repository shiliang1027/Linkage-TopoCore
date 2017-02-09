package com.linkage.module.topo.framework.view.component.toolbar.action
{
	import com.linkage.module.topo.framework.Constants;
	import com.linkage.module.topo.framework.controller.action.IAction;
	import com.linkage.module.topo.framework.controller.action.canvas.CanvasActionWrapper;
	import com.linkage.module.topo.framework.controller.action.canvas.CreateLinkAction;
	import com.linkage.module.topo.framework.controller.action.canvas.MultSelectAction;
	import com.linkage.module.topo.framework.controller.action.canvas.PanWheelAction;
	import com.linkage.module.topo.framework.controller.event.ActionEvent;
	import com.linkage.module.topo.framework.controller.event.TopoEvent;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;
	
	import flash.events.MouseEvent;

	/**
	 * 创建链路模式 Action图标
	 * @author duangr
	 *
	 */
	public class CreateLinkActionIcon extends TopoActionIcon
	{
		public function CreateLinkActionIcon()
		{
			super();
			this.toolTip = "创建链路";
			authKey = "CreateLink";
		}

		override protected function initAction(topoCanvas:TopoCanvas):IAction
		{
			var action:IAction = new CanvasActionWrapper(topoCanvas, new MultSelectAction(topoCanvas), new PanWheelAction(topoCanvas), new CreateLinkAction(topoCanvas));
			action.weight = Constants.WEIGHT_ACTION_LINK_EDIT;
			return action;
		}

		override public function onMouseClick(event:MouseEvent = null):void
		{
			super.onMouseClick(event);
			// 切换到此模式时,清空选中容器
			_topoCanvas.clearAllSelect();

			_topoCanvas.dispatchEvent(new TopoEvent(TopoEvent.CREATE_LINK_PANEL_SHOW));
		}

		override protected function onActionChanged(event:ActionEvent):void
		{
			super.onActionChanged(event);
			if (event.newAction != _action)
			{
				_topoCanvas.dispatchEvent(new TopoEvent(TopoEvent.CREATE_LINK_PANEL_HIDE));
			}
		}

	}
}