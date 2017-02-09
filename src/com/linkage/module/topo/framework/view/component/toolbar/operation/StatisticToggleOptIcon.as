package com.linkage.module.topo.framework.view.component.toolbar.operation
{
	import com.linkage.module.topo.framework.controller.event.TopoEvent;

	import flash.events.MouseEvent;

	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	/**
	 * 统计面板切换操作 图标类
	 * @author duangr
	 *
	 */
	public class StatisticToggleOptIcon extends TopoOptIcon
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.view.component.toolbar.operation.StatisticToggleOptIcon");

		public function StatisticToggleOptIcon()
		{
			super();
			this.toolTip = "统计面板显隐切换";
			authKey = "StatisticToggle";
		}

		override protected function onMouseClick(event:MouseEvent):void
		{
			_topoCanvas.dispatchEvent(new TopoEvent(TopoEvent.STATISTIC_TOGGLE));
		}

	}
}