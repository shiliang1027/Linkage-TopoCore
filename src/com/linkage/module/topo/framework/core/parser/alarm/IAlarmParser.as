package com.linkage.module.topo.framework.core.parser.alarm
{
	import com.linkage.module.topo.framework.core.model.alarm.IAlarm;

	/**
	 * 告警解析器接口
	 * @author duangr
	 *
	 */
	public interface IAlarmParser
	{

		/**
		 * 解析告警的数据
		 * @param alarm
		 *
		 */
		function parse(alarm:IAlarm, data:Object):void;
	}
}