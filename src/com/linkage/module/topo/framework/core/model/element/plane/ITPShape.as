package com.linkage.module.topo.framework.core.model.element.plane
{


	/**
	 * 形状对象接口
	 * @author duangr
	 *
	 */
	public interface ITPShape extends ITPPlane
	{

		/**
		 * 形状类型
		 */
		function get shapeType():String;
		function set shapeType(value:String):void;

		/**
		 * 平行四边形的倾斜角度
		 */
		function get parallelogramAngle():Number;
		function set parallelogramAngle(value:Number):void;

		/**
		 * 填充类型
		 */
		function get fillType():String;
		function set fillType(value:String):void;

		/**
		 * 第一种填充色
		 */
		function get fillColorStart():uint;
		function set fillColorStart(value:uint):void;

		/**
		 * 第二种填充色
		 */
		function get fillColorEnd():uint;
		function set fillColorEnd(value:uint):void;

		/**
		 * 填充图片
		 */
		function get fillImage():String;
		function set fillImage(value:String):void;

		/**
		 * 填充透明度
		 */
		function get fillAlpha():Number;
		function set fillAlpha(value:Number):void;

		/**
		 * 边框颜色
		 */
		function get borderColor():uint;
		function set borderColor(value:uint):void;

		/**
		 * 边框厚度
		 */
		function get borderWidth():Number;
		function set borderWidth(value:Number):void;

		/**
		 * 边框透明度
		 */
		function get borderAlpha():Number;
		function set borderAlpha(value:Number):void;

		/**
		 * 是否启用阴影效果
		 */
		function get shadowEnable():Number;
		function set shadowEnable(value:Number):void;

	}
}