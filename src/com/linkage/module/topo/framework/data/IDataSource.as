package com.linkage.module.topo.framework.data
{
	import flash.geom.Point;

	/**
	 * 与WEB交互的数据源支撑
	 * @author duangr
	 *
	 */
	public interface IDataSource
	{
		/**
		 * 获取拓扑图的菜单
		 * @param success  成功后回调函数,参数为 xml:XML <br/> 格式为: functin(data:XML):void{ ... }
		 * @param complete 不管成功还是失败,都要回调的函数,无参数<br/> 格式为: functin():void{ ... }
		 * @param error 失败后回调函数<br/> 格式为: functin():void{ ... }
		 *
		 */
		function loadTopoMenus(success:Function, complete:Function = null, error:Function = null):void;

		/**
		 * 获取创建视图时拓扑图的菜单
		 * @param success  成功后回调函数,参数为 xml:XML <br/> 格式为: functin(data:XML):void{ ... }
		 * @param complete 不管成功还是失败,都要回调的函数,无参数<br/> 格式为: functin():void{ ... }
		 * @param error 失败后回调函数<br/> 格式为: functin():void{ ... }
		 *
		 */
		function loadCreateViewMenus(success:Function, complete:Function = null, error:Function = null):void;

		/**
		 * 加载拓扑图数据
		 * @param topoName 拓扑数据源的名称
		 * @param id 拓扑id
		 * @param type segment|wiew
		 * @param success 成功后回调函数,参数为 xml:XML <br/> 格式为: functin(data:XML):void{ ... }
		 * @param complete 不管成功还是失败,都要回调的函数,无参数<br/> 格式为: functin():void{ ... }
		 * @param error 失败后回调函数,无参数<br/> 格式为: functin():void{ ... }
		 *
		 */
		function loadTopoData(topoName:String, id:String, type:String, success:Function, complete:Function = null, error:Function = null):void;

		/**
		 * 根据TopoSql加载拓扑数据
		 * @param topoName 拓扑数据源的名称
		 * @param boxnames  查询容器的名称,批量时使用','分隔<br/>
		 *            ObjectTDataBox LinkTDataBox SegmentTDataBox NodeTDataBox GroupTDataBox<br/>
		 * @param topoSql 拓扑SQL,如:<br/>  from_id exist [1/123,1/234,1/236] AND to_id exist [1/123,1/234,1/235,1/236] AND visible=1 AND area_id=1
		 * @param success 成功后回调函数,参数为 xml:XML <br/> 格式为: functin(data:XML):void{ ... }
		 * @param complete 不管成功还是失败,都要回调的函数,无参数<br/> 格式为: functin():void{ ... }
		 * @param error 失败后回调函数,无参数<br/> 格式为: functin():void{ ... }
		 *
		 */
		function loadTopoDataBySql(topoName:String, boxnames:String, topoSql:String, success:Function, complete:Function = null, error:Function = null):void;

		/**
		 * 获取父层次拓扑图数据
		 * @param topoName 拓扑数据源的名称
		 * @param pid 父对象id
		 * @param success  成功后回调函数,参数为 xml:XML<br/> 格式为: functin(data:XML):void{ ... }
		 * @param complete 不管成功还是失败,都要回调的函数,无参数 <br/> 格式为: functin():void{ ... }
		 * @param error 失败后回调函数,无参数<br/> 格式为: functin():void{ ... }
		 *
		 */
		function loadParentTopoData(topoName:String, pid:String, success:Function, complete:Function = null, error:Function = null):void;

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
		 * 获取拓扑树的数据
		 * @param topoName 拓扑数据源的名称
		 * @param id 网段id
		 * @param level 向下获取的树的层级
		 * @param topoSql 拓扑sql,如:<br/>
		 *            <li>visible=0 : 仅显示隐藏</li><br/>
		 *            <li>visible=1 : 仅显示可见</li><br/>
		 *            <li>空字符串: 显示全部</li>
		 * @param success 成功后回调函数,参数为 xml:XML<br/> 格式为: functin(data:XML):void{ ... }
		 * @param complete 不管成功还是失败,都要回调的函数,无参数 <br/> 格式为: functin():void{ ... }
		 * @param error 失败后回调函数,无参数<br/> 格式为: functin():void{ ... }
		 *
		 */
		function loadTopoTree(topoName:String, id:String, level:int, topoSql:String, success:Function, complete:Function = null, error:Function = null):void;

		/**
		 * 刷新告警
		 * @param topoName 拓扑数据源的名称
		 * @param type 告警类型(0:全部告警, 1:设备告警 2:性能告警)
		 * @param objIdArr 待刷新告警对象的id(多个的话使用逗号分隔)
		 * @param linkIdArr 待刷新告警对象的id(多个的话使用逗号分隔)
		 * @param success  成功后回调函数,参数为 alarms:Object <br/> 格式为: functin(alarms:Object):void{ ... }
		 * @param complete 不管成功还是失败,都要回调的函数,无参数<br/> 格式为: functin():void{ ... }
		 * @param error 失败后回调函数<br/> 格式为: functin():void{ ... }
		 *
		 */
//		function loadAlarms(topoName:String, type:String, objIdArr:String, linkIdArr:String, extInfo:String, success:Function, complete:Function = null, error:Function = null):void;
		function loadAlarms(params:Object, success:Function, complete:Function = null, error:Function = null):void;

		/**
		 * 网元移位
		 * @param topoName 拓扑数据源的名称
		 * @param pid 父对象id
		 * @param position 发生变化元素的坐标(格式为: id,x,y;id,x,y;...)
		 * @param success  成功后回调函数,无参数<br/> 格式为: functin():void{ ... }
		 * @param complete 不管成功还是失败,都要回调的函数,无参数<br/> 格式为: functin():void{ ... }
		 * @param error 失败后回调函数<br/> 格式为: functin():void{ ... }
		 *
		 */
		function modifyPosition(topoName:String, pid:String, position:String, success:Function = null, complete:Function = null, error:Function = null):void;

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
		 * 保存拓扑图
		 * @param topoName 拓扑数据源的名称
		 * @param success  成功后回调函数,参数为 result:Object<br/> 格式为: functin(result:Object):void{ ... }
		 * @param complete 不管成功还是失败,都要回调的函数,无参数<br/> 格式为: functin():void{ ... }
		 * @param error 失败后回调函数<br/> 格式为: functin():void{ ... }
		 *
		 */
		function saveTopo(topoName:String, success:Function, complete:Function = null, error:Function = null):void;

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

		/**
		 * 查询拓扑用到的图标<br/>
		 * 返回XML格式为
		 *
		 * <pre>
		 * 	&lt;icons&gt;&lt;icon k='MSC' v='MSC.png' /&gt;&lt;/icons&gt;
		 * </pre>
		 *
		 * @param success  成功后回调函数,参数为 xml:XML <br/> 格式为: functin(data:XML):void{ ... }
		 * @param complete 不管成功还是失败,都要回调的函数,无参数<br/> 格式为: functin():void{ ... }
		 * @param error 失败后回调函数<br/> 格式为: functin():void{ ... }
		 *
		 */
		function queryTopoIcons(success:Function, complete:Function = null, error:Function = null):void;

		/**
		 * 根据regex查询所有可用的toponame<br/>
		 * 返回XML格式为
		 *
		 * <pre>
		 * 	&lt;toponames&gt&lt;toponame v='toponame' /&gt;&lt;/toponames&gt;
		 * </pre>
		 *
		 * @param regex 过滤toponame的正则表达式
		 * @param success 成功后回调函数,参数为 xml:XML <br/> 格式为: functin(data:XML):void{ ... }
		 * @param complete 管成功还是失败,都要回调的函数,无参数<br/> 格式为: functin():void{ ... }
		 * @param error 失败后回调函数<br/> 格式为: functin():void{ ... }
		 *
		 */
		function findAvailableTopoName(regex:String, success:Function, complete:Function = null, error:Function = null):void;

		/**
		 * 列出工程相对路径下面的png图片文件的名称
		 *
		 * @param path 相对工程的路径, 比如 /cms/webtopo/images/theme/fillimage
		 * @param success 成功后回调函数,参数为 xml:XML <br/> 格式为: functin(data:XML):void{ ... }
		 * @param complete 管成功还是失败,都要回调的函数,无参数<br/> 格式为: functin():void{ ... }
		 * @param error 失败后回调函数<br/> 格式为: functin():void{ ... }
		 *
		 */
		function listPicNames(path:String, success:Function, complete:Function = null, error:Function = null):void;
		
		/**
		 * 列出拓扑的图例信息
		 *
		 * @param param map-->pid=**,拓扑id
		 * @param success 成功后回调函数,参数为 xml:XML <br/> 格式为: functin(data:XML):void{ ... }
		 * @param complete 管成功还是失败,都要回调的函数,无参数<br/> 格式为: functin():void{ ... }
		 * @param error 失败后回调函数<br/> 格式为: functin():void{ ... }
		 *
		 */
		function doloadTopoLinkDesc(param:Object, success:Function, complete:Function = null, error:Function = null):void;
	}
}