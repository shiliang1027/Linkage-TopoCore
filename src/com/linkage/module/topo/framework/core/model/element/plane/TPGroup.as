package com.linkage.module.topo.framework.core.model.element.plane
{
	import com.linkage.module.topo.framework.Constants;
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.model.element.point.ITPPoint;
	import com.linkage.module.topo.framework.core.parser.ElementProperties;
	import com.linkage.system.structure.map.IMap;
	import com.linkage.system.structure.map.Map;
	import com.linkage.system.utils.StringUtils;

	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	/**
	 * 拓扑分组对象
	 * @author duangr
	 *
	 */
	public class TPGroup extends TPShape implements ITPGroup
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.core.model.element.plane.TPGroup");
		// 默认是否展开
		private var _expanded:Boolean = false;
		// element容器 (id -> Element )
		private var _elementMap:IMap = new Map();
		// 缓存的子对象id(此时子对象可能还没有构造起来)
		private var _cacheChildIds:Array = [];

		// 分组中网元的对端网元 -> 临时创建的链路对象
		private var _oppoLinks:Array = null;

		public function TPGroup()
		{
			super();
			this.type = "group";
		}
		override public function get alarmEnabled():Boolean
		{
			return true;
		}
		public function get expanded():Boolean
		{
			return _expanded;
		}

		public function set expanded(value:Boolean):void
		{
			_expanded = value;
		}

		public function get closedIcon():String
		{
			return StringUtils.isEmpty(getExtendProperty(ElementProperties.GROUP_CLOSED_ICON)) ? ElementProperties.DEFAULT_GROUP_CLOSED_ICON : getExtendProperty(ElementProperties.GROUP_CLOSED_ICON);
		}

		public function set closedIcon(value:String):void
		{
			this.addExtendProperty(ElementProperties.GROUP_CLOSED_ICON, value);
		}

		public function get defaultStatus():String
		{
			return StringUtils.isEmpty(getExtendProperty(ElementProperties.GROUP_DEFAULT_STATUS)) ? ElementProperties.DEFAULT_GROUP_DEFAULT_STATUS : getExtendProperty(ElementProperties.GROUP_DEFAULT_STATUS);
		}

		public function set defaultStatus(value:String):void
		{
			this.addExtendProperty(ElementProperties.GROUP_DEFAULT_STATUS, value);
		}

		override public function copyFrom(element:IElement):void
		{
			super.copyFrom(element);
			var group:ITPGroup = element as ITPGroup;
			closedIcon = group.closedIcon;
			defaultStatus = group.defaultStatus;
		}

		public function addChild(id:String, element:ITPPoint):void
		{
			if (element == null)
			{
				log.error("TPGroup.addChild 时,child为 Null");
				_cacheChildIds.push(id);
				return;
			}
			_elementMap.put(element.id, element);
			element.groupOwner = this;

		}

		public function removeChild(id:String):void
		{
			var element:ITPPoint = _elementMap.remove(id);
			if (element)
			{
				element.groupOwner = null;
			}
		}

		public function eachChild(callback:Function):void
		{
			if (callback == null)
			{
				return;
			}
			_elementMap.forEach(function(id:String, element:ITPPoint):void
				{
					callback.call(null, id, element);
				});
		}

		public function eachCacheChildId(callback:Function):void
		{
			_cacheChildIds.forEach(function(childId:String, index:int, array:Array):void
				{
					callback.call(null, childId);
				});
		}

		override public function addMoveXY(x:Number, y:Number):void
		{
			super.addMoveXY(x, y);
			eachChild(function(id:String, element:ITPPoint):void
				{
					element.addMoveXY(x, y);
				});
		}

		public function isChildInGroupBounds(element:ITPPoint):Boolean
		{
			if (element is ITPPlane)
			{
				return bounds.containsRect((element as ITPPlane).bounds);
			}
			else
			{
				return bounds.contains(element.x, element.y);
			}
		}

		public function set oppoLinks(value:Array):void
		{
			_oppoLinks = value;
		}

		public function get oppoLinks():Array
		{
			return _oppoLinks;
		}

		override public function get weight():uint
		{
			return Constants.WEIGHT_ELEMENT_GROUP;
		}

		override public function get itemName():String
		{
			return Constants.ITEM_NAME_TPGROUP;
		}

		override public function destroy():void
		{
			super.destroy();
			_elementMap.clear();
			_elementMap = null;
			_cacheChildIds.length = 0;
			_cacheChildIds = null;
		}

		override public function toString():String
		{
			return "TPGroup(" + id + ": " + name + " : " + shapeType + " : " + expanded + " : " + closedIcon + ")(" + x + ", " + y + ") w:" + width + " h:" + height;
		}
	}
}