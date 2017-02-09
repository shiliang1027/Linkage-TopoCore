package com.linkage.module.topo.framework.util
{
	import flash.display.Graphics;
	import flash.geom.Point;

	/**
	 * 数学工具类
	 * @author duangr
	 *
	 */
	public class MathUtil
	{
		
		// 角度转换成弧度的系数  [角度 * 此系数 = 弧度]
		private static const ANGLE_COEFFICIENT:Number = Math.PI / 180.0;

		/**
		 * 角度转弧度
		 * @param angle 角度
		 * @return
		 *
		 */
		public static function angle2radian(angle:Number):Number
		{
			return angle * ANGLE_COEFFICIENT;
		}

		/**
		 * 弧度转角度
		 * @param radian 弧度
		 * @return
		 *
		 */
		public static function radian2angle(radian:Number):Number
		{
			return radian / ANGLE_COEFFICIENT;
		}

		/**
		 * 找到距离目标点的偏移点坐标
		 * @param source
		 * @param target
		 * @param toTargetH 沿 起点->终点 连线,距终点的距离
		 * @param toTargetV 距离 起点->终点 连线垂距
		 * @param left 是否左侧偏移点
		 * @return
		 *
		 */
		public static function findTargetOffsetPoint(source:Point, target:Point, toTargetH:Number, toTargetV:Number, left:Boolean = true):Point
		{
			var offsetPoint:Point;
			var middlePoint:Point;
			var edgeAngle:Number = Math.atan2(target.y - source.y, target.x - source.x);
			middlePoint = Point.polar(Point.distance(target, source) - toTargetH, edgeAngle);
			middlePoint.offset(source.x, source.y);
			if (left)
			{
				offsetPoint = Point.polar(toTargetV, (edgeAngle - (Math.PI / 2.0)));
			}
			else
			{
				offsetPoint = Point.polar(toTargetV, (edgeAngle + (Math.PI / 2.0)));
			}
			offsetPoint.offset(middlePoint.x, middlePoint.y);
			return offsetPoint;
		}

		/**
		 * 找到两点的中心点坐标
		 * @param source
		 * @param target
		 * @return
		 *
		 */
		public static function findCenterPoint(source:Point, target:Point):Point
		{
			var middlePoint:Point = new Point();
			middlePoint.x = (source.x + target.x) / 2;
			middlePoint.y = (source.y + target.y) / 2;
			
			return middlePoint;
		}

		/**
		 * 绘制二阶段贝塞尔曲线(一个控制点)<br>
		 * B(t)=(1-t){pow2} * P0 + 2 * t * (1-t) * P1 + t{pow2} * P2,  t取值[0,1]
		 * @param g
		 * @param p0 起点
		 * @param p1
		 * @param p2 终点
		 *
		 */
		public static function drawBesselSolidCurveLevel2(g:Graphics, p0:Point, p1:Point, p2:Point):void
		{
			var tStep:Number = 0.01;
			g.moveTo(p0.x, p0.y);
			for (var t:Number = 0; t <= 1; t += tStep)
			{
				g.lineTo(findBesselL2(t, p0.x, p1.x, p2.x), findBesselL2(t, p0.y, p1.y, p2.y));
			}

		}

		/**
		 * 绘制二阶段贝塞尔曲线(一个控制点,虚线)<br>
		 * B(t)=(1-t){pow2} * P0 + 2 * t * (1-t) * P1 + t{pow2} * P2,  t取值[0,1]
		 * @param g
		 * @param p0 起点
		 * @param p1
		 * @param p2 终点
		 *
		 */
		public static function drawBesselDashCurveLevel2(g:Graphics, p0:Point, p1:Point, p2:Point, dashLen:uint = 10, dashGap:uint = 10):void
		{
			var tStep:Number = 0.01;
			g.moveTo(p0.x, p0.y);

			var dashPoint1:Point = new Point(p0.x, p0.y);
			var dashPoint2:Point = new Point();
			var drawSolidFlag:Boolean = true;

			for (var t:Number = 0; t <= 1; t += tStep)
			{
				var x:Number = findBesselL2(t, p0.x, p1.x, p2.x);
				var y:Number = findBesselL2(t, p0.y, p1.y, p2.y);
				dashPoint2.x = x;
				dashPoint2.y = y;


				if (drawSolidFlag)
				{
					g.lineTo(x, y);
					if (Point.distance(dashPoint1, dashPoint2) >= dashLen)
					{
						dashPoint1.x = x;
						dashPoint1.y = y;
						drawSolidFlag = false;
					}
				}
				else
				{
					g.moveTo(x, y);
					if (Point.distance(dashPoint1, dashPoint2) >= dashGap)
					{
						dashPoint1.x = x;
						dashPoint1.y = y;
						drawSolidFlag = true;
					}
				}
			}

		}

		/**
		 * 找到2级贝塞尔的曲线的点(x点或者y点)<br>
		 * B(t)=(1-t){pow2} * P0 + 2 * t * (1-t) * P1 + t{pow2} * P2,  t取值[0,1]
		 *
		 * @param t
		 * @param x0
		 * @param x1
		 * @param x2
		 * @return
		 *
		 */
		private static function findBesselL2(t:Number, x0:Number, x1:Number, x2:Number):Number
		{
			return Math.pow((1 - t), 2) * x0 + 2 * t * (1 - t) * x1 + Math.pow(t, 2) * x2;
		}

		/**
		 * 绘制三阶段贝塞尔曲线(两个控制点)<br>
		 * B(t)=(1-t){pow3} * P0 + 3 * t * (1-t){pow2} * P1 + 3 * t{pow2} * (1-t) * P2 + t{pow3} * P3,  t取值[0,1]
		 * @param g
		 * @param p0 起点
		 * @param p1
		 * @param p2
		 * @param p3 终点
		 *
		 */
		public static function drawBesselCurveLevel3(g:Graphics, p0:Point, p1:Point, p2:Point, p3:Point):void
		{
			var tStep:Number = 0.01;
			g.moveTo(p0.x, p0.y);
			for (var t:Number = 0; t <= 1; t += tStep)
			{
				g.lineTo(findBesselL3(t, p0.x, p1.x, p2.x, p3.x), findBesselL3(t, p0.y, p1.y, p2.y, p3.y));
			}
		}

		/**
		 * 找到3级贝塞尔曲线的点 (x点或者y点)<br>
		 * B(t)=(1-t){pow3} * P0 + 3 * t * (1-t){pow2} * P1 + 3 * t{pow2} * (1-t) * P2 + t{pow3} * P3,  t取值[0,1]
		 *
		 * @param t
		 * @param x0
		 * @param x1
		 * @param x2
		 * @param x3
		 * @return
		 *
		 */
		private static function findBesselL3(t:Number, x0:Number, x1:Number, x2:Number, x3:Number):Number
		{
			return Math.pow((1 - t), 3) * x0 + 3 * t * Math.pow((1 - t), 2) * x1 + 3 * Math.pow(t, 2) * (1 - t) * x2 + Math.pow(t, 3) * x3;
		}

		/**
		 * 画折线(实线)
		 * @param g 画笔
		 * @param p0 起点
		 * @param p1 终点
		 *
		 */
		public static function drawSolidPolyline(g:Graphics, p0:Point, p1:Point,location:String="left"):void
		{
			var centerPoint:Point = findCenterPoint(p0,p1);
			g.moveTo(p0.x, p0.y);
			switch(location){
				case "left":
					g.lineTo(p0.x, centerPoint.y);
					g.lineTo(p1.x, centerPoint.y);
					break;
				case "right":
					g.lineTo(centerPoint.x, p0.y);
					g.lineTo(centerPoint.x, p1.y);
					break;
			}
			g.lineTo(p1.x, p1.y);
		}
		
		/**
		 * 画折线(虚线)
		 * @param g 画笔
		 * @param p0 起点
		 * @param p1 终点
		 * @param dashLen 虚线线长度
		 * @param dashGap 虚线间隙
		 */
		public static function drawDashPolyline(g:Graphics, p0:Point, p1:Point,location:String="left", dashLen:uint = 10, dashGap:uint = 10):void
		{
			//TODO
			var centerPoint:Point = findCenterPoint(p0,p1);
//			g.moveTo(p0.x, p0.y);
			var p_1:Point=null;
			var p_2:Point=null;
			switch(location){
				case "left":
					p_1=new Point(p0.x, centerPoint.y);
					p_2=new Point(p1.x, centerPoint.y);
					break;
				case "right":
					p_1=new Point(centerPoint.x, p0.y);
					p_2=new Point(centerPoint.x, p1.y);
					break;
			}
			drawStraightDashLine(g,p0,p_1);
			drawStraightDashLine(g,p_1,p_2);
			drawStraightDashLine(g,p_2,p1);
			
		}
		
		
		
		/**
		 * 画直线(实线)
		 * @param g 画笔
		 * @param p0 起点
		 * @param p1 终点
		 *
		 */
		public static function drawStraightSolidLine(g:Graphics, p0:Point, p1:Point):void
		{
			g.moveTo(p0.x, p0.y);
			g.lineTo(p1.x, p1.y);
		}

		/**
		 * 画直线(虚线)
		 * @param g 画笔
		 * @param p0 起点
		 * @param p1 终点
		 * @param dashLen 虚线线长度
		 * @param dashGap 虚线间隙
		 *
		 */
		public static function drawStraightDashLine(g:Graphics, p0:Point, p1:Point, dashLen:uint = 5, dashGap:uint = 5):void
		{
			var max:Number = Point.distance(p0, p1);
			var l:Number = 0;
			var p3:Point;
			var p4:Point;
			while (l < max)
			{
				p3 = Point.interpolate(p1, p0, l / max);
				l += dashLen;

				if (l > max)
					l = max;
				p4 = Point.interpolate(p1, p0, l / max);
				g.moveTo(p3.x, p3.y);
				g.lineTo(p4.x, p4.y);
				l += dashGap;
			}
		}


		/**
		 * 在目标点画三角箭头
		 * @param g 画笔
		 * @param source
		 * @param target
		 * @param thickness
		 * @param fillColor
		 * @param alpha
		 * @param arrowHeight
		 * @param arrowWidth
		 *
		 */
		public static function drawArrowDeltaAtTarget(g:Graphics, source:Point, target:Point, thickness:Number, fillColor:uint, alpha:Number, arrowHeight:Number, arrowWidth:Number):void
		{
			// 画箭头
			var lArrowBase:Point;
			var rArrowBase:Point;
			var mArrowBase:Point;			
			var edgeAngle:Number;
			var arrowHeadLength:Number = arrowHeight;
			var arrowBaseSize:Number = arrowWidth;
			
			edgeAngle = Math.atan2(target.y - source.y, target.x - source.x);
			mArrowBase = Point.polar(Point.distance(target, source) + arrowHeadLength, edgeAngle);
			mArrowBase.offset(source.x, source.y);

			lArrowBase = Point.polar(arrowBaseSize / 2.9, (edgeAngle - (Math.PI / 2.0)));
			rArrowBase = Point.polar(arrowBaseSize / 2.9, (edgeAngle + (Math.PI / 2.0)));
	
			lArrowBase.offset(target.x,target.y);
			rArrowBase.offset(target.x,target.y);

			g.lineStyle(thickness, fillColor, alpha);
			g.beginFill(fillColor, alpha);
			
			
			g.moveTo(mArrowBase.x, mArrowBase.y);
			g.lineTo(lArrowBase.x, lArrowBase.y);
			g.lineTo(rArrowBase.x, rArrowBase.y);
			g.lineTo(mArrowBase.x, mArrowBase.y);
			
			
			g.endFill();
		}
		/**
		 * 在目标点画固定方向三角箭头
		 * @param g 画笔
		 * @param target
		 * @param direction 0123上右下左
		 * @param thickness
		 * @param fillColor
		 * @param alpha
		 * @param arrowHeight
		 * @param arrowWidth
		 *
		 */
		public static function drawArrowByDirection(g:Graphics, target:Point, direction:String, thickness:Number, fillColor:uint, alpha:Number, arrowHeight:Number, arrowWidth:Number):void
		{
			var lArrowBase:Point=new Point();
			var rArrowBase:Point=new Point();
			var mArrowBase:Point=new Point();
			
			switch(direction)
			{
				//箭头朝向
				//向上
				case "up":
					lArrowBase.x=target.x-arrowWidth/2;
					lArrowBase.y=target.y;
					rArrowBase.x=target.x+arrowWidth/2;
					rArrowBase.y=target.y;
					mArrowBase.x=target.x;
					mArrowBase.y=target.y-arrowHeight;
					break;
				//向右
				case "right":
					lArrowBase.x=target.x;
					lArrowBase.y=target.y-arrowWidth/2;
					rArrowBase.x=target.x;
					rArrowBase.y=target.y+arrowWidth/2;
					mArrowBase.x=target.x+arrowHeight;
					mArrowBase.y=target.y;
					break;
				//向下
				case "down":
					lArrowBase.x=target.x-arrowWidth/2;
					lArrowBase.y=target.y;
					rArrowBase.x=target.x+arrowWidth/2;
					rArrowBase.y=target.y;
					mArrowBase.x=target.x;
					mArrowBase.y=target.y+arrowHeight;
					break;
				//向左
				case "left":
					lArrowBase.x=target.x;
					lArrowBase.y=target.y-arrowWidth/2;
					rArrowBase.x=target.x;
					rArrowBase.y=target.y+arrowWidth/2;
					mArrowBase.x=target.x-arrowHeight;
					mArrowBase.y=target.y;
					break;
				//向右下
				case "right-down":
					lArrowBase.x=target.x+(arrowWidth/2)*Math.cos(Math.PI/4);
					lArrowBase.y=target.y-(arrowWidth/2)*Math.cos(Math.PI/4);
					rArrowBase.x=target.x-(arrowWidth/2)*Math.cos(Math.PI/4);
					rArrowBase.y=target.y+(arrowWidth/2)*Math.cos(Math.PI/4);
					mArrowBase.x=target.x+arrowHeight*Math.cos(Math.PI/4);
					mArrowBase.y=target.y+arrowHeight*Math.cos(Math.PI/4);
					break;
				//向右上
				case "right-up":
					lArrowBase.x=target.x-(arrowWidth/2)*Math.cos(Math.PI/4);
					lArrowBase.y=target.y-(arrowWidth/2)*Math.cos(Math.PI/4);
					rArrowBase.x=target.x+(arrowWidth/2)*Math.cos(Math.PI/4);
					rArrowBase.y=target.y+(arrowWidth/2)*Math.cos(Math.PI/4);
					mArrowBase.x=target.x+arrowHeight*Math.cos(Math.PI/4);
					mArrowBase.y=target.y-arrowHeight*Math.cos(Math.PI/4);
					break;
				//向左上
				case "left-up":
					lArrowBase.x=target.x-(arrowWidth/2)*Math.cos(Math.PI/4);
					lArrowBase.y=target.y+(arrowWidth/2)*Math.cos(Math.PI/4);
					rArrowBase.x=target.x+(arrowWidth/2)*Math.cos(Math.PI/4);
					rArrowBase.y=target.y-(arrowWidth/2)*Math.cos(Math.PI/4);
					mArrowBase.x=target.x-arrowHeight*Math.cos(Math.PI/4);
					mArrowBase.y=target.y-arrowHeight*Math.cos(Math.PI/4);
					break;
				//向左下
				case "left-down":
					lArrowBase.x=target.x-(arrowWidth/2)*Math.cos(Math.PI/4);
					lArrowBase.y=target.y-(arrowWidth/2)*Math.cos(Math.PI/4);
					rArrowBase.x=target.x+(arrowWidth/2)*Math.cos(Math.PI/4);
					rArrowBase.y=target.y+(arrowWidth/2)*Math.cos(Math.PI/4);
					mArrowBase.x=target.x-arrowHeight*Math.cos(Math.PI/4);
					mArrowBase.y=target.y+arrowHeight*Math.cos(Math.PI/4);
					break;
			}
			g.lineStyle(thickness, fillColor, alpha);
			g.beginFill(fillColor, alpha);
			
			
			g.moveTo(mArrowBase.x, mArrowBase.y);
			g.lineTo(lArrowBase.x, lArrowBase.y);
			g.lineTo(rArrowBase.x, rArrowBase.y);
			g.lineTo(mArrowBase.x, mArrowBase.y);
			
			
			g.endFill();
				
		}

	}
}