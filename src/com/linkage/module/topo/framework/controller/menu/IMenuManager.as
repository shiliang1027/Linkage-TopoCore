package com.linkage.module.topo.framework.controller.menu
{


	import com.linkage.module.topo.framework.core.Feature;

	import flash.display.InteractiveObject;

	/**
	 * 菜单管理器接口
	 * @author duangr
	 *
	 */
	public interface IMenuManager
	{
		/**
		 * 初始化菜单管理器
		 * @param menuXML
		 * @param urlContext
		 *
		 */
		function initialize(menuXML:XML, urlContext:String):void;

		/**
		 * 菜单所有者
		 * @param menuOwner
		 *
		 */
		function set menuOwner(menuOwner:InteractiveObject):void;

		/**
		 * 触发双击事件
		 * @param feature
		 *
		 */
		function onDoubleClick(feature:Feature):void;

		/**
		 * 清理数据
		 */
		function clear():void;

		/**
		 * 程序的版本(非框架的版本)
		 * @param value
		 *
		 */
		function set version(value:String):void;
	}
}