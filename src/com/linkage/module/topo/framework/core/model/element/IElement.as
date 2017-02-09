package com.linkage.module.topo.framework.core.model.element
{
	import com.linkage.module.topo.framework.core.Feature;
	import com.linkage.module.topo.framework.core.IGetProperty;
	import com.linkage.module.topo.framework.core.model.alarm.IAlarm;
	import com.linkage.module.topo.framework.core.parser.element.IElementParser;
	import com.linkage.module.topo.framework.core.style.layout.ILayout;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;
	import com.linkage.module.topo.framework.view.component.TopoLayer;
	import com.linkage.system.structure.map.IMap;
	
	import flash.events.IEventDispatcher;

	/**
	 * 元素接口(拓扑中所有对象的基础)
	 * @author duangr
	 *
	 */
	public interface IElement extends IGetProperty, IEventDispatcher
	{
		/**
		 * 元素编号
		 */
		function get id():String;
		function set id(id:String):void;

		/**
		 * 元素的名称
		 */
		function get name():String;
		function set name(name:String):void;

		/**
		 * 元素的类型
		 */
		function get type():String;
		function set type(type:String):void;

		/**
		 * 元素的样式
		 */
		function get style():String;
		function set style(value:String):void;

		/**
		 * z-index
		 */
		function get zindex():int;
		function set zindex(value:int):void;

		/**
		 * 是否显示(0隐藏，1显示)
		 */
		function get visible():int;
		function set visible(visible:int):void;

		/**
		 * label的布局方式
		 */
		function get labelLayout():String;
		function set labelLayout(value:String):void;

		/**
		 * label的tooltip提示内容(为定义时使用 name 的内容)
		 * @return
		 */
		function get labelTooltip():String;
		function set labelTooltip(value:String):void;

		/**
		 * label的最大宽度
		 */
		function get labelMaxWidth():Number;
		function set labelMaxWidth(value:Number):void;


		/**
		 * 拓扑要素
		 */
		function get feature():Feature;
		function set feature(value:Feature):void;

		/**
		 * 权重值
		 */
		function get weight():uint;

		/**
		 * 节点名称
		 */
		function get itemName():String;

		/**
		 * 从传入的对象中复制属性
		 * @param element
		 *
		 */
		function copyFrom(element:IElement):void;

		/**
		 * 坐标增量变化
		 * @param x
		 * @param y
		 *
		 */
		function addMoveXY(x:Number, y:Number):void;

		/**
		 * 根据解析器,解析数据到对象
		 * @param parser
		 * @param data
		 * @return 解析是否成功
		 */
		function parseData(parser:IElementParser, data:Object, topoCanvas:TopoLayer):Boolean;

		/**
		 * 根据解析器,输出对象内容
		 * @param parser
		 * @return
		 *
		 */
		function output(parser:IElementParser):*;

		/**
		 * 对象是否支持告警渲染
		 */
		function get alarmEnabled():Boolean;

		/**
		 * 告警对象
		 */
		function get alarm():IAlarm;
		function set alarm(value:IAlarm):void

		/**
		 * 元素是否发生变化
		 */
		function get changed():Boolean;
		function set changed(value:Boolean):void;
		/**
		 * 客户端端口
		 */
		function get cteName():String;
		function set cteName(value:String):void;
		/**
		 * 电路名称
		 */
		function get circuit_code():String;
		function set circuit_code(value:String):void;
		/**
		 * 服务端端口
		 */
		function get steName():String;
		function set steName(value:String):void;
		function get ctePort():String;
		function set ctePort(value:String):void;
		/**
		 * 服务端端口
		 */
		function get stePort():String;
		function set stePort(value:String):void;

		/**
		 * 刷新数据
		 */
		function refresh():void;

		/**
		 * 销毁对象
		 */
		function destroy():void;

		/**
		 * 清空扩展属性
		 *
		 */
		function clearExtendProperties():void;

		/**
		 * 给元素添加扩展属性
		 * @param key 属性的key
		 * @param value 属性的值
		 *
		 */
		function addExtendProperty(key:String, value:String):void;

		/**
		 * 移除扩展属性
		 * @param key
		 *
		 */
		function removeExtendProperty(key:String):void;

		/**
		 * 循环扩展属性
		 * @param callback 回调函数,参数为 function callback(key:String,value:String):void{...}
		 * @param thisObject 用作函数的 this 的对象
		 */
		function eachExtendProperty(callback:Function, thisObject:* = null):void;
		/**
		 * 获取扩展属性
		 * @param key
		 * @return
		 *
		 */
		function getExtendProperty(key:String):String;

		/**
		 * 重置元素在画布中的叠放顺序,若传入的索引位置>=0,则放在指定位置,否则根据关联对象自动决定索引位置(如链路)
		 * @param index
		 *
		 */
		function resetElementIndex(index:int = -1):void;

	}
}