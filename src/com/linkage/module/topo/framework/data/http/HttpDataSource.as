package com.linkage.module.topo.framework.data.http
{
	import com.linkage.module.topo.framework.Version;
	import com.linkage.module.topo.framework.data.IDataSource;
	import com.linkage.module.topo.framework.util.TopoUtil;
	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;
	import com.linkage.system.rpc.http.HttpUtil;
	
	import flash.geom.Point;
	import flash.net.URLVariables;
	
	import mx.rpc.events.FaultEvent;

	/**
	 * HTTP的方式的数据源
	 * @author duangr
	 *
	 */
	public class HttpDataSource implements IDataSource
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.data.http.HttpDataSource");
		// 远程请求Action的前缀
		private static const ACTION_PREFIX:String = "/cms/webtopo/topo/topo!";
		// session Id
		private var _sessionId:String = null;
		// URL 上下文 (工程名)
		private var _urlContext:String = null;

		public function HttpDataSource(sessionId:String, urlContext:String)
		{
			this._sessionId = sessionId;
			this._urlContext = urlContext;
		}

		/**
		 * 截取xml文件,将 最后一个 ">" 后面的内容去掉
		 * @param input
		 * @return
		 *
		 */
		private function subXmlStr(input:String):String
		{
			var index:int = input.lastIndexOf(">");
			if (index != -1)
			{
				return input.substring(0, index + 1);
			}
			else
			{
				return input;
			}
		}

		/**
		 * 执行无参数的回调
		 * @param callback
		 *
		 */
		private function noParamCallBack(callback:Function):void
		{
			if (callback != null)
			{
				callback.call();
			}
		}

		public function loadTopoData(topoName:String, id:String, type:String, success:Function, complete:Function = null, error:Function = null):void
		{
			log.debug("HTTP Start loadTopoData topoName={0} id={1} type={2}", topoName, id, type);
			var url:String = _urlContext + ACTION_PREFIX + "loadTopoData.action";
			var params:URLVariables = new URLVariables();
			params.version = Version.VERSION; // 将版本号发给web
			params.topoName = topoName;
			//params.port = port;
			params.id = id;
			params.type = type;

			var startTime:Number = new Date().getTime();
			HttpUtil.httpService(_sessionId, url, function(result:Object):void
				{
					log.debug("loadTopoData Success. SpendTime:{0}s", (new Date().getTime() - startTime) / 1000.00);
					success.call(null, new XML(subXmlStr(result as String)));
					noParamCallBack(complete);
				}, params, function(event:FaultEvent):void
				{
					noParamCallBack(error);
					noParamCallBack(complete);
				});
		}

		public function loadTopoDataBySql(topoName:String, boxnames:String, topoSql:String, success:Function, complete:Function = null, error:Function = null):void
		{
			log.debug("HTTP Start loadTopoDataBySql topoName={0} boxnames={1} topoSql={2}", topoName, boxnames, topoSql);
			var url:String = _urlContext + ACTION_PREFIX + "loadTopoDataBySql.action";
			var params:URLVariables = new URLVariables();
			params.version = Version.VERSION; // 将版本号发给web
			params.topoName = topoName;
			//params.port = port;
			params.type = boxnames;
			params.data = topoSql;

			var startTime:Number = new Date().getTime();
			HttpUtil.httpService(_sessionId, url, function(result:Object):void
				{
					log.debug("loadTopoDataBySql Success. SpendTime:{0}s", (new Date().getTime() - startTime) / 1000.00);
					success.call(null, new XML(subXmlStr(result as String)));
					noParamCallBack(complete);
				}, params, function(event:FaultEvent):void
				{
					noParamCallBack(error);
					noParamCallBack(complete);
				});
		}

		public function loadTopoMenus(success:Function, complete:Function = null, error:Function = null):void
		{
			log.debug("HTTP Start loadTopoMenus");
			var url:String = _urlContext + ACTION_PREFIX + "loadTopoMenus.action";
			var params:URLVariables = new URLVariables();
			params.version = Version.VERSION; // 将版本号发给web

			var startTime:Number = new Date().getTime();
			HttpUtil.httpService(_sessionId, url, function(result:Object):void
				{
					log.debug("loadTopoMenus Success. SpendTime:{0}s", (new Date().getTime() - startTime) / 1000.00);
					success.call(null, new XML(subXmlStr(result as String)));
					noParamCallBack(complete);
				}, params, function(event:FaultEvent):void
				{
					noParamCallBack(error);
					noParamCallBack(complete);
				});
		}

		public function loadCreateViewMenus(success:Function, complete:Function = null, error:Function = null):void
		{
			log.debug("HTTP Start loadCreateViewMenus");
			var url:String = _urlContext + ACTION_PREFIX + "loadCreateViewMenus.action";
			var params:URLVariables = new URLVariables();
			params.version = Version.VERSION; // 将版本号发给web

			var startTime:Number = new Date().getTime();
			HttpUtil.httpService(_sessionId, url, function(result:Object):void
				{
					log.debug("loadCreateViewMenus Success. SpendTime:{0}s", (new Date().getTime() - startTime) / 1000.00);
					success.call(null, new XML(subXmlStr(result as String)));
					noParamCallBack(complete);
				}, params, function(event:FaultEvent):void
				{
					noParamCallBack(error);
					noParamCallBack(complete);
				});
		}

		public function loadParentTopoData(topoName:String, pid:String, success:Function, complete:Function = null, error:Function = null):void
		{
			log.debug("HTTP Start loadParentTopoData topoName={0} pid={1}", topoName, pid);
			var url:String = _urlContext + ACTION_PREFIX + "loadParentTopoData.action";
			var params:URLVariables = new URLVariables();
			params.version = Version.VERSION; // 将版本号发给web
			params.topoName = topoName;
			params.id = pid;

			var startTime:Number = new Date().getTime();
			HttpUtil.httpService(_sessionId, url, function(result:Object):void
				{
					log.debug("loadParentTopoData Success. SpendTime:{0}s", (new Date().getTime() - startTime) / 1000.00);
					success.call(null, new XML(subXmlStr(result as String)));
					noParamCallBack(complete);
				}, params, function(event:FaultEvent):void
				{
					noParamCallBack(error);
					noParamCallBack(complete);
				});
		}

		public function loadViewModelTopoData(topoName:String, modelId:String, modelParams:String, success:Function, complete:Function = null, error:Function = null):void
		{
			log.debug("HTTP Start loadViewModelTopoData topoName={0} modelId={1} modelParams={2}", topoName, modelId, modelParams);
			var url:String = _urlContext + ACTION_PREFIX + "loadViewModelTopoData.action";
			var params:URLVariables = new URLVariables();
			params.version = Version.VERSION; // 将版本号发给web
			params.topoName = topoName;
			params.id = modelId;
			params.data = modelParams;

			var startTime:Number = new Date().getTime();
			HttpUtil.httpService(_sessionId, url, function(result:Object):void
				{
					log.debug("loadViewModelTopoData Success. SpendTime:{0}s", (new Date().getTime() - startTime) / 1000.00);
					success.call(null, new XML(subXmlStr(result as String)));
					noParamCallBack(complete);
				}, params, function(event:FaultEvent):void
				{
					noParamCallBack(error);
					noParamCallBack(complete);
				});
		}

		public function loadTopoTree(topoName:String, id:String, level:int, topoSql:String, success:Function, complete:Function = null, error:Function = null):void
		{
			log.debug("HTTP Start loadTopoTree topoName={0} id={1} level={2} topoSql={3}", topoName, id, level, topoSql);
			var url:String = _urlContext + ACTION_PREFIX + "loadTopoTree.action";
			var params:URLVariables = new URLVariables();
			params.version = Version.VERSION; // 将版本号发给web
			params.topoName = topoName;
			params.id = id;
			params.num = level;
			params.data = topoSql;

			var startTime:Number = new Date().getTime();
			HttpUtil.httpService(_sessionId, url, function(result:Object):void
				{
					log.debug("loadTopoTree Success. SpendTime:{0}s", (new Date().getTime() - startTime) / 1000.00);
					success.call(null, new XML(subXmlStr(result as String)));
					noParamCallBack(complete);
				}, params, function(event:FaultEvent):void
				{
					noParamCallBack(error);
					noParamCallBack(complete);
				});
		}

//		public function loadAlarms(topoName:String, type:String, objIdArr:String, linkIdArr:String, extInfo:String, success:Function, complete:Function = null, error:Function = null):void
//		{
//			//			log.debug("HTTP Start loadAlarms type={0}", type);
//			var url:String = _urlContext + ACTION_PREFIX + "loadAlarms.action";
//			var params:URLVariables = new URLVariables();
//			params.version = Version.VERSION; // 将版本号发给web
//			params.topoName = topoName;
//			params.type = type;
//			params.id = objIdArr;
//			params.data = linkIdArr;
//			params.extInfo = extInfo;
//			
//			var startTime:Number = new Date().getTime();
//			HttpUtil.httpService(_sessionId, url, function(result:Object):void
//			{
//				//					log.debug("loadAlarms Success. SpendTime:{0}s", (new Date().getTime() - startTime) / 1000.00);
//				success.call(null, TopoUtil.jsonDecode(result as String));
//				noParamCallBack(complete);
//			}, params, function(event:FaultEvent):void
//			{
//				//					log.debug("loadAlarms Error.\n  [faultCode] {0}\n  [faultString] {1}\n  [faultDetail] {2}", event.fault.faultCode, event.fault.faultString, event.fault.faultDetail);
//				noParamCallBack(error);
//				noParamCallBack(complete);
//			});
//		}
		
		public function loadAlarms(params:Object, success:Function, complete:Function = null, error:Function = null):void
		{
			//			log.debug("HTTP Start loadAlarms type={0}", type);
			var url:String = _urlContext + ACTION_PREFIX + "loadAlarms.action";
			var param:URLVariables = new URLVariables();
			param.version = Version.VERSION; // 将版本号发给web
			param.topoName = params.topoName;
			param.type = params.type;
			param.id = params.objIdArr;
			param.data = params.linkIdArr;
			param.extInfo = params.extInfo;
			
			var startTime:Number = new Date().getTime();
			HttpUtil.httpService(_sessionId, url, function(result:Object):void
			{
				//					log.debug("loadAlarms Success. SpendTime:{0}s", (new Date().getTime() - startTime) / 1000.00);
				success.call(null, TopoUtil.jsonDecode(result as String));
				noParamCallBack(complete);
			}, param, function(event:FaultEvent):void
			{
				//					log.debug("loadAlarms Error.\n  [faultCode] {0}\n  [faultString] {1}\n  [faultDetail] {2}", event.fault.faultCode, event.fault.faultString, event.fault.faultDetail);
				noParamCallBack(error);
				noParamCallBack(complete);
			});
		}

		public function modifyPosition(topoName:String, pid:String, position:String, success:Function = null, complete:Function = null, error:Function = null):void
		{
			log.debug("HTTP Start modifyPosition topoName={0} pid={1}", topoName, pid);
			var url:String = _urlContext + ACTION_PREFIX + "modifyPosition.action";
			var params:URLVariables = new URLVariables();
			params.version = Version.VERSION; // 将版本号发给web
			params.topoName = topoName;
			params.id = pid;
			params.data = position;

			var startTime:Number = new Date().getTime();
			HttpUtil.httpService(_sessionId, url, function(result:Object):void
				{
					log.debug("modifyPosition Success. SpendTime:{0}s", (new Date().getTime() - startTime) / 1000.00);
					noParamCallBack(success);
					noParamCallBack(complete);
				}, params, function(event:FaultEvent):void
				{
					noParamCallBack(error);
					noParamCallBack(complete);
				});
		}

		public function modifyLayer(topoName:String, pid:String, point:Point, idArr:String, success:Function = null, complete:Function = null, error:Function = null):void
		{
			log.debug("HTTP Start modifyLayer topoName={0} pid={1}", topoName, pid);
			var url:String = _urlContext + ACTION_PREFIX + "modifyLayer.action";
			var params:URLVariables = new URLVariables();
			params.version = Version.VERSION; // 将版本号发给web
			params.topoName = topoName;
			params.id = pid;
			params.x = point.x;
			params.y = point.y;
			params.data = idArr;

			var startTime:Number = new Date().getTime();
			HttpUtil.httpService(_sessionId, url, function(result:Object):void
				{
					log.debug("modifyLayer Success. SpendTime:{0}s", (new Date().getTime() - startTime) / 1000.00);
					noParamCallBack(success);
					noParamCallBack(complete);
				}, params, function(event:FaultEvent):void
				{
					noParamCallBack(error);
					noParamCallBack(complete);
				});
		}

		public function saveTopo(topoName:String, success:Function, complete:Function = null, error:Function = null):void
		{
			log.debug("HTTP Start saveTopo topoName={0}", topoName);
			var url:String = _urlContext + ACTION_PREFIX + "saveTopo.action";
			var params:URLVariables = new URLVariables();
			params.version = Version.VERSION; // 将版本号发给web
			params.topoName = topoName;

			var startTime:Number = new Date().getTime();
			HttpUtil.httpService(_sessionId, url, function(result:Object):void
				{
					log.debug("saveTopo Success. SpendTime:{0}s", (new Date().getTime() - startTime) / 1000.00);
					success.call(null, result);
					noParamCallBack(complete);
				}, params, function(event:FaultEvent):void
				{
					noParamCallBack(error);
					noParamCallBack(complete);
				});
		}

		public function notify(topoName:String, data:String, success:Function, complete:Function = null, error:Function = null):void
		{
//			log.debug("HTTP Start notify");
			var url:String = _urlContext + ACTION_PREFIX + "dispatchEvent.action";
			var params:URLVariables = new URLVariables();
			params.version = Version.VERSION; // 将版本号发给web
			params.topoName = topoName;
			params.data = data;

			var startTime:Number = new Date().getTime();
			HttpUtil.httpService(_sessionId, url, function(result:Object):void
				{
//					log.debug("notify Success. SpendTime:{0}s", (new Date().getTime() - startTime) / 1000.00);
					success.call(null, result);
					noParamCallBack(complete);
				}, params, function(event:FaultEvent):void
				{
					noParamCallBack(error);
					noParamCallBack(complete);
				});
		}

//		public function searchTopo(type:String, value:String, success:Function, complete:Function = null, error:Function = null):void
//		{
//			log.debug("HTTP Start searchTopo type={0} value={1}", type, value);
//			var url:String = _urlContext + ACTION_PREFIX + "searchTopo.action";
//			var params:URLVariables = new URLVariables();
//			params.version = Version.VERSION; // 将版本号发给web
//			params.type = type;
//			params.data = value;
//
//			var startTime:Number = new Date().getTime();
//			HttpUtil.httpService(_sessionId, url, function(result:Object):void
//				{
//					log.debug("searchTopo Success. SpendTime:{0}s", (new Date().getTime() - startTime) / 1000.00);
//					success.call(null, new XML(subXmlStr(result as String)));
//					noParamCallBack(complete);
//				}, params, function(event:FaultEvent):void
//				{
//					noParamCallBack(error);
//					noParamCallBack(complete);
//				});
//		}

		public function queryTopoIcons(success:Function, complete:Function = null, error:Function = null):void
		{
			log.debug("HTTP Start queryTopoIcons");
			var url:String = _urlContext + ACTION_PREFIX + "queryTopoIcons.action";
			var params:URLVariables = new URLVariables();
			params.version = Version.VERSION; // 将版本号发给web

			var startTime:Number = new Date().getTime();
			HttpUtil.httpService(_sessionId, url, function(result:Object):void
				{
					log.debug("queryTopoIcons Success. SpendTime:{0}s", (new Date().getTime() - startTime) / 1000.00);
					success.call(null, new XML(subXmlStr(result as String)));
					noParamCallBack(complete);
				}, params, function(event:FaultEvent):void
				{
					noParamCallBack(error);
					noParamCallBack(complete);
				});
		}

		public function findAvailableTopoName(regex:String, success:Function, complete:Function = null, error:Function = null):void
		{
			log.debug("HTTP Start findAvailableTopoName regex={0}", regex);
			var url:String = _urlContext + ACTION_PREFIX + "findAvailableTopoName.action";
			var params:URLVariables = new URLVariables();
			params.version = Version.VERSION; // 将版本号发给web
			params.data = regex;

			var startTime:Number = new Date().getTime();
			HttpUtil.httpService(_sessionId, url, function(result:Object):void
				{
					log.debug("findAvailableTopoName Success. SpendTime:{0}s", (new Date().getTime() - startTime) / 1000.00);
					success.call(null, new XML(subXmlStr(result as String)));
					noParamCallBack(complete);
				}, params, function(event:FaultEvent):void
				{
					noParamCallBack(error);
					noParamCallBack(complete);
				});
		}

		public function listPicNames(path:String, success:Function, complete:Function = null, error:Function = null):void
		{
			log.debug("HTTP Start listPicNames path={0}", path);
			var url:String = _urlContext + ACTION_PREFIX + "listPicNames.action";
			var params:URLVariables = new URLVariables();
			params.version = Version.VERSION; // 将版本号发给web
			params.data = path;

			var startTime:Number = new Date().getTime();
			HttpUtil.httpService(_sessionId, url, function(result:Object):void
				{
					log.debug("listPicNames Success. SpendTime:{0}s", (new Date().getTime() - startTime) / 1000.00);
					success.call(null, new XML(subXmlStr(result as String)));
					noParamCallBack(complete);
				}, params, function(event:FaultEvent):void
				{
					noParamCallBack(error);
					noParamCallBack(complete);
				});
		}
		
		public function doloadTopoLinkDesc(param:Object, success:Function, complete:Function = null, error:Function = null):void
		{
			log.debug("HTTP Start doloadTopoLinkDesc param.pid={0}", param.pid);
			var url:String = _urlContext + ACTION_PREFIX + "doloadTopoLinkDesc.action";
			var params:URLVariables = new URLVariables();
			params.version = Version.VERSION; // 将版本号发给web
			params.data = param;
			
			var startTime:Number = new Date().getTime();
			HttpUtil.httpService(_sessionId, url, function(result:Object):void
			{
				log.debug("doloadTopoLinkDesc Success. SpendTime:{0}s", (new Date().getTime() - startTime) / 1000.00);
				success.call(null, new XML(subXmlStr(result as String)));
				noParamCallBack(complete);
			}, params, function(event:FaultEvent):void
			{
				noParamCallBack(error);
				noParamCallBack(complete);
			});
		}
		
	}
}