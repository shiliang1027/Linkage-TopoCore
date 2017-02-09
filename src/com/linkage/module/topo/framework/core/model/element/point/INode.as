package com.linkage.module.topo.framework.core.model.element.point
{

	/**
	 * 节点对象接口
	 * @author duangr
	 *
	 */
	public interface INode extends ITPPoint
	{
		/**
		 * 图标名称
		 */
		function get icon():String;
		function set icon(value:String):void;

		/**
		 * 图标的宽度
		 */
		function get iconWidth():Number;
		function set iconWidth(value:Number):void;

		/**
		 * 图标的高度
		 */
		function get iconHeight():Number;
		function set iconHeight(value:Number):void;
	}
}