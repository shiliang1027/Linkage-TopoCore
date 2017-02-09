package com.linkage.module.topo.framework.service
{
	import com.linkage.module.topo.framework.view.TopoPanelContainer;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;

	import flash.errors.IllegalOperationError;

	/**
	 * 业务逻辑类
	 * @author duangr
	 *
	 */
	public class Service implements IService
	{
		// 面板的容器(含画布)
		protected var _panelContainer:TopoPanelContainer = null;
		// URL 上下文 (工程名)
		private var _urlContext:String = null;

		public function Service()
		{

		}

		public function get name():String
		{
			throw new IllegalOperationError("Function get name() from abstract class Service has not been implemented by subclass.");
			return null;
		}

		public function set urlContext(value:String):void
		{
			_urlContext = value;
		}

		public function get urlContext():String
		{
			return _urlContext;
		}

		public function set attributes(attr:Object):void
		{
		}

		public function start():void
		{
		}

		public function set panelContainer(panelContainer:TopoPanelContainer):void
		{
			this._panelContainer = panelContainer;
		}

		public function pause():void
		{
		}
		
		public function restore():void
		{
		}
		
		/**
		 * 画布
		 */
		public function get topoCanvas():TopoCanvas
		{
			return this._panelContainer.topoCanvas;
		}
	}
}