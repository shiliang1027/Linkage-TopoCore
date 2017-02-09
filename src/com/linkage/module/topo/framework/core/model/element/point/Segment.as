package com.linkage.module.topo.framework.core.model.element.point
{
	import com.linkage.module.topo.framework.Constants;

	/**
	 * 网段对象
	 * @author duangr
	 *
	 */
	public class Segment extends Node implements ISegment
	{
		public function Segment()
		{
			super();
			this.type = "segment";
		}

		override public function get weight():uint
		{
			return Constants.WEIGHT_ELEMENT_SEGMENT;
		}

		override public function get itemName():String
		{
			return Constants.ITEM_NAME_SEGMENT;
		}

		override public function toString():String
		{
			return "Segment(" + id + ": " + name + " / " + type + " / (" + x + "," + y + "))";
		}
	}
}