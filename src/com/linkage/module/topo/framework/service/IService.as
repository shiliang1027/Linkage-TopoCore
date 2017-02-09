package com.linkage.module.topo.framework.service
{
	import com.linkage.module.topo.framework.view.TopoPanelContainer;

	/**
	 * 拓扑图中业务逻辑的接口
	 * @author duangr
	 *
	 */
	public interface IService
	{
		/**
		 * 业务类的名称(作为标识,日志分析时使用)
		 */
		function get name():String;

		/**
		 * url上下文(工程名)
		 */
		function set urlContext(value:String):void;
		function get urlContext():String;

		/**
		 * 所需要的参数
		 */
		function set attributes(attr:Object):void;

		/**
		 * 通知逻辑类开始运行
		 */
		function start():void;

		/**
		 * 拓扑面板容器
		 *
		 */
		function set panelContainer(panelContainer:TopoPanelContainer):void;

		/**
		 *暂停
		 *
		 */
		function pause():void;

		/**
		 *恢复
		 *
		 */
		function restore():void;
	}
}