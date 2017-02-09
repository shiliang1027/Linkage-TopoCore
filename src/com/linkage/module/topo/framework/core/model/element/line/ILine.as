package com.linkage.module.topo.framework.core.model.element.line
{
	import com.linkage.module.topo.framework.core.model.element.IElement;

	/**
	 * 线 接口
	 * @author duangr
	 *
	 */
	public interface ILine extends IElement
	{
		/**
		 * 线的提示信息
		 */
		function get lineToolTip():String;
		function set lineToolTip(value:String):void;

		/**
		 * 线的颜色
		 */
		function get lineColor():uint;
		function set lineColor(value:uint):void;

		/**
		 * 线的粗细
		 */
		function get lineWidth():Number;
		function set lineWidth(value:Number):void;

		/**
		 * 线的透明度
		 */
		function get lineAlpha():Number;
		function set lineAlpha(value:Number):void;

		/**
		 * 线的符号(实线,虚线)
		 */
		function get lineSymbol():String;
		function set lineSymbol(value:String):void;

		/**
		 * 线的类型(直线/贝塞尔曲线)
		 */
		function get lineType():String;
		function set lineType(value:String):void;

		

	}
}