package com.linkage.module.topo.framework.core.model.element.plane
{
	import com.linkage.module.topo.framework.Constants;
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.parser.ElementProperties;
	import com.linkage.module.topo.framework.view.component.TopoLayer;
	import com.linkage.system.utils.StringUtils;

	import mx.core.UIComponent;

	import spark.components.Group;

	public class HLinkLayer extends TPShape implements IHLinkLayer
	{
		// 拓扑层次展现对象
		private var _topoLayer:TopoLayer = null;
		// 拓扑层次展现对象的容器
		private var _topoLayerContainer:Group = null;
		// 拓扑层次展现对象是否初始化完成的标志位
		private var _topoLayerCreationComplete:Boolean = false;

		public function HLinkLayer()
		{
			super();
			this.type = ElementProperties.PROPERTYVALUE_OBJECT_TYPE_HLINK_LAYER;
		}

		override public function get weight():uint
		{
			return Constants.WEIGHT_ELEMENT_HLINKLAYER;
		}

		override public function get itemName():String
		{
			return Constants.ITEM_NAME_HLINKLAYER;
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

		public function set sourceId(value:String):void
		{
			this.addExtendProperty(ElementProperties.OBJECT_TOPO_SOURCE_ID, value);
		}

		public function get sourceId():String
		{
			var value:String = getExtendProperty(ElementProperties.OBJECT_TOPO_SOURCE_ID);
			return StringUtils.isEmpty(value) ? "" : value;
		}

		public function set sourceName(value:String):void
		{
			this.addExtendProperty(ElementProperties.OBJECT_TOPO_SOURCE_NAME, value);
		}

		public function get sourceName():String
		{
			var value:String = getExtendProperty(ElementProperties.OBJECT_TOPO_SOURCE_NAME);
			return StringUtils.isEmpty(value) ? "" : value;
		}

		public function set sourceTopoName(value:String):void
		{
			this.addExtendProperty(ElementProperties.OBJECT_TOPO_SOURCE_TOPONAME, value);
		}

		public function get sourceTopoName():String
		{
			var value:String = getExtendProperty(ElementProperties.OBJECT_TOPO_SOURCE_TOPONAME);
			return StringUtils.isEmpty(value) ? "" : value;
		}

		public function set sourceTopoType(value:String):void
		{
			this.addExtendProperty(ElementProperties.OBJECT_TOPO_SOURCE_TYPE, value);
		}

		public function get sourceTopoType():String
		{
			var value:String = getExtendProperty(ElementProperties.OBJECT_TOPO_SOURCE_TYPE);
			return StringUtils.isEmpty(value) ? ElementProperties.DEFAULT_OBJECT_TOPO_TYPE : value;
		}

		public function set sourceTopoParam(value:String):void
		{
			this.addExtendProperty(ElementProperties.OBJECT_TOPO_SOURCE_PARAM, value);
		}

		public function get sourceTopoParam():String
		{
			var value:String = getExtendProperty(ElementProperties.OBJECT_TOPO_SOURCE_PARAM);
			return StringUtils.isEmpty(value) ? "" : value;
		}

		override public function copyFrom(element:IElement):void
		{
			super.copyFrom(element);
			var hlinkLayer:IHLinkLayer = element as IHLinkLayer;
			linkId = hlinkLayer.linkId;
			linkName = hlinkLayer.linkName;
			linkTopoName = hlinkLayer.linkTopoName;
			linkTopoType = hlinkLayer.linkTopoType;
			openType = hlinkLayer.openType;
			sourceId = hlinkLayer.sourceId;
			sourceName = hlinkLayer.sourceName;
			sourceTopoName = hlinkLayer.sourceTopoName;
			sourceTopoType = hlinkLayer.sourceTopoType;
			sourceTopoParam = hlinkLayer.sourceTopoParam;
		}


		public function set topoLayer(value:TopoLayer):void
		{
			_topoLayer = value;
		}

		public function get topoLayer():TopoLayer
		{
			return _topoLayer;
		}

		public function set topoLayerCreationComplete(value:Boolean):void
		{
			_topoLayerCreationComplete = value;
		}

		public function get topoLayerCreationComplete():Boolean
		{
			return _topoLayerCreationComplete;
		}

		public function set topoLayerContainer(value:Group):void
		{
			_topoLayerContainer = value;
		}

		public function get topoLayerContainer():Group
		{
			return _topoLayerContainer;
		}

		override public function destroy():void
		{
			super.destroy();
			_topoLayer = null;
			_topoLayerContainer = null;
		}

		override public function toString():String
		{
			return "HLinkLayer(" + id + ": " + name + " : " + shapeType + ")(" + x + ", " + y + ") w:" + width + " h:" + height;
		}
	}
}