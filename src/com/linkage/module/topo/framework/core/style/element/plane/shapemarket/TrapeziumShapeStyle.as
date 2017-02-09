package com.linkage.module.topo.framework.core.style.element.plane.shapemarket
{
	import com.linkage.module.topo.framework.core.Feature;
	import com.linkage.module.topo.framework.core.model.element.plane.ITPShape;

	import flash.display.Graphics;

	import mx.core.UIComponent;

	/**
	 * 梯形样式
	 * @author duangr
	 *
	 */
	public class TrapeziumShapeStyle implements IShapeStyle
	{
		public function TrapeziumShapeStyle()
		{
		}

		public function drawShape(g:Graphics, feature:Feature, shape:ITPShape):void
		{
			g.drawRect(0, 0, feature.width, feature.height);
		}

		public function rotateShape(ui:UIComponent, shape:ITPShape):void
		{
			ui.rotationX = -shape.parallelogramAngle;
		}
	}
}