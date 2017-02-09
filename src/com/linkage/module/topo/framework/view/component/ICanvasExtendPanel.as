package com.linkage.module.topo.framework.view.component
{
	import flash.display.DisplayObject;


	/**
	 * 画布的扩展面板容器接口
	 * @author duangr
	 *
	 */
	public interface ICanvasExtendPanel
	{

		/**
		 * 画布
		 */
		function set topoCanvas(value:TopoCanvas):void;

		/**
		 * 参考显示的父对象(不一定是此面板真正的parent)
		 *
		 */
		function set panelParent(value:DisplayObject):void;

		/**
		 * 在设置上面两个set方法后,初始化时执行(提供给子类重写)
		 *
		 */
		function initPanel():void;

		/**
		 * 布局初始化时 从组件的上边缘到锚点目标的上边缘的垂直距离
		 * @param value
		 *
		 */
		function set iTop(value:Number):void;

		/**
		 * 布局初始化时 从组件的下边缘到锚点目标的下边缘的垂直距离
		 * @param value
		 *
		 */
		function set iBottom(value:Number):void;

		/**
		 * 布局初始化时 从组件的左边缘到锚点目标的左边缘的水平距离
		 * @param value
		 *
		 */
		function set iLeft(value:Number):void;

		/**
		 * 布局初始化时 从组件的右边缘到锚点目标的右边缘的水平距离
		 * @param value
		 *
		 */
		function set iRight(value:Number):void;
	}
}