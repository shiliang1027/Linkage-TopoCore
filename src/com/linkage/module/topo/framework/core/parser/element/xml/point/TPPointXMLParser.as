package com.linkage.module.topo.framework.core.parser.element.xml.point
{
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.model.element.point.ITPPoint;
	import com.linkage.module.topo.framework.core.parser.element.xml.ElementXMLParser;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;
	import com.linkage.module.topo.framework.view.component.TopoLayer;

	/**
	 * 点对象XML解析器
	 * @author duangr
	 *
	 */
	public class TPPointXMLParser extends ElementXMLParser
	{
		public function TPPointXMLParser()
		{
			super();
		}

		override public function parse(e:IElement, data:Object, topoCanvas:TopoLayer):Boolean
		{
			return super.parse(e, data, topoCanvas) && doParse(e as ITPPoint, data);
		}

		/**
		 * 解析点对象数据
		 * @param node
		 *
		 */
		private function doParse(point:ITPPoint, data:Object):Boolean
		{
			point.x = Number(data.@x);
			point.y = Number(data.@y);
			return true;
		}

		override protected function outputCommonAttr(e:IElement):String
		{
			var point:ITPPoint = e as ITPPoint;
			return super.outputCommonAttr(e) + " x=\"" + int(point.x) + "\" y=\"" + int(point.y) + "\"";
		}

	}
}