package com.linkage.module.topo.framework.core.model
{
	import com.linkage.module.topo.framework.core.model.alarm.Alarm;
	import com.linkage.module.topo.framework.core.model.alarm.IAlarm;
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.parser.alarm.AlarmParser;
	import com.linkage.module.topo.framework.core.parser.alarm.IAlarmParser;
	import com.linkage.module.topo.framework.view.component.TopoLayer;

	/**
	 * 告警工厂
	 * @author duangr
	 *
	 */
	public class AlarmFactory implements IAlarmFactory
	{
		// 告警解析器
		private var _alarmParser:IAlarmParser = null;

		public function AlarmFactory(topoLayer:TopoLayer)
		{
			_alarmParser = new AlarmParser(topoLayer);
		}

		public function buildNullAlarm(element:IElement):IAlarm
		{
			return new Alarm(_alarmParser);
		}
	}
}