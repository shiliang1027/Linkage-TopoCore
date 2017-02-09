package com.linkage.module.topo.framework.core.model.element.line
{
	import com.linkage.module.topo.framework.Constants;
	import com.linkage.module.topo.framework.core.model.element.Element;
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.parser.ElementProperties;
	import com.linkage.system.utils.StringUtils;
	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;
	
	import flash.geom.Point;

	/**
	 * 线对象
	 * 为了能整体移动线,起点和终点的左边都是相对自身x,y的
	 * @author duangr
	 *
	 */
	public class TPLine extends Line implements ITPLine
	{
		// X坐标
		private var _x:Number = 0;
		// Y坐标
		private var _y:Number = 0;
		// 宽度
		private var _width:int = 0;
		// 高度
		private var _height:int = 0;

		/**
		 * 线的起始点坐标
		 */
		private var _fromPoint:Point = null;
		/**
		 * 线的结束点坐标
		 */
		private var _toPoint:Point = null;
		// 拐角点(控制点)
		private var _flexPoints:Array = [];


		public function TPLine()
		{
			super();
			this.type = ElementProperties.PROPERTYVALUE_OBJECT_TYPE_LINE;
		}

		override public function get weight():uint
		{
			return Constants.WEIGHT_ELEMENT_LINE;
		}

		override public function get itemName():String
		{
			return Constants.ITEM_NAME_TPLINE;
		}

		override public function getProperty(key:String):String
		{
			var returnValue:String = super.getProperty(key);

			if (returnValue != null)
			{
				return returnValue;
			}

			switch (key)
			{
				case "x":
					returnValue = this._x.toString();
					break;
				case "y":
					returnValue = this._y.toString();
					break;
				case "width":
					returnValue = this._width.toString();
					break;
				case "height":
					returnValue = this._height.toString();
					break;
				default:
					break;
			}

			return returnValue;
		}

		override public function eachProperty(callback:Function, thisObject:* = null):void
		{
			if (callback == null)
			{
				return;
			}
			callback.call(thisObject, "x", this._x);
			callback.call(thisObject, "y", this._y);
			callback.call(thisObject, "width", this._width);
			callback.call(thisObject, "height", this._height);
			super.eachProperty(callback, thisObject);
		}

		public function get x():Number
		{
			return _x;
		}

		public function set x(x:Number):void
		{
			this._x = x;
		}

		public function get y():Number
		{
			return _y;
		}

		public function set y(y:Number):void
		{
			this._y = y;
		}

		public function get width():int
		{
			return _width;
		}

		public function set width(value:int):void
		{
			this._width = value;
		}

		public function get height():int
		{
			return _height;
		}

		public function set height(value:int):void
		{
			this._height = value;
		}

		override public function addMoveXY(x:Number, y:Number):void
		{
			this.x += x;
			this.y += y;
			changed = true;
		}

		public function get fromPoint():Point
		{
			return this._fromPoint;
		}

		public function set fromPoint(from:Point):void
		{
			this._fromPoint = from;
		}

		public function get toPoint():Point
		{
			return this._toPoint;
		}

		public function set toPoint(to:Point):void
		{
			this._toPoint = to;
		}

		public function get flexPoints():Array
		{
			// 在 TPLineXMLParser 中负责解析和拼装最终的扩展属性
			return _flexPoints;
		}

		public function set flexPoints(value:Array):void
		{
			// 在 TPLineXMLParser 中负责解析和拼装最终的扩展属性
			_flexPoints = value;
		}


		override public function copyFrom(element:IElement):void
		{
			super.copyFrom(element);
			var line:ITPLine = element as ITPLine;
			fromPoint = line.fromPoint;
			toPoint = line.toPoint;
			flexPoints = line.flexPoints;
		}

		override public function destroy():void
		{
			super.destroy();
			_fromPoint = null;
			_toPoint = null;
			_flexPoints = null;
		}

		override public function toString():String
		{
			return "TPLine(" + id + ": " + name + " / " + type + ")";
		}

	}
}