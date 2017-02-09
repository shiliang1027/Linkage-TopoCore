package com.linkage.module.topo.framework.core.parser.element.xml.plane
{
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.model.element.plane.IHLinkTopo;
	import com.linkage.module.topo.framework.core.parser.ElementProperties;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;
	import com.linkage.module.topo.framework.view.component.TopoLayer;

	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	/**
	 * 内部链接XML解析器
	 * @author duangr
	 *
	 */
	public class HLinkTopoXMLParser extends TPShapeXMLParser
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.core.parser.element.xml.plane.HLinkTopoXMLParser");

		public function HLinkTopoXMLParser()
		{
			super();

			appendNotOutputExtendProperty(ElementProperties.OBJECT_TOPO_TYPE, ElementProperties.DEFAULT_OBJECT_TOPO_TYPE);
			appendNotOutputExtendProperty(ElementProperties.OBJECT_TOPO_OPENTYPE, ElementProperties.DEFAULT_OBJECT_TOPO_OPENTYPE);
			appendNotOutputExtendProperty(ElementProperties.OBJECT_SHOW_TYPE, ElementProperties.DEFAULT_OBJECT_SHOW_TYPE);
		}

		override public function parse(e:IElement, data:Object, topoCanvas:TopoLayer):Boolean
		{
			return super.parse(e, data, topoCanvas) && doParse(e as IHLinkTopo, data);
		}

		/**
		 * 解析内部链接对象数据
		 * @param hlinkTopo
		 *
		 */
		private function doParse(hlinkTopo:IHLinkTopo, data:Object):Boolean
		{

			return true;
		}


	}
}