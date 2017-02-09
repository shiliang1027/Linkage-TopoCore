package com.linkage.module.topo.framework.core.model.element.plane
{
	import com.linkage.module.topo.framework.Constants;
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.parser.ElementProperties;
	import com.linkage.system.utils.StringUtils;

	/**
	 * 拓扑内部链接对象
	 * @author duangr
	 *
	 */
	public class HLinkTopo extends TPShape implements IHLinkTopo
	{

		public function HLinkTopo()
		{
			super();
			this.type = ElementProperties.PROPERTYVALUE_OBJECT_TYPE_HLINK_TOPO;
		}

		override public function get alarmEnabled():Boolean
		{
			return true;
		}

		override public function get weight():uint
		{
			return Constants.WEIGHT_ELEMENT_HLINKTOPO;
		}

		override public function get itemName():String
		{
			return Constants.ITEM_NAME_HLINKTOPO;
		}

		public function set linkId(value:String):void
		{
			this.addExtendProperty(ElementProperties.OBJECT_TOPO_ID, value);
		}

		public function get linkId():String
		{
			var value:String = getExtendProperty(ElementProperties.OBJECT_TOPO_ID);
			return StringUtils.isEmpty(value) ? "" : value;
		}

		public function set linkName(value:String):void
		{
			this.addExtendProperty(ElementProperties.OBJECT_TOPO_NAME, value);
		}

		public function get linkName():String
		{
			var value:String = getExtendProperty(ElementProperties.OBJECT_TOPO_NAME);
			return StringUtils.isEmpty(value) ? "" : value;
		}

		public function set linkTopoName(value:String):void
		{
			this.addExtendProperty(ElementProperties.OBJECT_TOPO_TOPONAME, value);
		}

		public function get linkTopoName():String
		{
			var value:String = getExtendProperty(ElementProperties.OBJECT_TOPO_TOPONAME);
			return StringUtils.isEmpty(value) ? "" : value;
		}

		public function set linkTopoType(value:String):void
		{
			this.addExtendProperty(ElementProperties.OBJECT_TOPO_TYPE, value);
		}

		public function get linkTopoType():String
		{
			var value:String = getExtendProperty(ElementProperties.OBJECT_TOPO_TYPE);
			return StringUtils.isEmpty(value) ? ElementProperties.DEFAULT_OBJECT_TOPO_TYPE : value;
		}

		public function set openType(value:String):void
		{
			this.addExtendProperty(ElementProperties.OBJECT_TOPO_OPENTYPE, value);
		}

		public function get openType():String
		{
			var value:String = getExtendProperty(ElementProperties.OBJECT_TOPO_OPENTYPE);
			return StringUtils.isEmpty(value) ? ElementProperties.DEFAULT_OBJECT_TOPO_OPENTYPE : value;
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

		override public function copyFrom(element:IElement):void
		{
			super.copyFrom(element);
			var hlinkTopo:IHLinkTopo = element as IHLinkTopo;
			linkId = hlinkTopo.linkId;
			linkName = hlinkTopo.linkName;
			linkTopoType = hlinkTopo.linkTopoType;
			openType = hlinkTopo.openType;
			showType = hlinkTopo.showType;
		}

		override public function toString():String
		{
			return "HLinkTopo(" + id + ": " + name + " : " + shapeType + ")(" + x + ", " + y + ") w:" + width + " h:" + height;
		}
	}
}