package com.linkage.module.topo.framework.view.component.toolbar.action
{
	import com.linkage.module.topo.framework.Constants;
	import com.linkage.module.topo.framework.controller.action.IAction;
	import com.linkage.module.topo.framework.controller.event.ActionEvent;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;
	import com.linkage.module.topo.framework.view.component.toolbar.TopoToolBar;
	
	import flash.events.MouseEvent;
	
	import mx.skins.spark.EditableComboBoxSkin;

	/**
	 * 编辑模式下 Action图标
	 * @author duangr
	 *
	 */
	public class EditActionIcon extends TopoActionIcon
	{
		// 此模式影响的toolbar
		private var _subToolBar:TopoToolBar = null;

		public function EditActionIcon()
		{
			super();
			this.toolTip = "编辑拓扑";
			authKey = "Edit";
		}

		override protected function initAction(topoCanvas:TopoCanvas):IAction
		{
			// 空方法,自己不具有Action,使用子的Action
			return null;
		}

		override public function onMouseClick(event:MouseEvent = null):void
		{
			if (actionEnable == false)
			{
				if (_subToolBar)
				{
					_subToolBar.visible = true;
				}

				(_subToolBar.getElementAt(0) as TopoActionIcon).onMouseClick();
				actionEnable = true;
			}
			invalidateSkinState();
		}

		override protected function onActionChanged(event:ActionEvent):void
		{
			// 模式成选择模式了,隐藏下属的工具栏
			if (event.newAction.weight == Constants.WEIGHT_ACTION_SELECT)
			{
				if (_subToolBar)
				{
					_subToolBar.visible = false;
				}
				actionEnable = false;
				invalidateSkinState();
			}
		}

		/**
		 * 模式下属的工具栏
		 */
		public function set subToolBar(value:TopoToolBar):void
		{
			_subToolBar = value;
			_subToolBar.visible = false;
		}

	}
}