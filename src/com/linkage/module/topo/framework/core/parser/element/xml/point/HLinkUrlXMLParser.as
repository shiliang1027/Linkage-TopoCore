package com.linkage.module.topo.framework.core.parser.element.xml.point
{
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.model.element.plane.IHLinkUrl;
	import com.linkage.module.topo.framework.core.parser.ElementProperties;
	import com.linkage.module.topo.framework.core.parser.element.xml.plane.TPShapeXMLParser;
	import com.linkage.module.topo.framework.view.component.TopoLayer;

	/**
	 * 超链接URL对象解析器
	 * @author duangr
	 *
	 */
	public class HLinkUrlXMLParser extends TPShapeXMLParser
	{

		public function HLinkUrlXMLParser()
		{
			super();

			appendNotOutputExtendProperty(ElementProperties.OBJECT_TEXT_COLOR, ElementProperties.DEFAULT_OBJECT_TEXT_COLOR);
		}

		override public function parse(e:IElement, data:Object, topoCanvas:TopoLayer):Boolean
		{
			return super.parse(e, data, topoCanvas) && doParse(e as IHLinkUrl, data);
		}

		/**
		 * 解析url对象数据
		 * @param hlinkUrl
		 *
		 */
		private function doParse(hlinkUrl:IHLinkUrl, data:Object):Boolean
		{
			return true;
		}

		override protected function outputCommonAttr(e:IElement):String
		{
			var hlinkUrl:IHLinkUrl = e as IHLinkUrl;
			return super.outputCommonAttr(e);
		}

	}
}