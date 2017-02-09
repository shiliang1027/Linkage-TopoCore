package com.linkage.module.topo.framework.controller.event
{
	import flash.events.Event;

	/**
	 * 拓扑告警事件
	 * @author duangr
	 *
	 */
	public class TopoAlarmEvent extends Event
	{
		/**
		 * 事件类型: 显示告警流水面板
		 */
		public static const SHOW_FLOW_ALARM:String = "AlarmEvent_SHOW_FLOW_ALARM";
		/**
		 * 事件类型: 隐藏告警流水面板
		 */
		public static const HIDE_FLOW_ALARM:String = "AlarmEvent_HIDE_FLOW_ALARM";

		public function TopoAlarmEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}