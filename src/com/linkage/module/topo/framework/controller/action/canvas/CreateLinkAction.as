package com.linkage.module.topo.framework.controller.action.canvas
{
	import com.linkage.module.topo.framework.Constants;
	import com.linkage.module.topo.framework.controller.event.TopoEvent;
	import com.linkage.module.topo.framework.core.Feature;
	import com.linkage.module.topo.framework.core.model.element.point.ITPPoint;
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
	 * 创建链路模式
	 * @author duangr
	 *
	 */
	public class CreateLinkAction extends CanvasAction
	{
		// log
		private static const log:ILogger = Log.getLogger("com.linkage.module.topo.framework.controller.action.canvas.CreateLinkAction");

		// 链路区域
		private var _shape:Group = new Group();
		private var _startX:Number = 0;
		private var _startY:Number = 0;

		private var _createLinkThickness:uint = Constants.DEFAULT_CREATELINK_LINE_SIZE;
		private var _createLinkColor:uint = Constants.DEFAULT_CREATELINK_LINE_COLOR;

		// 起点对象
		private var _fromPoint:ITPPoint = null;

		public function CreateLinkAction(canvas:TopoCanvas)
		{
			super(canvas);
			// 绘制链路的容器,不能响应鼠标事件
			_shape.mouseEnabled = false;
		}

		override public function get name():String
		{
			return "创建链路模式";
		}

		override public function onDownFeature(event:MouseEvent, mouseCanvasPoint:Point, downFeature:Feature):void
		{
			drawLinkStart(downFeature.element as ITPPoint, mouseCanvasPoint.x, mouseCanvasPoint.y);
		}
		
		override public function onMoveWithDownFeature(event:MouseEvent, mouseCanvasPoint:Point, downFeature:Feature):void
		{
			drawLinkMoving(mouseCanvasPoint.x, mouseCanvasPoint.y);
		}

		override public function onMoveWithDownFeatureButUp(event:MouseEvent, mouseCanvasPoint:Point, downFeature:Feature):void
		{
			drawLinkClear();
		}

		override public function onUpWithDownFeatureNoMove(event:MouseEvent, mouseCanvasPoint:Point, downFeature:Feature, upFeature:Feature):void
		{
			drawLinkClear();
		}

		override public function onUpWithDownFeatureAndMove(event:MouseEvent, mouseCanvasPoint:Point, downFeature:Feature, upFeature:Feature):void
		{
			if (upFeature)
			{
				drawLinkEnd(upFeature.element as ITPPoint, mouseCanvasPoint.x, mouseCanvasPoint.y);
			}
			else
			{
				drawLinkClear();
			}
		}

		/**
		 * 开始画Live模式的链路
		 * @param x 相对画布的X坐标
		 * @param y 相对画布的Y坐标
		 *
		 */
		private function drawLinkStart(fromPoint:ITPPoint, x:Number, y:Number):void
		{
			if (fromPoint == null)
			{
				return;
			}
			_fromPoint = fromPoint;
			if (!_canvas.contains(_shape))
			{
				_canvas.addElement(_shape);
			}
			_shape.visible = true;
			_startX = x;
			_startY = y;
			var g:Graphics = _shape.graphics;
			g.clear();
			g.lineStyle(_createLinkThickness, _createLinkColor);
		}

		/**
		 * Live模式的链路移动中
		 * @param x 相对画布的X坐标
		 * @param y 相对画布的Y坐标
		 *
		 */
		private function drawLinkMoving(x:Number, y:Number):void
		{
			if (_fromPoint == null)
			{
				return;
			}
			var g:Graphics = _shape.graphics;
			g.clear();
			g.lineStyle(_createLinkThickness, _createLinkColor);
			g.moveTo(_startX, _startY);
			g.lineTo(x, y);
		}


		/**
		 * Live模式的链路绘制结束
		 * @param x 相对画布的X坐标
		 * @param y 相对画布的Y坐标
		 *
		 */
		private function drawLinkEnd(endPoint:ITPPoint, x:Number, y:Number):void
		{
			if (_fromPoint == null)
			{
				return;
			}
			drawLinkClear();
			triggerCreateEvent(_fromPoint, endPoint);
		}

		/**
		 * 清除绘制的链路
		 */
		private function drawLinkClear():void
		{
			_shape.graphics.clear();
			_shape.visible = false;
		}

		/**
		 * 触发创建事件
		 * @param fromPoint
		 * @param toPoint
		 *
		 */
		private function triggerCreateEvent(fromPoint:ITPPoint, toPoint:ITPPoint):void
		{
			if (fromPoint == null || toPoint == null || fromPoint == toPoint)
			{
				return;
			}
			var properties:IMap = new Map();
			properties.put("fromPoint", fromPoint);
			properties.put("toPoint", toPoint);
			var event:TopoEvent = new TopoEvent(TopoEvent.CREATE_LINK, null, properties);
			_canvas.dispatchEvent(event);
			log.debug("抛出创建链路事件 {0}", properties);
		}
	}
}