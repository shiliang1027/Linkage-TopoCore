package com.linkage.module.topo.framework.core.model.element.plane
{
	import com.linkage.module.topo.framework.core.model.element.point.ITPObject;

	import flash.geom.Rectangle;

	/**
	 * 面接口
	 * @author duangr
	 *
	 */
	public interface ITPPlane extends ITPObject
	{
		/**
		 * 面的宽度
		 */
		function get width():int;
		function set width(value:int):void;

		/**
		 * 面的高度
		 */
		function get height():int;
		function set height(value:int):void;

		/**
		 * 数据范围
		 */
		function get bounds():Rectangle;
	}
}