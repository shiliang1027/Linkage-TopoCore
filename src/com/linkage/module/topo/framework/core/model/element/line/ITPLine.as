package com.linkage.module.topo.framework.core.model.element.line
{
	import flash.geom.Point;

	/**
	 * 拓扑多拐点折线接口
	 * @author duangr
	 *
	 */
	public interface ITPLine extends ILine
	{
		/**
		 * 线自身的X坐标
		 */
		function get x():Number;
		function set x(x:Number):void;

		/**
		 * 线自身的Y坐标
		 */
		function get y():Number;
		function set y(y:Number):void;

		/**
		 * 线的宽度(此字段没有入库,是从全部点中解析出来)
		 */
		function get width():int;
		function set width(value:int):void;

		/**
		 * 线的高度(此字段没有入库,是从全部点中解析出来)
		 */
		function get height():int;
		function set height(value:int):void;

		/**
		 * 线的开始点相对自身偏移的坐标
		 */
		function get fromPoint():Point;
		function set fromPoint(from:Point):void;

		/**
		 * 线的结束点相对自身偏移的坐标
		 */
		function get toPoint():Point;
		function set toPoint(to:Point):void;

		/**
		 * 线的拐角点相对自身偏移的坐标数组
		 */
		function get flexPoints():Array;
		function set flexPoints(value:Array):void;

	}
}