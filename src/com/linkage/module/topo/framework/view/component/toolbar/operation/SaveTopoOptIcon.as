package com.linkage.module.topo.framework.view.component.toolbar.operation
{
	import com.linkage.module.topo.framework.controller.event.TopoEvent;

	import flash.events.MouseEvent;

	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	/**
	 * 保存拓扑图标类
	 * @author duangr
	 *
	 */
	public class SaveTopoOptIcon extends TopoOptIcon
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.view.component.toolbar.operation.SaveTopoOptIcon");

		public function SaveTopoOptIcon()
		{
			super();
			this.toolTip = "保存拓扑";
			authKey = "SaveTopo";
		}

		override protected function onMouseClick(event:MouseEvent):void
		{
			_topoCanvas.dispatchEvent(new TopoEvent(TopoEvent.SAVE_TOPO));
		}

	}
}