package com.linkage.module.topo.framework.service.extend.data
{
	import com.ailk.common.system.logging.ILogger;
	import com.ailk.common.system.logging.Log;
	import com.linkage.module.topo.framework.Constants;
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.model.element.line.ITPLine;
	import com.linkage.module.topo.framework.core.model.element.point.ITPPoint;
	import com.linkage.module.topo.framework.data.IDataSource;
	import com.linkage.module.topo.framework.service.Service;
	import com.linkage.module.topo.framework.service.core.IDataService;
	import com.linkage.module.topo.framework.util.MessageUtil;
	import com.linkage.module.topo.framework.util.TopoUtil;
	import com.linkage.system.utils.StringUtils;
	
	import flash.geom.Point;

	/**
	 * 拓扑内置的默认(拓扑服务)数据支撑的业务类.<br/>
	 * 初始化时所需参数key包括:<br/>
	 * <table>
	 * <tr><td>id</td><td>要加载的拓扑图id</td></tr>
	 * <tr><td>type</td><td>segment|view 标识id是网段还是视图</td></tr>
	 * </table>
	 *
	 * @author duangr
	 *
	 */
	public class DefaultDataService extends Service implements IDataService
	{
		// log
		private var log:ILogger = Log.getLoggerByClass(DefaultDataService);
		// 数据源
		private var _dataSource:IDataSource = null;

		// ---------------------------------- //
		// 要加载的拓扑图id
		private var _topoId:String = null;
		// 拓扑图类型(segment|view)
		private var _topoType:String = null;
		// 拓扑数据源名称
		private var _topoName:String = null;
		// 拓扑数据源名称
		private var _port:String = null;

		public function DefaultDataService(dataSource:IDataSource, attr:Object = null)
		{
			super();
			this._dataSource = dataSource;
			attributes = attr;
		}

		override public function get name():String
		{
			return "默认数据业务";
		}

		override public function set attributes(attr:Object):void
		{
			if (attr)
			{
				_topoName = attr[Constants.PARAM_TOPONAME];
				_topoId = attr[Constants.PARAM_TOPOID];
				_topoType = attr[Constants.PARAM_TOPOTYPE];
			}
		}

		public function loadDefaultTopoData(success:Function, complete:Function = null, error:Function = null):void
		{
			// 存在默认id的话则加载拓扑
			if (!StringUtils.isEmpty(_topoId))
			{
				log.debug("[{0}] 加载默认拓扑 topoName={1} id={2} type={3}", name, _topoName, _topoId, _topoType);
				_dataSource.loadTopoData(_topoName, _topoId, _topoType, success, complete, error);
			}
			else
			{
				log.debug("[{0}] 无默认拓扑,无需加载...", name);
				TopoUtil.noParamCallBack(complete);
			}
		}

		public function loadTopoData(topoName:String, id:String, type:String, success:Function, complete:Function = null, error:Function = null):void
		{
			log.debug("[{0}] 加载自身拓扑 id={1} type={2}", name, id, type); 
			_dataSource.loadTopoData(topoName, id, type, success, complete, error);
		}

		public function loadParentTopoData(topoName:String, id:String, type:String, success:Function, complete:Function = null, error:Function = null):void
		{
			log.debug("[{0}] 加载父层拓扑 id={1} type={2}", name, id, type);
			_dataSource.loadParentTopoData(topoName, id, success, complete, error);
		}

		public function loadViewModelTopoData(topoName:String, modelId:String, modelParams:String, success:Function, complete:Function = null, error:Function = null):void
		{
			log.debug("[{0}] 根据视图模板加载拓扑 modelId={1} modelParams={2}", name, modelId, modelParams);
			_dataSource.loadViewModelTopoData(topoName, modelId, modelParams, success, complete, error);
		}

		public function modifyPosition(complete:Function, success:Function = null, error:Function = null):void
		{
			log.debug("[{0}] 通知坐标移动", name);
			// 位置参数
			var position:Array = [];
			topoCanvas.eachChanged(function(id:String, element:IElement):void
				{
					if (element is ITPPoint)
					{
						var point:ITPPoint = element as ITPPoint;
						position.push(point.id + "," + int(Math.round(point.x)) + "," + int(Math.round(point.y)));
						point.changed = false;
					}
					else if (element is ITPLine)
					{
						var line:ITPLine = element as ITPLine;
						position.push(line.id + "," + int(Math.round(line.x)) + "," + int(Math.round(line.y)));
						line.changed = false;
					}
				});

			if (position.length == 0)
			{
				log.debug("没有对象移动,不需要网元移位.");
				if (complete != null)
				{
					complete.call();
				}
				return;
			}
			_dataSource.modifyPosition(topoCanvas.topoName, topoCanvas.topoId, position.join(";"), success, complete, error);
		}

		public function modifyLayer(topoName:String, pid:String, point:Point, idArr:String, success:Function = null, complete:Function = null, error:Function = null):void
		{
			_dataSource.modifyLayer(topoName, pid, point, idArr, success, complete, error);
		}

		public function saveTopo(topoName:String, success:Function = null, complete:Function = null, error:Function = null):void
		{
			log.debug("[{0}] 保存拓扑 {1}", name, topoName);
			_dataSource.saveTopo(topoName, function(result:Object):void
				{

					if (success != null)
					{
						if (result.toString() == "1")
						{
							success.call(null, true);
						}
						else
						{
							success.call(null, false);
						}
					}
				}, complete, function():void
				{
					MessageUtil.showMessage("保存拓扑失败!(通信故障)");
					if (error != null)
					{
						error.call();
					}
				});
		}

		public function loadAlarms(params:Object,success:Function, complete:Function = null, error:Function = null):void
		{
			_dataSource.loadAlarms(params, success, complete, error);
		}

		public function notify(topoName:String, data:String, success:Function, complete:Function = null, error:Function = null):void
		{
			_dataSource.notify(topoName, data, success, complete, error);
		}
	}
}