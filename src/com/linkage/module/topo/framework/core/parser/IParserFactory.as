package com.linkage.module.topo.framework.core.parser
{
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.parser.element.IElementParser;

	/**
	 * 解析器的工厂接口
	 * @author duangr
	 *
	 */
	public interface IParserFactory
	{
		/**
		 * 根据元素属性获取对应的数据解析对象
		 * @param element
		 * @return
		 *
		 */
		function buildElementParser(element:IElement):IElementParser;
	}
}