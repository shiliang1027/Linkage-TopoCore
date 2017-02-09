package com.linkage.module.topo.framework.core.model.element.plane
{
	import com.linkage.module.topo.framework.core.model.element.point.ITPPoint;

	/**
	 * 分组对象接口
	 * @author duangr
	 *
	 */
	public interface ITPGroup extends ITPShape
	{
		/**
		 * 默认是否展开
		 */
		function get expanded():Boolean;
		function set expanded(value:Boolean):void;

		/**
		 * 关闭时图标
		 */
		function get closedIcon():String;
		function set closedIcon(value:String):void;

		/**
		 * 默认状态展开闭合状态 (close|open)
		 */
		function get defaultStatus():String;
		function set defaultStatus(value:String):void;

		/**
		 * 添加子元素
		 * @param id
		 * @param element
		 *
		 */
		function addChild(id:String, element:ITPPoint):void;

		/**
		 * 从分组中移除子元素
		 * @param id
		 *
		 */
		function removeChild(id:String):void;

		/**
		 * 遍历每一个内部对象
		 * @param callback 回调函数,格式为: function callback(id:String, element:ITPPoint):void{ ... }
		 *
		 */
		function eachChild(callback:Function):void;

		/**
		 * 遍历每一个缓存的内部对象id(此时这些内部对象还没有初始化)
		 * @param callback 回调函数,格式为: function callback(id:String):void{ ... }
		 *
		 */
		function eachCacheChildId(callback:Function):void;

		/**
		 * 判断子孙是否在分组的范围内
		 * @param element
		 * @return
		 *
		 */
		function isChildInGroupBounds(element:ITPPoint):Boolean;

		/**
		 * 分组和分组中网元的对端网元直接的临时性链路
		 * @param value
		 *
		 */
		function set oppoLinks(value:Array):void;
		function get oppoLinks():Array;
	}
}