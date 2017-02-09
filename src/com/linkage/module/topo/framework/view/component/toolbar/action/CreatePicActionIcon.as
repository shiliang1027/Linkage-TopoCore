package com.linkage.module.topo.framework.view.component.toolbar.action
{

	import com.linkage.module.topo.framework.Constants;
	import com.linkage.module.topo.framework.controller.action.IAction;
	import com.linkage.module.topo.framework.controller.action.canvas.CanvasActionWrapper;
	import com.linkage.module.topo.framework.controller.action.canvas.CreatePicAction;
	import com.linkage.module.topo.framework.controller.action.canvas.CreateShapeAction;
	import com.linkage.module.topo.framework.controller.action.canvas.PanWheelAction;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;

	import flash.events.MouseEvent;

	/**
	 * 创建图片对象
	 *
	 * @author duangr (65250)
	 * @version 1.0
	 * @date 2012-6-20
	 * @langversion 3.0
	 * @playerversion Flash 11
	 * @productversion Flex 4
	 * @copyright Ailk NBS-Network Mgt. RD Dept.
	 *
	 */
	public class CreatePicActionIcon extends TopoActionIcon
	{
		public function CreatePicActionIcon()
		{
			super();
			this.toolTip = "创建图片对象";
			authKey = "CreateShapePic";
		}

		override protected function initAction(topoCanvas:TopoCanvas):IAction
		{
			var action:IAction = new CanvasActionWrapper(topoCanvas, new CreatePicAction(topoCanvas), new PanWheelAction(topoCanvas));
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