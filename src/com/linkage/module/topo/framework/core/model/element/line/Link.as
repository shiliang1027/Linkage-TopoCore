package com.linkage.module.topo.framework.core.model.element.line
{
	import com.linkage.module.topo.framework.Constants;
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.model.element.point.ITPPoint;
	import com.linkage.module.topo.framework.core.parser.ElementProperties;
	import com.linkage.system.utils.StringUtils;

	/**
	 * 链路对象,两端要连接对象
	 * @author duangr
	 *
	 */
	public class Link extends Line implements ILink
	{
		// 开始端节点
		private var _fromElement:ITPPoint = null;
		// 结束端节点
		private var _toElement:ITPPoint = null;
		// 默认是否展开
		private var _expanded:Boolean = false;

		public function Link()
		{
			super();
			this.type = ""; //ElementProperties.PROPERTYVALUE_LINK_TYPE_NORMAL;
		}

		override public function get alarmEnabled():Boolean
		{
			return true;
		}

		override public function get weight():uint
		{
			return Constants.WEIGHT_ELEMENT_LINK;
		}

		override public function get itemName():String
		{
			return Constants.ITEM_NAME_LINK;
		}

		override public function getExtendProperty(key:String):String
		{
			if(key != null && StringUtils.endsWith(key, "#i"))
			{
				var pos:Number = key.lastIndexOf("#i");
				key = key.substring(0, pos) + feature.selectChildFeatureKey;
			}
			return super.getExtendProperty(key);
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
				case "expanded":
					return String(this._expanded);
					break;
				case "from":
					return this._fromElement.id;
					break;
				case "to":
					return this._toElement.id;
					break;
				default:
					break;
			}

			// 若还没有找到属性,可以找两端网元的属性
			if (StringUtils.startsWith(key, "_FE_"))
			{
				return _fromElement.getProperty(key.substring(4));
			}
			if (StringUtils.startsWith(key, "_TE_"))
			{
				return _toElement.getProperty(key.substring(4));
			}

			return returnValue;
		}

		override public function eachProperty(callback:Function, thisObject:* = null):void
		{
			if (callback == null)
			{
				return;
			}
			callback.call(thisObject, "expanded", this._expanded);
			callback.call(thisObject, "from", this._fromElement.id);
			callback.call(thisObject, "to", this._toElement.id);
			super.eachProperty(callback, thisObject);
		}

		public function get fromElement():ITPPoint
		{
			return this._fromElement;
		}

		public function set fromElement(from:ITPPoint):void
		{
			this._fromElement = from;
		}

		public function get toElement():ITPPoint
		{
			return this._toElement;
		}

		public function set toElement(to:ITPPoint):void
		{
			this._toElement = to;
		}

		override public function refresh():void
		{
		}

		public function get expanded():Boolean
		{
			return _expanded;
		}

		public function set expanded(value:Boolean):void
		{
			_expanded = value;
		}

		public function get linkBessel2OffsetV():Number
		{
			return StringUtils.isEmpty(getExtendProperty(ElementProperties.LINK_BESSEL2_OFFSETV)) ? ElementProperties.DEFAULT_LINK_BESSEL2_OFFSETV : Number(getExtendProperty(ElementProperties.LINK_BESSEL2_OFFSETV));
		}

		public function set linkBessel2OffsetV(value:Number):void
		{
			this.addExtendProperty(ElementProperties.LINK_BESSEL2_OFFSETV, String(value));
		}
		
		public function get poly_location():String
		{
			return StringUtils.isEmpty(getExtendProperty(ElementProperties.LINK_POLY_LOCATION)) ? ElementProperties.LINK_POLY_LOCATION : String(getExtendProperty(ElementProperties.LINK_POLY_LOCATION));
		}
		
		public function set poly_location(value:String):void
		{
			this.addExtendProperty(ElementProperties.LINK_POLY_LOCATION, String(value));
		}
		
		
		public function get linkCount():int
		{
			return StringUtils.isEmpty(getExtendProperty(ElementProperties.LINK_COUNT)) ? ElementProperties.DEFAULT_LINK_COUNT : int(getExtendProperty(ElementProperties.LINK_COUNT));
		}

		public function set linkCount(value:int):void
		{
			this.addExtendProperty(ElementProperties.LINK_COUNT, String(value));
		}

		public function get linkDefaultStatus():String
		{
			return StringUtils.isEmpty(getExtendProperty(ElementProperties.LINK_DEFAULT_STATUS)) ? ElementProperties.DEFAULT_LINK_DEFAULT_STATUS : getExtendProperty(ElementProperties.LINK_DEFAULT_STATUS);
		}

		public function set linkDefaultStatus(value:String):void
		{
			this.addExtendProperty(ElementProperties.LINK_DEFAULT_STATUS, value);
		}

		public function get linkOpenGap():Number
		{
			return StringUtils.isEmpty(getExtendProperty(ElementProperties.LINK_OPEN_GAP)) ? ElementProperties.DEFAULT_LINK_OPEN_GAP : Number(getExtendProperty(ElementProperties.LINK_OPEN_GAP));
		}

		public function set linkOpenGap(value:Number):void
		{
			this.addExtendProperty(ElementProperties.LINK_OPEN_GAP, String(value));
		}

		public function get linkOpenOffsetH():Number
		{
			return StringUtils.isEmpty(getExtendProperty(ElementProperties.LINK_OPEN_OFFSETH)) ? ElementProperties.DEFAULT_LINK_OPEN_OFFSETH : Number(getExtendProperty(ElementProperties.LINK_OPEN_OFFSETH));
		}

		public function set linkOpenOffsetH(value:Number):void
		{
			this.addExtendProperty(ElementProperties.LINK_OPEN_OFFSETH, String(value));
		}

		public function get linkOpenType():String
		{
			return StringUtils.isEmpty(getExtendProperty(ElementProperties.LINK_OPEN_TYPE)) ? ElementProperties.DEFAULT_LINK_OPEN_TYPE : getExtendProperty(ElementProperties.LINK_OPEN_TYPE);
		}

		public function set linkOpenType(value:String):void
		{
			this.addExtendProperty(ElementProperties.LINK_OPEN_TYPE, value);
		}

		public function get linkFromArrowEnable():Boolean
		{
			return getExtendProperty(ElementProperties.LINK_FROM_ARROW) == ElementProperties.PROPERTYVALUE_LINK_ARROW_TRUE;
		}

		public function set linkFromArrowEnable(value:Boolean):void
		{
			if (value)
			{
				this.addExtendProperty(ElementProperties.LINK_FROM_ARROW, ElementProperties.PROPERTYVALUE_LINK_ARROW_TRUE);
			}
			else
			{
				this.addExtendProperty(ElementProperties.LINK_FROM_ARROW, ElementProperties.PROPERTYVALUE_LINK_ARROW_FALSE);
			}
		}

		public function get linkFromArrowType():String
		{
			return StringUtils.isEmpty(getExtendProperty(ElementProperties.LINK_FROM_ARROW_TYPE)) ? ElementProperties.DEFAULT_LINK_ARROW_TYPE : getExtendProperty(ElementProperties.LINK_FROM_ARROW_TYPE);
		}

		public function set linkFromArrowType(value:String):void
		{
			this.addExtendProperty(ElementProperties.LINK_FROM_ARROW_TYPE, value);
		}

		public function get linkFromArrowHeight():Number
		{
			return StringUtils.isEmpty(getExtendProperty(ElementProperties.LINK_FROM_ARROW_HEIGHT)) ? ElementProperties.DEFAULT_LINK_ARROW_HEIGHT : Number(getExtendProperty(ElementProperties.LINK_FROM_ARROW_HEIGHT));
		}

		public function set linkFromArrowHeight(value:Number):void
		{
			this.addExtendProperty(ElementProperties.LINK_FROM_ARROW_HEIGHT, String(value));
		}

		public function get linkFromArrowWidth():Number
		{
			return StringUtils.isEmpty(getExtendProperty(ElementProperties.LINK_FROM_ARROW_WIDTH)) ? ElementProperties.DEFAULT_LINK_ARROW_WIDTH : Number(getExtendProperty(ElementProperties.LINK_FROM_ARROW_WIDTH));
		}

		public function set linkFromArrowWidth(value:Number):void
		{
			this.addExtendProperty(ElementProperties.LINK_FROM_ARROW_WIDTH, String(value));
		}

		public function get linkToArrowEnable():Boolean
		{
			return getExtendProperty(ElementProperties.LINK_TO_ARROW) == ElementProperties.PROPERTYVALUE_LINK_ARROW_TRUE;
		}

		public function set linkToArrowEnable(value:Boolean):void
		{
			if (value)
			{
				this.addExtendProperty(ElementProperties.LINK_TO_ARROW, ElementProperties.PROPERTYVALUE_LINK_ARROW_TRUE);
			}
			else
			{
				this.addExtendProperty(ElementProperties.LINK_TO_ARROW, ElementProperties.PROPERTYVALUE_LINK_ARROW_FALSE);
			}
		}

		public function get linkToArrowType():String
		{
			return StringUtils.isEmpty(getExtendProperty(ElementProperties.LINK_TO_ARROW_TYPE)) ? ElementProperties.DEFAULT_LINK_ARROW_TYPE : getExtendProperty(ElementProperties.LINK_TO_ARROW_TYPE);
		}

		public function set linkToArrowType(value:String):void
		{
			this.addExtendProperty(ElementProperties.LINK_TO_ARROW_TYPE, value);
		}

		public function get linkToArrowHeight():Number
		{
			return StringUtils.isEmpty(getExtendProperty(ElementProperties.LINK_TO_ARROW_HEIGHT)) ? ElementProperties.DEFAULT_LINK_ARROW_HEIGHT : Number(getExtendProperty(ElementProperties.LINK_TO_ARROW_HEIGHT));
		}

		public function set linkToArrowHeight(value:Number):void
		{
			this.addExtendProperty(ElementProperties.LINK_TO_ARROW_HEIGHT, String(value));
		}

		public function get linkToArrowWidth():Number
		{
			return StringUtils.isEmpty(getExtendProperty(ElementProperties.LINK_TO_ARROW_WIDTH)) ? ElementProperties.DEFAULT_LINK_ARROW_WIDTH : Number(getExtendProperty(ElementProperties.LINK_TO_ARROW_WIDTH));
		}

		public function set linkToArrowWidth(value:Number):void
		{
			this.addExtendProperty(ElementProperties.LINK_TO_ARROW_WIDTH, String(value))
		}

		override public function copyFrom(element:IElement):void
		{
			super.copyFrom(element);
			var link:ILink = element as ILink;
			fromElement = link.fromElement;
			toElement = link.toElement;
			linkBessel2OffsetV = link.linkBessel2OffsetV;
			linkCount = link.linkCount;
			linkDefaultStatus = link.linkDefaultStatus;
			linkOpenGap = link.linkOpenGap;
			linkOpenOffsetH = link.linkOpenOffsetH;
			linkOpenType = link.linkOpenType;
			linkFromArrowEnable = link.linkFromArrowEnable;
			linkFromArrowType = link.linkFromArrowType;
			linkFromArrowHeight = link.linkFromArrowHeight;
			linkFromArrowWidth = link.linkFromArrowWidth;
			linkToArrowEnable = link.linkToArrowEnable;
			linkToArrowType = link.linkToArrowType;
			linkToArrowHeight = link.linkToArrowHeight;
			linkToArrowWidth = link.linkToArrowWidth;
		}

		override public function destroy():void
		{
			super.destroy();
			_fromElement = null;
			_toElement = null;
		}

		override public function toString():String
		{
			return "Link(" + id + ":" + name + ", type:" + type + ", expanded:" + expanded + ", linkCount:" + linkCount + " {" + fromElement + " -> " + toElement + "})";
		}
	}
}