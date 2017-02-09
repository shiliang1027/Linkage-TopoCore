package com.linkage.module.topo.framework.core.model.element.point
{
	import com.linkage.module.topo.framework.Constants;
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.parser.ElementProperties;
	import com.linkage.system.utils.StringUtils;

	/**
	 * 文本对象
	 * @author duangr
	 *
	 */
	public class TPText extends TPObject implements ITPText
	{

		public function TPText()
		{
			super();
			this.type = ElementProperties.PROPERTYVALUE_OBJECT_TYPE_TEXT;
		}

		override public function get weight():uint
		{
			return Constants.WEIGHT_ELEMENT_TEXT;
		}

		override public function get itemName():String
		{
			return Constants.ITEM_NAME_TPTEXT;
		}

		public function set text(value:String):void
		{
			this.addExtendProperty(ElementProperties.OBJECT_TEXT, value);
		}

		public function get text():String
		{
			var value:String = getExtendProperty(ElementProperties.OBJECT_TEXT);
			return StringUtils.isEmpty(value) ? "" : value;
		}

		public function set textColor(value:uint):void
		{
			this.addExtendProperty(ElementProperties.OBJECT_TEXT_COLOR, String(value));
		}

		public function get textColor():uint
		{
			var value:String = getExtendProperty(ElementProperties.OBJECT_TEXT_COLOR);
			return StringUtils.isEmpty(value) ? ElementProperties.DEFAULT_OBJECT_TEXT_COLOR : uint(value);
		}

		public function set textSize(value:int):void
		{
			this.addExtendProperty(ElementProperties.OBJECT_TEXT_SIZE, String(value));
		}

		public function get textSize():int
		{
			var value:String = getExtendProperty(ElementProperties.OBJECT_TEXT_SIZE);
			return StringUtils.isEmpty(value) ? ElementProperties.DEFAULT_OBJECT_TEXT_SIZE : int(value);
		}

		override public function copyFrom(element:IElement):void
		{
			super.copyFrom(element);
			var tpText:ITPText = element as ITPText;
			text = tpText.text;
			textColor = tpText.textColor;
			textSize = tpText.textSize;
		}


		override public function toString():String
		{
			return "Text(" + id + ": " + name + " / " + type + " / (" + x + "," + y + "))";
		}
	}
}