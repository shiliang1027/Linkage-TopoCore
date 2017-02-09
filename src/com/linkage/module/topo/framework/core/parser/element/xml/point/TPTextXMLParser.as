package com.linkage.module.topo.framework.core.parser.element.xml.point
{
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.model.element.point.ITPText;
	import com.linkage.module.topo.framework.core.parser.ElementProperties;
	import com.linkage.module.topo.framework.view.component.TopoLayer;

	/**
	 * 文本对象解析器
	 * @author duangr
	 *
	 */
	public class TPTextXMLParser extends NodeXMLParser
	{

		public function TPTextXMLParser()
		{
			super();

			appendNotOutputExtendProperty(ElementProperties.OBJECT_TEXT_COLOR, ElementProperties.DEFAULT_OBJECT_TEXT_COLOR);
			appendNotOutputExtendProperty(ElementProperties.OBJECT_TEXT_SIZE, ElementProperties.DEFAULT_OBJECT_TEXT_SIZE);
		}

		override public function parse(e:IElement, data:Object, topoCanvas:TopoLayer):Boolean
		{
			return super.parse(e, data, topoCanvas) && doParse(e as ITPText, data);
		}

		/**
		 * 解析文本对象数据
		 * @param text
		 *
		 */
		private function doParse(text:ITPText, data:Object):Boolean
		{
			return true;
		}

		override protected function outputCommonAttr(e:IElement):String
		{
			var text:ITPText = e as ITPText;
			return super.outputCommonAttr(e);
		}

	}
}