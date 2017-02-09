package com.linkage.module.topo.framework.core.style.layout
{
	import com.linkage.module.topo.framework.core.Feature;

	import mx.core.IVisualElement;

	/**
	 * Label隐藏布局
	 * @author duangr
	 *
	 */
	public class HideLayout extends BottomLayout
	{
		public function HideLayout()
		{
		}

		override public function layoutLabel(text:String, label:IVisualElement, feature:Feature):IVisualElement
		{
			var label:IVisualElement = super.layoutLabel(text, label, feature);
			label.visible = false;
			return label;
		}
	}
}