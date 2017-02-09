package com.linkage.module.topo.framework.service.extend.menu
{
	import com.linkage.module.topo.framework.service.Service;
	import com.linkage.module.topo.framework.util.TopoUtil;
	import com.linkage.system.rpc.http.HttpUtil;
	import com.linkage.system.utils.StringUtils;

	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;
	import mx.utils.URLUtil;

	/**
	 * 根据URL加载拓扑菜单业务逻辑<br>
	 * 此业务类需要在启动之前先赋值菜单的URL
	 *
	 * @author duangr
	 *
	 */
	public class UrlMenuService extends Service
	{

		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.service.extend.menu.UrlMenuService");

		// 会话id
		private var _sessionId:String = null;
		// 菜单URL
		private var _menuUrl:String = null;

		public function UrlMenuService(sessionId:String, menuUrl:String)
		{
			super();
			_sessionId = sessionId;
			_menuUrl = menuUrl;
		}

		override public function get name():String
		{
			return "拓扑菜单URL加载业务逻辑";
		}

		override public function set attributes(attr:Object):void
		{
			if (attr)
			{
				if (attr.hasOwnProperty("sessionId"))
				{
					_sessionId = attr["sessionId"];
				}
				if (attr.hasOwnProperty("menuUrl"))
				{
					_menuUrl = attr["menuUrl"];
				}
			}
		}

		override public function start():void
		{
			if (_sessionId == null)
			{
				throw new ArgumentError("MenuService参数异常,必须设置[sessionId]参数!");
			}
			if (_menuUrl == null)
			{
				throw new ArgumentError("MenuService参数异常,必须设置[menuUrl]参数!");
			}
			var startTime:Number = new Date().getTime();
			var sessionId:String = null;
			if (StringUtils.endsWithIgnoreCase(_menuUrl, "action") || StringUtils.endsWithIgnoreCase(_menuUrl, "jsp"))
			{
				sessionId = _sessionId;
			}
			HttpUtil.httpService(sessionId, _menuUrl, function(result:Object):void
				{
					log.debug("loadTopoMenu Success. SpendTime:{0}s", (new Date().getTime() - startTime) / 1000.00);
					var menuData:XML = new XML(TopoUtil.subXmlStr(result as String));
					topoCanvas.menuManager.initialize(menuData, urlContext);
				});

		}
	}
}