package com.linkage.module.topo.framework.service.extend.menu
{
	import com.linkage.module.topo.framework.Constants;
	import com.linkage.module.topo.framework.data.IDataSource;
	import com.linkage.module.topo.framework.service.Service;
	import com.linkage.module.topo.framework.util.TopoUtil;

	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	/**
	 * 拓扑内置的默认(拓扑服务)菜单加载业务逻辑
	 * @author duangr
	 *
	 */
	public class DefaultMenuService extends Service
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.service.extend.menu.DefaultMenuService");
		// 数据源
		private var _dataSource:IDataSource = null;

		public function DefaultMenuService(dataSource:IDataSource, attr:Object = null)
		{
			super();
			_dataSource = dataSource;
			attributes = attr;
		}

		override public function get name():String
		{
			return "默认菜单业务逻辑";
		}

		override public function set attributes(attr:Object):void
		{
		}

		override public function start():void
		{
			loadTopoMenus();
		}

		/**
		 * 加载远程拓扑菜单
		 *
		 */
		private function loadTopoMenus():void
		{
			_dataSource.loadTopoMenus(function(data:XML):void
				{
					topoCanvas.menuManager.initialize(data, urlContext);
				}, function():void
				{
				// complete
				}, function():void
				{
				// error
				});
		}

	}
}