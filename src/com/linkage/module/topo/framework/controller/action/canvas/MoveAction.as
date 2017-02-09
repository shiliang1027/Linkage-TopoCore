package com.linkage.module.topo.framework.controller.action.canvas
{
	import com.linkage.module.topo.framework.Constants;
	import com.linkage.module.topo.framework.core.Feature;
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.model.element.point.ITPPoint;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;

	import flash.events.MouseEvent;
	import flash.geom.Point;

	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	/**
	 * 移动模式 Action
	 * @author duangr
	 *
	 */
	public class MoveAction extends CanvasAction
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.controller.action.canvas.MoveAction");
		private var _moveLastX:Number = 0;
		private var _moveLastY:Number = 0;

		// 是否处于移动中的标识
		private var _isMoving:Boolean = false;

		public function MoveAction(canvas:TopoCanvas)
		{
			super(canvas);
		}

		override public function get name():String
		{
			return "移动模式";
		}

		override public function onDownFeature(event:MouseEvent, mouseCanvasPoint:Point, downFeature:Feature):void
		{
			if (_canvas.getProperty(Constants.PROPERTY_CANVAS_ISLOCKED) != "true")
			{
				selectedDragStart(mouseCanvasPoint);
			}
		}

		override public function onMoveWithDownFeature(event:MouseEvent, mouseCanvasPoint:Point, downFeature:Feature):void
		{
			if (_canvas.getProperty(Constants.PROPERTY_CANVAS_ISLOCKED) != "true")
			{
				selectedDraging(mouseCanvasPoint);
			}
			if (!_isMoving)
			{
				mouseEventDisable();
				_isMoving = true;
			}
		}

		override public function onMoveWithDownFeatureButUp(event:MouseEvent, mouseCanvasPoint:Point, downFeature:Feature):void
		{
			_isMoving = false;
			mouseEventEnable();
		}

		override public function onUpWithDownFeatureNoMove(event:MouseEvent, mouseCanvasPoint:Point, downFeature:Feature, upFeature:Feature):void
		{
			_isMoving = false;
			mouseEventEnable();
		}

		override public function onUpWithDownFeatureAndMove(event:MouseEvent, mouseCanvasPoint:Point, downFeature:Feature, upFeature:Feature):void
		{
			_isMoving = false;
			mouseEventEnable();
		}

		/**
		 * 禁用选中对象的鼠标事件<br/>
		 * 移动选中对象时需要触发此禁用事件,否则移动对象时会出现晃动的效果
		 */
		private function mouseEventDisable():void
		{
			_canvas.eachSelect(function(id:String, element:IElement):void
				{
					element.feature.mouseEnabled = false;
					element.feature.mouseChildren = false;
				});
		}

		/**
		 * 启用选中对象的鼠标事件<br/>
		 * 移动选中对象结束,重新让选中对象响应鼠标事件
		 */
		private function mouseEventEnable():void
		{
			_canvas.eachSelect(function(id:String, element:IElement):void
				{
					element.feature.mouseEnabled = true;
					element.feature.mouseChildren = true;
				});
		}

		/**
		 * 被选中对象开始拖动
		 * @param mousePoint 当前鼠标坐标
		 *
		 */
		private function selectedDragStart(mousePoint:Point):void
		{
			_moveLastX = mousePoint.x;
			_moveLastY = mousePoint.y;
		}

		/**
		 * 被选中对象拖动中事件
		 * @param mousePoint 当前鼠标坐标
		 *
		 */
		private function selectedDraging(mousePoint:Point):void
		{
			var addX:Number = mousePoint.x - _moveLastX;
			var addY:Number = mousePoint.y - _moveLastY;

//			var _minX:Number = Number.MAX_VALUE;
//			var _minY:Number = Number.MAX_VALUE;
//			var _maxX:Number = -Number.MAX_VALUE;
//			var _maxY:Number = -Number.MAX_VALUE;

			_canvas.eachSelect(function(id:String, element:IElement):void
				{
					element.feature.addMoveXY(addX, addY);

					// 此处做一个判断对象有没有拖出分组的逻辑
					var point:ITPPoint = element as ITPPoint;
					if (point && point.groupOwner && !point.groupOwner.isChildInGroupBounds(point))
					{
						element.feature.addMoveXY(-addX, -addY);
					}

//					_minX = Math.min(_minX, point.x);
//					_minY = Math.min(_minY, point.y);
//					_maxX = Math.max(_maxX, point.x);
//					_maxY = Math.max(_maxY, point.y);
				});

			_moveLastX = mousePoint.x;
			_moveLastY = mousePoint.y;

//			log.debug("数据范围 ({0}, {1}) -> ({2}, {3})", _minX, _minY, _maxX, _maxY);
//			_canvas.dataBounds.updateByAppendMinMaxPoint(_minX, _minY, _maxX, _maxY);
		}


	}
}