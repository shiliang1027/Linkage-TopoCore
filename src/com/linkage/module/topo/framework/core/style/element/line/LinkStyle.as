package com.linkage.module.topo.framework.core.style.element.line
{
	import com.linkage.module.topo.framework.Constants;
	import com.linkage.module.topo.framework.controller.event.FeatureEvent;
	import com.linkage.module.topo.framework.core.ChildFeature;
	import com.linkage.module.topo.framework.core.Feature;
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.model.element.line.ILink;
	import com.linkage.module.topo.framework.core.model.element.line.ITPLine;
	import com.linkage.module.topo.framework.core.model.element.line.Link;
	import com.linkage.module.topo.framework.core.model.element.point.ITPPoint;
	import com.linkage.module.topo.framework.core.parser.ElementProperties;
	import com.linkage.module.topo.framework.util.AlarmConstants;
	import com.linkage.module.topo.framework.util.MathUtil;
	import com.linkage.module.topo.framework.util.TopoUtil;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;
	import com.linkage.module.topo.framework.view.component.TopoLayer;
	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;
	import com.linkage.system.utils.StringUtils;
	
	import flash.display.Graphics;
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	import mx.effects.IEffectInstance;
	
	import spark.components.Group;

	/**
	 * 链路样式
	 * @author duangr
	 *
	 */
	public class LinkStyle extends LineStyle
	{
		// log
		private var _element:IElement = null;
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.core.style.element.line.LinkStyle");

		public function LinkStyle()
		{
			super();
		}

		override public function draw(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):void
		{
			var link:ILink = element as ILink;
			var fromFeature:Feature = link.fromElement.feature;
			var toFeature:Feature = link.toElement.feature;
			if (fromFeature.creationComplete && toFeature.creationComplete)
			{
				initLinkStyle(feature, link, topoLayer, topoCanvas);
			}
			else
			{
				if (!fromFeature.creationComplete)
				{
					fromFeature.addEventListener(FeatureEvent.CREATION_COMPLETE, handler_creationComplete);
				}
				if (!toFeature.creationComplete)
				{
					toFeature.addEventListener(FeatureEvent.CREATION_COMPLETE, handler_creationComplete);
				}
			}

			function handler_creationComplete(event:FeatureEvent):void
			{
				// 删除监听的事件
				(event.target as Feature).removeEventListener(FeatureEvent.CREATION_COMPLETE, handler_creationComplete);

				if (fromFeature.creationComplete && toFeature.creationComplete)
				{
					initLinkStyle(feature, link, topoLayer, topoCanvas);
				}
			}
		}

		override public function select(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):void
		{
//			log.info("select");
			var link:ILink = element as ILink;
			
			var dblPoints:DoublePoints = findFromToPoints(feature, topoLayer);//找到起点和终点两个坐标
			var fromPoint:Point = dblPoints.fromPoint;
			var toPoint:Point = dblPoints.toPoint;
			
			reviseFeatureXY(feature, fromPoint, toPoint);// 修正自身的坐标和宽,高
			reviseFromToPoint(feature, fromPoint, toPoint);//修正线的起点/终点坐标,将全局坐标(db)转换为相对链路的本地坐标
			// 清空链路的名称
			feature.removeAllElements();
			drawLinkWithStyle(feature, link, topoLayer, topoCanvas, link.lineWidth, ElementProperties.DEFAULT_LINE_COLOR_SELECTED, link.lineColor);
			// 画链路的提示
			var toolTip:String = link.lineToolTip;
			if (StringUtils.isEmpty(toolTip))
			{
				toolTip = link.name;
			}
			drawLabel(feature, link, toolTip,true,true);
			
			if(link.name !="" && link.name != null )
			{
				_element = feature.element;
				_element.eachExtendProperty(function(key:String, value:String):void
				{
					if(key == "from_mo_name")
					{
						if(value == null || value == "")
						{
							link.cteName = " ";
						}else
						{
							link.cteName = "A端网元："+value;
						}
						
					}else if(key == "from_mo_port")
					{
						if(value == null || value == "")
						{
							link.ctePort = " ";
						}else
						{
							link.ctePort ="(端口："+ value+")";
						}
						
					}else if(key == "to_mo_name")
					{
						if(value == null || value == "")
						{
							link.steName = " ";
						}else
						{
							link.steName = "Z端网元："+value;
						}
					}
					else if(key == "to_mo_port")
					{
						if(value == null || value == "")
						{
							link.stePort = " ";
						}else
						{
							link.stePort ="(端口："+ value+")";
						}
					}
				});
				
				drawRightLineLabel(feature, link, link.cteName,link.ctePort,fromPoint,toPoint,true);
				drawLeftLineLabel(feature, link, link.steName,link.stePort,fromPoint,toPoint,true);
			}
		}
		
		override public function unSelect(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):void
		{
//			log.info("unselect");
			var link:ILink = element as ILink;
			
			var dblPoints:DoublePoints = findFromToPoints(feature, topoLayer);//找到起点和终点两个坐标
			var fromPoint:Point = dblPoints.fromPoint;
			var toPoint:Point = dblPoints.toPoint;
			
			reviseFeatureXY(feature, fromPoint, toPoint);// 修正自身的坐标和宽,高
			reviseFromToPoint(feature, fromPoint, toPoint);//修正线的起点/终点坐标,将全局坐标(db)转换为相对链路的本地坐标
			
			// 清空链路的名称
			feature.removeAllElements();
			drawLinkWithStyle(feature, link, topoLayer, topoCanvas, link.lineWidth, link.lineColor, link.lineColor);
			// 画链路名称
			drawLabel(feature, link, link.name,false,true);
			//合并链路动作之后立即刷新链路告警颜色
			super.refreshAlarm(feature,link,topoLayer,topoCanvas);
			
			if(link.name !="" && link.name != null )
			{
				_element = feature.element;
				_element.eachExtendProperty(function(key:String, value:String):void
				{
					if(key == "from_mo_name")
					{
						if(value == null || value == "")
						{
							link.cteName = " ";
						}else
						{
							link.cteName = "A端网元："+value;
						}
						
					}else if(key == "from_mo_port")
					{
						if(value == null || value == "")
						{
							link.ctePort = " ";
						}else
						{
							link.ctePort ="(端口："+ value+")";
						}
						
					}else if(key == "to_mo_name")
					{
						if(value == null || value == "")
						{
							link.steName = " ";
						}else
						{
							link.steName ="Z端网元："+ value;
						}
					}
					else if(key == "to_mo_port")
					{
						if(value == null || value == "")
						{
							link.stePort = " ";
						}else
						{
							link.stePort ="(端口："+ value+")";
						}
					}
				});
				
				drawRightLineLabel(feature, link, link.cteName,link.ctePort,fromPoint,toPoint,false);
				drawLeftLineLabel(feature, link, link.steName,link.stePort,fromPoint,toPoint,false);
			}
		}

		override protected function beforeDraw(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):Boolean
		{
			feature.graphics.clear();
			var link:ILink = element as ILink;
			// 链路的显隐由两端对象的显隐决定
//			log.info("feature={0},,element={1},,topoLayer={2},,attributes={3}",feature,element,topoLayer,attributes);
//			log.info("link.fromElement.feature.visible={0},,link.toElement.feature.visible={1}",link.fromElement.feature.visible,link.toElement.feature.visible);
//			log.info("feature.parent != null===={0},,,,topoLayer.viewAllEnabled===={1},,,,element.visible==={2}",(feature.parent != null),topoLayer.viewAllEnabled,element.visible);
			var flag:Boolean = super.beforeDraw(feature, element, topoLayer, topoCanvas, attributes) && link.fromElement.feature.visible && link.toElement.feature.visible;
			if (flag)
			{
				// 显示时,判断下: 若链路自身为隐藏,或者链路两端网元存在隐藏,则 alpha=0.5
				// 正常显示时,要保留之前的透明度(主要考虑到高亮功能)
				feature.alpha = (link.visible == 0 || link.fromElement.visible == 0 || link.toElement.visible == 0) ? Constants.DEFAULT_FEATURE_ALPHA_HIDE : Constants.DEFAULT_FEATURE_ALPHA_SHOW * feature.
					alpha;
			}
			return flag;
		}

		override public function refresh(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):void
		{
			initLinkStyle(feature, element as ILink, topoLayer, topoCanvas);
			if (feature.selected)
			{
				select(feature, element, topoLayer, topoCanvas, attributes);
			}
		}
		
		/**
		 * override super refreashAlarm
		 * 覆盖父类刷新告警方法，链路没有展开时需要知道其子对象的告警情况，获取最高级别告警及方向，用于渲染父对象链路
		 */ 
		override public function refreshAlarm(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):void
		{		
			//LineStyle refreashAlarm
			super.refreshAlarm(feature,element,topoLayer,topoCanvas,attributes);
		}

		override public function afterMove(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):void
		{
			initLinkStyle(feature, element as ILink, topoLayer, topoCanvas);
		}

		override protected function initDeepth(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas):void
		{
			// 链路不要每次刷新都算深度
			if (feature.creationComplete)
			{
				return;
			}
			var link:ILink = element as ILink;
			// 修正链路的 elementIndex,位于两端网元最低层次的上面
			var fromElement:ITPPoint = TopoUtil.findElementDrawOnCanvas(link.fromElement);
			var toElement:ITPPoint = TopoUtil.findElementDrawOnCanvas(link.toElement);

			// 参照元素为最低层次的元素
			var referElement:IElement = null;
			// 【做法】修正链路的 elementIndex,位于两端网元中间,具体讲就是位于最网元的上面
			if (fromElement.zindex == toElement.zindex)
			{
				// 深度相同时,找到 elementIndex 最小的作为参照
				referElement = topoLayer.getElementIndex(fromElement.feature) < topoLayer.getElementIndex(toElement.feature) ? fromElement : toElement;
			}
			else
			{
				// 深度不同时,找到 深度最小的作为参照
				referElement = (fromElement.zindex < toElement.zindex) ? fromElement : toElement;
			}
			// 链路和低层次元素处于同一 zindex,但是链路elementIndex要比元素高(默认链路是后加入的,已经低了)
			feature.depth = referElement.zindex;
			// 先把链路放在元素的下面,然后再交换下位置到元素的上面,防止数组越界
			topoLayer.setElementIndex(feature, topoLayer.getElementIndex(referElement.feature));
			topoLayer.swapElements(feature, referElement.feature);
		}

		/**
		 * 初始化链路样式(核心的绘制方法)
		 * @param feature
		 * @param link
		 * @param topoLayer
		 * @param topoCanvas
		 *
		 */
		protected function initLinkStyle(feature:Feature, link:ILink, topoLayer:TopoLayer, topoCanvas:TopoCanvas):void
		{
			feature.visible = beforeDraw(feature, link, topoLayer, topoCanvas);
			if (feature.visible)
			{
				initDeepth(feature, link, topoLayer, topoCanvas);
				drawLinkWithStyle(feature, link, topoLayer, topoCanvas, link.lineWidth, link.lineColor, link.lineColor);
				
				drawLabel(feature, link, link.name,false,true);
				
				var dblPoints:DoublePoints = findFromToPoints(feature, topoLayer);//找到起点和终点两个坐标
				var fromPoint:Point = dblPoints.fromPoint;
				var toPoint:Point = dblPoints.toPoint;
				
				reviseFeatureXY(feature, fromPoint, toPoint);// 修正自身的坐标和宽,高
				reviseFromToPoint(feature, fromPoint, toPoint);//修正线的起点/终点坐标,将全局坐标(db)转换为相对链路的本地坐标
				
				if(link.name !="" && link.name != null )
				{
					_element = feature.element;
					_element.eachExtendProperty(function(key:String, value:String):void
					{
						if(key == "from_mo_name")
						{
							if(value == null || value == "")
							{
								link.cteName = " ";
							}else
							{
								link.cteName ="A端网元："+ value;
							}
							
						}else if(key == "from_mo_port")
						{
							if(value == null || value == "")
							{
								link.ctePort = " ";
							}else
							{
								link.ctePort ="(端口："+ value+")";
							}
							
						}else if(key == "to_mo_name")
						{
							if(value == null || value == "")
							{
								link.steName = " ";
							}else
							{
								link.steName ="Z端网元："+ value;
							}
						}
						else if(key == "to_mo_port")
						{
							if(value == null || value == "")
							{ 
								link.stePort = " ";
							}else
							{
								link.stePort ="(端口："+ value+")";
							}
						}
					});
					
					drawRightLineLabel(feature, link, link.cteName,link.ctePort,fromPoint,toPoint,false);
					drawLeftLineLabel(feature, link, link.steName,link.stePort,fromPoint,toPoint,false);
				}
				creationComplete(feature);
			}
		}

		/**
		 * 画链路
		 * @param feature
		 * @param link
		 * @param topoCanvas
		 *
		 */
		protected function drawLinkWithStyle(feature:Feature, link:ILink, topoLayer:TopoLayer, topoCanvas:TopoCanvas, thickness:Number, color:uint, defColor:uint):void
		{
//			log.info("[drawLinkWithStyle]");
			feature.graphics.clear();
//			feature.removeAllElements();
//			// 将坐标点修正为两端对象的中点
			var dblPoints:DoublePoints = findFromToPoints(feature, topoLayer);//找到起点和终点两个坐标
			var fromPoint:Point = dblPoints.fromPoint;
			var toPoint:Point = dblPoints.toPoint;
			reviseFeatureXY(feature, fromPoint, toPoint);// 修正自身的坐标和宽,高
			reviseFromToPoint(feature, fromPoint, toPoint);
			
//			var linegr:AilkLineGroup = new AilkLineGroup();
//			linegr.width = Math.sqrt(Math.pow(Math.abs(fromPoint.x-toPoint.x),2)+Math.pow(Math.abs(fromPoint.y-toPoint.y),2));
//			linegr.x=fromPoint.x;
//			linegr.y=fromPoint.y;
//			var a:Number = getRotation(fromPoint,toPoint);
//			linegr.rotation=a;
//			log.info("[drawLinkWithStyle]linegr.width:{0},{1},{2},{3},{4}",linegr.width,fromPoint,toPoint,feature,a);
//			feature.addElement(linegr);
			
			// 画链路主体
			drawLinkBodyMain(fromPoint, toPoint, feature, link, topoLayer, topoCanvas, thickness, color, defColor);
//			
//			// 画链路箭头
		
			drawLinkArrowMain(fromPoint, toPoint, feature, link, topoLayer, topoCanvas, thickness, color);
//			var element:IElement; 
//			var line:ITPLine = element as ITPLine; 

		}

		private function getRotation(fromPoint:Point,toPoint:Point):Number{
			return Math.atan((fromPoint.y-toPoint.y) / (fromPoint.x-toPoint.x)) /Math.PI * 180+(fromPoint.x>=toPoint.x?180:0);
		}
		// ================================== //
		//             修正坐标
		// ================================== //

		/**
		 * 找到起点和终点两个坐标
		 * @param feature
		 * @param topoLayer
		 * @return
		 *
		 */
		protected function findFromToPoints(feature:Feature, topoLayer:TopoLayer):DoublePoints
		{
			var link:ILink = feature.element as ILink;
			var fromPoint:Point = topoLayer.xyToLocal(feature, link.fromElement.x, link.fromElement.y);
			var toPoint:Point = topoLayer.xyToLocal(feature, link.toElement.x, link.toElement.y);
			return new DoublePoints(fromPoint, toPoint);
		}

		/**
		 * 修正自身的坐标和宽,高
		 * @param feature
		 * @param fromPoint
		 * @param toPoint
		 *
		 */
		private function reviseFeatureXY(feature:Feature, fromPoint:Point, toPoint:Point):void
		{
			// 计算容器的位置(矩形区域)
			var maxX:Number = Math.max(fromPoint.x, toPoint.x);
			var maxY:Number = Math.max(fromPoint.y, toPoint.y);
			var minX:Number = Math.min(fromPoint.x, toPoint.x);
			var minY:Number = Math.min(fromPoint.y, toPoint.y);
			feature.x = minX;
			feature.y = minY;
			feature.width = maxX - minX;
			feature.height = maxY - minY;
		}

		/**
		 * 修正线的起点/终点坐标,将全局坐标(db)转换为相对链路的本地坐标
		 * @param feature
		 * @param fromPoint
		 * @param toPoint
		 *
		 */
		protected function reviseFromToPoint(feature:Feature, fromPoint:Point, toPoint:Point):void
		{
			// 先修正成相对自身 feature 的点坐标
			// 由于线是在Feature里面绘制的,要将内部点的坐标再减去自身的坐标
			fromPoint.x = fromPoint.x - feature.x;
			fromPoint.y = fromPoint.y - feature.y;
			toPoint.x = toPoint.x - feature.x;
			toPoint.y = toPoint.y - feature.y;

			// 考虑到两端对象都占有一定空间,将两端对象中心点修正成为两端对象的边缘点
//
			var link:ILink = feature.element as ILink;
			switch (link.lineType)
			{
				case ElementProperties.PROPERTYVALUE_LINE_TYPE_BESSEL2: // 二级贝塞尔曲线
				case ElementProperties.PROPERTYVALUE_LINE_TYPE_POLY:
					break;
				default:
					// 修正起点
					var newFromPoint:Point = TopoUtil.reviseAPoint(link.fromElement.feature, fromPoint, toPoint);
					// 修正终点
					var newToPoint:Point = TopoUtil.reviseAPoint(link.toElement.feature, toPoint, fromPoint);
					
					fromPoint.x = newFromPoint.x;
					fromPoint.y = newFromPoint.y;
					toPoint.x = newToPoint.x;
					toPoint.y = newToPoint.y;
					break;
			}
			
		}

		// ================================== //
		//             画body
		// ================================== //

		/**
		 * 画链路的主体(入口方法)
		 *
		 * @param fromPoint
		 * @param toPoint
		 * @param feature
		 * @param link
		 * @param topoLayer
		 * @param topoCanvas
		 * @param thickness
		 * @param color
		 *
		 */
		private function drawLinkBodyMain(fromPoint:Point, toPoint:Point, feature:Feature, link:ILink, topoLayer:TopoLayer, topoCanvas:TopoCanvas, thickness:Number, color:uint, defColor:uint):void
		{
//			log.info("查看日志：fromPoint={0},toPoint={1}",fromPoint,toPoint);
			// 初始化子对象
			if(link.linkCount>0)
			{
				for(var i:int=0;i<link.linkCount;i++)
				{
					createChildFeatureWithoutDraw(i,feature);
				}
			}
			// 画链路主体
			switch (link.lineSymbol)
			{
				case ElementProperties.PROPERTYVALUE_LINE_SYMBOL_DASH:
					if (link.linkCount > 0 && link.expanded)
					{
						drawLinkExpandBodyDash(feature, link, fromPoint, toPoint, thickness, color, defColor);
					}
					else
					{
						drawLinkBodyDash(feature, link, fromPoint, toPoint, thickness, color, defColor);
					}
					break;
				case ElementProperties.PROPERTYVALUE_LINE_SYMBOL_SOLID:
				default:
					if (link.linkCount > 0 && link.expanded)
					{
						drawLinkExpandBodySolid(feature, link, fromPoint, toPoint, thickness, color, defColor);
					}
					else
					{
						drawLinkBodySolid(feature, link, fromPoint, toPoint, thickness, color, defColor);
					}
					break;
			}
		}

		/**
		 * 画闭合时链路的主体(实线)
		 * @param feature
		 * @param link
		 * @param fromPoint
		 * @param toPoint
		 * @param thickness
		 * @param color
		 *
		 */
		private function drawLinkBodySolid(feature:Feature, link:ILink, fromPoint:Point, toPoint:Point, thickness:Number, color:uint, defColor:uint):void
		{
			// 画线 ,要考虑实线虚线的实线
			var g:Graphics = feature.graphics;
			g.lineStyle(thickness, color, link.lineAlpha);
			// 判断是直线还是曲线
			switch (link.lineType)
			{
				case ElementProperties.PROPERTYVALUE_LINE_TYPE_BESSEL2: // 二级贝塞尔曲线
					MathUtil.drawBesselSolidCurveLevel2(g, fromPoint, MathUtil.findTargetOffsetPoint(fromPoint, toPoint, Point.distance(fromPoint, toPoint) / 2, link.linkBessel2OffsetV), toPoint);
					break;
				case ElementProperties.PROPERTYVALUE_LINE_TYPE_POLY: // 折线
					MathUtil.drawSolidPolyline(g, fromPoint, toPoint,link.poly_location);
					break;
				case ElementProperties.PROPERTYVALUE_LINE_TYPE_STRAIGHT: // 直线
				default:
					//如果是多条线路合并也需要一条线分起始到中心，中心到末端两条线
//					if(link.linkCount>0)
//					if(true)
//					{
//						var ui:Group = new Group();
//						ui.x = 0;
//						ui.y = 0;
//						ui.width = feature.width;
//						ui.height = feature.height;
//						feature.addElement(ui);
//						feature.toElement = ui;
//						g = feature.toElement.graphics;
//						g.lineStyle(thickness, (feature.selected ? color : defColor), link.lineAlpha);
//						var pointC:Point = MathUtil.findCenterPoint(fromPoint, toPoint);
//						MathUtil.drawStraightSolidLine(g, toPoint, pointC);
//						
//						ui = new Group();
//						ui.x = 0;
//						ui.y = 0;
//						ui.width = feature.width;
//						ui.height = feature.height;
//						feature.addElement(ui);
//						feature.fromElement = ui;
//						g = feature.fromElement.graphics;
//						g.lineStyle(thickness, (feature.selected ? color : defColor), link.lineAlpha);
//						
						MathUtil.drawStraightSolidLine(g, fromPoint, toPoint);
//					}
//					else
//					{
//						MathUtil.drawStraightSolidLine(g, fromPoint, toPoint);
//					}
					break;
			}
		}

		/**
		 * 画闭合时链路的主体(虚线)
		 * @param feature
		 * @param link
		 * @param fromPoint
		 * @param toPoint
		 * @param thickness
		 * @param color
		 *
		 */
		private function drawLinkBodyDash(feature:Feature, link:ILink, fromPoint:Point, toPoint:Point, thickness:Number, color:uint, defColor:uint):void
		{
			// 画线 ,要考虑实线虚线的实线
			var g:Graphics = feature.graphics;
			g.lineStyle(thickness, color, link.lineAlpha);
			// 判断是直线还是曲线
			switch (link.lineType)
			{
				case ElementProperties.PROPERTYVALUE_LINE_TYPE_BESSEL2: // 二级贝塞尔曲线
					MathUtil.drawBesselDashCurveLevel2(g, fromPoint, MathUtil.findTargetOffsetPoint(fromPoint, toPoint, Point.distance(fromPoint, toPoint) / 2, link.linkBessel2OffsetV), toPoint);
					break;
				case ElementProperties.PROPERTYVALUE_LINE_TYPE_POLY: // 折线
					MathUtil.drawDashPolyline(g, fromPoint, toPoint,link.poly_location);
					break;
				case ElementProperties.PROPERTYVALUE_LINE_TYPE_STRAIGHT: // 直线
				default:
					//如果是多条线路合并也需要一条线分起始到中心，中心到末端两条线
//					if(link.linkCount>0)
//					{
//						var ui:Group = new Group();
//						//ui.x = 0;
//						//ui.y = 0;
//						//ui.width = feature.width;
//						//ui.height = feature.height;
//						
//						if(!feature.fromElement)
//						{
//							feature.addElement(ui);
//							feature.fromElement = ui;
//						}
//						g = feature.fromElement.graphics;
//						g.lineStyle(thickness, (feature.selected ? color : defColor), link.lineAlpha);
//						
//						var pointC:Point = MathUtil.findCenterPoint(fromPoint, toPoint);
//						
//						MathUtil.drawStraightDashLine(g, toPoint, pointC);
//
//						if(!feature.toElement)
//						{
//							feature.addElement(ui);
//							feature.toElement = ui;
//						}
//						g = feature.toElement.graphics;
//						g.lineStyle(thickness, (feature.selected ? color : defColor), link.lineAlpha);
//						
//						MathUtil.drawStraightDashLine(g, pointC, fromPoint);
//					}
//					else
//					{
						MathUtil.drawStraightDashLine(g, fromPoint, toPoint);
//					}
					break;
			}
		}
		
		/**
		 * 画展开时链路主体(实线)
		 * @param feature
		 * @param link
		 * @param fromPoint
		 * @param toPoint
		 * @param thickness
		 * @param color
		 * @param defColor
		 *
		 */
		private function drawLinkExpandBodySolid(feature:Feature, link:ILink, fromPoint:Point, toPoint:Point, thickness:Number, color:uint, defColor:uint):void
		{
			var childFeature:ChildFeature = null;
			var g:Graphics = null;
			var i:int = 0;
			var offsetH:Number = link.linkOpenOffsetH;
			var offsetV:Number = 0;
			var point1:Point = null;
			var point2:Point = null;
			var pointC:Point = null;
			var linkColor:String="";
			var preColor:uint=defColor;
			switch (link.linkOpenType)
			{
				case ElementProperties.PROPERTYVALUE_LINK_OPEN_TYPE_ARC: // 圆弧拐点

					for (i = 0; i < link.linkCount; i++)
					{
						linkColor=link.getExtendProperty("mo_port_color_"+(i+1));
						
						if(!StringUtils.isEmpty(linkColor)){
							defColor=new uint(linkColor);
						}else{
							defColor=preColor;
						}
						
						
						childFeature = createChildFeature(i, feature);
						g = findFromExpandChild(childFeature).graphics;
						g.lineStyle(thickness, (childFeature.selectStatue ? color : defColor), link.lineAlpha);

						offsetV = findOffsetV(i, link.linkCount, link.linkOpenGap);
						point1 = MathUtil.findTargetOffsetPoint(toPoint, fromPoint, offsetH, offsetV, true);
						point2 = MathUtil.findTargetOffsetPoint(fromPoint, toPoint, offsetH, offsetV, false);
						var point1c:Point = MathUtil.findTargetOffsetPoint(toPoint, fromPoint, 0, offsetV, true);
						var point2c:Point = MathUtil.findTargetOffsetPoint(fromPoint, toPoint, 0, offsetV, false);
						pointC = MathUtil.findCenterPoint(point1, point2);

						MathUtil.drawBesselSolidCurveLevel2(g, fromPoint, point1c, point1);
						MathUtil.drawStraightSolidLine(g, point1, pointC);
						
						
						g = findToExpandChild(childFeature).graphics;
						g.lineStyle(thickness, (childFeature.selectStatue ? color : defColor), link.lineAlpha);
						MathUtil.drawStraightSolidLine(g, pointC, point2);
						MathUtil.drawBesselSolidCurveLevel2(g, point2, point2c, toPoint);
					}

					break;
				case ElementProperties.PROPERTYVALUE_LINK_OPEN_TYPE_PARALLEL: // 不画拐点

					for (i = 0; i < link.linkCount; i++)
					{
						linkColor=link.getExtendProperty("mo_port_color_"+(i+1));
						
						if(!StringUtils.isEmpty(linkColor)){
							defColor=new uint(linkColor);
						}else{
							defColor=preColor;
						}
						
						childFeature = createChildFeature(i, feature);
						
						g = findFromExpandChild(childFeature).graphics;
						g.lineStyle(thickness, (childFeature.selectStatue ? color : defColor), link.lineAlpha);

						offsetV = findOffsetV(i, link.linkCount, link.linkOpenGap);
						point1 = MathUtil.findTargetOffsetPoint(toPoint, fromPoint, offsetH, offsetV, true);
						point2 = MathUtil.findTargetOffsetPoint(fromPoint, toPoint, offsetH, offsetV, false);
						pointC = MathUtil.findCenterPoint(point1, point2);

						MathUtil.drawStraightSolidLine(g, point1, pointC);
						
						g = findToExpandChild(childFeature).graphics;
						g.lineStyle(thickness, (childFeature.selectStatue ? color : defColor), link.lineAlpha);
						MathUtil.drawStraightSolidLine(g, pointC, point2);
					}

					break;
				case ElementProperties.PROPERTYVALUE_LINK_OPEN_TYPE_TRIANGLE: // 三角直连
				default:
					
					// 找到拐点,直接连线
					for (i = 0; i < link.linkCount; i++)
					{
						linkColor=link.getExtendProperty("mo_port_color_"+(i+1));
						
						if(!StringUtils.isEmpty(linkColor)){
							defColor=new uint(linkColor);
						}else{
							defColor=preColor;
						}
						childFeature = createChildFeature(i, feature);
						
						g = findFromExpandChild(childFeature).graphics;
						g.lineStyle(thickness, (childFeature.selectStatue ? color : defColor), link.lineAlpha);

						offsetV = findOffsetV(i, link.linkCount, link.linkOpenGap);
						point1 = MathUtil.findTargetOffsetPoint(toPoint, fromPoint, offsetH, offsetV, true);
						point2 = MathUtil.findTargetOffsetPoint(fromPoint, toPoint, offsetH, offsetV, false);
						pointC = MathUtil.findCenterPoint(point1, point2);
						
						
						MathUtil.drawStraightSolidLine(g, fromPoint, point1);
						MathUtil.drawStraightSolidLine(g, point1, pointC);
						
						g = findToExpandChild(childFeature).graphics;
						g.lineStyle(thickness, (childFeature.selectStatue ? color : defColor), link.lineAlpha);
						
						MathUtil.drawStraightSolidLine(g, pointC, point2);
						MathUtil.drawStraightSolidLine(g, point2, toPoint);
					}
					break;
			}
		}

		/**
		 * 画展开时链路主体(虚线)
		 * @param feature
		 * @param link
		 * @param fromPoint
		 * @param toPoint
		 * @param thickness
		 * @param color
		 * @param defColor
		 *
		 */
		private function drawLinkExpandBodyDash(feature:Feature, link:ILink, fromPoint:Point, toPoint:Point, thickness:Number, color:uint, defColor:uint):void
		{
			var childFeature:ChildFeature = null;
			var g:Graphics = null;
			var i:int = 0;
			var offsetH:Number = link.linkOpenOffsetH;
			var offsetV:Number = 0;
			var point1:Point = null;
			var point2:Point = null;
			var pointC:Point = null;
			var linkColor:String="";
			var preColor:uint=defColor;
			switch (link.linkOpenType)
			{
				case ElementProperties.PROPERTYVALUE_LINK_OPEN_TYPE_ARC: // 圆弧拐点

					for (i = 0; i < link.linkCount; i++)
					{
						linkColor=link.getExtendProperty("mo_port_color_"+(i+1));
						
						if(!StringUtils.isEmpty(linkColor)){
							defColor=new uint(linkColor);
						}else{
							defColor=preColor;
						}
						
						childFeature = createChildFeature(i, feature);
						
						g = findFromExpandChild(childFeature).graphics;
						g.lineStyle(thickness, (childFeature.selectStatue ? color : defColor), link.lineAlpha);

						offsetV = findOffsetV(i, link.linkCount, link.linkOpenGap);
						point1 = MathUtil.findTargetOffsetPoint(toPoint, fromPoint, offsetH, offsetV, true);
						point2 = MathUtil.findTargetOffsetPoint(fromPoint, toPoint, offsetH, offsetV, false);
						var point1c:Point = MathUtil.findTargetOffsetPoint(toPoint, fromPoint, 0, offsetV, true);
						var point2c:Point = MathUtil.findTargetOffsetPoint(fromPoint, toPoint, 0, offsetV, false);
						pointC = MathUtil.findCenterPoint(point1, point2);

						MathUtil.drawBesselDashCurveLevel2(g, fromPoint, point1c, point1);
						MathUtil.drawStraightDashLine(g, point1, pointC);
						
						
						g = findToExpandChild(childFeature).graphics;
						g.lineStyle(thickness, (childFeature.selectStatue ? color : defColor), link.lineAlpha);
						MathUtil.drawStraightDashLine(g, pointC, point2);
						MathUtil.drawBesselDashCurveLevel2(g, point2, point2c, toPoint);
					}

					break;
				case ElementProperties.PROPERTYVALUE_LINK_OPEN_TYPE_PARALLEL: // 不画拐点

					for (i = 0; i < link.linkCount; i++)
					{
						linkColor=link.getExtendProperty("mo_port_color_"+(i+1));
						
						if(!StringUtils.isEmpty(linkColor)){
							defColor=new uint(linkColor);
						}else{
							defColor=preColor;
						}
						
						childFeature = createChildFeature(i, feature);
						
						g = findFromExpandChild(childFeature).graphics;
						g.lineStyle(thickness, (childFeature.selectStatue ? color : defColor), link.lineAlpha);

						offsetV = findOffsetV(i, link.linkCount, link.linkOpenGap);
						point1 = MathUtil.findTargetOffsetPoint(toPoint, fromPoint, offsetH, offsetV, true);
						point2 = MathUtil.findTargetOffsetPoint(fromPoint, toPoint, offsetH, offsetV, false);
						pointC = MathUtil.findCenterPoint(point1, point2);

						MathUtil.drawStraightDashLine(g, point1, pointC);
						
						g = findToExpandChild(childFeature).graphics;
						g.lineStyle(thickness, (childFeature.selectStatue ? color : defColor), link.lineAlpha);
						MathUtil.drawStraightDashLine(g, pointC, point2);
					}

					break;
				case ElementProperties.PROPERTYVALUE_LINK_OPEN_TYPE_TRIANGLE: // 三角直连
				default:
					// 找到拐点,直接连线
					for (i = 0; i < link.linkCount; i++)
					{
						linkColor=link.getExtendProperty("mo_port_color_"+(i+1));
						
						if(!StringUtils.isEmpty(linkColor)){
							defColor=new uint(linkColor);
						}else{
							defColor=preColor;
						}
						
						childFeature = createChildFeature(i, feature);
						
//						log.warn("找到拐点,直接连线:" + childFeature.selectStatue);
						
						g = findFromExpandChild(childFeature).graphics;
						g.lineStyle(thickness, (childFeature.selectStatue ? color : defColor), link.lineAlpha);

						offsetV = findOffsetV(i, link.linkCount, link.linkOpenGap);
						point1 = MathUtil.findTargetOffsetPoint(toPoint, fromPoint, offsetH, offsetV, true);
						point2 = MathUtil.findTargetOffsetPoint(fromPoint, toPoint, offsetH, offsetV, false);
						pointC = MathUtil.findCenterPoint(point1, point2);
						
						MathUtil.drawStraightDashLine(g, fromPoint, point1);
						MathUtil.drawStraightDashLine(g, point1, pointC);
						
						g = findToExpandChild(childFeature).graphics;
						g.lineStyle(thickness, (childFeature.selectStatue ? color : defColor), link.lineAlpha);
						
						MathUtil.drawStraightDashLine(g, pointC, point2);
						MathUtil.drawStraightDashLine(g, point2, toPoint);
					}
					break;
			}
		}
		
		/**
		 * 创建子对象
		 */ 
		private function createChildFeature(num:int, feature:Feature):ChildFeature
		{
			var key:String = String(num + 1);
			var childFeature:ChildFeature = feature.childMap.get(key);
			if(childFeature == null)
			{
				childFeature = new ChildFeature();
			}
			feature.addElement(childFeature);
			return childFeature;
		}
		
		private function createChildFeatureWithoutDraw(num:int, feature:Feature):void
		{
			var key:String = String(num + 1);
			var childFeature:ChildFeature = feature.childMap.get(key);
			if(childFeature == null)
			{
				childFeature = new ChildFeature();
				childFeature.featureKey = key;
			}
			feature.childMap.put(key,childFeature);
		}
		
		/**
		 * 找到展开的子可视对象
		 * @param feature
		 * @return
		 *
		 */
		private function findFromExpandChild(feature:ChildFeature):UIComponent
		{
			var ui:Group = new Group();
			ui.x = 0;
			ui.y = 0;
			ui.width = feature.width;
			ui.height = feature.height;
			feature.addFromElement(ui);
			return ui;
		}
		
		/**
		 * 找到展开的子可视对象
		 * @param feature
		 * @return
		 *
		 */
		private function findToExpandChild(feature:ChildFeature):UIComponent
		{
			var ui:Group = new Group();
			ui.x = 0;
			ui.y = 0;
			ui.width = feature.width;
			ui.height = feature.height;
			feature.addToElement(ui);
			return ui;
		}

		/**
		 * 查找垂直偏移量
		 * @param index
		 * @param count
		 * @param gap
		 * @return
		 *
		 */
		private function findOffsetV(index:int, count:int, gap:Number):Number
		{
			var offsetV:Number = 0;
			if (index % 2 == 0)
			{
				offsetV = gap * index / 2;
			}
			else
			{
				offsetV = -gap * (index + 1) / 2;
			}
			// 偶数时做偏移
			if (count % 2 == 0)
			{
				offsetV = offsetV + gap / 2;
			}
			return offsetV;
		}


		// ================================== //
		//             画Arrow
		// ================================== //

		/**
		 * 画链路箭头(入口方法)
		 *
		 * @param fromPoint
		 * @param toPoint
		 * @param feature
		 * @param link
		 * @param topoLayer
		 * @param topoCanvas
		 * @param thickness
		 * @param color
		 *
		 */
		private function drawLinkArrowMain(fromPoint:Point, toPoint:Point, feature:Feature, link:ILink, topoLayer:TopoLayer, topoCanvas:TopoCanvas, thickness:Number, color:uint):void
		{
			// 根据线类型画箭头
			
			if(link.lineType==ElementProperties.PROPERTYVALUE_LINE_TYPE_POLY)
			{
				if (link.linkFromArrowEnable)
				{
					drawArrowByLineType(link.linkFromArrowType, feature, link.lineAlpha, toPoint, fromPoint, thickness, color, link.linkFromArrowHeight, link.linkFromArrowWidth);
				}
				if (link.linkToArrowEnable)
				{
					drawArrowByLineType(link.linkToArrowType, feature, link.lineAlpha, fromPoint, toPoint, thickness, color, link.linkToArrowHeight, link.linkToArrowWidth);
				}
			}
			else{
				
				if (link.linkFromArrowEnable)
				{
					drawArrowByType(link.linkFromArrowType, feature, link.lineAlpha, toPoint, fromPoint, thickness, color, link.linkFromArrowHeight, link.linkFromArrowWidth);
				}
				if (link.linkToArrowEnable)
				{
					drawArrowByType(link.linkToArrowType, feature, link.lineAlpha, fromPoint, toPoint, thickness, color, link.linkToArrowHeight, link.linkToArrowWidth);
				}
			}
			
			
			
		}

		/**
		 * 根据箭头类型画箭头
		 * @param linkType
		 * @param feature
		 * @param link
		 * @param source
		 * @param target
		 * @param thickness
		 * @param fillColor
		 *
		 */
		private function drawArrowByType(linkType:String, feature:Feature, alpha:Number, source:Point, target:Point, thickness:Number, fillColor:uint, arrowHeight:Number, arrowWidth:Number):void
		{
//			log.debug("开始根据类型画箭头 {0} ", linkType);
			switch (linkType)
			{
				case ElementProperties.PROPERTYVALUE_LINK_ARROW_TYPE_DELTA:
					MathUtil.drawArrowDeltaAtTarget(feature.graphics, source, target, thickness, fillColor, alpha, arrowHeight, arrowWidth);
					break;
				
			}
		}
		/**
		 * 画折线的箭头
		 * @param linkType
		 * @param feature
		 * @param link
		 * @param source
		 * @param target
		 * @param thickness
		 * @param fillColor
		 *
		 */
		private function drawArrowByLineType(linkType:String, feature:Feature, alpha:Number, source:Point, target:Point, thickness:Number, fillColor:uint, arrowHeight:Number, arrowWidth:Number):void
		{
			switch (linkType)
			{
				case ElementProperties.PROPERTYVALUE_LINK_ARROW_TYPE_DELTA:
					var edgeAngle:Number = Math.atan2(source.y - target.y, source.x - target.x);
					if(edgeAngle>=Math.PI*0.875||edgeAngle<=-Math.PI*0.875){
						MathUtil.drawArrowByDirection(feature.graphics, target,"right", thickness, fillColor, alpha, arrowHeight, arrowWidth);						
					}else if(edgeAngle>Math.PI*0.625){
						MathUtil.drawArrowByDirection(feature.graphics, target,"right-up", thickness, fillColor, alpha, arrowHeight, arrowWidth);
					}else if(edgeAngle>Math.PI*0.375){	
						MathUtil.drawArrowByDirection(feature.graphics, target,"up", thickness, fillColor, alpha, arrowHeight, arrowWidth);	
					}else if(edgeAngle>Math.PI*0.125){
						MathUtil.drawArrowByDirection(feature.graphics, target,"left-up", thickness, fillColor, alpha, arrowHeight, arrowWidth);	
					}else if(edgeAngle>-Math.PI*0.125){
						MathUtil.drawArrowByDirection(feature.graphics, target,"left", thickness, fillColor, alpha, arrowHeight, arrowWidth);
					}else if(edgeAngle>-Math.PI*0.375){
						MathUtil.drawArrowByDirection(feature.graphics, target,"left-down", thickness, fillColor, alpha, arrowHeight, arrowWidth);	
					}else if(edgeAngle>-Math.PI*0.625){	
						MathUtil.drawArrowByDirection(feature.graphics, target,"down", thickness, fillColor, alpha, arrowHeight, arrowWidth);
					}else{
						MathUtil.drawArrowByDirection(feature.graphics, target,"right-down", thickness, fillColor, alpha, arrowHeight, arrowWidth);
					}
					break;
			}
		}
	}
}