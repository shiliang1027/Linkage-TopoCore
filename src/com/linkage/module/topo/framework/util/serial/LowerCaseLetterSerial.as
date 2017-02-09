package com.linkage.module.topo.framework.util.serial
{


	/**
	 * 小写字母版本的连续编号<br/>
	 * a - z - aa - az - za - zz - aaa - aaz - zzz - aaaa
	 * @author duangr
	 *
	 */
	public class LowerCaseLetterSerial extends AbstractLetterSerial
	{

		public function LowerCaseLetterSerial()
		{
			super();
		}

		override protected function get minCharCode():Number
		{
			return UNICODE_a;
		}

		override protected function get maxCharCode():Number
		{
			return UNICODE_z;
		}

	}
}