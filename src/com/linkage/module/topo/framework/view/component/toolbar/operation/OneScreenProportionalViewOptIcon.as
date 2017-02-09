package com.linkage.module.topo.framework.view.component.toolbar.operation
{
	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	import flash.events.MouseEvent;

	/**
	 * 一屏显示操作(等比例缩放) 图标
	 * @author duangr
	 *
	 */
	public class OneScreenProportionalViewOptIcon extends OneScreenViewOptIcon
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.view.component.toolbar.operation.OneScreenProportionalViewOptIcon");

		public function OneScreenProportionalViewOptIcon()
		{
			super();
			this.toolTip = "一屏显示";
			authKey = "OneScreenProportionalView";
		}

		override protected function onMouseClick(event:MouseEvent):void
		{
			_topoCanvas.oneScreenViewProportional();
		}

	}
}