package com.linkage.module.topo.framework.view.component.toolbar.operation
{
	import com.linkage.module.topo.framework.view.component.hawkeye.HawkEye;
	import com.linkage.module.topo.framework.view.component.hawkeye.HawkEyeContainer;

	import flash.events.MouseEvent;

	import mx.core.UIComponent;
	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	/**
	 * 鹰眼操作 图标
	 * @author duangr
	 *
	 */
	public class HawkEyeOptIcon extends TopoOptIcon
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.view.component.toolbar.operation.HawkEyeOptIcon");
		// 鹰眼
		private var _hawkEyes:HawkEyeContainer = null;

		public function HawkEyeOptIcon()
		{
			super();
			this.toolTip = "鹰眼";
			authKey = "HawkEye";
		}

		public function set hawkEyes(value:HawkEyeContainer):void
		{
			_hawkEyes = value;
		}

		override protected function onMouseClick(event:MouseEvent):void
		{
			_hawkEyes.toggle();
		}

	}
}