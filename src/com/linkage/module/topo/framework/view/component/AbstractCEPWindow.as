package com.linkage.module.topo.framework.view.component
{
	import com.linkage.system.component.panel.Window;

	import flash.display.DisplayObject;
	import flash.errors.IllegalOperationError;

	import mx.managers.PopUpManager;

	/**
	 * 基于window扩展的 画布扩展面板
	 * @author duangr
	 *
	 */
	public class AbstractCEPWindow extends Window implements ICanvasExtendPanel
	{
		// 画布
		protected var _topoCanvas:TopoCanvas = null;
		// 面板的显示状态
		private var _showStatus:Boolean = false;
		// 参考显示的父对象
		private var _panelParent:DisplayObject = null;

		private var _iTop:Number = -1;
		private var _iLeft:Number = -1;
		private var _iBottom:Number = -1;
		private var _iRight:Number = -1;

		public function AbstractCEPWindow()
		{
			super();
		}

		/**
		 * 初始化时执行,提供给子类重写
		 *
		 */
		public function initPanel():void
		{

		}

		public function set panelParent(value:DisplayObject):void
		{
			_panelParent = value;
		}


		public function set topoCanvas(value:TopoCanvas):void
		{
			_topoCanvas = value;
		}

		/**
		 * 面板当前的显示状态
		 * @return
		 *
		 */
		protected function get showStatus():Boolean
		{
			return _showStatus;
		}

		/**
		 * 关闭面板
		 *
		 */
		protected function hide():void
		{
			_showStatus = false;
			PopUpManager.removePopUp(this);
		}

		/**
		 * 展现面板
		 *
		 */
		protected function show():void
		{
			initLocation();
			_showStatus = true;
			PopUpManager.addPopUp(this, _panelParent);
		}

		/**
		 * 布局初始化时 从组件的上边缘到锚点目标的上边缘的垂直距离
		 * @param value
		 *
		 */
		public function set iTop(value:Number):void
		{
			_iTop = value;
		}

		/**
		 * 布局初始化时 从组件的下边缘到锚点目标的下边缘的垂直距离
		 * @param value
		 *
		 */
		public function set iBottom(value:Number):void
		{
			_iBottom = value;
		}

		/**
		 * 布局初始化时 从组件的左边缘到锚点目标的左边缘的水平距离
		 * @param value
		 *
		 */
		public function set iLeft(value:Number):void
		{
			_iLeft = value;
		}

		/**
		 * 布局初始化时 从组件的右边缘到锚点目标的右边缘的水平距离
		 * @param value
		 *
		 */
		public function set iRight(value:Number):void
		{
			_iRight = value;
		}

		/**
		 * 初始化默认位置坐标
		 *
		 */
		private function initLocation():void
		{
			if (_iTop != -1)
			{
				this.y = _iTop;
			}
			else if (_iBottom != -1)
			{
				this.y = _panelParent.height - _iBottom - this.height;
			}
			if (_iLeft != -1)
			{
				this.x = _iLeft;
			}
			else if (_iRight != -1)
			{
				this.x = _panelParent.width - _iRight - this.width;
			}
		}
	}
}