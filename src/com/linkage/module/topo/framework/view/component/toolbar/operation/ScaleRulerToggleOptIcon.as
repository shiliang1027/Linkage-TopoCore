package com.linkage.module.topo.framework.view.component.toolbar.operation
{
	import com.linkage.module.topo.framework.controller.event.TopoEvent;
	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	import flash.events.MouseEvent;

	/**
	 * 标尺显隐切换操作 图标类
	 * @author duangr
	 *
	 */
	public class ScaleRulerToggleOptIcon extends TopoOptIcon
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.view.component.toolbar.operation.ScaleRulerToggleOptIcon");

		public function ScaleRulerToggleOptIcon()
		{
			super();
			this.toolTip = "标尺显隐切换";
			authKey = "ScaleRulerToggle";
		}

		override protected function onMouseClick(event:MouseEvent):void
		{
			_topoCanvas.dispatchEvent(new TopoEvent(TopoEvent.SCALERULER_TOGGLE));
		}
	}
}