package com.linkage.module.topo.framework.core.model.element.plane.cell
{
	import flash.geom.Point;

	/**
	 * Grid中的Cell对象
	 *
	 * @author duangr
	 *
	 */
	public interface ITPCell
	{
		/**
		 * 宽度
		 */
		function get width():Number;
		function set width(value:Number):void;

		/**
		 * 高度
		 */
		function get height():Number;
		function set height(value:Number):void;

		/**
		 * 中心点坐标(是存储的坐标点)
		 */
		function get centerPoint():Point;
		function set centerPoint(value:Point):void;

		/**
		 * 行序号
		 */
		function get rowSerial():String;
		function set rowSerial(value:String):void;

		/**
		 * 列序号
		 */
		function get columnSerial():String;
		function set columnSerial(value:String):void;

	}
}