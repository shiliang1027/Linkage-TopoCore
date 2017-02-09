package com.linkage.module.topo.framework.core.style.element.plane.shapemarket
{
	import com.linkage.module.topo.framework.core.Feature;
	import com.linkage.module.topo.framework.core.model.element.plane.ITPShape;

	import flash.display.Graphics;

	import mx.core.UIComponent;

	/**
	 * 圆形形状
	 * @author duangr
	 *
	 */
	public class CircleShapeStyle implements IShapeStyle
	{
		public function CircleShapeStyle()
		{
		}

		public function drawShape(g:Graphics, feature:Feature, shape:ITPShape):void
		{
			var radius2:Number = Math.min(shape.width, shape.height);
			g.drawCircle(shape.width / 2, shape.height / 2, radius2 / 2);
		}

		public function rotateShape(ui:UIComponent, shape:ITPShape):void
		{
			// 矩形不需要转换
		}
	}
}