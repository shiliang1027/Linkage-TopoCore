package com.linkage.module.topo.framework.core.model
{
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.model.alarm.IAlarm;

	/**
	 * 告警工厂类
	 * @author duangr
	 *
	 */
	public interface IAlarmFactory
	{
		/**
		 * 构造空的告警对象
		 * @param element
		 * @return
		 *
		 */
		function buildNullAlarm(element:IElement):IAlarm;

	}
}