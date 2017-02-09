package com.linkage.module.topo.framework.core.style.element.plane.shapemarket
{
	import com.linkage.module.topo.framework.core.Feature;
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.model.element.plane.ITPShape;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;
	import com.linkage.module.topo.framework.view.component.TopoLayer;

	import flash.display.Graphics;
	import flash.geom.Matrix;

	import mx.core.UIComponent;

	/**
	 * 矩形形状样式类
	 * @author duangr
	 *
	 */
	public class RectangleShapeStyle implements IShapeStyle
	{
		public function RectangleShapeStyle()
		{
		}

		public function drawShape(g:Graphics, feature:Feature, shape:ITPShape):void
		{
			g.drawRect(0, 0, feature.width, feature.height);
		}

		public function rotateShape(ui:UIComponent, shape:ITPShape):void
		{
			// 矩形不需要转换
		}

	}
}