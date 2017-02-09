package com.linkage.module.topo.framework.core.parser.element.xml.plane
{
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.model.element.plane.IHLinkLayer;
	import com.linkage.module.topo.framework.core.parser.ElementProperties;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;
	import com.linkage.module.topo.framework.view.component.TopoLayer;

	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	/**
	 * 立体层次XML解析器
	 * @author duangr
	 *
	 */
	public class HLinkLayerXMLParser extends TPShapeXMLParser
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.core.parser.element.xml.plane.HLinkLayerXMLParser");

		public function HLinkLayerXMLParser()
		{
			super();

			appendNotOutputExtendProperty(ElementProperties.OBJECT_TOPO_TYPE, ElementProperties.DEFAULT_OBJECT_TOPO_TYPE);
			appendNotOutputExtendProperty(ElementProperties.OBJECT_TOPO_OPENTYPE, ElementProperties.DEFAULT_OBJECT_TOPO_OPENTYPE);
			appendNotOutputExtendProperty(ElementProperties.OBJECT_TOPO_SOURCE_TYPE, ElementProperties.DEFAULT_OBJECT_TOPO_TYPE);
		}

		override public function parse(e:IElement, data:Object, topoCanvas:TopoLayer):Boolean
		{
			return super.parse(e, data, topoCanvas) && doParse(e as IHLinkLayer, data);
		}

		/**
		 * 解析立体层次对象数据
		 * @param hlinkTopo
		 *
		 */
		private function doParse(hlinkLayer:IHLinkLayer, data:Object):Boolean
		{

			return true;
		}

	}
}