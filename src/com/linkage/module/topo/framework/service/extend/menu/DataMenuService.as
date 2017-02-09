package com.linkage.module.topo.framework.service.extend.menu
{
	import com.linkage.module.topo.framework.service.Service;

	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	/**
	 * 拓扑菜单加载业务逻辑<br>
	 * 此业务类需要在启动之前先赋值菜单数据
	 *
	 * @author duangr
	 *
	 */
	public class DataMenuService extends Service
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.service.extend.menu.MenuService");

		// 菜单数据
		private var _menuData:XML = null;

		public function DataMenuService(menuData:XML)
		{
			super();
			_menuData = menuData;
		}

		override public function get name():String
		{
			return "拓扑菜单加载业务逻辑";
		}

		override public function set attributes(attr:Object):void
		{
			if (attr && attr.hasOwnProperty("menuData"))
			{
				_menuData = attr["menuData"];
			}
		}

		override public function start():void
		{
			if (_menuData == null)
			{
				throw new ArgumentError("MenuService参数异常,必须设置[menuData]参数!");
			}
			topoCanvas.menuManager.initialize(_menuData, urlContext);
		}

	}
}