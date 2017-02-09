package com.linkage.module.topo.framework.core.model.element.plane
{

	/**
	 * 超链接URL对象接口
	 * @author duangr
	 *
	 */
	public interface IHLinkUrl extends ITPShape
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

		/**
		 * 超链接的url
		 */
		function set url(value:String):void;
		function get url():String;

		/**
		 * 展现形式
		 */
		function set showType(value:String):void;
		function get showType():String;
	}
}