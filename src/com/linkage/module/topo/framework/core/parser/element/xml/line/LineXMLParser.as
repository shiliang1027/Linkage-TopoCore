package com.linkage.module.topo.framework.core.parser.element.xml.line
{
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.model.element.line.ILine;
	import com.linkage.module.topo.framework.core.parser.ElementProperties;
	import com.linkage.module.topo.framework.core.parser.element.xml.ElementXMLParser;
	import com.linkage.module.topo.framework.view.component.TopoLayer;

	/**
	 * 线对象XML解析器
	 * @author duangr
	 *
	 */
	public class LineXMLParser extends ElementXMLParser
	{


		public function LineXMLParser()
		{
			super();

			appendNotOutputExtendProperty(ElementProperties.LINE_TOOLTIP, ElementProperties.DEFAULT_LINE_TOOLTIP);
			appendNotOutputExtendProperty(ElementProperties.LINE_COLOR, ElementProperties.DEFAULT_LINE_COLOR);
			appendNotOutputExtendProperty(ElementProperties.LINE_WIDTH, ElementProperties.DEFAULT_LINE_WIDTH);
			appendNotOutputExtendProperty(ElementProperties.LINE_ALPHA, ElementProperties.DEFAULT_LINE_ALPHA);
			appendNotOutputExtendProperty(ElementProperties.LINE_SYMBOL, ElementProperties.DEFAULT_LINE_SYMBOL);
			appendNotOutputExtendProperty(ElementProperties.LINE_TYPE, ElementProperties.DEFAULT_LINE_TYPE);
		}

		override public function parse(e:IElement, data:Object, topoCanvas:TopoLayer):Boolean
		{
			return super.parse(e, data, topoCanvas) && doParse(e as ILine, data, topoCanvas);
		}

		private function doParse(line:ILine, data:Object, topoCanvas:TopoLayer):Boolean
		{
			return true;
		}


		override protected function outputCommonAttr(e:IElement):String
		{
			return super.outputCommonAttr(e);
		}

	}
}