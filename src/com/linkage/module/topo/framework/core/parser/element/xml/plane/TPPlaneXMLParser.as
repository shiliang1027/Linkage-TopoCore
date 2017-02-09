package com.linkage.module.topo.framework.core.parser.element.xml.plane
{
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.model.element.plane.ITPPlane;
	import com.linkage.module.topo.framework.core.model.element.point.Node;
	import com.linkage.module.topo.framework.core.parser.element.xml.ElementXMLParser;
	import com.linkage.module.topo.framework.core.parser.element.xml.point.NodeXMLParser;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;
	import com.linkage.module.topo.framework.view.component.TopoLayer;

	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	/**
	 * 面对象XML解析器
	 * @author duangr
	 *
	 */
	public class TPPlaneXMLParser extends NodeXMLParser
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.core.parser.element.xml.plane.TPPlaneXMLParser");

		public function TPPlaneXMLParser()
		{
			super();
		}

		override public function parse(e:IElement, data:Object, topoCanvas:TopoLayer):Boolean
		{
			return super.parse(e, data, topoCanvas) && doParse(e as ITPPlane, data);
		}

		/**
		 * 解析点对象数据
		 * @param node
		 *
		 */
		private function doParse(plane:ITPPlane, data:Object):Boolean
		{
			plane.width = Number(data.@width);
			plane.height = Number(data.@height);
			return true;
		}

		override protected function outputCommonAttr(e:IElement):String
		{
			var plane:ITPPlane = e as ITPPlane;
			return super.outputCommonAttr(e) + " width=\"" + plane.width + "\" height=\"" + plane.height + "\"";
		}
	}
}