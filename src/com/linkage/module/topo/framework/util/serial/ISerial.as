package com.linkage.module.topo.framework.util.serial
{

	/**
	 * 连续编号接口
	 * @author duangr
	 *
	 */
	public interface ISerial
	{
		/**
		 * 当前的值
		 */
		function set current(value:*):void;
		function get current():*;

		/**
		 * 获取下一个的值
		 * @return
		 *
		 */
		function next():*;
	}
}