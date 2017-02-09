package com.linkage.module.topo.framework.core.parser.element.xml.line
{
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.model.element.line.ITPLine;
	import com.linkage.module.topo.framework.core.parser.ElementProperties;
	import com.linkage.module.topo.framework.view.component.TopoLayer;
	import com.linkage.system.utils.StringUtils;

	import flash.geom.Point;

	/**
	 * 线对象XML解析器
	 * @author duangr
	 *
	 */
	public class TPLineXMLParser extends LineXMLParser
	{

		// 拐点的内分隔符(点内X和Y的)
		private static const POINTS_INNER_SPLIT:String = ",";
		// 拐点的外分隔符(点与点之间的)
		private static const POINTS_OUTTER_SPLIT:String = ";";

		public function TPLineXMLParser()
		{
			super();

			appendNotOutputExtendProperty(ElementProperties.LINE_FLEX_POINTS, "");
		}

		override public function parse(e:IElement, data:Object, topoCanvas:TopoLayer):Boolean
		{
			return super.parse(e, data, topoCanvas) && doParse(e as ITPLine, data, topoCanvas);
		}

		private function doParse(line:ITPLine, data:Object, topoCanvas:TopoLayer):Boolean
		{
			// 先解析自身坐标
			line.x = Number(data.@x);
			line.y = Number(data.@y);

			// 再解析相对自身的偏移坐标
			var value:String = null;
			var array:Array = null;
			// 起点
			value = line.getExtendProperty(ElementProperties.LINE_FROM_POINT);
			if (!StringUtils.isEmpty(value))
			{
				array = value.split(POINTS_INNER_SPLIT)
				if (array.length == 2)
				{
					line.fromPoint = new Point(array[0], array[1]);
				}
			}
			// 终点
			value = line.getExtendProperty(ElementProperties.LINE_TO_POINT);
			if (!StringUtils.isEmpty(value))
			{
				array = value.split(POINTS_INNER_SPLIT)
				if (array.length == 2)
				{
					line.toPoint = new Point(array[0], array[1]);
				}
			}
			// 拐点
			value = line.getExtendProperty(ElementProperties.LINE_FLEX_POINTS);
			if (!StringUtils.isEmpty(value))
			{
				array = value.split(POINTS_OUTTER_SPLIT);
				var flexPoints:Array = [];
				array.forEach(function(xystr:String, index:int, arr:Array):void
					{
						var xy:Array = xystr.split(POINTS_INNER_SPLIT);
						if (xy.length == 2)
						{
							flexPoints.push(new Point(xy[0], xy[1]));
						}
					});
				line.flexPoints = flexPoints;
			}

			// 遍历全部的点,找到范围
			if (line.fromPoint && line.toPoint)
			{
				var maxX:Number = Math.max(line.fromPoint.x, line.toPoint.x);
				var maxY:Number = Math.max(line.fromPoint.y, line.toPoint.y);
				line.flexPoints.forEach(function(item:Point, index:int, array:Array):void
					{
						maxX = Math.max(item.x, maxX);
						maxY = Math.max(item.y, maxY);
					});
				line.width = maxX;
				line.height = maxY;
			}

			return true;
		}

		override protected function outputCommonAttr(e:IElement):String
		{
			var line:ITPLine = e as ITPLine;
			// 将起点,终点放入扩展属性
			line.addExtendProperty(ElementProperties.LINE_FROM_POINT, line.fromPoint.x + POINTS_INNER_SPLIT + line.fromPoint.y);
			line.addExtendProperty(ElementProperties.LINE_TO_POINT, line.toPoint.x + POINTS_INNER_SPLIT + line.toPoint.y);
			// 将拐点信息放入扩展属性
			var pointArray:Array = [];
			line.flexPoints.forEach(function(item:Point, index:int, arr:Array):void
				{
					pointArray.push(item.x + POINTS_INNER_SPLIT + item.y);
				});
			line.addExtendProperty(ElementProperties.LINE_FLEX_POINTS, pointArray.join(POINTS_OUTTER_SPLIT));
			return super.outputCommonAttr(e) + " x=\"" + int(line.x) + "\" y=\"" + int(line.y) + "\"";
		}

	}
}