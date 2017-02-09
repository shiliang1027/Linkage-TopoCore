package com.linkage.module.topo.framework.controller.action
{
	import com.linkage.module.topo.framework.core.Feature;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;

	import flash.events.MouseEvent;

	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;
	import mx.managers.CursorManager;
	import mx.managers.CursorManagerPriority;

	/**
	 * Action的基本实现,是一切Action实现的基类
	 * @author duangr
	 *
	 */
	public class BaseAction implements IAction
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.controller.action.BaseAction");
		// 权重值
		private var _weight:uint = 0;
		// 拓扑图画布
		protected var _canvas:TopoCanvas = null;
		// 光标类
		protected var _cursor:Class;
		// 唯一标识
		private var _key:String = null;
		
		public function toString():String
		{
			return "模式名称:" + name;
		}

		public function get name():String
		{
			return "基类Action";
		}

		public function BaseAction(canvas:TopoCanvas)
		{
			this._canvas = canvas;
		}

		public function set key(value:String):void
		{
			_key = value;
		}
		
		public function get key():String
		{
			return _key;
		}
		
		public function set weight(value:uint):void
		{
			_weight = value;
		}

		public function get weight():uint
		{
			return _weight;
		}

		public function set cursor(value:Class):void
		{
			_cursor = value
		}

		public function addCanvasListeners():void
		{
//			log.debug("--->{0},{1}",this._canvas,this._canvas.parent);
			if (this._canvas && this._canvas.parent)
			{
				this._canvas.parent.addEventListener(MouseEvent.CLICK, onClick);
				this._canvas.parent.addEventListener(MouseEvent.DOUBLE_CLICK, onDblClick);
				this._canvas.parent.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				this._canvas.parent.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				this._canvas.parent.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				this._canvas.parent.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
				this._canvas.parent.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
				this._canvas.parent.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			}
			if (_cursor != null)
			{
				CursorManager.setCursor(_cursor, CursorManagerPriority.MEDIUM, -5, -5);
			}
		}

		public function removeCanvasListeners():void
		{
			CursorManager.removeCursor(CursorManager.currentCursorID);
			if (this._canvas&&this._canvas.parent)
			{
				this._canvas.parent.removeEventListener(MouseEvent.CLICK, onClick);
				this._canvas.parent.removeEventListener(MouseEvent.DOUBLE_CLICK, onDblClick);
				this._canvas.parent.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				this._canvas.parent.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				this._canvas.parent.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				this._canvas.parent.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
				this._canvas.parent.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
				this._canvas.parent.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			}
		}

		public function onClick(event:MouseEvent):void
		{
		}

		public function onDblClick(event:MouseEvent):void
		{
		}

		public function onMouseDown(event:MouseEvent):void
		{
		}

		public function onMouseUp(event:MouseEvent):void
		{
		}

		public function onMouseMove(event:MouseEvent):void
		{
		}

		public function onRightClick(event:MouseEvent):void
		{
		}

		public function handlerRightClick(feature:Feature):void
		{

		}

		public function onMouseOver(event:MouseEvent):void
		{
		}

		public function onMouseOut(event:MouseEvent):void
		{
		}

		public function onMouseWheel(event:MouseEvent):void
		{
		}
	}
}