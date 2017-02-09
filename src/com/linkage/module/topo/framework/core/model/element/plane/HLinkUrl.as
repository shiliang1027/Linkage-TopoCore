package com.linkage.module.topo.framework.core.model.element.plane
{
	import com.linkage.module.topo.framework.Constants;
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.parser.ElementProperties;
	import com.linkage.system.utils.StringUtils;

	/**
	 * 超链接URL对象
	 * @author duangr
	 *
	 */
	public class HLinkUrl extends TPShape implements IHLinkUrl
	{
		public function HLinkUrl()
		{
			super();
			this.type = ElementProperties.PROPERTYVALUE_OBJECT_TYPE_HLINK_URL;
		}

		override public function get weight():uint
		{
			return Constants.WEIGHT_ELEMENT_HLINKURL;
		}

		override public function get itemName():String
		{
			return Constants.ITEM_NAME_TPTEXT;
		}

		public function set url(value:String):void
		{
			this.addExtendProperty(ElementProperties.OBJECT_URL, value);
		}

		public function get url():String
		{
			var value:String = getExtendProperty(ElementProperties.OBJECT_URL);
			return StringUtils.isEmpty(value) ? "" : value;
		}

		public function set showType(value:String):void
		{
			this.addExtendProperty(ElementProperties.OBJECT_SHOW_TYPE, value);
		}

		public function get showType():String
		{
			var value:String = getExtendProperty(ElementProperties.OBJECT_SHOW_TYPE);
			return StringUtils.isEmpty(value) ? ElementProperties.DEFAULT_OBJECT_SHOW_TYPE : value;
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
			var hlinkUrl:IHLinkUrl = element as IHLinkUrl;
			url = hlinkUrl.url;
			showType = hlinkUrl.showType;
			text = hlinkUrl.text;
			textColor = hlinkUrl.textColor;
			textSize = hlinkUrl.textSize;
		}

		override public function toString():String
		{
			return "HLinkUrl(" + id + ": " + name + " / " + url + " / (" + x + "," + y + "))";
		}
	}
}