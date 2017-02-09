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
	public class CenterLayout implements ILayout
	{
		public function CenterLayout()
		{
		}

		public function layoutPointLabel(text:String, label:IVisualElement, feature:Feature,fromPoint:Point,toPoint:Point):IVisualElement
		{
			return null;
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
			var fontSize:Number = feature.getStyle("fontSize");
			var textLength:Number = StringUtils.getStrLen(text) * fontSize / 2;

			label.x = feature.width / 2.0 - textLength / 2.0;
			label.y = feature.height / 2.0;
			
			// 画在图标的左边
		    //label.x = -textLength - 2;
			//label.y = feature.height / 2.0;
			
			// 画在图标的右边
			//label.x = feature.width + 2;
			//label.y = feature.height / 2.0;
			
			//Label顶部布局
			//label.x = feature.width / 2.0 - textLength / 2.0;
			//label.y = -2 - fontSize;
			
			// 画在图标的正下方
			//label.x = feature.width / 2.0 - textLength / 2.0;
			//label.y = feature.height + 2;

			return label;
		}

	}
}