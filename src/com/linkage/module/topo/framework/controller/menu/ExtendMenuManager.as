package com.linkage.module.topo.framework.controller.menu
{
	import com.linkage.module.topo.framework.Constants;
	import com.linkage.module.topo.framework.controller.event.TopoEvent;
	import com.linkage.module.topo.framework.core.Feature;
	import com.linkage.module.topo.framework.core.parser.ElementProperties;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;
	import com.linkage.module.topo.framework.view.component.TopoLayer;
	import com.linkage.system.structure.map.IMap;
	import com.linkage.system.structure.map.Map;
	import com.linkage.system.utils.StringUtils;

	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenuItem;

	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	/**
	 * 扩展视图菜单
	 * @author duangr
	 *
	 */
	public class ExtendMenuManager extends MenuManager
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.controller.menu.ExtendMenuManager");
		// 视图的前缀
		private static const VIEW_PREFIX:String = "view/";
		// 视图id与菜单的映射
		private var _viewId2MenuItemMap:IMap = new Map();
		// 菜单节点对象与右键菜单资源的映射Map
		private var _extendMenuItem2ResMap:IMap = new Map();

		public function ExtendMenuManager(topoCanvas:TopoCanvas)
		{
			super(topoCanvas);
		}

		override public function clear():void
		{
			_viewId2MenuItemMap.clear();
			_extendMenuItem2ResMap.clear();
		}

		override protected function initExtendMenuItems(feature:Feature, features:Array, topoCanvas:TopoCanvas):Array
		{
			var menuItems:Array = [];
			// 单选时,并且当前不是视图时 生效
			if (feature && !(features.length > 1) && topoCanvas.topoType != ElementProperties.PROPERTYVALUE_NETVIEW_TYPE_VIEW)
			{
				feature.element.eachProperty(function(key:String, value:String):void
					{

						if (StringUtils.startsWith(key, VIEW_PREFIX))
						{
							var menuItem:ContextMenuItem = _viewId2MenuItemMap.get(key);
							if (menuItem == null)
							{
								// 构造菜单对象
								menuItem = new ContextMenuItem(value);
								menuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, extendCMenuItemHandler);
								// 构造菜单的资源对象
								var menuResItem:MenuResItem = new MenuResItem();
								// 先设置几个后续有用的属性
								menuResItem.name = value;
								menuResItem.type = Constants.MENU_TYPE_EVENT;
								menuResItem.action = "EventType(" + TopoEvent.GO_DOWN + ") EventProperty(id=" + key + ", type=view)";

								_viewId2MenuItemMap.put(key, menuItem);
								_extendMenuItem2ResMap.put(menuItem, menuResItem);
							}
							menuItems.push(menuItem);
						}
					});
			}
			return menuItems;
		}


		/**
		 * 扩展的菜单捕获回调
		 * @param event
		 *
		 */
		private function extendCMenuItemHandler(event:ContextMenuEvent):void
		{
			var itemRes:MenuResItem = _extendMenuItem2ResMap.get(event.target);

			if (itemRes == null)
			{
				return;
			}
			customCMenuItemHandlerWithRes(event.contextMenuOwner as Feature, itemRes);
		}

		override protected function findDblMenuResItem(feature:Feature, topoCanvas:TopoCanvas):Array
		{
			// 如果已经配置过双击事件,直接执行
			var itemResItems:Array = super.findDblMenuResItem(feature, topoCanvas);
			if (itemResItems && itemResItems.length > 0)
			{
				var menuResItem:MenuResItem = itemResItems[0];
				// 是静态视图菜单,需要读取对象中的静态视图扩展属性,构造完整的菜单
				if (menuResItem && menuResItem.ztype == Constants.MENU_ZTYPE_STATIC_VIEW)
				{
					// 有效的视图菜单数组
					var viewMenuResItems:Array = [];
					// 当前不是视图时 生效
					if (feature && topoCanvas.topoType != ElementProperties.PROPERTYVALUE_NETVIEW_TYPE_VIEW)
					{
						feature.element.eachProperty(function(key:String, value:String):void
							{
								if (StringUtils.startsWith(key, VIEW_PREFIX))
								{
									// 构造菜单的资源对象
									var view_menuResItem:MenuResItem = new MenuResItem();
									// 先设置几个后续有用的属性
									view_menuResItem.name = value;
									view_menuResItem.type = menuResItem.type;
									view_menuResItem.action = menuResItem.action.replace("$[static_view_id]", key);
									viewMenuResItems.push(view_menuResItem);
								}
							});
					}
					if (viewMenuResItems.length > 0)
					{
						return viewMenuResItems;
					}
					else
					{
						// 没有有效的视图菜单,响应第二个菜单
						itemResItems.shift();
						return itemResItems;
					}
				}
			}
			return itemResItems;
		}
	}
}