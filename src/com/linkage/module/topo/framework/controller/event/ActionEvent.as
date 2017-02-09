package com.linkage.module.topo.framework.controller.event
{
	import com.linkage.module.topo.framework.controller.action.IAction;

	import flash.events.Event;

	/**
	 * Action事件
	 * @author duangr
	 *
	 */
	public class ActionEvent extends Event
	{
		/**
		 * 事件类型: 画布Action变化事件
		 */
		public static const ACTION_CHANGED:String = "ActionEvent_ACTION_CHANGED";
		// 旧的Action
		private var _oldAction:IAction = null;
		// 新的Action
		private var _newAction:IAction = null;

		/**
		 * 构造方法
		 * @param type 事件类型
		 * @param oldAction 变化前的Action
		 * @param newAction 变化后的Action
		 * @param bubbles
		 * @param cancelable
		 *
		 */
		public function ActionEvent(type:String, oldAction:IAction, newAction:IAction, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			this._oldAction = oldAction;
			this._newAction = newAction;
		}

		/**
		 * 变更前的Action
		 *
		 */
		public function get oldAction():IAction
		{
			return _oldAction;
		}

		/**
		 * 变更后的Action
		 *
		 */
		public function get newAction():IAction
		{
			return _newAction;
		}


	}
}