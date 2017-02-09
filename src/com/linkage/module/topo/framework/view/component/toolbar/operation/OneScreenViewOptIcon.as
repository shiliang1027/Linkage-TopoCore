package com.linkage.module.topo.framework.view.component.toolbar.operation
{
	import flash.events.MouseEvent;

	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	/**
	 * 一屏显示操作 图标
	 * @author duangr
	 *
	 */
	public class OneScreenViewOptIcon extends TopoOptIcon
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.view.component.toolbar.operation.OneScreenViewOptIcon");

		public function OneScreenViewOptIcon()
		{
			super();
			this.toolTip = "一屏显示";
			authKey = "OneScreenView";
		}

		override protected function onMouseClick(event:MouseEvent):void
		{
			_topoCanvas.oneScreenView();
		}

	}
}