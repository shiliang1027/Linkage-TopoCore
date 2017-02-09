package com.linkage.module.topo.framework.core.model.element.point
{
	import com.linkage.module.topo.framework.core.model.element.Element;
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.model.element.line.ILink;
	import com.linkage.module.topo.framework.core.model.element.plane.ITPGroup;

	import mx.utils.ArrayUtil;

	/**
	 * 点对象
	 * @author duangr
	 *
	 */
	public class TPPoint extends Element implements ITPPoint
	{
		// X坐标
		private var _x:Number = 0;
		// Y坐标
		private var _y:Number = 0;
		// 所属的Group
		private var _groupOwner:ITPGroup = null;
		// 终到此节点的线
		private var _inLines:Array = [];
		// 此节点往外发出的线
		private var _outLines:Array = [];


		public function TPPoint()
		{
			super();

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

		override public function copyFrom(element:IElement):void
		{
			super.copyFrom(element);
			var point:ITPPoint = element as ITPPoint;
			x = point.x;
			y = point.y;
		}

		override public function addMoveXY(x:Number, y:Number):void
		{
			this.x += x;
			this.y += y;
			changed = true;
		}

		public function set groupOwner(value:ITPGroup):void
		{
			_groupOwner = value;
		}

		public function get groupOwner():ITPGroup
		{
			return _groupOwner;
		}

		public function get outLines():Array
		{
			return this._outLines;
		}

		public function get inLines():Array
		{
			return this._inLines;
		}

		public function addOutLine(link:ILink):void
		{
			_outLines.push(link);
		}

		public function addInLine(link:ILink):void
		{
			_inLines.push(link);
		}

		public function removeOutLine(link:ILink):void
		{
			var index:int = ArrayUtil.getItemIndex(link, _outLines);
			if (index != -1)
			{
				_outLines.splice(index, 1);
			}
		}

		public function removeInLine(link:ILink):void
		{
			var index:int = ArrayUtil.getItemIndex(link, _inLines);
			if (index != -1)
			{
				_inLines.splice(index, 1);
			}
		}

		override public function resetElementIndex(index:int = -1):void
		{
			if (index >= 0)
			{
				// 节点两端的链路也要刷新
				eachLinks(function(link:ILink):void
					{
						link.resetElementIndex();
					});
			}
		}

		/**
		 * 遍历节点的关联链路,执行回调方法
		 * @param callback 回调方法,入参为 link:ILink
		 *
		 */
		public function eachLinks(callback:Function):void
		{
			if (callback == null)
			{
				return;
			}
			var link:ILink = null;
			for each (link in inLines)
			{
				callback.call(null, link);
			}
			for each (link in outLines)
			{
				callback.call(null, link);
			}
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
				case "groupOwner":
					returnValue = String(groupOwner != null);
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
			callback.call(thisObject, "groupOwner", String(groupOwner != null));
			super.eachProperty(callback, thisObject);
		}

		override public function destroy():void
		{
			super.destroy();
			_groupOwner = null;
			_inLines.length = 0;
			_inLines = null;
			_outLines.length = 0;
			_outLines = null;
		}

		override public function toString():String
		{
			return "TPPoint(" + id + ": " + name + " / " + type + " / (" + x + "," + y + "))";
		}

	}
}