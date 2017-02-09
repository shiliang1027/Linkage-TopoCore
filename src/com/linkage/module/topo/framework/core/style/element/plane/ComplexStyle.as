package com.linkage.module.topo.framework.core.style.element.plane
{
	import com.linkage.module.topo.framework.core.Feature;
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.model.element.plane.ITPComplex;
	import com.linkage.module.topo.framework.core.parser.ElementProperties;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;
	import com.linkage.module.topo.framework.view.component.TopoLayer;

	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	/**
	 * 复合对象样式(既能体现形状,又能体现节点图标)
	 * @author duangr
	 *
	 */
	public class ComplexStyle extends ShapeStyle
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.core.style.element.plane.ComplexStyle");

		public function ComplexStyle(imageContext:String, fillImageContext:String)
		{
			super(imageContext, fillImageContext);
		}

		override public function select(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):void
		{
			var complex:ITPComplex = element as ITPComplex;
			switch (complex.showType)
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
			var complex:ITPComplex = element as ITPComplex;
			switch (complex.showType)
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

		override public function refreshAlarm(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):void
		{
			var complex:ITPComplex = element as ITPComplex;
			switch (complex.showType)
			{
				case ElementProperties.PROPERTYVALUE_OBJECT_SHOW_TYPE_SHAPE:
					// 形状对象时,不绘制告警
					break;
				case ElementProperties.PROPERTYVALUE_OBJECT_SHOW_TYPE_ICON:
				default:
					super.refreshAlarm(feature, complex, topoLayer, topoCanvas);
					break;
			}
		}

		override public function draw(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):void
		{
			feature.visible = beforeDraw(feature, element, topoLayer, topoCanvas, attributes);
			if (feature.visible)
			{
				initDeepth(feature, element, topoLayer, topoCanvas);
				var complex:ITPComplex = element as ITPComplex;

				switch (complex.showType)
				{
					case ElementProperties.PROPERTYVALUE_OBJECT_SHOW_TYPE_SHAPE:
						// 画形状
						revisePlaneXY(feature, complex, topoLayer, topoCanvas);
						drawShapeWithStyle(feature, complex, topoLayer, topoCanvas);

						break;
					case ElementProperties.PROPERTYVALUE_OBJECT_SHOW_TYPE_ICON:
					default:
						// 画图标
						reviseXY(feature, complex, topoLayer, topoCanvas);
						drawIcon(feature, complex, complex.icon, complex.labelTooltip, topoLayer, topoCanvas);
						break;
				}

			}
		}

	}
}