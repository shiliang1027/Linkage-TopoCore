package com.linkage.module.topo.framework.core.parser.element.xml.plane
{
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.model.element.plane.ITPShape;
	import com.linkage.module.topo.framework.core.parser.ElementProperties;
	import com.linkage.module.topo.framework.core.parser.element.xml.point.NodeXMLParser;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;
	import com.linkage.module.topo.framework.view.component.TopoLayer;

	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	/**
	 * 形状对象XML解析器
	 * @author duangr
	 *
	 */
	public class TPShapeXMLParser extends TPPlaneXMLParser
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.core.parser.element.xml.plane.TPShapeXMLParser");

		public function TPShapeXMLParser()
		{
			super();

			appendNotOutputExtendProperty(ElementProperties.SHAPE_TYPE, ElementProperties.DEFAULT_SHAPE_TYPE);

			appendNotOutputExtendProperty(ElementProperties.SHAPE_PARALLELOGRAM_ANGLE, ElementProperties.DEFAULT_SHAPE_PARALLELOGRAM_ANGLE);
			appendNotOutputExtendProperty(ElementProperties.SHAPE_FILL_TYPE, ElementProperties.DEFAULT_SHAPE_FILL_TYPE);
			appendNotOutputExtendProperty(ElementProperties.SHAPE_FILL_COLOR_START, ElementProperties.DEFAULT_SHAPE_FILL_COLOR_START);
			appendNotOutputExtendProperty(ElementProperties.SHAPE_FILL_COLOR_END, ElementProperties.DEFAULT_SHAPE_FILL_COLOR_END);
			appendNotOutputExtendProperty(ElementProperties.SHAPE_FILL_ALPHA, ElementProperties.DEFAULT_SHAPE_FILL_ALPHA);
			appendNotOutputExtendProperty(ElementProperties.SHAPE_BORDER_COLOR, ElementProperties.DEFAULT_SHAPE_BORDER_COLOR);
			appendNotOutputExtendProperty(ElementProperties.SHAPE_BORDER_WIDTH, ElementProperties.DEFAULT_SHAPE_BORDER_WIDTH);
			appendNotOutputExtendProperty(ElementProperties.SHAPE_BORDER_ALPHA, ElementProperties.DEFAULT_SHAPE_BORDER_ALPHA);
			appendNotOutputExtendProperty(ElementProperties.SHAPE_SHADOW_ENABLE, ElementProperties.DEFAULT_SHAPE_SHADOW_ENABLE);

		}

		override public function parse(e:IElement, data:Object, topoCanvas:TopoLayer):Boolean
		{
			return super.parse(e, data, topoCanvas) && doParse(e as ITPShape, data);
		}

		/**
		 * 解析形状对象数据
		 * @param shape
		 *
		 */
		private function doParse(shape:ITPShape, data:Object):Boolean
		{
			return true;
		}


	}
}