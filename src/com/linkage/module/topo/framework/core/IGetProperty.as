package com.linkage.module.topo.framework.core
{

	/**
	 * 获取属性的接口
	 * @author duangr
	 *
	 */
	public interface IGetProperty
	{
		/**
		 * 获取属性
		 * @param key
		 * @return
		 *
		 */
		function getProperty(key:String):String;

		/**
		 * 循环属性
		 * @param callback 回调函数,参数为 function callback(key:String,value:String):void{...}
		 *  @param thisObject 用作函数的 this 的对象
		 */
		function eachProperty(callback:Function, thisObject:* = null):void;
	}
}