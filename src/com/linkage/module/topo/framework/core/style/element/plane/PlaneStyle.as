package com.linkage.module.topo.framework.core.style.element.plane
{
	import com.linkage.module.topo.framework.core.Feature;
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.model.element.plane.ITPPlane;
	import com.linkage.module.topo.framework.core.style.element.point.TPObjectStyle;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;
	import com.linkage.module.topo.framework.view.component.TopoLayer;
	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	import flash.geom.Point;

	/**
	 * 面样式
	 * @author duangr
	 *
	 */
	public class PlaneStyle extends TPObjectStyle
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.core.style.element.plane.PlaneStyle");

		public function PlaneStyle(imageContext:String)
		{
			super(imageContext);
		}

		override protected function beforeDraw(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):Boolean
		{
			feature.graphics.clear();
			return super.beforeDraw(feature, element, topoLayer, topoCanvas, attributes);
		}

		/**
		 * 修正坐标(数据中的坐标点作为面对象的中心点)<br/>
		 * 此方法主要是供子类调用使用
		 *
		 * @param feature
		 * @param plane
		 * @param topoCanvas
		 *
		 */
		protected function revisePlaneXY(feature:Feature, plane:ITPPlane, topoLayer:TopoLayer, topoCanvas:TopoCanvas):void
		{
			var point:Point = topoLayer.xyToLocal(feature, plane.x, plane.y);
			feature.x = point.x - plane.width / 2;
			feature.y = point.y - plane.height / 2;
			feature.width = plane.width;
			feature.height = plane.height;
		}

	}
}