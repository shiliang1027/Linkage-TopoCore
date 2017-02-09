package com.linkage.module.topo.framework.core.style.element.line
{
	import com.linkage.module.topo.framework.core.ChildFeature;
	import com.linkage.module.topo.framework.core.Feature;
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.model.element.line.ITPLine;
	import com.linkage.module.topo.framework.core.parser.ElementProperties;
	import com.linkage.module.topo.framework.util.AlarmConstants;
	import com.linkage.module.topo.framework.util.MathUtil;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;
	import com.linkage.module.topo.framework.view.component.TopoLayer;
	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;
	
	import flash.display.Graphics;
	import flash.geom.Point;
	
	import mx.effects.IEffectInstance;

	/**
	 * 线样式
	 * @author duangr
	 *
	 */
	public class TPLineStyle extends LineStyle
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.core.style.element.line.TPLineStyle");

		public function TPLineStyle()
		{
			super();
		}

		override public function draw(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):void
		{
			feature.visible = beforeDraw(feature, element, topoLayer, topoCanvas, attributes);
			if (feature.visible)
			{
				initDeepth(feature, element, topoLayer, topoCanvas);
				var line:ITPLine = element as ITPLine;
				drawLineWithStyle(feature, line, topoLayer, topoCanvas, line.lineWidth, line.lineColor); 
				drawLabel(feature, line, line.name,false,false);
				
				creationComplete(feature);
			}
		}

		/**
		 * 画线
		 * @param feature
		 * @param line
		 * @param topoCanvas
		 *
		 */
		private function drawLineWithStyle(feature:Feature, line:ITPLine, topoLayer:TopoLayer, topoCanvas:TopoCanvas, thickness:Number, color:uint):void
		{
			feature.graphics.clear();

			// 将 (x,y)作为自身的坐标, fromPoint,toPoint中都已经是相对自身(x,y)的相对坐标了
			reviseFeatureXY(feature, line, topoLayer);

			// 将 启点,拐点,终点 拼装起来
			var points:Array = [line.fromPoint].concat(line.flexPoints);
			points.push(line.toPoint);

			drawLineBody(feature, line, points, thickness, color);
		}

		/**
		 * 修正自身的坐标和宽,高<br/>
		 * 将 (x,y)作为自身的坐标, fromPoint,toPoint中都已经是相对自身(x,y)的相对坐标了
		 *
		 * @param feature
		 * @param fromPoint
		 * @param toPoint
		 *
		 */
		private function reviseFeatureXY(feature:Feature, line:ITPLine, topoLayer:TopoLayer):void
		{
			var point:Point = topoLayer.xyToLocal(feature, line.x, line.y);
			feature.x = point.x;
			feature.y = point.y;

			feature.width = line.width;
			feature.height = line.height;
		}

		/**
		 * 画线的主体
		 * @param feature
		 * @param line
		 * @param points  路径点集合
		 * @param thickness
		 * @param color
		 *
		 */
		private function drawLineBody(feature:Feature, line:ITPLine, points:Array, thickness:Number, color:uint):void
		{
			// 画线 ,要考虑实线虚线的实线
			// TODO: 位置会还原
			switch (line.lineSymbol)
			{
				case ElementProperties.PROPERTYVALUE_LINE_SYMBOL_DASH:
					drawLineBodyDash(feature, line, points, thickness, color);
					break;
//				case ElementProperties.PROPERTYVALUE_LINE_SYMBOL_POLY:
//					drawPolyline(feature, line, points, thickness, color);
//					break;
				case ElementProperties.PROPERTYVALUE_LINE_SYMBOL_SOLID:
				default:
					drawLineBodySolid(feature, line, points, thickness, color);
					break;
			}
		}

		/**
		 * 画虚线
		 * @param feature
		 * @param line
		 * @param points
		 * @param thickness
		 * @param color
		 *
		 */
		private function drawLineBodyDash(feature:Feature, line:ITPLine, points:Array, thickness:Number, color:uint):void
		{
			var g:Graphics = feature.graphics;
			g.lineStyle(thickness, color, line.lineAlpha);

			var length:uint = points.length;
			points.forEach(function(item:Point, index:int, array:Array):void
				{
					// 只要当前点不是最后一个,就将当前和后一个之间创建连线
					if (index < length - 1)
					{
						MathUtil.drawStraightDashLine(g, item, array[index + 1]);
					}
				});
		}

		/**
		 * 画实线
		 * @param feature
		 * @param line
		 * @param points
		 * @param thickness
		 * @param color
		 *
		 */
		private function drawLineBodySolid(feature:Feature, line:ITPLine, points:Array, thickness:Number, color:uint):void
		{
			var g:Graphics = feature.graphics;
			g.lineStyle(thickness, color, line.lineAlpha);

			var length:uint = points.length;
			points.forEach(function(item:Point, index:int, array:Array):void
				{
					// 只要当前点不是最后一个,就将当前和后一个之间创建连线
					if (index < length - 1)
					{
						MathUtil.drawStraightSolidLine(g, item, array[index + 1]);
					}
				});
		}
		/**
		 * 画折线
		 * @param feature
		 * @param line
		 * @param points
		 * @param thickness
		 * @param color
		 *
		 */
//		private function drawPolyline(feature:Feature, line:ITPLine, points:Array, thickness:Number, color:uint):void
//		{
//			var g:Graphics = feature.graphics;
//			g.lineStyle(thickness, color, line.lineAlpha);
//			
//			var length:uint = points.length;
//			points.forEach(function(item:Point, index:int, array:Array):void
//			{
//				// 只要当前点不是最后一个,就将当前和后一个之间创建连线
//				if (index < length - 1)
//				{
//					MathUtil.drawPolyline(g, item, array[index + 1]);
//				}
//			});
//		}

		override public function select(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):void
		{
			var line:ITPLine = element as ITPLine;
			drawLineWithStyle(feature, line, topoLayer, topoCanvas, line.lineWidth, ElementProperties.DEFAULT_LINE_COLOR_SELECTED);
		}

		override public function unSelect(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):void
		{
			var line:ITPLine = element as ITPLine;
			drawLineWithStyle(feature, line, topoLayer, topoCanvas, line.lineWidth, line.lineColor);
		}

		override public function afterMove(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):void
		{
			// 空方法
		}
	}

}
