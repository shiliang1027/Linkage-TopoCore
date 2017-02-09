package com.linkage.module.topo.framework.core.model.alarm
{
	import com.linkage.module.topo.framework.core.parser.alarm.IAlarmParser;
	import com.linkage.module.topo.framework.util.AlarmConstants;

	/**
	 * 告警对象
	 * @author duangr
	 *
	 */
	public class Alarm implements IAlarm
	{
		// parser
		private var _parser:IAlarmParser = null;
		// 告警数量
		private var _level1:uint = 0;
		private var _level2:uint = 0;
		private var _level3:uint = 0;
		private var _level4:uint = 0;

		public function Alarm(parser:IAlarmParser)
		{
			_parser = parser;
		}

		public function toString():String
		{
			return "一级(" + _level1 + ") 二级(" + _level2 + ") 三级(" + _level3 + ") 四级(" + _level4 + ")";
		}

		public function set data(data:Object):void
		{
			_parser.parse(this, data);
		}


		public function reset():void
		{
			_level1 = 0;
			_level2 = 0;
			_level3 = 0;
			_level4 = 0;
		}

		public function hasAlarm():Boolean
		{
			return (_level1 + _level2 + _level3 + _level4) > 0;
		}

		public function maxLevel():uint
		{
			if (_level1 > 0)
			{
				return AlarmConstants.LEVEL1;
			}
			else if (_level2 > 0)
			{
				return AlarmConstants.LEVEL2;
			}
			else if (_level3 > 0)
			{
				return AlarmConstants.LEVEL3;
			}
			else if (_level4 > 0)
			{
				return AlarmConstants.LEVEL4;
			}
			else
			{
				return 0;
			}
		}

		public function maxLevelNum():uint
		{
			if (_level1 > 0)
			{
				return _level1;
			}
			else if (_level2 > 0)
			{
				return _level2;
			}
			else if (_level3 > 0)
			{
				return _level3;
			}
			else if (_level4 > 0)
			{
				return _level4;
			}
			else
			{
				return 0;
			}
		}

		public function set level1(num:uint):void
		{
			_level1 = num;
		}

		public function get level1():uint
		{
			return _level1;
		}

		public function set level2(num:uint):void
		{
			_level2 = num;
		}

		public function get level2():uint
		{
			return _level2;
		}

		public function set level3(num:uint):void
		{
			_level3 = num;
		}

		public function get level3():uint
		{
			return _level3;
		}


		public function set level4(num:uint):void
		{
			_level4 = num;
		}

		public function get level4():uint
		{
			return _level4;
		}
	}
}