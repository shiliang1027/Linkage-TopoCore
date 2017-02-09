package com.linkage.module.topo.framework.core.parser.element.xml.plane
{
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.model.element.plane.ITPView;
	import com.linkage.module.topo.framework.view.component.TopoLayer;

	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	/**
	 * 视图XML解析器
	 * @author duangr
	 *
	 */
	public class TPViewXMLParser extends TPComplexXMLParser
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.core.parser.element.xml.plane.TPViewXMLParser");

		public function TPViewXMLParser()
		{
			super();
		}

		override public function parse(e:IElement, data:Object, topoCanvas:TopoLayer):Boolean
		{
			return super.parse(e, data, topoCanvas) && doParse(e as ITPView, data);
		}

		/**
		 * 解析视图对象数据
		 * @param hlinkTopo
		 *
		 */
		private function doParse(tpView:ITPView, data:Object):Boolean
		{

			return true;
		}


	}
}