package com.linkage.module.topo.framework.core.model.element.point
{
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.model.element.line.ILink;
	import com.linkage.module.topo.framework.core.model.element.plane.ITPGroup;

	/**
	 * 点接口
	 * @author duangr
	 *
	 */
	public interface ITPPoint extends IElement
	{
		/**
		 * 元素的X坐标
		 */
		function get x():Number;
		function set x(x:Number):void;

		/**
		 * 元素的Y坐标
		 */
		function get y():Number;
		function set y(y:Number):void;

		/**
		 * 对象所属的分组
		 */
		function set groupOwner(value:ITPGroup):void;
		function get groupOwner():ITPGroup;

		/**
		 * 全部以此节点作为起点的链路对象
		 */
		function get outLines():Array;

		/**
		 * 全部的以此节点作为终点的链路对象
		 */
		function get inLines():Array;

		/**
		 * 遍历每一条链路
		 * @param callback 回调方法,格式为: function callback(link:ILink):void{...}
		 *
		 */
		function eachLinks(callback:Function):void;

		/**
		 * 添加一个以此节点作为起点的链路对象关系
		 * @param line
		 *
		 */
		function addOutLine(line:ILink):void;
		/**
		 * 添加一个以此节点作为终点的链路对象关系
		 * @param line
		 *
		 */
		function addInLine(line:ILink):void;
		/**
		 *删除一个以此节点作为起点的链路对象关系
		 * @param line
		 *
		 */
		function removeOutLine(line:ILink):void;
		/**
		 * 删除一个以此节点作为终点的链路对象关系
		 * @param line
		 *
		 */
		function removeInLine(line:ILink):void;
	}
}