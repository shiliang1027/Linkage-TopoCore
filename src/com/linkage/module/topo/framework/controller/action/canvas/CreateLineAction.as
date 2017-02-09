package com.linkage.module.topo.framework.controller.action.canvas
{
	import com.linkage.module.topo.framework.Constants;
	import com.linkage.module.topo.framework.controller.event.TopoEvent;
	import com.linkage.module.topo.framework.core.Feature;
	import com.linkage.module.topo.framework.core.parser.ElementProperties;
	import com.linkage.module.topo.framework.util.MathUtil;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;
	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;
	import com.linkage.system.structure.map.IMap;
	import com.linkage.system.structure.map.Map;

	import flash.display.Graphics;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	import spark.components.Group;

	/**
	 * 创建线对象的模式<br/>
	 * <pre>
	 * 操作模式:
	 * 1.鼠标在空白处点下,当抬起时创建第一个起点.
	 * 2.鼠标移动时绘制线的路径
	 * 3.鼠标点下,当抬起时创建第二个点
	 * 4.鼠标双击后抬起时,创建终点.
	 * </pre>
	 *
	 * @author duangr
	 *
	 */
	public class CreateLineAction extends CanvasAction
	{
		// log
		private static const log:ILogger = Log.getLogger("com.linkage.module.topo.framework.controller.action.canvas.CreateLineAction");

		private var _createLineThickness:uint = Constants.DEFAULT_CREATELINK_LINE_SIZE;
		private var _createLineColor:uint = Constants.DEFAULT_CREATELINK_LINE_COLOR;
		private var _createLineSymbol:String = ElementProperties.DEFAULT_LINE_SYMBOL;
		private var _createLineAlpha:Number = ElementProperties.DEFAULT_LINE_ALPHA;

		// 线的绘制区域(缓存的线,拐点之前的线放在这里面)
		private var _cacheShape:Group = new Group();
		// 线的绘制区域(当前临时的线,拐点之后的放在这里面)
		private var _tempShape:Group = new Group();

		// 上一次缓存的点
		private var _lastPoint:Point = null;
		// 当前移动到的点
		private var _currentPoint:Point = null;

		// 绘制过程中缓存的点
		private var _cachePoints:Array = [];
		private var _drawing:Boolean = false;

		// -------- 单件实例 ---------
		private static var _instance:CreateLineAction = null;

		public function CreateLineAction(canvas:TopoCanvas, pvt:_PrivateClass)
		{
			super(canvas);
			if (pvt == null)
			{
				throw new ArgumentError("CreateLineAction构造时,参数[pvt:_PrivateClass]不能为null!");
			}
		}

		/**
		 * 获取单件实例
		 * @return
		 *
		 */
		public static function getInstance(canvas:TopoCanvas):CreateLineAction
		{
			if (_instance == null)
			{
				_instance = new CreateLineAction(canvas, new _PrivateClass());
			}
			return _instance;
		}

		override public function get name():String
		{
			return "创建线对象模式";
		}

		public function set createLineThickness(value:uint):void
		{
			_createLineThickness = value;
			drawLineFlexPoint();
			drawLineMoving();
		}

		public function set createLineColor(value:uint):void
		{
			_createLineColor = value;
			drawLineFlexPoint();
			drawLineMoving();
		}

		public function set createLineSymbol(value:String):void
		{
			_createLineSymbol = value;
			drawLineFlexPoint();
			drawLineMoving();
		}

		public function set createLineAlpha(value:Number):void
		{
			_createLineAlpha = value;

			_cacheShape.alpha = _createLineAlpha;
			_tempShape.alpha = _createLineAlpha;
		}


		override public function onUpWithDownCanvasNoMove(event:MouseEvent, mouseCanvasPoint:Point, upFeature:Feature):void
		{
			// 创建点
			savePoint(mouseCanvasPoint);
		}

		override public function onUpWithDownCanvasAndMove(event:MouseEvent, mouseCanvasPoint:Point, upFeature:Feature):void
		{
			// 创建点
			savePoint(mouseCanvasPoint);
		}

		override public function onMoveWithoutDown(event:MouseEvent, mouseCanvasPoint:Point):void
		{
			// 移动
			_currentPoint = mouseCanvasPoint;
			drawLineMoving();
		}

		override public function onDoubleClickCanvas(event:MouseEvent, mouseCanvasPoint:Point):void
		{
			// 双击结束画线
			saveEndPoint(mouseCanvasPoint);
		}

		/**
		 * 保存点
		 * @param point
		 *
		 */
		private function savePoint(point:Point):void
		{
			if (_cachePoints.length == 0)
			{
				// 这是第一个点
				_cachePoints.push(point);

				// 开始画线
				drawLineStart();
			}
			else
			{
				// 这是中间的拐点
				_cachePoints.push(point);

				// 画线的拐点(拐点之前的放入缓存形状中,拐点之后的还是放在临时形状中)
				drawLineFlexPoint();
			}
			_lastPoint = point;
		}

		/**
		 * 保存线的终点
		 * @param point
		 *
		 */
		private function saveEndPoint(endPoint:Point):void
		{
			drawLineEnd();
			// 由于是双击结束的,因此列表中已经放入了终点两遍
			clearEndRepeatPoint();
			if (_cachePoints.length == 0)
			{
				return;
			}
			_cachePoints.push(endPoint);
			triggerCreateEvent(_cachePoints);
			_cachePoints.length = 0;

			// 清除终点的重复数据
			function clearEndRepeatPoint():void
			{
				if (_cachePoints.length == 0)
				{
					return;
				}
				var lp:Point = _cachePoints[_cachePoints.length - 1];
				if (endPoint.equals(lp))
				{
					_cachePoints.pop();
					clearEndRepeatPoint();
				}
			}
		}

		/**
		 * 清除全部的点
		 *
		 */
		public function clearAllPoints():void
		{
			drawLineEnd();
			_cachePoints.length = 0;
		}

		/**
		 * 清除上一个点
		 *
		 */
		public function clearLastPoint():void
		{
			// 至少缓存了2个点,才能清除上一个,否则就是全部清除
			if (_cachePoints.length > 1)
			{
				_cachePoints.pop();
				drawLineFlexPoint();
				_lastPoint = _cachePoints[_cachePoints.length - 1];
				drawLineMoving();
			}
			else
			{
				clearAllPoints();
			}
		}

		// ----------------- 绘图的过程 --------------

		/**
		 * 开始画线
		 *
		 */
		private function drawLineStart():void
		{
			_drawing = true;

			if (!_canvas.contains(_cacheShape))
			{
				_canvas.addElement(_cacheShape);
			}
			_cacheShape.visible = true;

			if (!_canvas.contains(_tempShape))
			{
				_canvas.addElement(_tempShape);
			}
			_tempShape.visible = true;
		}

		/**
		 * 绘制移动过程中的线的轨迹
		 *
		 */
		private function drawLineMoving():void
		{
			if (!_drawing)
			{
				return
			}
			var g:Graphics = _tempShape.graphics;
			g.clear();
			g.lineStyle(_createLineThickness, _createLineColor);

			switch (_createLineSymbol)
			{
				case ElementProperties.PROPERTYVALUE_LINE_SYMBOL_DASH:
					MathUtil.drawStraightDashLine(g, _lastPoint, _currentPoint);
					break
				case ElementProperties.PROPERTYVALUE_LINE_SYMBOL_SOLID:
				default:
					MathUtil.drawStraightSolidLine(g, _lastPoint, _currentPoint);
					break;
			}
		}

		/**
		 * 绘制拐点前的线
		 *
		 */
		private function drawLineFlexPoint():void
		{
			var length:uint = _cachePoints.length;
			if (length == 0)
			{
				return;
			}
			var g:Graphics = _cacheShape.graphics;
			g.clear();
			g.lineStyle(_createLineThickness, _createLineColor);

			_cachePoints.forEach(function(item:Point, index:int, array:Array):void
				{
					// 只要当前点不是最后一个,就将当前和后一个之间创建连线
					if (index < length - 1)
					{
						switch (_createLineSymbol)
						{
							case ElementProperties.PROPERTYVALUE_LINE_SYMBOL_DASH:
								MathUtil.drawStraightDashLine(g, item, array[index + 1]);
								break
							case ElementProperties.PROPERTYVALUE_LINE_SYMBOL_SOLID:
							default:
								MathUtil.drawStraightSolidLine(g, item, array[index + 1]);
								break;
						}
					}
				});
		}

		/**
		 * 结束画线
		 *
		 */
		private function drawLineEnd():void
		{
			_drawing = false;
			_cacheShape.graphics.clear();
			_cacheShape.visible = false;
			_tempShape.graphics.clear();
			_tempShape.visible = false;
		}

		// ----------------- 事件 --------------
		/**
		 * 触发创建事件
		 *
		 */
		private function triggerCreateEvent(points:Array):void
		{
			var properties:IMap = new Map();
			properties.put("points", points);
			var event:TopoEvent = new TopoEvent(TopoEvent.CREATE_LINE, null, properties);
			_canvas.dispatchEvent(event);
			log.debug("抛出创建线对象事件 {0}", properties);
		}

	}
}

class _PrivateClass
{
	public function _PrivateClass()
	{

	}
}