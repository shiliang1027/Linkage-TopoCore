package com.linkage.module.topo.framework.core.style.element.plane
{
	import com.linkage.module.topo.framework.core.Feature;
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.model.element.plane.IHLinkUrl;
	import com.linkage.module.topo.framework.core.model.element.plane.ITPShape;
	import com.linkage.module.topo.framework.core.model.element.point.INode;
	import com.linkage.module.topo.framework.core.parser.ElementProperties;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;
	import com.linkage.module.topo.framework.view.component.TopoLayer;
	import com.linkage.system.utils.StringUtils;

	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	import spark.components.Label;

	/**
	 * url超链接对象样式
	 * @author duangr
	 *
	 */
	public class HLinkUrlStyle extends ShapeStyle
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.core.style.element.point.HLinkUrlStyle");

		public function HLinkUrlStyle(imageContext:String, fillImageContext:String)
		{
			super(imageContext, fillImageContext);
		}

		override public function select(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):void
		{
			var hlinkUrl:IHLinkUrl = element as IHLinkUrl;
			switch (hlinkUrl.showType)
			{
				case ElementProperties.PROPERTYVALUE_OBJECT_SHOW_TYPE_SHAPE:
					super.select(feature, element, topoLayer, topoCanvas, attributes);
					break;
				case ElementProperties.PROPERTYVALUE_OBJECT_SHOW_TYPE_ICON:
				default:
					defaultSelect(feature, element, topoLayer, topoCanvas, attributes);
					break;
			}
		}

		override public function unSelect(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):void
		{
			var hlinkUrl:IHLinkUrl = element as IHLinkUrl;
			switch (hlinkUrl.showType)
			{
				case ElementProperties.PROPERTYVALUE_OBJECT_SHOW_TYPE_SHAPE:
					super.unSelect(feature, element, topoLayer, topoCanvas, attributes);
					break;
				case ElementProperties.PROPERTYVALUE_OBJECT_SHOW_TYPE_ICON:
				default:
					defaultUnSelect(feature, element, topoLayer, topoCanvas, attributes);
					break;
			}
		}

		override public function draw(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):void
		{
			feature.visible = beforeDraw(feature, element, topoLayer, topoCanvas, attributes);
			if (feature.visible)
			{
				initDeepth(feature, element, topoLayer, topoCanvas);
				var hlinkUrl:IHLinkUrl = element as IHLinkUrl;

				switch (hlinkUrl.showType)
				{
					case ElementProperties.PROPERTYVALUE_OBJECT_SHOW_TYPE_SHAPE:
						// 画形状
						revisePlaneXY(feature, hlinkUrl, topoLayer, topoCanvas);
						drawShapeWithStyle(feature, hlinkUrl, topoLayer, topoCanvas);
						break;
					case ElementProperties.PROPERTYVALUE_OBJECT_SHOW_TYPE_ICON:
					default:
						// 画图标
						reviseXY(feature, hlinkUrl, topoLayer, topoCanvas);
						var textContent:String = StringUtils.isEmpty(hlinkUrl.text) ? hlinkUrl.name : hlinkUrl.text;
						drawIcon(feature, hlinkUrl, hlinkUrl.icon, textContent, topoLayer, topoCanvas);
						break;
				}

			}
		}

		/**
		 * 图标画完之后
		 * @param feature
		 * @param node
		 * @param topoCanvas
		 *
		 */
		override protected function afterDrawIcon(feature:Feature, node:INode, topoLayer:TopoLayer, topoCanvas:TopoCanvas):void
		{
			drawUrlLabel(feature, node as IHLinkUrl);
		}

		override protected function afterDrawShape(feature:Feature, shape:ITPShape, topoLayer:TopoLayer, topoCanvas:TopoCanvas):void
		{
			drawUrlLabel(feature, shape as IHLinkUrl);
		}

		/**
		 * 画URL的label
		 * @param feature
		 * @param hlinkUrl
		 *
		 */
		private function drawUrlLabel(feature:Feature, hlinkUrl:IHLinkUrl):void
		{

			var textContent:String = StringUtils.isEmpty(hlinkUrl.text) ? hlinkUrl.name : hlinkUrl.text;
			var label:Label = drawLabel(feature, hlinkUrl, textContent,false,false);
			if (label)
			{
				label.setStyle("color", hlinkUrl.textColor);
				label.setStyle("fontSize", hlinkUrl.textSize);
			}
		}

	}
}