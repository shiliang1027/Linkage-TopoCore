package com.linkage.module.topo.framework.util.serial
{

	/**
	 * 大写字母版本的连续编号<br/>
	 * A - Z - AA - ZZ - ZZZ
	 * @author duangr
	 *
	 */
	public class UpperCaseLetterSerial extends AbstractLetterSerial
	{
		public function UpperCaseLetterSerial()
		{
			super();
		}

		override protected function get minCharCode():Number
		{
			return UNICODE_A;
		}

		override protected function get maxCharCode():Number
		{
			return UNICODE_Z;
		}
	}
}