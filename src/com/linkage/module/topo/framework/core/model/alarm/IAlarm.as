package com.linkage.module.topo.framework.core.model.alarm
{

	/**
	 * 告警接口
	 * @author duangr
	 *
	 */
	public interface IAlarm
	{
		/**
		 * 设置告警的数据
		 * @param data
		 *
		 */
		function set data(data:Object):void;

		/**
		 * 重置告警,将告警置为0
		 *
		 */
		function reset():void;

		/**
		 * 判断是否存在告警
		 * @return
		 *
		 */
		function hasAlarm():Boolean;

		/**
		 * 获取告警的最高级别
		 * @return
		 *
		 */
		function maxLevel():uint;

		/**
		 * 获取最高级别告警对应的数量
		 * @return
		 *
		 */
		function maxLevelNum():uint;

		/**
		 * 1级告警数量
		 */
		function set level1(num:uint):void;
		function get level1():uint;

		/**
		 * 2级告警数量
		 */
		function set level2(num:uint):void;
		function get level2():uint;

		/**
		 * 3级告警数量
		 */
		function set level3(num:uint):void;
		function get level3():uint;

		/**
		 * 4级告警数量
		 */
		function set level4(num:uint):void;
		function get level4():uint;


	}
}