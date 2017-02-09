package com.linkage.module.topo.framework.data.remotimg
{
	import com.linkage.module.topo.framework.Constants;
	import com.linkage.module.topo.framework.data.IDataSource;
	import com.linkage.module.topo.framework.util.TopoUtil;
	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;
	import com.linkage.system.rpc.remoting.BlazeDSUtil;
	
	import flash.geom.Point;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.remoting.RemoteObject;

	/**
	 * 远程对象数据源
	 * @author duangr
	 *
	 */
	public class RemoteDataSource implements IDataSource
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.data.remotimg.RemoteDataSource");

		private static const DESTINATION:String = "flexdestination_topo_toposervice";
		private static const SOURCE:String = "com.linkage.module.cms.webtopo.topo.flexds.TopoFlexDSImp";
		private static const endpoint_SUFFIX:String = "/messagebroker/amf";

		// 用户对象
		private var _user:Object = null;
		// url上下文
		private var _urlContext:String = null;
		// EndPoint
		private var _endpoint:String = null;

		public function RemoteDataSource(user:Object, urlContext:String)
		{
			this._user = user;
			this._urlContext = urlContext;
			this._endpoint = this._urlContext + endpoint_SUFFIX;
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

		/**
		 * 检查拓扑名称,若为null使用默认值
		 * @param topoName
		 * @return
		 *
		 */
		private function checkTopoName(topoName:String):String
		{
			return topoName == null ? Constants.DEFAULT_TOPONAME : topoName;
		}

		public function loadTopoMenus(success:Function, complete:Function = null, error:Function = null):void
		{
			log.debug("BlazeDS Start loadTopoMenus");
			var startTime:Number = new Date().getTime();
			var remoteService:RemoteObject = BlazeDSUtil.newService(DESTINATION, SOURCE, _endpoint, function(result:Object):void
				{
					log.debug("loadTopoMenus Success. SpendTime:{0}s", (new Date().getTime() - startTime) / 1000.00);
					success.call(null, new XML(result.toString()));
					noParamCallBack(complete);
				}, function(event:FaultEvent):void
				{
					noParamCallBack(error);
					noParamCallBack(complete);
				}, true, "loadTopoMenus");
			remoteService.loadTopoMenus(_user);
		}

		public function loadCreateViewMenus(success:Function, complete:Function = null, error:Function = null):void
		{
			log.debug("BlazeDS Start loadCreateViewMenus");
			var startTime:Number = new Date().getTime();
			var remoteService:RemoteObject = BlazeDSUtil.newService(DESTINATION, SOURCE, _endpoint, function(result:Object):void
				{
					log.debug("loadCreateViewMenus Success. SpendTime:{0}s", (new Date().getTime() - startTime) / 1000.00);
					success.call(null, new XML(result.toString()));
					noParamCallBack(complete);
				}, function(event:FaultEvent):void
				{
					noParamCallBack(error);
					noParamCallBack(complete);
				}, true, "loadCreateViewMenus");
			remoteService.loadCreateViewMenus(_user);
		}

		public function loadTopoData(topoName:String, id:String, type:String, success:Function, complete:Function = null, error:Function = null):void
		{
			log.debug("BlazeDS Start loadTopoData topoName={0} id={1} type={2}", topoName, id, type);
			var startTime:Number = new Date().getTime();
			var remoteService:RemoteObject = BlazeDSUtil.newService(DESTINATION, SOURCE, _endpoint, function(result:Object):void
				{
					log.debug("loadTopoData Success. SpendTime:{0}s", (new Date().getTime() - startTime) / 1000.00);
					success.call(null, new XML(result.toString()));
					noParamCallBack(complete);
				}, function(event:FaultEvent):void
				{
					noParamCallBack(error);
					noParamCallBack(complete);  
				}, true, "loadTopoData");
			remoteService.loadTopoData(_user, topoName, id, type);
		}

		public function loadTopoDataBySql(topoName:String,boxnames:String, topoSql:String, success:Function, complete:Function = null, error:Function = null):void
		{
			log.debug("BlazeDS Start loadTopoDataBySql topoName={0} boxnames={1} topoSql={2}", topoName, boxnames, topoSql);
			var startTime:Number = new Date().getTime();
			var remoteService:RemoteObject = BlazeDSUtil.newService(DESTINATION, SOURCE, _endpoint, function(result:Object):void
				{
					log.debug("loadTopoDataBySql Success. SpendTime:{0}s", (new Date().getTime() - startTime) / 1000.00);
					success.call(null, new XML(result.toString()));
					noParamCallBack(complete);
				}, function(event:FaultEvent):void
				{
					noParamCallBack(error);
					noParamCallBack(complete);
				}, true, "loadTopoDataBySql");
			remoteService.loadTopoDataBySql(_user, checkTopoName(topoName), boxnames, topoSql);
		}

		public function loadParentTopoData(topoName:String, pid:String, success:Function, complete:Function = null, error:Function = null):void
		{
			log.debug("BlazeDS Start loadParentTopoData topoName={0} pid={1}", topoName, pid);
			var startTime:Number = new Date().getTime();
			var remoteService:RemoteObject = BlazeDSUtil.newService(DESTINATION, SOURCE, _endpoint, function(result:Object):void
				{
					log.debug("loadParentTopoData Success. SpendTime:{0}s", (new Date().getTime() - startTime) / 1000.00);
					success.call(null, new XML(result.toString()));
					noParamCallBack(complete);
				}, function(event:FaultEvent):void
				{
					noParamCallBack(error);
					noParamCallBack(complete);
				}, true, "loadParentTopoData");
			remoteService.loadParentTopoData(_user, checkTopoName(topoName), pid);
		}

		public function loadViewModelTopoData(topoName:String, modelId:String, modelParams:String, success:Function, complete:Function = null, error:Function = null):void
		{
			log.debug("BlazeDS Start loadViewModelTopoData topoName={0} modelId={1} modelParams={2}", topoName, modelId, modelParams);
			var startTime:Number = new Date().getTime();
			var remoteService:RemoteObject = BlazeDSUtil.newService(DESTINATION, SOURCE, _endpoint, function(result:Object):void
				{
					log.debug("loadViewModelTopoData Success. SpendTime:{0}s", (new Date().getTime() - startTime) / 1000.00);
					success.call(null, new XML(result.toString()));
					noParamCallBack(complete);
				}, function(event:FaultEvent):void
				{
					noParamCallBack(error);
					noParamCallBack(complete);
				}, true, "loadViewModelTopoData");
			remoteService.loadViewModelTopoData(_user, checkTopoName(topoName), modelId, modelParams);
		}

		public function loadTopoTree(topoName:String, id:String, level:int, topoSql:String, success:Function, complete:Function = null, error:Function = null):void
		{
			log.debug("BlazeDS Start loadTopoTree topoName={0} id={1} level={2} topoSql={3}", topoName, id, level, topoSql);
			var startTime:Number = new Date().getTime();
			var remoteService:RemoteObject = BlazeDSUtil.newService(DESTINATION, SOURCE, _endpoint, function(result:Object):void
				{
					log.debug("loadTopoTree Success. SpendTime:{0}s", (new Date().getTime() - startTime) / 1000.00);
					success.call(null, new XML(result.toString()));
					noParamCallBack(complete);
				}, function(event:FaultEvent):void
				{
					noParamCallBack(error);
					noParamCallBack(complete);
				}, true, "loadTopoTree");
			remoteService.loadTopoTree(_user, checkTopoName(topoName), id, level, topoSql);
		}

		private function loadAlarmsOld(topoName:String, type:String, objIdArr:String, linkIdArr:String, extInfo:String, success:Function, complete:Function = null, error:Function = null):void
		{
			//log.debug("BlazeDS Start loadAlarms type={0}", type);
			var startTime:Number = new Date().getTime();
			var remoteService:RemoteObject = BlazeDSUtil.newService(DESTINATION, SOURCE, _endpoint, function(result:Object):void
			{
				//					log.debug("loadAlarms Success. SpendTime:{0}s", (new Date().getTime() - startTime) / 1000.00);
				success.call(null, TopoUtil.jsonDecode(result as String));
				noParamCallBack(complete);
			}, function(event:FaultEvent):void
			{
				noParamCallBack(error);
				noParamCallBack(complete);
			}, true, "loadAlarms");
			remoteService.loadAlarms(_user, checkTopoName(topoName), type, objIdArr, linkIdArr, extInfo);
		}
		
		public function loadAlarms(params:Object, success:Function, complete:Function = null, error:Function = null):void
		{
			//log.debug("BlazeDS Start loadAlarms type={0}", type);
			log.info("[loadAlarms]1--------------------------------->");
//			var startTime:Number = new Date().getTime();
//			var remoteService:RemoteObject = BlazeDSUtil.newService(DESTINATION, SOURCE, _endpoint, function(result:Object):void
//			{
//				//					log.debug("loadAlarms Success. SpendTime:{0}s", (new Date().getTime() - startTime) / 1000.00);
//				success.call(null, TopoUtil.jsonDecode(result as String));
//				noParamCallBack(complete);
//			}, function(event:FaultEvent):void
//			{
//				noParamCallBack(error);
//				noParamCallBack(complete);
//			}, true, "loadAlarms");
//			params.user=_user;
//			log.info(params);
//			log.info("[loadAlarms]2--------------------------------->");
//			
//			remoteService.loadAlarmsNew(params);
			loadAlarmsOld(params.topoName,params.type,params.objIds,params.linkIds,params.extInfo,success,complete,error);
		}

		public function modifyPosition(topoName:String, pid:String, position:String, success:Function = null, complete:Function = null, error:Function = null):void
		{
			log.debug("BlazeDS Start modifyPosition topoName={0} pid={1}", topoName, pid);
			var startTime:Number = new Date().getTime();
			var remoteService:RemoteObject = BlazeDSUtil.newService(DESTINATION, SOURCE, _endpoint, function(result:Object):void
				{
					log.debug("modifyPosition Success. SpendTime:{0}s", (new Date().getTime() - startTime) / 1000.00);
					noParamCallBack(success);
					noParamCallBack(complete);
				}, function(event:FaultEvent):void
				{
					noParamCallBack(error);
					noParamCallBack(complete);
				}, true, "modifyPosition");
			remoteService.modifyPosition(_user, checkTopoName(topoName), pid, position);
		}

		public function modifyLayer(topoName:String, pid:String, point:Point, idArr:String, success:Function = null, complete:Function = null, error:Function = null):void
		{
			log.debug("BlazeDS Start modifyLayer topoName={0} pid={1}", topoName, pid);
			var startTime:Number = new Date().getTime();
			var remoteService:RemoteObject = BlazeDSUtil.newService(DESTINATION, SOURCE, _endpoint, function(result:Object):void
				{
					log.debug("modifyLayer Success. SpendTime:{0}s", (new Date().getTime() - startTime) / 1000.00);
					noParamCallBack(success);
					noParamCallBack(complete);
				}, function(event:FaultEvent):void
				{
					noParamCallBack(error);
					noParamCallBack(complete);
				}, true, "modifyLayer");
			remoteService.modifyLayer(_user, checkTopoName(topoName), pid, point.x, point.y, idArr);
		}

		public function saveTopo(topoName:String, success:Function, complete:Function = null, error:Function = null):void
		{
			log.debug("BlazeDS Start saveTopo topoName={0}", topoName);
			var startTime:Number = new Date().getTime();
			var remoteService:RemoteObject = BlazeDSUtil.newService(DESTINATION, SOURCE, _endpoint, function(result:Object):void
				{
					log.debug("saveTopo Success. SpendTime:{0}s", (new Date().getTime() - startTime) / 1000.00);
					success.call(null, result);
					noParamCallBack(complete);
				}, function(event:FaultEvent):void
				{
					noParamCallBack(error);
					noParamCallBack(complete);
				}, true, "saveTopo");
			remoteService.saveTopo(_user, topoName);
		}

		public function notify(topoName:String, data:String, success:Function, complete:Function = null, error:Function = null):void
		{
//			log.debug("BlazeDS Start notify");
			var startTime:Number = new Date().getTime();
			var remoteService:RemoteObject = BlazeDSUtil.newService(DESTINATION, SOURCE, _endpoint, function(result:Object):void
				{
					log.debug("notify Success. SpendTime:{0}s", (new Date().getTime() - startTime) / 1000.00);
					log.info(result.toString());
					success.call(null, result.toString());
					noParamCallBack(complete);
				}, function(event:FaultEvent):void
				{
					noParamCallBack(error);
					noParamCallBack(complete);
				}, true, "notify");
			remoteService.notify(_user, checkTopoName(topoName), data);
		}

		public function queryTopoIcons(success:Function, complete:Function = null, error:Function = null):void
		{
			log.debug("BlazeDS Start queryTopoIcons");
			var startTime:Number = new Date().getTime();
			var remoteService:RemoteObject = BlazeDSUtil.newService(DESTINATION, SOURCE, _endpoint, function(result:Object):void
				{
					log.debug("queryTopoIcons Success. SpendTime:{0}s", (new Date().getTime() - startTime) / 1000.00);
					success.call(null, new XML(result.toString()));
					noParamCallBack(complete);
				}, function(event:FaultEvent):void
				{
					noParamCallBack(error);
					noParamCallBack(complete);
				}, true, "queryTopoIcons");
			remoteService.queryTopoIcons(_user);
		}

		public function findAvailableTopoName(regex:String, success:Function, complete:Function = null, error:Function = null):void
		{
			log.info("findAvailableTopoName test");
			log.debug("BlazeDS Start findAvailableTopoName regex={0}", regex);
			var startTime:Number = new Date().getTime();
			var remoteService:RemoteObject = BlazeDSUtil.newService(DESTINATION, SOURCE, _endpoint, function(result:Object):void
				{
					log.debug("findAvailableTopoName Success. SpendTime:{0}s", (new Date().getTime() - startTime) / 1000.00);
					log.info("findAvailableTopoName Success test");
					success.call(null, new XML(result.toString()));
					noParamCallBack(complete);
				}, function(event:FaultEvent):void
				{
					noParamCallBack(error);
					noParamCallBack(complete);
				}, true, "findAvailableTopoName");
			
			log.info("remoteService.findAvailableTopoName test");
			remoteService.findAvailableTopoName(_user, regex);
		}

		public function listPicNames(path:String, success:Function, complete:Function = null, error:Function = null):void
		{
			log.debug("BlazeDS Start listPicNames path={0}", path);
			var startTime:Number = new Date().getTime();
			var remoteService:RemoteObject = BlazeDSUtil.newService(DESTINATION, SOURCE, _endpoint, function(result:Object):void
				{
					log.debug("listPicNames Success. SpendTime:{0}s", (new Date().getTime() - startTime) / 1000.00);
					success.call(null, new XML(result.toString()));
					noParamCallBack(complete);
				}, function(event:FaultEvent):void
				{
					noParamCallBack(error);
					noParamCallBack(complete);
				}, true, "listPicNames");
			remoteService.listPicNames(_user, path);
		}
		public function doloadTopoLinkDesc(param:Object, success:Function, complete:Function = null, error:Function = null):void
		{
			log.debug("BlazeDS Start doloadTopoLinkDesc param.pid={0}", param.id);
			var startTime:Number = new Date().getTime();
			var remoteService:RemoteObject = BlazeDSUtil.newService(DESTINATION, SOURCE, _endpoint, function(result:Object):void
			{
				log.debug("doloadTopoLinkDesc Success. SpendTime:{0}s", (new Date().getTime() - startTime) / 1000.00);
				success.call(null, new XML(result.toString()));
				noParamCallBack(complete);
			}, function(event:FaultEvent):void
			{
				noParamCallBack(error);
				noParamCallBack(complete);
			}, true, "doloadTopoLinkDesc");
			remoteService.doloadTopoLinkDesc(_user, param);
		}
	}
}