package com.linkage.module.topo.framework.core.parser.element.xml.plane
{
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.model.element.plane.ITPGrid;
	import com.linkage.module.topo.framework.core.parser.ElementProperties;
	import com.linkage.module.topo.framework.view.component.TopoLayer;
	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	/**
	 * 网格对象XML解析器
	 * @author duangr
	 *
	 */
	public class TPGridXMLParser extends TPPlaneXMLParser
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.core.parser.element.xml.plane.TPGridXMLParser");

		public function TPGridXMLParser()
		{
			super();

			appendNotOutputExtendProperty(ElementProperties.GRID_BORDER_COLOR, ElementProperties.DEFAULT_GRID_BORDER_COLOR);
			appendNotOutputExtendProperty(ElementProperties.GRID_BORDER_WIDTH, ElementProperties.DEFAULT_GRID_BORDER_WIDTH);
			appendNotOutputExtendProperty(ElementProperties.GRID_BORDER_ALPHA, ElementProperties.DEFAULT_GRID_BORDER_ALPHA);
			appendNotOutputExtendProperty(ElementProperties.GRID_CELL_FILL_COLOR_START, ElementProperties.DEFAULT_GRID_CELL_FILL_COLOR_START);
			appendNotOutputExtendProperty(ElementProperties.GRID_CELL_FILL_COLOR_END, ElementProperties.DEFAULT_GRID_CELL_FILL_COLOR_END);
			appendNotOutputExtendProperty(ElementProperties.GRID_CELL_FILL_ALPHA, ElementProperties.DEFAULT_GRID_CELL_FILL_ALPHA);

			appendNotOutputExtendProperty(ElementProperties.GRID_ROW_COUNT, ElementProperties.DEFAULT_GRID_ROW_COUNT);
			appendNotOutputExtendProperty(ElementProperties.GRID_ROW_LABEL_LAYOUT, ElementProperties.DEFAULT_GRID_ROW_LABEL_LAYOUT);
			appendNotOutputExtendProperty(ElementProperties.GRID_COLUMN_COUNT, ElementProperties.DEFAULT_GRID_COLUMN_COUNT);
			appendNotOutputExtendProperty(ElementProperties.GRID_COLUMN_LABEL_LAYOUT, ElementProperties.DEFAULT_GRID_COLUMN_LABEL_LAYOUT);
			appendNotOutputExtendProperty(ElementProperties.GRID_LABEL_SPELL, ElementProperties.DEFAULT_GRID_LABEL_SPELL);
		}

		override public function parse(e:IElement, data:Object, topoCanvas:TopoLayer):Boolean
		{
			return super.parse(e, data, topoCanvas) && doParse(e as ITPGrid, data);
		}

		/**
		 * 解析网格对象数据
		 * @param shape
		 *
		 */
		private function doParse(tpGrid:ITPGrid, data:Object):Boolean
		{
			return true;
		}
	}
}