package com.linkage.module.topo.framework.core.style.element.plane.shapemarket
{
	import com.linkage.module.topo.framework.core.Feature;
	import com.linkage.module.topo.framework.core.model.element.plane.ITPShape;
	import com.linkage.module.topo.framework.util.MathUtil;

	import flash.display.Graphics;
	import flash.geom.Matrix;

	import mx.core.UIComponent;

	/**
	 * 平行四边形样式
	 * @author duangr
	 *
	 */
	public class ParallelogramShapeStyle implements IShapeStyle
	{
		public function ParallelogramShapeStyle()
		{
		}

		public function drawShape(g:Graphics, feature:Feature, shape:ITPShape):void
		{
			g.drawRect(0, 0, feature.width, feature.height);
		}

		public function rotateShape(ui:UIComponent, shape:ITPShape):void
		{
			ui.transform.matrix = new Matrix(1, 0, Math.tan(MathUtil.angle2radian(-shape.parallelogramAngle)), 1);
		}
	}
}