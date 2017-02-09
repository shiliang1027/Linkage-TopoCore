package com.linkage.module.topo.framework.service.extend.data
{
	import com.linkage.module.topo.framework.service.Service;
	import com.linkage.module.topo.framework.service.core.IDataService;
	import com.linkage.module.topo.framework.util.TopoUtil;
	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;
	
	import flash.geom.Point;

	/**
	 * 空数据支撑业务类.<br/>
	 *
	 * @author duangr
	 *
	 */
	public class EmptyDataService extends Service implements IDataService
	{

		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.service.extend.data.EmptyDataService");

		public function EmptyDataService()
		{
			super();
		}

		override public function get name():String
		{
			return "空数据支撑业务类";
		}


		public function loadDefaultTopoData(success:Function, complete:Function = null, error:Function = null):void
		{
			TopoUtil.noParamCallBack(complete);
		}

		public function loadTopoData(topoName:String, id:String, type:String, success:Function, complete:Function = null, error:Function = null):void
		{
			TopoUtil.noParamCallBack(complete);
		}

		public function loadParentTopoData(topoName:String, id:String, type:String, success:Function, complete:Function = null, error:Function = null):void
		{
			TopoUtil.noParamCallBack(complete);
		}

		public function loadViewModelTopoData(topoName:String, modelId:String, modelParams:String, success:Function, complete:Function = null, error:Function = null):void
		{
			TopoUtil.noParamCallBack(complete);
		}

		public function modifyPosition(complete:Function, success:Function = null, error:Function = null):void
		{
			TopoUtil.noParamCallBack(complete);
		}

		public function modifyLayer(topoName:String, pid:String, point:Point, idArr:String, success:Function = null, complete:Function = null, error:Function = null):void
		{
			TopoUtil.noParamCallBack(complete);
		}

		public function saveTopo(topoName:String, success:Function = null, complete:Function = null, error:Function = null):void
		{
			TopoUtil.noParamCallBack(complete);
		}

		public function loadAlarms(params:Object, success:Function, complete:Function = null, error:Function = null):void
		{
			TopoUtil.noParamCallBack(complete);
		}

		public function notify(topoName:String, data:String, success:Function, complete:Function = null, error:Function = null):void
		{
			TopoUtil.noParamCallBack(complete);
		}
	}
}