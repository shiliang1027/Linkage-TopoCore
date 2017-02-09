package com.linkage.module.topo.framework.controller.action
{
	import com.linkage.module.topo.framework.core.Feature;

	import flash.events.MouseEvent;

	public interface IAction
	{
		/**
		 * Action的名称
		 */
		function get name():String;

		/**
		 * Action的Key
		 */
		function get key():String;
		function set key(value:String):void;
		
		/**
		 * 权重值
		 */
		function set weight(value:uint):void;
		function get weight():uint;

		/**
		 * 模式下光标类
		 */
		function set cursor(value:Class):void;

		/**
		 * 给画布添加监听方法
		 */
		function addCanvasListeners():void;

		/**
		 * 移除画布的监听方法
		 */
		function removeCanvasListeners():void;

		/**
		 * 鼠标点击事件
		 * @param event
		 *
		 */
		function onClick(event:MouseEvent):void;

		/**
		 * 鼠标双击事件
		 * @param event
		 *
		 */
		function onDblClick(event:MouseEvent):void;

		/**
		 * 鼠标左键按下事件
		 * @param event
		 *
		 */
		function onMouseDown(event:MouseEvent):void;

		/**
		 * 鼠标左键抬起事件
		 * @param event
		 *
		 */
		function onMouseUp(event:MouseEvent):void;

		/**
		 * 鼠标移动事件
		 * @param event
		 *
		 */
		function onMouseMove(event:MouseEvent):void;

		/**
		 * 鼠标右键单击事件
		 * @param event
		 *
		 */
		function onRightClick(event:MouseEvent):void;

		/**
		 * 捕获鼠标右键事件
		 * @param feature
		 *
		 */
		function handlerRightClick(feature:Feature):void;

		/**
		 * 鼠标移动到某显示对象上面事件
		 * @param event
		 *
		 */
		function onMouseOver(event:MouseEvent):void;

		/**
		 * 鼠标移出某显示对象事件
		 * @param event
		 *
		 */
		function onMouseOut(event:MouseEvent):void;

		/**
		 * 鼠标滚轮滚动到某显示对象上面事件
		 * @param event
		 *
		 */
		function onMouseWheel(event:MouseEvent):void;
	}
}