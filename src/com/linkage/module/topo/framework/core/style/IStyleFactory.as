package com.linkage.module.topo.framework.core.style
{
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.style.layout.ILayout;
	import com.linkage.module.topo.framework.core.style.element.IStyle;

	/**
	 * 样式的工厂类接口
	 * @author duangr
	 *
	 */
	public interface IStyleFactory
	{

		/**
		 * 根据元素属性获取对应的样式解析对象
		 * @param element
		 * @return
		 *
		 */
		function buildStyle(element:IElement):IStyle;

	}
}