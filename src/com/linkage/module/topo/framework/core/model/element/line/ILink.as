package com.linkage.module.topo.framework.core.model.element.line
{
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.model.element.point.ITPPoint;

	/**
	 * 链路对象接口,两端要连接对象
	 * @author duangr
	 *
	 */
	public interface ILink extends ILine
	{
		/**
		 * 链路的开始节点
		 */
		function get fromElement():ITPPoint;
		function set fromElement(from:ITPPoint):void;

		/**
		 * 链路的结束节点
		 */
		function get toElement():ITPPoint;
		function set toElement(to:ITPPoint):void;

		/**
		 * 是否展开
		 */
		function get expanded():Boolean;
		function set expanded(value:Boolean):void;


		/**
		 * 二级贝塞尔沿直线中心点垂直偏移量
		 */
		function get linkBessel2OffsetV():Number;
		function set linkBessel2OffsetV(value:Number):void;
		
		/**
		 * 折线方向
		 */
		function get poly_location():String;
		function set poly_location(value:String):void;

		/**
		 * 链路对应物理链路数量
		 */
		function get linkCount():int;
		function set linkCount(value:int):void;

		/**
		 * 默认状态展开闭合状态 (close|open)
		 */
		function get linkDefaultStatus():String;
		function set linkDefaultStatus(value:String):void;

		/**
		 * 链路展开后间隙
		 */
		function get linkOpenGap():Number;
		function set linkOpenGap(value:Number):void;

		/**
		 * 展开后贝塞尔控制点沿链路方向偏移量
		 */
		function get linkOpenOffsetH():Number;
		function set linkOpenOffsetH(value:Number):void;

		/**
		 * 链路展开后多条线交汇处类型
		 */
		function get linkOpenType():String;
		function set linkOpenType(value:String):void;

		/**
		 * 链路起点箭头是否启用
		 */
		function get linkFromArrowEnable():Boolean;
		function set linkFromArrowEnable(value:Boolean):void;

		/**
		 * 起点箭头类型
		 */
		function get linkFromArrowType():String;
		function set linkFromArrowType(value:String):void;

		/**
		 * 起点箭头高度
		 */
		function get linkFromArrowHeight():Number;
		function set linkFromArrowHeight(value:Number):void;

		/**
		 * 起点箭头宽度
		 */
		function get linkFromArrowWidth():Number;
		function set linkFromArrowWidth(value:Number):void;

		/**
		 * 链路终点箭头是否启用
		 */
		function get linkToArrowEnable():Boolean;
		function set linkToArrowEnable(value:Boolean):void;

		/**
		 * 终点箭头类型
		 */
		function get linkToArrowType():String;
		function set linkToArrowType(value:String):void;

		/**
		 * 终点箭头高度
		 */
		function get linkToArrowHeight():Number;
		function set linkToArrowHeight(value:Number):void;

		/**
		 * 终点箭头宽度
		 */
		function get linkToArrowWidth():Number;
		function set linkToArrowWidth(value:Number):void;
	}
}