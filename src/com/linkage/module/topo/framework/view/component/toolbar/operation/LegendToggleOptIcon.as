package com.linkage.module.topo.framework.view.component.toolbar.operation
{
	import com.linkage.module.topo.framework.controller.event.TopoEvent;

	import flash.events.MouseEvent;

	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	/**
	 * 图例切换操作 图标类
	 * @author duangr
	 *
	 */
	public class LegendToggleOptIcon extends TopoOptIcon
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.view.component.toolbar.operation.LegendToggleOptIcon");

		public function LegendToggleOptIcon()
		{
			super();
			this.toolTip = "图例显隐切换";
			authKey = "LegendToggle";
		}

		override protected function onMouseClick(event:MouseEvent):void
		{
			_topoCanvas.dispatchEvent(new TopoEvent(TopoEvent.LEGEND_TOGGLE));
		}

	}
}