package com.linkage.module.topo.framework.core.style.element.line
{
	import flash.geom.Point;

	/**
	 * 存放两个点的类
	 * @author duangr
	 *
	 */
	public class DoublePoints
	{
		private var _fromPoint:Point = null;
		private var _toPoint:Point = null;

		public function DoublePoints(fromPoint:Point, toPoint:Point)
		{
			_fromPoint = fromPoint;
			_toPoint = toPoint;
		}

		/**
		 * 起点
		 */
		public function get fromPoint():Point
		{
			return _fromPoint;
		}

		public function set fromPoint(value:Point):void
		{
			_fromPoint = value;
		}

		/**
		 * 终点
		 */
		public function get toPoint():Point
		{
			return _toPoint;
		}

		public function set toPoint(value:Point):void
		{
			_toPoint = value;
		}
	}
}