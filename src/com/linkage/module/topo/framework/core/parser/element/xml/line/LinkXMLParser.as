package com.linkage.module.topo.framework.core.parser.element.xml.line
{
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.model.element.line.ILink;
	import com.linkage.module.topo.framework.core.model.element.line.ITPLine;
	import com.linkage.module.topo.framework.core.model.element.point.ITPPoint;
	import com.linkage.module.topo.framework.core.parser.ElementProperties;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;
	import com.linkage.module.topo.framework.view.component.TopoLayer;
	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	/**
	 * 链路对象XML解析器
	 * @author duangr
	 *
	 */
	public class LinkXMLParser extends LineXMLParser
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.core.parser.element.xml.line.LinkXMLParser");

		public function LinkXMLParser()
		{
			super();

			appendNotOutputExtendProperty(ElementProperties.LINK_BESSEL2_OFFSETV, ElementProperties.DEFAULT_LINK_BESSEL2_OFFSETV);
			appendNotOutputExtendProperty(ElementProperties.LINK_COUNT, ElementProperties.DEFAULT_LINK_COUNT);
			appendNotOutputExtendProperty(ElementProperties.LINK_DEFAULT_STATUS, ElementProperties.DEFAULT_LINK_DEFAULT_STATUS);
			appendNotOutputExtendProperty(ElementProperties.LINK_OPEN_GAP, ElementProperties.DEFAULT_LINK_OPEN_GAP);
			appendNotOutputExtendProperty(ElementProperties.LINK_OPEN_OFFSETH, ElementProperties.DEFAULT_LINK_OPEN_OFFSETH);
			appendNotOutputExtendProperty(ElementProperties.LINK_OPEN_TYPE, ElementProperties.DEFAULT_LINK_OPEN_TYPE);

			appendNotOutputExtendProperty(ElementProperties.LINK_FROM_ARROW, ElementProperties.PROPERTYVALUE_LINK_ARROW_FALSE);
			appendNotOutputExtendProperty(ElementProperties.LINK_FROM_ARROW_TYPE, ElementProperties.DEFAULT_LINK_ARROW_TYPE);
			appendNotOutputExtendProperty(ElementProperties.LINK_FROM_ARROW_HEIGHT, ElementProperties.DEFAULT_LINK_ARROW_HEIGHT);
			appendNotOutputExtendProperty(ElementProperties.LINK_FROM_ARROW_WIDTH, ElementProperties.DEFAULT_LINK_ARROW_WIDTH);

			appendNotOutputExtendProperty(ElementProperties.LINK_TO_ARROW, ElementProperties.PROPERTYVALUE_LINK_ARROW_FALSE);
			appendNotOutputExtendProperty(ElementProperties.LINK_TO_ARROW_TYPE, ElementProperties.DEFAULT_LINK_ARROW_TYPE);
			appendNotOutputExtendProperty(ElementProperties.LINK_TO_ARROW_HEIGHT, ElementProperties.DEFAULT_LINK_ARROW_HEIGHT);
			appendNotOutputExtendProperty(ElementProperties.LINK_TO_ARROW_WIDTH, ElementProperties.DEFAULT_LINK_ARROW_WIDTH);
		}

		override public function parse(e:IElement, data:Object, topoCanvas:TopoLayer):Boolean
		{
			return super.parse(e, data, topoCanvas) && doParse(e as ILink, data, topoCanvas);
		}

		/**
		 * 解析链路对象数据
		 * @param node
		 *
		 */
		protected function doParse(link:ILink, data:Object, topoCanvas:TopoLayer):Boolean
		{
			var fromPoint:ITPPoint = topoCanvas.findElementById(String(data.@from)) as ITPPoint;
			var toPoint:ITPPoint = topoCanvas.findElementById(String(data.@to)) as ITPPoint;
			if (fromPoint == null || toPoint == null)
			{
				log.warn("解析链路[{0}]时找不到两端网元 from={1} to={2}", link.id, data.@from, data.@to);
				return false;
			}
			link.fromElement = fromPoint;
			link.toElement = toPoint;
			link.expanded = link.linkDefaultStatus == ElementProperties.PROPERTYVALUE_LINK_DEFAULT_STATUS_OPEN ? true : false;

			// 在两端对象中增加链路引用
			fromPoint.addOutLine(link);
			toPoint.addInLine(link);
			return true;
		}

		override protected function outputCommonAttr(e:IElement):String
		{
			var link:ILink = e as ILink;
			return super.outputCommonAttr(e) + " from=\"" + trimNull(link.fromElement.id) + "\" to=\"" + trimNull(link.toElement.id) + "\"";
		}
	}
}