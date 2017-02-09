package com.linkage.module.topo.framework.core.model.element.point
{

	/**
	 * 文本对象接口
	 * @author duangr
	 *
	 */
	public interface ITPText extends ITPObject
	{
		/**
		 * 文本内容
		 */
		function set text(value:String):void;
		function get text():String;

		/**
		 * 文本颜色
		 */
		function set textColor(value:uint):void;
		function get textColor():uint;

		/**
		 * 文本字体大小
		 */
		function set textSize(value:int):void;
		function get textSize():int;
	}
}