package com.linkage.module.topo.framework.core.model.element.plane
{
	import com.linkage.module.topo.framework.view.component.TopoLayer;

	import mx.core.UIComponent;

	import spark.components.BorderContainer;
	import spark.components.Group;

	/**
	 * 立体层次
	 * @author duangr
	 *
	 */
	public interface IHLinkLayer extends ITPShape
	{
		/**
		 * 链接到的拓扑id
		 */
		function set linkId(value:String):void;
		function get linkId():String;

		/**
		 * 链接到的拓扑名称
		 */
		function set linkName(value:String):void;
		function get linkName():String;

		/**
		 * 链接到的拓扑数据源名称
		 */
		function set linkTopoName(value:String):void;
		function get linkTopoName():String;

		/**
		 * 链接到的拓扑类型
		 */
		function set linkTopoType(value:String):void;
		function get linkTopoType():String;

		/**
		 * 链接到的拓扑打开方式
		 */
		function set openType(value:String):void;
		function get openType():String;

		/**
		 * 获取数据的拓扑id
		 */
		function set sourceId(value:String):void;
		function get sourceId():String;

		/**
		 * 获取数据的拓扑名称
		 */
		function set sourceName(value:String):void;
		function get sourceName():String;

		/**
		 * 获取数据的拓扑数据源名称
		 */
		function set sourceTopoName(value:String):void;
		function get sourceTopoName():String;

		/**
		 * 获取数据的拓扑类型
		 */
		function set sourceTopoType(value:String):void;
		function get sourceTopoType():String;

		/**
		 * 获取数据的参数
		 */
		function set sourceTopoParam(value:String):void;
		function get sourceTopoParam():String;

		/**
		 * 拓扑层次绘制对象
		 */
		function set topoLayer(value:TopoLayer):void;
		function get topoLayer():TopoLayer;

		/**
		 * 拓扑层次是否初始化完成的标志
		 */
		function set topoLayerCreationComplete(value:Boolean):void;
		function get topoLayerCreationComplete():Boolean;

		/**
		 * 拓扑层次的容器对象
		 */
		function set topoLayerContainer(value:Group):void;
		function get topoLayerContainer():Group;
	}
}