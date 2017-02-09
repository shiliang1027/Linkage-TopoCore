package com.linkage.module.topo.framework.core.parser.element.xml.plane
{
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.model.element.plane.ITPGroup;
	import com.linkage.module.topo.framework.core.model.element.plane.ITPShape;
	import com.linkage.module.topo.framework.core.model.element.point.ITPPoint;
	import com.linkage.module.topo.framework.core.parser.ElementProperties;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;
	import com.linkage.module.topo.framework.view.component.TopoLayer;
	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	/**
	 * 分组对象XML解析器
	 * @author duangr
	 *
	 */
	public class TPGroupXMLParser extends TPShapeXMLParser
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.core.parser.element.xml.plane.TPGroupXMLParser");

		public function TPGroupXMLParser()
		{
			super();

			appendNotOutputExtendProperty(ElementProperties.GROUP_CLOSED_ICON, ElementProperties.DEFAULT_GROUP_CLOSED_ICON);
			appendNotOutputExtendProperty(ElementProperties.GROUP_DEFAULT_STATUS, ElementProperties.DEFAULT_GROUP_DEFAULT_STATUS);
		}

		override public function parse(e:IElement, data:Object, topoCanvas:TopoLayer):Boolean
		{
			return super.parse(e, data, topoCanvas) && doParse(e as ITPGroup, data, topoCanvas);
		}

		/**
		 * 解析分组对象数据
		 * @param node
		 *
		 */
		private function doParse(group:ITPGroup, data:Object, topoCanvas:TopoLayer):Boolean
		{
			group.expanded = group.defaultStatus == ElementProperties.PROPERTYVALUE_GROUP_DEFAULT_STATUS_OPEN ? true : false;
			// ------------- 解析内部对象 -------------
			// <Node id="1/2343" />
			// <Segment id="1/23" />
			// <Object id="1/ly/1"/>
			var child:Object = null;
			for each (child in data.Node)
			{
				group.addChild(child.@id, topoCanvas.findNodeById(child.@id));
			}
			for each (child in data.Segment)
			{
				group.addChild(child.@id, topoCanvas.findSegmentById(child.@id));
			}
			for each (child in data.Group)
			{
				group.addChild(child.@id, topoCanvas.findGroupById(child.@id));
			}
			for each (child in data.Object)
			{
				var element:IElement = topoCanvas.findObjectById(child.@id);
				if (element is ITPPoint)
				{
					group.addChild(child.@id, element as ITPPoint);
				}
			}
			return true;
		}

	}
}