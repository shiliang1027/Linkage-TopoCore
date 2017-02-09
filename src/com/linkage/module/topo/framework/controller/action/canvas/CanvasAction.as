package com.linkage.module.topo.framework.controller.action.canvas
{
	import com.linkage.module.topo.framework.controller.action.BaseAction;
	import com.linkage.module.topo.framework.core.ChildFeature;
	import com.linkage.module.topo.framework.core.Feature;
	import com.linkage.module.topo.framework.util.TopoUtil;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;
	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;
	
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	
	public class CanvasAction extends BaseAction implements ICanvasAction
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.controller.action.canvas.CanvasAction");
		// 事件堆栈
		protected var _eventStack:Array = [];

		public function CanvasAction(canvas:TopoCanvas)
		{
			super(canvas);
		}

		override public function get name():String
		{
			return "画布基类Action";
		}

		override public function addCanvasListeners():void
		{
			super.addCanvasListeners();
			afterActionEnabled();
		}

		override public function removeCanvasListeners():void
		{
			super.removeCanvasListeners();
			afterActionDisabled();
		}

		public function afterActionEnabled():void
		{

		}

		public function afterActionDisabled():void
		{

		}

		/**
		 * 判断事件堆栈是否为空
		 * @return
		 *
		 */
		protected function isEventStackEmpty():Boolean
		{
			return _eventStack.length == 0;
		}

		/**
		 * 清空事件堆栈
		 *
		 */
		protected function clearEventStack():void
		{
			_eventStack = [];
		}

		/**
		 * 根据鼠标事件找到事件对于的Feature对象
		 * @param event
		 * @return
		 *
		 */
		protected function findTargetFeatureByMouseEvent(event:MouseEvent):Feature
		{
			return TopoUtil.findTargetFeature(event.target);
		}

		/**
		 * 根据鼠标事件找到事件对于的Feature对象
		 * @param event
		 * @return
		 *
		 */
		protected function findTargetChildFeatureByMouseEvent(event:MouseEvent):ChildFeature
		{
			return TopoUtil.findTargetChildFeature(event.target);
		}
		
		override public function onDblClick(event:MouseEvent):void
		{
			var downFeature:Feature = findTargetFeatureByMouseEvent(event);
			var mouseCanvasPoint:Point = TopoUtil.findMousePoint(event, _canvas);

			// 触发双击事件
			_canvas.menuManager.onDoubleClick(downFeature);

			if (downFeature)
			{
				onDoubleClickFeature(event, mouseCanvasPoint, downFeature);
			}
			else
			{
				onDoubleClickCanvas(event, mouseCanvasPoint);
			}

		}

		/**
		 * 鼠标左键按下事件:
		 * <pre>
		 * A.点击到元素上:
		 * B.点击到空白处:
		 * </pre>
		 *
		 * @param event
		 */
		override public function onMouseDown(event:MouseEvent):void
		{
			clearEventStack();
			var downFeature:Feature = findTargetFeatureByMouseEvent(event);
			var mouseCanvasPoint:Point = TopoUtil.findMousePoint(event, _canvas);
			if (downFeature)
			{
				if(downFeature.element.getProperty("mo_id")){
					ExternalInterface.call("onDeviceClick",downFeature.element.getProperty("mo_id"));
				}
				// 选中的目标位元素中的子对象，设置子对象为选中状态
				var childFeature:ChildFeature = findTargetChildFeatureByMouseEvent(event);
				if(childFeature)
				{
					downFeature.selectChildFeature(childFeature);
				}
				onDownFeature(event, mouseCanvasPoint, downFeature);
			}
			else
			{
				onDownCanvas(event, mouseCanvasPoint);
			}
			_eventStack.push(event);

		}

		/**
		 * 鼠标左键抬起事件
		 * <pre>
		 * A.若之前点击过
		 * 	a)鼠标移动过
		 * 		1.之前点击在空白处
		 * 		2.之前点击在元素上
		 * 	b)鼠标没有移动过
		 * 		1.之前点击在空白处
		 * 		2.之前点击在元素上
		 *
		 * B.若之前没有点击过
		 * </pre>
		 *
		 * @param event
		 *
		 */
		override public function onMouseUp(event:MouseEvent):void
		{
			if (!isEventStackEmpty())
			{
				var downFeature:Feature = findTargetFeatureByMouseEvent(_eventStack[0]);
				var upFeature:Feature = findTargetFeatureByMouseEvent(event);
				var mouseCanvasPoint:Point = TopoUtil.findMousePoint(event, _canvas);
				// 事件堆栈为大小为1,说明没有鼠标移动事件.
				if (_eventStack.length == 1)
				{
					if (downFeature)
					{
						onUpWithDownFeatureNoMove(event, mouseCanvasPoint, downFeature, upFeature);
					}
					else
					{
						onUpWithDownCanvasNoMove(event, mouseCanvasPoint, upFeature);
					}
				}
				else
				{
					if (downFeature)
					{
						onUpWithDownFeatureAndMove(event, mouseCanvasPoint, downFeature, upFeature);
					}
					else
					{
						onUpWithDownCanvasAndMove(event, mouseCanvasPoint, upFeature);
					}
				}
			}
			clearEventStack();
		}

		/**
		 * [多选状态]鼠标移动事件
		 * <pre>
		 * A.若之前点击过
		 * 	a)之前点击在元素上
		 * 	b)之前点击在空白处
		 *
		 * B.若之前没有点击过
		 * </pre>
		 *
		 * @param event
		 *
		 */
		override public function onMouseMove(event:MouseEvent):void
		{
			var mouseCanvasPoint:Point = TopoUtil.findMousePoint(event, _canvas);
			if (!isEventStackEmpty())
			{
				// 找到之前的元素
				var downFeature:Feature = findTargetFeatureByMouseEvent(_eventStack[0]);
				if (downFeature)
				{
					if (event.buttonDown)
					{
						onMoveWithDownFeature(event, mouseCanvasPoint, downFeature);
					}
					else
					{
						onMoveWithDownFeatureButUp(event, mouseCanvasPoint, downFeature);
					}
				}
				else
				{
					if (event.buttonDown)
					{
						onMoveWithDownCanvas(event, mouseCanvasPoint);
					}
					else
					{
						onMoveWithDownCanvasButUp(event, mouseCanvasPoint);
					}
				}
				_eventStack.push(event);
			}
			else
			{
				onMoveWithoutDown(event, mouseCanvasPoint);
			}

		}

		override public function onMouseWheel(event:MouseEvent):void
		{
			var mouseCanvasPoint:Point = TopoUtil.findMousePoint(event, _canvas);
			onMouseWheelCanvas(event, mouseCanvasPoint);
		}

		public function onDownFeature(event:MouseEvent, mouseCanvasPoint:Point, downFeature:Feature):void
		{
		}

		public function onDownCanvas(event:MouseEvent, mouseCanvasPoint:Point):void
		{
		}

		public function onMoveWithoutDown(event:MouseEvent, mouseCanvasPoint:Point):void
		{
		}

		public function onMoveWithDownFeature(event:MouseEvent, mouseCanvasPoint:Point, downFeature:Feature):void
		{
		}

		public function onMoveWithDownFeatureButUp(event:MouseEvent, mouseCanvasPoint:Point, downFeature:Feature):void
		{
		}

		public function onMoveWithDownCanvas(event:MouseEvent, mouseCanvasPoint:Point):void
		{
		}

		public function onMoveWithDownCanvasButUp(event:MouseEvent, mouseCanvasPoint:Point):void
		{
		}

		public function onUpWithDownFeatureNoMove(event:MouseEvent, mouseCanvasPoint:Point, downFeature:Feature, upFeature:Feature):void
		{
		}

		public function onUpWithDownFeatureAndMove(event:MouseEvent, mouseCanvasPoint:Point, downFeature:Feature, upFeature:Feature):void
		{
		}

		public function onUpWithDownCanvasNoMove(event:MouseEvent, mouseCanvasPoint:Point, upFeature:Feature):void
		{
		}

		public function onUpWithDownCanvasAndMove(event:MouseEvent, mouseCanvasPoint:Point, upFeature:Feature):void
		{
		}

		public function onMouseWheelCanvas(event:MouseEvent, mouseCanvasPoint:Point):void
		{

		}

		public function onDoubleClickFeature(event:MouseEvent, mouseCanvasPoint:Point, downFeature:Feature):void
		{
		}

		public function onDoubleClickCanvas(event:MouseEvent, mouseCanvasPoint:Point):void
		{
		}
	}
}