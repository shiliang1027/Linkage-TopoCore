package com.linkage.module.topo.framework.core.model.element.plane
{

	/**
	 * 拓扑内部链接对象
	 * @author duangr
	 *
	 */
	public interface IHLinkTopo extends ITPShape
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
		 * 展现形式
		 */
		function set showType(value:String):void;
		function get showType():String;
	}
}