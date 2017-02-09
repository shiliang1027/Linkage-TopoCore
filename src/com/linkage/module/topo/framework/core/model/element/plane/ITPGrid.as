package com.linkage.module.topo.framework.core.model.element.plane
{
	import com.linkage.module.topo.framework.core.model.element.plane.cell.ITPCell;

	/**
	 * 网格对象的接口
	 * @author duangr
	 *
	 */
	public interface ITPGrid extends ITPPlane
	{

		/**
		 * Grid边框颜色
		 */
		function get borderColor():uint;
		function set borderColor(value:uint):void;

		/**
		 * Grid边框厚度
		 */
		function get borderWidth():Number;
		function set borderWidth(value:Number):void;

		/**
		 * Grid边框的符号(实线,虚线)
		 */
		function get borderSymbol():String;
		function set borderSymbol(value:String):void;

		/**
		 * Grid边框透明度
		 */
		function get borderAlpha():Number;
		function set borderAlpha(value:Number):void;

		/**
		 * CELL第一种填充色
		 */
		function get cellFillColorStart():uint;
		function set cellFillColorStart(value:uint):void;

		/**
		 * CELL第二种填充色
		 */
		function get cellFillColorEnd():uint;
		function set cellFillColorEnd(value:uint):void;

		/**
		 * CELL填充透明度
		 */
		function get cellFillAlpha():Number;
		function set cellFillAlpha(value:Number):void;

		/**
		 * 行的数量
		 */
		function get rowCount():uint;
		function set rowCount(value:uint):void;

		/**
		 * 每行的占比,数组各元素之和为1
		 */
		function get rowPercents():Array;
		function set rowPercents(value:Array):void;

		/**
		 * 每行对应的序号数组
		 */
		function get rowSerial():Array;
		function set rowSerial(value:Array):void;

		/**
		 * 行Label的布局
		 */
		function get rowLabelLayout():String;
		function set rowLabelLayout(value:String):void;

		/**
		 * 行Label的显示范围的宽度
		 */
		function get rowLabelRectWidth():Number;
		function set rowLabelRectWidth(value:Number):void;

		/**
		 * 行Label的填充颜色
		 */
		function get rowLabelFillColor():uint;
		function set rowLabelFillColor(value:uint):void;

		/**
		 * 行Label的填充透明度
		 */
		function get rowLabelFillAlpha():Number;
		function set rowLabelFillAlpha(value:Number):void;

		/**
		 * 行Label的边框透明度
		 */
		function get rowLabelBorderAlpha():Number;
		function set rowLabelBorderAlpha(value:Number):void;

		/**
		 * 列的数量
		 */
		function get columnCount():uint;
		function set columnCount(value:uint):void;

		/**
		 * 每列的占比,数组各元素之和为1
		 */
		function get columnPercents():Array;
		function set columnPercents(value:Array):void;

		/**
		 * 每列对应的序号数组
		 */
		function get columnSerial():Array;
		function set columnSerial(value:Array):void;

		/**
		 * 列Label的布局
		 */
		function get columnLabelLayout():String;
		function set columnLabelLayout(value:String):void;

		/**
		 * 列Label的显示范围的高度
		 */
		function get columnLabelRectHeight():Number;
		function set columnLabelRectHeight(value:Number):void;

		/**
		 * 列Label的填充颜色
		 */
		function get columnLabelFillColor():uint;
		function set columnLabelFillColor(value:uint):void;

		/**
		 * 列Label的填充透明度
		 */
		function get columnLabelFillAlpha():Number;
		function set columnLabelFillAlpha(value:Number):void;

		/**
		 * 列Label的边框透明度
		 */
		function get columnLabelBorderAlpha():Number;
		function set columnLabelBorderAlpha(value:Number):void;

		/**
		 * Label的拼装格式
		 */
		function get labelSpell():String;
		function set labelSpell(value:String):void;

		/**
		 * 往Grid中添加Cell对象(这个过程是渲染时触发)
		 *
		 * @param cell
		 *
		 */
		function appendCell(cell:ITPCell):void;
		/**
		 * 清空已有的cell列表(这个过程是渲染时触发)
		 *
		 */
		function clearCells():void;

		/**
		 * 变量每一个Cell对象
		 *
		 * @param callback 回调方法,入参为: cell:ITPCell. 如: function(cell:ITPCell):void{ ... }
		 *
		 */
		function eachCell(callback:Function):void;
		/**
		 * cell对象的数量
		 */
		function get cellNum():int;

	}
}