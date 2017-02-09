package com.linkage.module.topo.framework.core.parser.element.xml.point
{
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.model.element.point.ITPObject;
	import com.linkage.module.topo.framework.view.component.TopoLayer;

	/**
	 * 拓扑内部简单对象XML解析器
	 * @author duangr
	 *
	 */
	public class TPObjectXMLParser extends NodeXMLParser
	{
		public function TPObjectXMLParser()
		{
			super();
		}

		override public function parse(e:IElement, data:Object, topoCanvas:TopoLayer):Boolean
		{
			return super.parse(e, data, topoCanvas) && doParse(e as ITPObject, data);
		}

		/**
		 * 解析拓扑内置简单对象数据
		 * @param tpObject 拓扑内置简单对象
		 * @param data 数据载体
		 *
		 */
		private function doParse(tpObject:ITPObject, data:Object):Boolean
		{
			// 此处可扩展
			return true;
		}

		override protected function outputCommonAttr(e:IElement):String
		{
			// 此处可扩展
			return super.outputCommonAttr(e)
		}
	}
}