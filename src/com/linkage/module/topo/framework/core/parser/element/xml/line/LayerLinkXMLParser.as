package com.linkage.module.topo.framework.core.parser.element.xml.line
{
	import com.linkage.module.topo.framework.core.model.element.line.ILayerLink;
	import com.linkage.module.topo.framework.core.model.element.line.ILink;
	import com.linkage.module.topo.framework.core.model.element.plane.IHLinkLayer;
	import com.linkage.module.topo.framework.core.model.element.point.ITPPoint;
	import com.linkage.module.topo.framework.core.parser.ElementProperties;
	import com.linkage.module.topo.framework.view.component.TopoLayer;

	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	/**
	 * 缩略图之间链路对象XML解析器
	 * @author duangr
	 *
	 */
	public class LayerLinkXMLParser extends LinkXMLParser
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.core.parser.element.xml.line.LayerLinkXMLParser");

		public function LayerLinkXMLParser()
		{
			super();
		}

		/**
		 * 解析链路对象数据
		 * @param node
		 *
		 */
		override protected function doParse(link:ILink, data:Object, topoCanvas:TopoLayer):Boolean
		{
			var layerLink:ILayerLink = link as ILayerLink;

			var fromLayer:IHLinkLayer = topoCanvas.findElementById(layerLink.fromLayerId) as IHLinkLayer;
			var toLayer:IHLinkLayer = topoCanvas.findElementById(layerLink.toLayerId) as IHLinkLayer;
			if (fromLayer == null || toLayer == null)
			{
				log.warn("解析缩略图间链路[{0}]时找不到两端缩略图对象 fromLayerId={1} toLayerId={2}", layerLink.id, layerLink.fromLayerId, layerLink.toLayerId);
				return false;
			}
			layerLink.fromElementId = String(data.@from);
			layerLink.toElementId = String(data.@to);
			layerLink.fromLayer = fromLayer;
			layerLink.toLayer = toLayer;
			layerLink.expanded = layerLink.linkDefaultStatus == ElementProperties.PROPERTYVALUE_LINK_DEFAULT_STATUS_OPEN ? true : false;

			// 在两端的缩略图中增加链路引用
			fromLayer.addOutLine(layerLink);
			toLayer.addInLine(layerLink);

			return true;
		}
	}
}