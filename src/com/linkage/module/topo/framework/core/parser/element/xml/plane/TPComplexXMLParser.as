package com.linkage.module.topo.framework.core.parser.element.xml.plane
{
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.model.element.plane.IHLinkTopo;
	import com.linkage.module.topo.framework.core.model.element.plane.ITPComplex;
	import com.linkage.module.topo.framework.core.parser.ElementProperties;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;
	import com.linkage.module.topo.framework.view.component.TopoLayer;

	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	/**
	 * 复合对象XML解析器
	 * @author duangr
	 *
	 */
	public class TPComplexXMLParser extends TPShapeXMLParser
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.core.parser.element.xml.plane.TPComplexXMLParser");

		public function TPComplexXMLParser()
		{
			super();

			appendNotOutputExtendProperty(ElementProperties.OBJECT_SHOW_TYPE, ElementProperties.DEFAULT_OBJECT_SHOW_TYPE);
		}

		override public function parse(e:IElement, data:Object, topoCanvas:TopoLayer):Boolean
		{
			return super.parse(e, data, topoCanvas) && doParse(e as ITPComplex, data);
		}

		/**
		 * 解析复合对象数据
		 * @param complex
		 *
		 */
		private function doParse(complex:ITPComplex, data:Object):Boolean
		{

			return true;
		}


	}
}