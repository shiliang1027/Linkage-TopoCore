package com.linkage.module.topo.framework.core.style.element.point
{
	import com.linkage.module.topo.framework.core.Feature;
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.model.element.point.ITPText;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;
	import com.linkage.module.topo.framework.view.component.TopoLayer;
	import com.linkage.system.utils.StringUtils;

	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	import spark.components.Label;

	/**
	 * 文本样式
	 * @author duangr
	 *
	 */
	public class TPTextStyle extends PointStyle
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.core.style.element.point.TPTextStyle");

		public function TPTextStyle()
		{
			super();
		}

		override public function select(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):void
		{
			feature.setStyle("fontWeight", "bold");
		}

		override public function unSelect(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):void
		{
			feature.setStyle("fontWeight", "normal");
		}

		override public function refreshAlarm(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):void
		{
			// 文本不体现告警,空方法
		}

		override public function draw(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):void
		{
			feature.visible = beforeDraw(feature, element, topoLayer, topoCanvas, attributes);
			if (feature.visible)
			{
				initDeepth(feature, element, topoLayer, topoCanvas);
				var text:ITPText = element as ITPText;

				reviseXY(feature, text, topoLayer, topoCanvas);
				drawTextBody(feature, text, topoLayer, topoCanvas);
				creationComplete(feature);
			}
		}

		/**
		 * 画文本对象的主体
		 * @param feature
		 * @param text
		 * @param topoCanvas
		 *
		 */
		private function drawTextBody(feature:Feature, text:ITPText, topoLayer:TopoLayer, topoCanvas:TopoCanvas):void
		{
			var textContent:String = StringUtils.isEmpty(text.text) ? text.name : text.text;
			var label:Label = new Label();
			label.text = textContent;

			label.setStyle("color", text.textColor);
			label.setStyle("fontSize", text.textSize);
			feature.addElement(label);
		}
	}
}