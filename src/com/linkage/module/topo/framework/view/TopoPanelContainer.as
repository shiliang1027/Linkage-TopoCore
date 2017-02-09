package com.linkage.module.topo.framework.view
{
	import com.linkage.module.topo.framework.view.component.TopoCanvas;

	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	import spark.components.SkinnableContainer;

	/**
	 * 拓扑图面板容器
	 * @author duangr
	 *
	 */
	public class TopoPanelContainer extends SkinnableContainer
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.view.TopoPanelContainer");
		// 画布
		private var _topoCanvas:TopoCanvas = null;

		public function TopoPanelContainer()
		{
			super();
//			this.closable = false;
//			this.minimizable = false;
//			this.maximizable = false;
		}

		/**
		 * 拓扑图核心画布
		 */
		public function get topoCanvas():TopoCanvas
		{
			return _topoCanvas;
		}

		/**
		 * @private
		 */
		public function set topoCanvas(value:TopoCanvas):void
		{
			_topoCanvas = value;
			_topoCanvas.hitArea = this;
		}

	}
}