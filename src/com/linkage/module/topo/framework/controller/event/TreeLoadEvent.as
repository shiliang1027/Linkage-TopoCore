package com.linkage.module.topo.framework.controller.event
{
	import flash.events.Event;

	/**
	 * 树加载事件
	 * @author duangr
	 *
	 */
	public class TreeLoadEvent extends Event
	{
		/**
		 * 事件类型: 触发树加载
		 */
		public static const TREE_LOAD:String = "TreeLoadEvent_TREE_LOAD";

		private var _data:* = null;

		public function TreeLoadEvent(type:String, data:*, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			_data = data;
		}

		/**
		 * 树节点的数据
		 * @return
		 *
		 */
		public function get data():*
		{
			return _data;
		}

		override public function clone():Event
		{
			return new TreeLoadEvent(type, _data, bubbles, cancelable);
		}

		override public function toString():String
		{
			return "[TreeLoadEvent] " + type;
		}

	}
}