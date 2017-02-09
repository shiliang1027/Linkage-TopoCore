package com.linkage.module.topo.framework.view.component.toolbar.operation
{
	import com.linkage.module.topo.framework.view.component.toolbar.TopoIcon;
	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	import flash.errors.IllegalOperationError;
	import flash.events.MouseEvent;

	/**
	 * 拓扑操作图标类
	 * @author duangr
	 *
	 */
	public class TopoOptIcon extends TopoIcon
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.view.component.toolbar.operation.TopoOptIcon");

		public function TopoOptIcon()
		{
			super();
			this.addEventListener(MouseEvent.CLICK, onMouseClick);
		}

		/**
		 * 按钮被点击后的回调方法
		 * @param event
		 *
		 */
		protected function onMouseClick(event:MouseEvent):void
		{
			throw new IllegalOperationError("Function onMouseClick(event:MouseEvent) from abstract class TopoOptIcon has not been implemented by subclass.");
		}
	}
}