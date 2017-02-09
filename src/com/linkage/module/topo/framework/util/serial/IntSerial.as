package com.linkage.module.topo.framework.util.serial
{

	/**
	 * 数字版本的连续编号
	 * @author duangr
	 *
	 */
	public class IntSerial implements ISerial
	{
		private var _value:int = 0;

		public function IntSerial()
		{
		}

		public function set current(value:*):void
		{
			if (!(value is int))
			{
				throw new TypeError("please insert int value");
			}
			_value = int(value);
		}

		public function get current():*
		{
			return _value;
		}

		public function next():*
		{
			return ++_value;
		}
	}
}