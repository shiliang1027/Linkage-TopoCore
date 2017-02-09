package com.linkage.module.topo.framework.view.component.toolbar.operation
{
	import com.linkage.module.topo.framework.controller.event.TopoEvent;

	import flash.events.MouseEvent;

	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	/**
	 * 自动布局图标类
	 * @author duangr
	 *
	 */
	public class AutoLayoutOptIcon extends TopoOptIcon
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.view.component.toolbar.operation.AutoLayoutOptIcon");

		public function AutoLayoutOptIcon()
		{
			super();
			this.toolTip = "自动布局";
			authKey = "AutoLayout";
		}

		override protected function onMouseClick(event:MouseEvent):void
		{
			_topoCanvas.dispatchEvent(new TopoEvent(TopoEvent.SHOW_LAYOUT));
		}

	}
}