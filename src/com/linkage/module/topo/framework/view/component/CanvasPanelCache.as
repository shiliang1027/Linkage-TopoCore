package com.linkage.module.topo.framework.view.component
{
	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	import flash.display.DisplayObject;

	/**
	 * 缓存画布面板的容器
	 * @author duangr
	 *
	 */
	public class CanvasPanelCache
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.view.component.CanvasPanelContainer");
		// 画布
		private var _topoCanvas:TopoCanvas = null;
		// 面板容器缓存
		private var _panelCache:Array = [];
		// 参考显示的父对象
		private var _panelParent:DisplayObject = null;

		public function CanvasPanelCache(topoCanvas:TopoCanvas, panelParent:DisplayObject)
		{
			_topoCanvas = topoCanvas;
			_panelParent = panelParent
		}

		/**
		 * 添加扩展面板
		 * @param panel
		 *
		 */
		public function addExtendPanel(panel:ICanvasExtendPanel):void
		{
			panel.topoCanvas = _topoCanvas;
			panel.panelParent = _panelParent;
			panel.initPanel();
			_panelCache.push(panel);
		}
	}
}