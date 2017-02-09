package com.linkage.module.topo.framework.core.parser.element
{
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;
	import com.linkage.module.topo.framework.view.component.TopoLayer;

	/**
	 * 元素数据解析器接口
	 *
	 * @author duangr
	 *
	 */
	public interface IElementParser
	{
		/**
		 * 解析元素的数据
		 * @param e 数据解析后对象载体
		 * @param data 待解析数据内容
		 * @param topoCanvas 画布
		 * @return 解析是否成功
		 *
		 */
		function parse(e:IElement, data:Object, topoCanvas:TopoLayer):Boolean;

		/**
		 * 根据元素对象的数据,生成XML格式
		 * @param e
		 * @return
		 *
		 */
		function output(e:IElement):*;
	}
}