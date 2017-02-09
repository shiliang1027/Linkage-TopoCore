package com.linkage.module.topo.framework.service.core
{
	import com.linkage.module.topo.framework.service.IService;
	
	import flash.geom.Point;

	/**
	 * 数据业务的接口
	 * @author duangr
	 *
	 */
	public interface IDataService extends IService
	{
		/**
		 * 加载默认的拓扑数据
		 * @param success  成功后回调函数,参数为 data:XML <br/> 格式为: functin(data:XML):void{ ... }
		 * @param complete 不管成功还是失败,都要回调的函数,无参数<br/> 格式为: functin():void{ ... }
		 * @param error 失败后回调函数,无参数<br/> 格式为: functin():void{ ... }
		 *
		 */
		function loadDefaultTopoData(success:Function, complete:Function = null, error:Function = null):void;

		/**
		 * 加载id下对应拓扑数据
		 * @param topoName 拓扑数据源的名称
		 * @param id
		 * @param type
		 * @param success  成功后回调函数,参数为 data:XML <br/> 格式为: functin(data:XML):void{ ... }
		 * @param complete 不管成功还是失败,都要回调的函数,无参数<br/> 格式为: functin():void{ ... }
		 * @param error 失败后回调函数,无参数<br/> 格式为: functin():void{ ... }
		 *
		 */
		function loadTopoData(topoName:String,id:String, type:String, success:Function, complete:Function = null, error:Function = null):void;

		/**
		 * 加载id的父层次的拓扑数据
		 * @param topoName 拓扑数据源的名称
		 * @param id
		 * @param type
		 * @param success  成功后回调函数,参数为 data:XML <br/> 格式为: functin(data:XML):void{ ... }
		 * @param complete 不管成功还是失败,都要回调的函数,无参数<br/> 格式为: functin():void{ ... }
		 * @param error 失败后回调函数,无参数<br/> 格式为: functin():void{ ... }
		 *
		 */
		function loadParentTopoData(topoName:String, id:String, type:String, success:Function, complete:Function = null, error:Function = null):void;

		/**
		 * 根据视图模板获取拓扑数据
		 * @param topoName 拓扑数据源的名称
		 * @param modelId 模板id
		 * @param modelParams 模板参数
		 * @param success  成功后回调函数,参数为 xml:XML<br/> 格式为: functin(data:XML):void{ ... }
		 * @param complete 不管成功还是失败,都要回调的函数,无参数 <br/> 格式为: functin():void{ ... }
		 * @param error 失败后回调函数,无参数<br/> 格式为: functin():void{ ... }
		 *
		 */
		function loadViewModelTopoData(topoName:String, modelId:String, modelParams:String, success:Function, complete:Function = null, error:Function = null):void;

		/**
		 * 坐标变更后保存
		 * @param complete 不管成功还是失败,都要回调的函数,无参数<br/> 格式为: functin():void{ ... }
		 * @param success 成功后回调函数,无参数<br/> 格式为: functin():void{ ... }
		 * @param error 失败后回调函数,无参数<br/> 格式为: functin():void{ ... }
		 *
		 */
		function modifyPosition(complete:Function, success:Function = null, error:Function = null):void;

		/**
		 * 粘帖移位
		 * @param topoName 拓扑数据源的名称
		 * @param pid 粘帖处父对象id
		 * @param point 粘帖处坐标
		 * @param idArr 发生变化元素的id(格式为: id,id,id,...)
		 * @param success  成功后回调函数,无参数<br/> 格式为: functin():void{ ... }
		 * @param complete 不管成功还是失败,都要回调的函数,无参数<br/> 格式为: functin():void{ ... }
		 * @param error 失败后回调函数<br/> 格式为: functin():void{ ... }
		 *
		 */
		function modifyLayer(topoName:String, pid:String, point:Point, idArr:String, success:Function = null, complete:Function = null, error:Function = null):void;

		/**
		 * 保存拓扑
		 * @param topoName 拓扑数据源的名称
		 * @param success  成功后回调函数,含操作结果的参数<br/> 格式为: functin(flag:Boolean):void{ ... }
		 * @param complete 不管成功还是失败,都要回调的函数,无参数<br/> 格式为: functin():void{ ... }
		 * @param error 失败后回调函数<br/> 格式为: functin():void{ ... }
		 *
		 */
		function saveTopo(topoName:String, success:Function = null, complete:Function = null, error:Function = null):void;

		/**
		 * 刷新告警
		 * @param topoName 拓扑数据源的名称
		 * @param type 网段或者视图的id//告警类型(0:全部告警,  1:设备告警 2:性能告警)
		 * @param objIdArr 待刷新告警对象的id(多个的话使用逗号分隔)
		 * @param linkIdArr 待刷新告警对象的id(多个的话使用逗号分隔)
		 * @param success  成功后回调函数,参数为 alarms:Object <br/> 格式为: functin(alarms:Object):void{ ... }
		 * @param complete 不管成功还是失败,都要回调的函数,无参数<br/> 格式为: functin():void{ ... }
		 * @param error 失败后回调函数<br/> 格式为: functin():void{ ... }
		 *
		 */
		function loadAlarms(params:Object, success:Function, complete:Function = null, error:Function = null):void;

		/**
		 * 通知后台事件
		 * @param topoName 拓扑数据源的名称
		 * @param data 包含主题的数据
		 * @param success  成功后回调函数,参数为 result:String<br/> 格式为: functin(result:String):void{ ... }
		 * @param complete 不管成功还是失败,都要回调的函数,无参数<br/> 格式为: functin():void{ ... }
		 * @param error 失败后回调函数<br/> 格式为: functin():void{ ... }
		 *
		 */
		function notify(topoName:String, data:String, success:Function, complete:Function = null, error:Function = null):void;
	}
}