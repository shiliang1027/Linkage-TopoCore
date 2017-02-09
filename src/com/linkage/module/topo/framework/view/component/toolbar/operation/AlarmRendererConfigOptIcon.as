package com.linkage.module.topo.framework.view.component.toolbar.operation
{
	import com.linkage.module.topo.framework.controller.event.TopoEvent;

	import flash.events.MouseEvent;

	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	/**
	 * 告警渲染配置面板切换操作 图标类
	 * @author duangr
	 *
	 */
	public class AlarmRendererConfigOptIcon extends TopoOptIcon
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.view.component.toolbar.operation.AlarmRendererConfigOptIcon");

		public function AlarmRendererConfigOptIcon()
		{
			super();
			this.toolTip = "告警渲染配置";
			authKey = "AlarmRendererConfig";
		}

		override protected function onMouseClick(event:MouseEvent):void
		{
			_topoCanvas.dispatchEvent(new TopoEvent(TopoEvent.ALARM_RENDERER_CONFIG));
		}

	}
}