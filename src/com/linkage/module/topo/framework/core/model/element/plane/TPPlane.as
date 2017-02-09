package com.linkage.module.topo.framework.core.model.element.plane
{
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.model.element.point.TPObject;

	import flash.geom.Rectangle;

	/**
	 * 面对象
	 * @author duangr
	 *
	 */
	public class TPPlane extends TPObject implements ITPPlane
	{
		// 宽度
		private var _width:int = 0;
		// 高度
		private var _height:int = 0;

		// ---- 边界的范围 ----
		private var _rectangle:Rectangle = new Rectangle();

		public function TPPlane()
		{
			super();
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
			callback.call(thisObject, "width", this._width);
			callback.call(thisObject, "height", this._height);
			super.eachProperty(callback, thisObject);
		}

		[Bindable]
		public function get width():int
		{
			return _width;
		}

		public function set width(value:int):void
		{
			this._width = value;
			_rectangle.width = value;
			_rectangle.x = x - _rectangle.width / 2
		}

		[Bindable]
		public function get height():int
		{
			return _height;
		}

		public function set height(value:int):void
		{
			this._height = value;
			_rectangle.height = value;
			_rectangle.y = y - _rectangle.height / 2;
		}

		override public function set x(x:Number):void
		{
			super.x = x;
			_rectangle.x = x - _rectangle.width / 2;
		}

		override public function set y(y:Number):void
		{
			super.y = y;
			_rectangle.y = y - _rectangle.height / 2;
		}

		public function get bounds():Rectangle
		{
			return _rectangle;
		}

		override public function copyFrom(element:IElement):void
		{
			super.copyFrom(element);
			var plane:ITPPlane = element as ITPPlane;
			width = plane.width;
			height = plane.height;
		}

		override public function toString():String
		{
			return "TPPlane(" + id + ": " + name + " / " + type + ")";
		}

	}
}