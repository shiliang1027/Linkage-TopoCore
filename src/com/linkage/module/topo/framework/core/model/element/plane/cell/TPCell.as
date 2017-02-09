package com.linkage.module.topo.framework.core.model.element.plane.cell
{
	import flash.geom.Point;

	/**
	 * 拓扑中网格对象中的CELL对象
	 *
	 * @author duangr
	 *
	 */
	public class TPCell implements ITPCell
	{
		private var _width:Number = 0;
		private var _height:Number = 0;
		private var _centerPoint:Point = null;
		private var _rowSerial:String = null;
		private var _columnSerial:String = null;

		public function TPCell()
		{
		}

		public function get width():Number
		{
			return _width;
		}

		public function set width(value:Number):void
		{
			_width = value;
		}

		public function get height():Number
		{
			return _height;
		}

		public function set height(value:Number):void
		{
			_height = value;
		}

		public function get centerPoint():Point
		{
			return _centerPoint;
		}

		public function set centerPoint(value:Point):void
		{
			_centerPoint = value;
		}

		public function get rowSerial():String
		{
			return _rowSerial;
		}

		public function set rowSerial(value:String):void
		{
			_rowSerial = value;
		}

		public function get columnSerial():String
		{
			return _columnSerial;
		}

		public function set columnSerial(value:String):void
		{
			_columnSerial = value;
		}

		public function toString():String
		{
			return "TPCell(r:" + rowSerial + " c:" + columnSerial + " c:" + centerPoint + " w:" + width + " h:" + height + ")";
		}
	}
}