package com.linkage.module.topo.framework.controller.action.canvas
{
	import com.linkage.module.topo.framework.core.Feature;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;

	import flash.events.MouseEvent;
	import flash.geom.Point;

	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	/**
	 * 画布Action包装器
	 * @author duangr
	 *
	 */
	public class CanvasActionWrapper extends CanvasAction
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.controller.action.canvas.CanvasActionWrapper");
		private var _canvasActions:Array = null;

		public function CanvasActionWrapper(canvas:TopoCanvas, ... canvasActions)
		{
			super(canvas);
			_canvasActions = canvasActions;

			if (_canvasActions == null || _canvasActions.length == 0)
			{
				throw new ArgumentError("参数数组[canvasActions]不能为空!");
			}
			if (!_canvasActions.every(function(item:*, index:int, array:Array):Boolean
				{
					return item is ICanvasAction;
				}))
			{
				throw new ArgumentError("参数数组[canvasActions]内每个对象都必须为 ICanvasAction 的实例!");
			}
		}

		override public function get name():String
		{
			var names:Array = [];
			_canvasActions.forEach(function(action:ICanvasAction, index:int, array:Array):void
				{
					names.push(action.name);
				});
			return names.join("+");
		}

		override public function afterActionEnabled():void
		{
			_canvasActions.forEach(function(action:ICanvasAction, index:int, array:Array):void
				{
					action.afterActionEnabled();
				});
		}

		override public function afterActionDisabled():void
		{
			_canvasActions.forEach(function(action:ICanvasAction, index:int, array:Array):void
				{
					action.afterActionDisabled();
				});
		}

		override public function onDownFeature(event:MouseEvent, mouseCanvasPoint:Point, downFeature:Feature):void
		{
			_canvasActions.forEach(function(action:ICanvasAction, index:int, array:Array):void
				{
					action.onDownFeature(event, mouseCanvasPoint, downFeature);
				});
		}

		override public function onDownCanvas(event:MouseEvent, mouseCanvasPoint:Point):void
		{
			_canvasActions.forEach(function(action:ICanvasAction, index:int, array:Array):void
				{
					action.onDownCanvas(event, mouseCanvasPoint);
				});
		}

		override public function onMoveWithoutDown(event:MouseEvent, mouseCanvasPoint:Point):void
		{
			_canvasActions.forEach(function(action:ICanvasAction, index:int, array:Array):void
				{
					action.onMoveWithoutDown(event, mouseCanvasPoint);
				});
		}

		override public function onMoveWithDownFeature(event:MouseEvent, mouseCanvasPoint:Point, downFeature:Feature):void
		{
			_canvasActions.forEach(function(action:ICanvasAction, index:int, array:Array):void
				{
					action.onMoveWithDownFeature(event, mouseCanvasPoint, downFeature);
				});
		}

		override public function onMoveWithDownFeatureButUp(event:MouseEvent, mouseCanvasPoint:Point, downFeature:Feature):void
		{
			_canvasActions.forEach(function(action:ICanvasAction, index:int, array:Array):void
				{
					action.onMoveWithDownFeatureButUp(event, mouseCanvasPoint, downFeature);
				});
		}

		override public function onMoveWithDownCanvas(event:MouseEvent, mouseCanvasPoint:Point):void
		{
			_canvasActions.forEach(function(action:ICanvasAction, index:int, array:Array):void
				{
					action.onMoveWithDownCanvas(event, mouseCanvasPoint);
				});
		}

		override public function onMoveWithDownCanvasButUp(event:MouseEvent, mouseCanvasPoint:Point):void
		{
			_canvasActions.forEach(function(action:ICanvasAction, index:int, array:Array):void
				{
					action.onMoveWithDownCanvasButUp(event, mouseCanvasPoint);
				});
		}

		override public function onUpWithDownFeatureNoMove(event:MouseEvent, mouseCanvasPoint:Point, downFeature:Feature, upFeature:Feature):void
		{
			_canvasActions.forEach(function(action:ICanvasAction, index:int, array:Array):void
				{
					action.onUpWithDownFeatureNoMove(event, mouseCanvasPoint, downFeature, upFeature);
				});
		}

		override public function onUpWithDownFeatureAndMove(event:MouseEvent, mouseCanvasPoint:Point, downFeature:Feature, upFeature:Feature):void
		{
			_canvasActions.forEach(function(action:ICanvasAction, index:int, array:Array):void
				{
					action.onUpWithDownFeatureAndMove(event, mouseCanvasPoint, downFeature, upFeature);
				});
		}

		override public function onUpWithDownCanvasNoMove(event:MouseEvent, mouseCanvasPoint:Point, upFeature:Feature):void
		{
			_canvasActions.forEach(function(action:ICanvasAction, index:int, array:Array):void
				{
					action.onUpWithDownCanvasNoMove(event, mouseCanvasPoint, upFeature);
				});
		}

		override public function onUpWithDownCanvasAndMove(event:MouseEvent, mouseCanvasPoint:Point, upFeature:Feature):void
		{
			_canvasActions.forEach(function(action:ICanvasAction, index:int, array:Array):void
				{
					action.onUpWithDownCanvasAndMove(event, mouseCanvasPoint, upFeature);
				});
		}

		override public function onRightClick(event:MouseEvent):void
		{
			_canvasActions.forEach(function(action:ICanvasAction, index:int, array:Array):void
				{
					action.onRightClick(event);
				});
		}

		override public function handlerRightClick(feature:Feature):void
		{
			_canvasActions.forEach(function(action:ICanvasAction, index:int, array:Array):void
				{
					action.handlerRightClick(feature);
				});
		}

		override public function onMouseWheelCanvas(event:MouseEvent, mouseCanvasPoint:Point):void
		{
			_canvasActions.forEach(function(action:ICanvasAction, index:int, array:Array):void
				{
					action.onMouseWheelCanvas(event, mouseCanvasPoint);
				});
		}


		override public function onDoubleClickFeature(event:MouseEvent, mouseCanvasPoint:Point, downFeature:Feature):void
		{
			_canvasActions.forEach(function(action:ICanvasAction, index:int, array:Array):void
				{
					action.onDoubleClickFeature(event, mouseCanvasPoint, downFeature);
				});
		}

		override public function onDoubleClickCanvas(event:MouseEvent, mouseCanvasPoint:Point):void
		{
			_canvasActions.forEach(function(action:ICanvasAction, index:int, array:Array):void
				{
					action.onDoubleClickCanvas(event, mouseCanvasPoint);
				});
		}
	}
}