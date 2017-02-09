package com.linkage.module.topo.framework.core.style.element.plane.shapemarket
{
	import com.linkage.module.topo.framework.core.Feature;
	import com.linkage.module.topo.framework.core.model.element.plane.ITPShape;
	import com.linkage.module.topo.framework.core.style.element.IStyle;

	import flash.display.Graphics;

	import mx.core.UIComponent;

	/**
	 * 形状样式接口
	 * @author duangr
	 *
	 */
	public interface IShapeStyle
	{
		/**
		 * 画形状
		 * @param g
		 * @param feature
		 * @param shape
		 *
		 */
		function drawShape(g:Graphics, feature:Feature, shape:ITPShape):void;

		/**
		 * 旋转UI对象成为指定的形状
		 * @param ui
		 * @param shape
		 *
		 */
		function rotateShape(ui:UIComponent, shape:ITPShape):void;
	}
}