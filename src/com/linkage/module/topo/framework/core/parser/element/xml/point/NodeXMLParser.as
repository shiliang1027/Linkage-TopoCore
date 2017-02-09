package com.linkage.module.topo.framework.core.parser.element.xml.point
{
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.model.element.point.INode;
	import com.linkage.module.topo.framework.core.parser.ElementProperties;
	import com.linkage.module.topo.framework.view.component.TopoLayer;

	/**
	 * 节点对象XML解析器
	 * @author duangr
	 *
	 */
	public class NodeXMLParser extends TPPointXMLParser
	{
		public function NodeXMLParser()
		{
			super();

			appendNotOutputExtendProperty(ElementProperties.ICON_WIDTH, ElementProperties.DEFAULT_ICON_WIDTH);
			appendNotOutputExtendProperty(ElementProperties.ICON_HEIGHT, ElementProperties.DEFAULT_ICON_HEIGHT);
		}

		override public function parse(e:IElement, data:Object, topoCanvas:TopoLayer):Boolean
		{
			return super.parse(e, data, topoCanvas) && doParse(e as INode, data);
		}

		/**
		 * 解析点对象数据
		 * @param node
		 *
		 */
		private function doParse(point:INode, data:Object):Boolean
		{
			point.icon = String(data.@icon);
			return true;
		}

		override protected function outputCommonAttr(e:IElement):String
		{
			var node:INode = e as INode;
			return super.outputCommonAttr(e) + " icon=\"" + trimNull(node.icon) + "\"";
		}
	}
}