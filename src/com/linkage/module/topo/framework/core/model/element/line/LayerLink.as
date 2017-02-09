package com.linkage.module.topo.framework.core.model.element.line
{
	import com.linkage.module.topo.framework.Constants;
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.model.element.plane.IHLinkLayer;
	import com.linkage.module.topo.framework.core.parser.ElementProperties;
	import com.linkage.system.utils.StringUtils;

	/**
	 * 缩略图之间的链路
	 * @author duangr
	 *
	 */
	public class LayerLink extends Link implements ILayerLink
	{
		// 始端网元所处的缩略图
		private var _fromLayer:IHLinkLayer = null;
		// 终端网元所处的缩略图
		private var _toLayer:IHLinkLayer = null;

		// 起点网元id
		private var _fromElementId:String = null;
		// 终点网元id
		private var _toElementId:String = null;

		public function LayerLink()
		{
			super();
			this.type = ElementProperties.PROPERTYVALUE_LINK_TYPE_LAYER;
		}

		override public function get weight():uint
		{
			return Constants.WEIGHT_ELEMENT_LAYERLINK;
		}

		override public function get itemName():String
		{
			return Constants.ITEM_NAME_LAYERLINK;
		}

		public function get fromElementId():String
		{
			return _fromElementId;
		}

		public function set fromElementId(value:String):void
		{
			_fromElementId = value;
		}

		public function get toElementId():String
		{
			return _toElementId;
		}

		public function set toElementId(value:String):void
		{
			_toElementId = value;
		}

		public function get fromLayerId():String
		{
			var value:String = getExtendProperty(ElementProperties.LINK_FROM_LAYER);
			return StringUtils.isEmpty(value) ? "" : value;
		}

		public function set fromLayerId(value:String):void
		{
			this.addExtendProperty(ElementProperties.LINK_FROM_LAYER, value);
		}

		public function get toLayerId():String
		{
			var value:String = getExtendProperty(ElementProperties.LINK_TO_LAYER);
			return StringUtils.isEmpty(value) ? "" : value;
		}

		public function set toLayerId(value:String):void
		{
			this.addExtendProperty(ElementProperties.LINK_TO_LAYER, value);
		}

		public function get fromLayer():IHLinkLayer
		{
			return _fromLayer;
		}

		public function set fromLayer(value:IHLinkLayer):void
		{
			_fromLayer = value;
		}

		public function get toLayer():IHLinkLayer
		{
			return _toLayer;
		}

		public function set toLayer(value:IHLinkLayer):void
		{
			_toLayer = value;
		}

		override public function get lineColor():uint
		{
			return StringUtils.isEmpty(getExtendProperty(ElementProperties.LINE_COLOR)) ? ElementProperties.DEFAULT_LAYERLINK_COLOR : uint(getExtendProperty(ElementProperties.LINE_COLOR));
		}

		override public function get lineWidth():Number
		{
			return StringUtils.isEmpty(getExtendProperty(ElementProperties.LINE_WIDTH)) ? ElementProperties.DEFAULT_LAYERLINK_WIDTH : Number(getExtendProperty(ElementProperties.LINE_WIDTH));
		}

		override public function copyFrom(element:IElement):void
		{
			super.copyFrom(element);
			var layerLink:ILayerLink = element as ILayerLink;
			fromLayerId = layerLink.fromLayerId;
			toLayerId = layerLink.toLayerId;
			fromElementId = layerLink.fromElementId;
			toElementId = layerLink.toElementId;
			fromLayer = layerLink.fromLayer;
			toLayer = layerLink.toLayer;
		}

		override public function destroy():void
		{
			super.destroy();
			_fromLayer = null;
			_toLayer = null;
			_fromElementId = null;
			_toElementId = null;
		}

		override public function toString():String
		{
			return "LayerLink(" + id + ":" + name + ", type:" + type + " {" + fromElement + " -> " + toElement + "})";
		}
	}
}