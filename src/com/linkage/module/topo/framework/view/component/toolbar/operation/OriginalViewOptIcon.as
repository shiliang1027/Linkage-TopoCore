package com.linkage.module.topo.framework.view.component.toolbar.operation
{
	import flash.events.MouseEvent;

	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	/**
	 * 原始尺寸正常显示 图标
	 * @author duangr
	 *
	 */
	public class OriginalViewOptIcon extends TopoOptIcon
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.view.component.toolbar.operation.OriginalViewOptIcon");

		public function OriginalViewOptIcon()
		{
			super();
			this.toolTip = "正常显示";
			authKey = "OriginalView";
		}

		override protected function onMouseClick(event:MouseEvent):void
		{
			_topoCanvas.originalView();
		}

	}
}