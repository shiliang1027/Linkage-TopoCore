package com.linkage.module.topo.framework.util.serial
{
	import com.linkage.system.utils.StringUtils;

	import flash.errors.IllegalOperationError;

	/**
	 * 抽象的字母版本的连续编号<br/>
	 * a - z - aa - az - za - zz - aaa - aaz - zzz - aaaa (或者大写)
	 * @author duangr
	 *
	 */
	public class AbstractLetterSerial implements ISerial
	{
		public static const UNICODE_a:uint = 97;
		public static const UNICODE_z:uint = 122;

		public static const UNICODE_A:uint = 65;
		public static const UNICODE_Z:uint = 90;

		// 存放字符串charCode的数组
		private var _charCodeArray:Array = null;

		public function AbstractLetterSerial()
		{
		}

		protected function get minCharCode():Number
		{
			throw new IllegalOperationError("get minCharCode() from abstract class AbstractLetterSerial has not been implemented by subclass");
		}

		protected function get maxCharCode():Number
		{
			throw new IllegalOperationError("get maxCharCode() from abstract class AbstractLetterSerial has not been implemented by subclass");
		}

		public function set current(value:*):void
		{
			if (!(value is String))
			{
				throw new TypeError("please insert String value");
			}
			var array:Array = StringUtils.str2charCodeArray(value as String);
			if (array.some(function(item:Number, index:int, array:Array):Boolean
				{
					return item < minCharCode || item > maxCharCode;
				}))
			{
				throw new ArgumentError(value + "'s charCode must between " + minCharCode + " and " + maxCharCode);
			}
			_charCodeArray = array;

		}

		public function get current():*
		{
			return StringUtils.charCodeArray2Str(_charCodeArray);
		}

		public function next():*
		{
			if (_charCodeArray == null || _charCodeArray.length == 0)
			{
				throw new IllegalOperationError("please set current property first.");
			}
			// 从最后一位(各位)起开始检验数据递增
			instanceCharCodeAt(_charCodeArray.length - 1);

			return StringUtils.charCodeArray2Str(_charCodeArray);
		}

		/**
		 * 从指定位开始递增charCode
		 * @param index
		 *
		 */
		private function instanceCharCodeAt(index:uint):void
		{
			if (_charCodeArray[index] < maxCharCode)
			{
				// 【1】如果指定位还没有到达最大charCode,递增指定位的charCode即可.
				_charCodeArray[index] = _charCodeArray[index] + 1;
			}
			else
			{
				// 【2】如果指定位已经达到最大charCode,将指定位设置为最小charCode,前一位按照前面的逻辑校验递增
				_charCodeArray[index] = minCharCode;
				if (index == 0)
				{
					// 【3】指定位已经是第一位时,前面再插入一位,值为最小charCode
					_charCodeArray.unshift(minCharCode);
				}
				else
				{
					instanceCharCodeAt(index - 1);
				}
			}
		}
	}
}