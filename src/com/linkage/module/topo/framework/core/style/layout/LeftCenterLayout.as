package com.linkage.module.topo.framework.core.style.layout
{
	import com.linkage.module.topo.framework.core.Feature;
	import com.linkage.system.utils.StringUtils;
	
	import flash.geom.Point;
	
	import mx.core.IVisualElement;

	/**
	 * Label中心布局
	 * @author duangr
	 *
	 */
	public class LeftCenterLayout implements ILayout
	{
		public function LeftCenterLayout()
		{
		}


		/**
		 * label放在中间
		 * @param text
		 * @param label
		 * @param feature
		 * @return
		 *
		 */
		
		public function layoutLabel(text:String, label:IVisualElement, feature:Feature):IVisualElement
		{
			return null;
		}
		
		public function layoutPointLabel(text:String, label:IVisualElement, feature:Feature,fromPoint:Point,toPoint:Point):IVisualElement
		{
			var fontSize:Number = feature.getStyle("fontSize");
			var textLength:Number = StringUtils.getStrLen(text) * fontSize / 2;
			
			//Label顶部布局
//			label.x = feature.width / 2.0 - textLength / 2.0;
//			label.y = -2 - fontSize;
			label.x = fromPoint.x + (toPoint.x - fromPoint.x)*3/4;
			label.y = fromPoint.y + (toPoint.y - fromPoint.y)*3/4 -25; 

			return label;
		}

	}
}