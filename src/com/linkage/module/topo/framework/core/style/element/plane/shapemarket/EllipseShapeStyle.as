package com.linkage.module.topo.framework.core.style.element.plane.shapemarket
{
	import com.linkage.module.topo.framework.core.Feature;
	import com.linkage.module.topo.framework.core.model.element.plane.ITPShape;

	import flash.display.Graphics;

	import mx.core.UIComponent;

	/**
	 * 椭圆形样式
	 * @author duangr
	 *
	 */
	public class EllipseShapeStyle implements IShapeStyle
	{
		public function EllipseShapeStyle()
		{
		}

		public function drawShape(g:Graphics, feature:Feature, shape:ITPShape):void
		{
			g.drawEllipse(0, 0, shape.width, shape.height);
		}

		public function rotateShape(ui:UIComponent, shape:ITPShape):void
		{
		}
	}
}