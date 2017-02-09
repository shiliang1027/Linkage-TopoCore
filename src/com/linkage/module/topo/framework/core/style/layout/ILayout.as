package com.linkage.module.topo.framework.core.style.layout
{
	import com.linkage.module.topo.framework.core.Feature;
	
	import flash.geom.Point;
	
	import mx.core.IVisualElement;

	/**
	 * 元素布局器接口
	 * @author duangr
	 *
	 */
	public interface ILayout
	{
		/**
		 * 布局Label
		 * @param text label的内容
		 * @param label label对象
		 * @param feature 拓扑要素
		 * @return
		 *
		 */
		function layoutLabel(text:String, label:IVisualElement, feature:Feature):IVisualElement;
		function layoutPointLabel(text:String, label:IVisualElement, feature:Feature,fromPoint:Point,toPoint:Point):IVisualElement;
	}
}