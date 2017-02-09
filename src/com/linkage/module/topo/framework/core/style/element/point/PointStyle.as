package com.linkage.module.topo.framework.core.style.element.point
{
	import com.linkage.module.topo.framework.core.Feature;
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.model.element.line.ILink;
	import com.linkage.module.topo.framework.core.model.element.point.ITPPoint;
	import com.linkage.module.topo.framework.core.style.element.AbstractStyle;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;
	import com.linkage.module.topo.framework.view.component.TopoLayer;

	import flash.geom.Point;

	/**
	 * 点样式
	 * @author duangr
	 *
	 */
	public class PointStyle extends AbstractStyle
	{
		public function PointStyle()
		{
			super();
		}

		override public function draw(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):void
		{
			feature.visible = beforeDraw(feature, element, topoLayer, topoCanvas, attributes);
			if (feature.visible)
			{
				initDeepth(feature, element, topoLayer, topoCanvas);
				creationComplete(feature);
			}
		}

		override protected function beforeDraw(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):Boolean
		{
			feature.removeAllElements();
			var point:ITPPoint = element as ITPPoint;
			var flag:Boolean = true;
			if (point.groupOwner)
			{
				flag = point.groupOwner.feature.visible && point.groupOwner.expanded;
			}
			return super.beforeDraw(feature, element, topoLayer, topoCanvas, attributes) && flag;
		}

		override public function afterMove(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):void
		{
			var point:ITPPoint = element as ITPPoint;

			point.eachLinks(function(link:ILink):void
				{
					link.feature.afterMove();
				});
		}

		override public function refresh(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):void
		{
			draw(feature, element, topoLayer, topoCanvas, attributes);
			if (feature.selected)
			{
				select(feature, element, topoLayer, topoCanvas, attributes);
			}
			var point:ITPPoint = element as ITPPoint;

			point.eachLinks(function(link:ILink):void
				{
					link.feature.refresh();
				});
		}

		/**
		 * 修正坐标
		 * @param feature
		 * @param tpPoint
		 * @param topoCanvas
		 *
		 */
		protected function reviseXY(feature:Feature, tpPoint:ITPPoint, topoLayer:TopoLayer, topoCanvas:TopoCanvas):void
		{
			var point:Point = topoLayer.xyToLocal(feature, tpPoint.x, tpPoint.y);
			feature.x = point.x;
			feature.y = point.y;
		}
	}
}