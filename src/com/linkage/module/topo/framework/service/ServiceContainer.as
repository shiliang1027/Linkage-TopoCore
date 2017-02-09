package com.linkage.module.topo.framework.service
{
	import com.linkage.module.topo.framework.Version;
	import com.linkage.module.topo.framework.service.core.IDataService;
	import com.linkage.module.topo.framework.service.core.TopoInternalService;
	import com.linkage.module.topo.framework.util.TopoUtil;
	import com.linkage.module.topo.framework.view.TopoPanelContainer;
	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	/**
	 * 业务逻辑的容器
	 * 内置核心的逻辑类,扩展类可以根据需要添加
	 * @author duangr
	 *
	 */
	public class ServiceContainer
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.service.ServiceContainer");
		// 面板的容器(含画布)
		private var _panelContainer:TopoPanelContainer = null;
		// 扩展业务
		private var _extendServices:Array = [];
		// 内置核心逻辑
		private var _internalService:TopoInternalService = null;
		// URL 上下文 (工程名)
		private var _urlContext:String = null;

		public function ServiceContainer(panelContainer:TopoPanelContainer, urlContext:String)
		{
			log.info("拓扑框架启动: {0}", Version.info);
			this._urlContext = TopoUtil.formatContext(urlContext);
			this._panelContainer = panelContainer;
			// 初始化内置业务逻辑
			this._internalService = new TopoInternalService();
			this._internalService.panelContainer = this._panelContainer;
			this._internalService.urlContext = this._urlContext;
		}

		/**
		 * 通知内部的业务逻辑实例(包括内置逻辑和扩展逻辑)开始运行
		 */
		public function start():void
		{
			log.info("ServiceContainer start ... 业务类{0}个", _extendServices.length);
			_panelContainer.topoCanvas.doValidate();
			_internalService.start();
			_extendServices.forEach(function(item:IService, index:int, array:Array):void
				{
					item.start();
				});
		}

		/**
		 * 通知内部暂停
		 */
		public function pause():void
		{
			log.info("ServiceContainer pause ... 通知内部暂停", _extendServices.length);
			_extendServices.forEach(function(item:IService, index:int, array:Array):void
				{
					item.pause();
				});
		}

		/**
		 * 通知内部恢复
		 */
		public function restore():void
		{
			log.info("ServiceContainer pause ... 通知内部恢复", _extendServices.length);
			_extendServices.forEach(function(item:IService, index:int, array:Array):void
				{
					item.restore();
				});
		}

		/**
		 * 添加扩展的逻辑类
		 * @param service
		 *
		 */
		public function addService(service:IService):void
		{
			service.panelContainer = this._panelContainer;
			service.urlContext = this._urlContext;
			_extendServices.push(service);
			log.info("添加业务类 {0}", service.name);

			if (service is IDataService)
			{
				_internalService.dataService = (service as IDataService);
			}
		}

		/**
		 * 内置业务逻辑
		 */
		public function get internalService():TopoInternalService
		{
			return _internalService;
		}


	}
}