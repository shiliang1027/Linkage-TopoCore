package com.linkage.module.topo.framework.core.parser.alarm
{
	import com.linkage.module.topo.framework.controller.event.CanvasEvent;
	import com.linkage.module.topo.framework.core.model.alarm.IAlarm;
	import com.linkage.module.topo.framework.util.AlarmConstants;
	import com.linkage.module.topo.framework.view.component.TopoLayer;
	import com.linkage.system.structure.map.ISet;
	import com.linkage.system.structure.map.Set;

	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	/**
	 * 告警解析器
	 * @author duangr
	 *
	 */
	public class AlarmParser implements IAlarmParser
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.core.parser.alarm.AlarmParser");

		// 画布
		private var _topoLayer:TopoLayer = null;
		private var _alarmTypes:ISet = new Set();
		private var _alarmLevels:ISet = new Set();

		public function AlarmParser(topoLayer:TopoLayer)
		{
			_topoLayer = topoLayer;
			// 默认监控1,2两级的告警
			_alarmTypes.add(AlarmConstants.ALARM_TYPE_DEVICE);
			_alarmTypes.add(AlarmConstants.ALARM_TYPE_PERFORMANCE);
			_alarmTypes.add(AlarmConstants.ALARM_TYPE_BUSINESS);

			_alarmLevels.add(AlarmConstants.LEVEL1);
			_alarmLevels.add(AlarmConstants.LEVEL2);
			_alarmLevels.add(AlarmConstants.LEVEL3);
			_alarmLevels.add(AlarmConstants.LEVEL4);

			// 监听告警渲染规则变化
			_topoLayer.addEventListener(CanvasEvent.ALARM_RENDERER_CHANGE, hanlder_AlarmRendererChange);
		}

		private function hanlder_AlarmRendererChange(event:CanvasEvent):void
		{
			var alarmTypes:ISet = event.getProperty(AlarmConstants.KEY_ALARM_TYPES);
			if (alarmTypes != null)
			{
				_alarmTypes = alarmTypes;
			}
			var alarmLevels:ISet = event.getProperty(AlarmConstants.KEY_ALARM_LEVELS);
			if (alarmLevels != null)
			{
				_alarmLevels = alarmLevels;
			}
			log.debug("告警渲染规则变更 alarmTypes:{0} alarmLevels:{1}", _alarmTypes, _alarmLevels);

		}

		public function parse(alarm:IAlarm, data:Object):void
		{
			var alarmType:uint = uint(data[AlarmConstants.XML_KEY_TYPE]);
//			log.debug("解析告警 {0} {1} type={2} 1={3} 2={4} 3={5} 4={6}", _alarmTypes, _alarmLevels, alarmType, uint(data[AlarmConstants.LEVEL1]), uint(data[AlarmConstants.LEVEL2]), uint(data[AlarmConstants.
//				LEVEL3]), uint(data[AlarmConstants.LEVEL4]));

			if (!_alarmTypes.contains(alarmType))
			{
				return;
			}
			_alarmLevels.forEach(function(level:uint):void
				{
					switch (level)
					{
						case 1:
							alarm.level1 += uint(data[AlarmConstants.LEVEL1]);
							break;
						case 2:
							alarm.level2 += uint(data[AlarmConstants.LEVEL2]);
							break;
						case 3:
							alarm.level3 += uint(data[AlarmConstants.LEVEL3]);
							break;
						case 4:
							alarm.level4 += uint(data[AlarmConstants.LEVEL4]);
							break;
					}
				});
		}
	}
}