package com.linkage.module.topo.framework.view.component.toolbar.operation
{
	import com.linkage.module.topo.framework.controller.event.TopoEvent;

	import flash.events.MouseEvent;

	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	/**
	 * 属性切换操作 图标类
	 * @author duangr
	 *
	 */
	public class AttrToggleOptIcon extends TopoOptIcon
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.view.component.toolbar.operation.AttrToggleOptIcon");

		public function AttrToggleOptIcon()
		{
			super();
			this.toolTip = "属性显隐切换";
			authKey = "AttrToggle";
		}

		override protected function onMouseClick(event:MouseEvent):void
		{
			_topoCanvas.dispatchEvent(new TopoEvent(TopoEvent.ATTRIBUTE_TOGGLE));
		}

	}
}