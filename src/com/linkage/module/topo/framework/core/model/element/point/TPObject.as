package com.linkage.module.topo.framework.core.model.element.point
{
	import com.linkage.module.topo.framework.Constants;
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.parser.ElementProperties;

	/**
	 * 拓扑内部的简单对象
	 * @author duangr
	 *
	 */
	public class TPObject extends Node implements ITPObject
	{
		public function TPObject()
		{
			super();
			this.type = ElementProperties.PROPERTYVALUE_OBJECT_TYPE_OBJECT;
		}

		override public function getProperty(key:String):String
		{
			return super.getProperty(key);
		}

		override public function eachProperty(callback:Function, thisObject:* = null):void
		{
			super.eachProperty(callback, thisObject);
		}

		override public function get alarmEnabled():Boolean
		{
			return false;
		}

		override public function get weight():uint
		{
			return Constants.WEIGHT_ELEMENT_TPOBJECT;
		}

		override public function get itemName():String
		{
			return Constants.ITEM_NAME_TPOBJECT;
		}

		override public function copyFrom(element:IElement):void
		{
			super.copyFrom(element);
		}

		override public function toString():String
		{
			return "TPObject(" + id + ": " + name + " / " + type + " / (" + x + "," + y + "))";
		}
	}
}