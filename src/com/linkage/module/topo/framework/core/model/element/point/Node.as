package com.linkage.module.topo.framework.core.model.element.point
{
	import com.linkage.module.topo.framework.Constants;
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.parser.ElementProperties;
	import com.linkage.system.utils.StringUtils;

	/**
	 * 节点对象
	 * @author duangr
	 *
	 */
	public class Node extends TPPoint implements INode
	{
		// 节点的图标
		private var _icon:String = null;

		public function Node()
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
				case "icon":
					returnValue = this._icon;
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
			callback.call(thisObject, "icon", this._icon);
			super.eachProperty(callback, thisObject);
		}

		public function get iconWidth():Number
		{
			return StringUtils.isEmpty(getExtendProperty(ElementProperties.ICON_WIDTH)) ? ElementProperties.DEFAULT_ICON_WIDTH : Number(getExtendProperty(ElementProperties.ICON_WIDTH));
		}

		public function set iconWidth(value:Number):void
		{
			this.addExtendProperty(ElementProperties.ICON_WIDTH, String(value));
		}

		public function get iconHeight():Number
		{
			return StringUtils.isEmpty(getExtendProperty(ElementProperties.ICON_HEIGHT)) ? ElementProperties.DEFAULT_ICON_HEIGHT : Number(getExtendProperty(ElementProperties.ICON_HEIGHT));
		}

		public function set iconHeight(value:Number):void
		{
			this.addExtendProperty(ElementProperties.ICON_HEIGHT, String(value));
		}

		override public function get alarmEnabled():Boolean
		{
			return true;
		}

		override public function get weight():uint
		{
			return Constants.WEIGHT_ELEMENT_NODE;
		}

		override public function get itemName():String
		{
			return Constants.ITEM_NAME_NODE;
		}

		public function get icon():String
		{
			return _icon;
		}

		public function set icon(icon:String):void
		{
			this._icon = icon;
		}

		override public function copyFrom(element:IElement):void
		{
			super.copyFrom(element);
			var node:INode = element as INode;
			icon = node.icon;
		}

		override public function toString():String
		{
			return itemName + "(" + id + ": " + name + " / " + type + " / (" + x + "," + y + "))";
		}
	}
}