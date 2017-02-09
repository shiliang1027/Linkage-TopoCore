package com.linkage.module.topo.framework.view.component.toolbar.action
{
	import com.linkage.module.topo.framework.controller.action.IAction;
	import com.linkage.module.topo.framework.controller.event.ActionEvent;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;
	import com.linkage.module.topo.framework.view.component.toolbar.TopoIcon;

	import flash.errors.IllegalOperationError;
	import flash.events.MouseEvent;

	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	/**
	 * 光标样式类
	 */
	[Style(name="cursorClass", type="Class")]
	/**
	 * 拓扑模式Action对应的操作图标
	 * @author duangr
	 *
	 */
	public class TopoActionIcon extends TopoIcon
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.view.component.toolbar.action.TopoActionIcon");
		// Action
		protected var _action:IAction = null;
		// 光标类
		private var _cursor:Class = null;
		// 是否默认Action
		private var _isDefault:Boolean = false;
		// 模式是否启用
		private var _actionEnable:Boolean = false;

		public function TopoActionIcon()
		{
			super();
			this.addEventListener(MouseEvent.CLICK, onMouseClick);
		}

		/**
		 * 拓扑图画布
		 */
		override public function set topoCanvas(value:TopoCanvas):void
		{
			_topoCanvas = value;
			_topoCanvas.addEventListener(ActionEvent.ACTION_CHANGED, onActionChanged);
			_action = initAction(_topoCanvas);
			if (_isDefault)
			{
				onMouseClick();
			}
			initCursor();
		}

		private function initCursor():void
		{
			_cursor = getStyle("cursorClass");
			if (_cursor)
			{
				_action.cursor = _cursor;
			}
		}

		/**
		 * 是否是默认的模式
		 */
		public function set isDefault(flag:Boolean):void
		{
			this._isDefault = flag;
		}

		/**
		 * 初始化Action
		 *
		 */
		protected function initAction(topoCanvas:TopoCanvas):IAction
		{
			// 具体由子类来实现
			throw new IllegalOperationError("Function initAction(topoCanvas:TopoCanvas) from abstract class TopoActionIcon has not been implemented by subclass.");
		}

		public function onMouseClick(event:MouseEvent = null):void
		{
			if (actionEnable == false)
			{
				_topoCanvas.action = _action;
				actionEnable = true;
			}
			invalidateSkinState();
		}

		/**
		 * 捕获到Action切换事件
		 * @param event
		 *
		 */
		protected function onActionChanged(event:ActionEvent):void
		{
			actionEnable = false;
			invalidateSkinState();
		}

		override protected function getCurrentSkinState():String
		{
			if (_actionEnable)
			{
				return "down";
			}
			return super.getCurrentSkinState();
		}

		public function get actionEnable():Boolean
		{
			return _actionEnable;
		}

		public function set actionEnable(value:Boolean):void
		{
			_actionEnable = value;
		}

	}
}