package com.linkage.module.topo.framework.controller.menu
{
	import com.adobe.utils.StringUtil;
	import com.linkage.module.topo.framework.Constants;
	import com.linkage.module.topo.framework.Version;
	import com.linkage.module.topo.framework.controller.event.TopoEvent;
	import com.linkage.module.topo.framework.core.Feature;
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.util.TopoUtil;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;
	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;
	import com.linkage.system.structure.map.IMap;
	import com.linkage.system.structure.map.Map;
	import com.linkage.system.utils.StringUtils;
	
	import flash.display.InteractiveObject;
	import flash.events.ContextMenuEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;

	/**
	 * 菜单管理器
	 * @author duangr
	 *
	 */
	public class MenuManager implements IMenuManager
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.controller.menu.MenuManager");
		// 弹出页面的上下文
		private var _urlContext:String = null;
		// 画布
		private var _topoCanvas:TopoCanvas = null;
		// 右键菜单资源集合
		private var _cMenuResArray:Array = [];
		// 双击事件菜单资源集合
		private var _dblclickMenuResArray:Array = [];
		// 右键菜单资源与菜单节点的映射Map
		private var _res2CMenuItemMap:IMap = new Map();
		// 菜单节点对象与右键菜单资源的映射Map
		private var _cMenuItem2ResMap:IMap = new Map();
		// 版本信息的菜单项(画布空白处触发此菜单)
		private var _versionMenuItem:ContextMenuItem = null;

		public function MenuManager(topoCanvas:TopoCanvas)
		{
			this._topoCanvas = topoCanvas;
		}

		public function initialize(menuXML:XML, urlContext:String):void
		{
			_urlContext = urlContext;
			initMenuRes(menuXML);
		}

		public function set menuOwner(menuOwner:InteractiveObject):void
		{
			if(menuOwner is TopoCanvas){
				log.debug("[menuOwner]menuOwner is TopoCanvas {0}",menuOwner is TopoCanvas);
				menuOwner.parent.contextMenu = initNullContextMenu();
				menuOwner.parent.doubleClickEnabled = true;
			}else{
				log.debug("[menuOwner]{0}",menuOwner);
				menuOwner.contextMenu = initNullContextMenu();
				menuOwner.doubleClickEnabled = true;
			}
			
		}

		public function clear():void
		{
			// 空方法,此对象没有需要清理的数据
			// 若子类中有要清理的可以实现
		}

		public function set version(value:String):void
		{
			_versionMenuItem = new ContextMenuItem("Version: " + value + " (" + Version.VERSION + ")", true, false);
		}

		/**
		 * 初始化右键菜单
		 * @return
		 *
		 */
		private function initNullContextMenu():ContextMenu
		{
			var menu:ContextMenu = new ContextMenu();
			menu.hideBuiltInItems();
			menu.addEventListener(ContextMenuEvent.MENU_SELECT, cMenuSelectHandler, false);
			return menu;
		}

		/**
		 * 捕获 双击事件
		 */
		public function onDoubleClick(feature:Feature):void
		{
			log.debug("捕获到双击事件 {0}", feature);
			// 根据对象,找到对应的双击资源对象
			var menuResItems:Array = findDblMenuResItem(feature, _topoCanvas)
			if (menuResItems && menuResItems.length > 0)
			{
				customEventHandler(menuResItems[0], feature);
			}
		}

		/**
		 * 找到双击对应的资源Item
		 * @param feature
		 * @param topoCanvas
		 * @return 按菜单显示优先级顺序排列的菜单数组(前面的优先级高)
		 *
		 */
		protected function findDblMenuResItem(feature:Feature, topoCanvas:TopoCanvas):Array
		{
			var itemResItems:Array = [];

			// 画布双击
			if (feature == null)
			{
				_dblclickMenuResArray.forEach(function(itemRes:MenuResItem, index:int, array:Array):void
					{
						if (MenuFilter.acceptCanvas(itemRes, _topoCanvas))
						{
							itemResItems.push(itemRes);
						}
					});
			}
			// 否则绘制点击对象的菜单
			else
			{
				_dblclickMenuResArray.some(function(itemRes:MenuResItem, index:int, array:Array):void
					{
						if (MenuFilter.acceptFeature(itemRes, feature, _topoCanvas))
						{
							itemResItems.push(itemRes);
						}
					});
			}
			if (itemResItems.length == 0)
			{
				// 没有找到菜单
				return null;
			}
			// 多个菜单,按depth排序,取出最大depth的菜单
			// 降序排列,取第一个
			itemResItems.sort(function(aItem:MenuResItem, bItem:MenuResItem):int
				{
					// 降序排列
					return bItem.depth - aItem.depth;
				});
			return itemResItems;
		}

		/**
		 * 空右键菜单被触发
		 * @param event
		 *
		 */
		private function cMenuSelectHandler(event:ContextMenuEvent):void
		{
			var feature:Feature = event.contextMenuOwner as Feature;
			log.debug("右键目标 {0}, 是否为画布:{1}", feature, event.contextMenuOwner is TopoCanvas);
			dispatchRightClickEvent(feature);
			buildContextMenu(feature);
		}

		/**
		 * 给具体的对象绘制右键菜单
		 *
		 */
		private function buildContextMenu(feature:Feature):void
		{
			log.debug("0000000000000000000000000>{0}",feature);
			var menu:ContextMenu = feature ? feature.contextMenu : _topoCanvas.parent.contextMenu;
			var customItems:Array = menu.customItems;
			log.debug("111111111111111111111111>{0}",menu);
			// 先清空已有的右键菜单
			customItems.length = 0;

			var features:Array = [];
			_topoCanvas.eachSelect(function(id:String, element:IElement):void
				{
					features.push(element.feature);
				});

			// 遍历菜单资源列表,判断是否可以画此菜单(菜单要符合框选中的全部对象)
			_cMenuResArray.forEach(function(itemRes:MenuResItem, index:int, array:Array):void
				{
					// 若存在框选对象,先绘制框选对象的菜单
					if (_topoCanvas.hasFeatureSelected())
					{
						if (MenuFilter.acceptFeatures(itemRes, features, _topoCanvas))
						{
							customItems.push(_res2CMenuItemMap.get(itemRes));
						}

					}
					// 没有框选,也没有点击到对象上面,绘制画布的菜单
					else if (feature == null)
					{
						if (MenuFilter.acceptCanvas(itemRes, _topoCanvas))
						{
							customItems.push(_res2CMenuItemMap.get(itemRes));
						}
					}
					// 否则绘制点击对象的菜单
					else
					{
						if (MenuFilter.acceptFeature(itemRes, feature, _topoCanvas))
						{
							customItems.push(_res2CMenuItemMap.get(itemRes));
						}
					}
				});

			var extendMenuItems:Array = initExtendMenuItems(feature, features, _topoCanvas);
			if (extendMenuItems != null)
			{
				//log.debug("扩展菜单个数: {0}", extendMenuItems.length);
				extendMenuItems.forEach(function(item:ContextMenuItem, index:int, array:Array):void
					{
					log.info(array);
						customItems.push(item);
					});
			}
			if (_topoCanvas.hasFeatureSelected() == false && feature == null)
			{
				// 此时是画布触发的菜单,再增加 版本信息的菜单
				customItems.push(_versionMenuItem);
			}
			log.debug("-------------==================>{0}",customItems);
			log.debug("右键菜单个数: {0}", customItems.length);
		}

		/**
		 * 初始化扩展的菜单
		 * @param feature
		 * @param features
		 * @param topoCanvas
		 * @return
		 *
		 */
		protected function initExtendMenuItems(feature:Feature, features:Array, topoCanvas:TopoCanvas):Array
		{
			return null;
		}


		/**
		 * 初始化菜单资源
		 * @param menuXml
		 *
		 */
		private function initMenuRes(menuXml:XML):void
		{
			var menuResItem:MenuResItem = null;
			var cmenus:XMLList = menuXml.cmenus;
			// 右键菜单资源
			for each (var menuXML:XML in cmenus.menu)
			{
				menuResItem = new MenuResItem();
				menuResItem.name = menuXML.@name;
				menuResItem.multiple = ("true" == menuXML.@multiple) ? true : false;
				menuResItem.icon = menuXML.@icon;
				menuResItem.actionWeight = parseInt(menuXML.@aweight, 2);
				menuResItem.elementWeight = parseInt(menuXML.@eweight, 2);
				menuResItem.type = menuXML.@type;
				menuResItem.action = String(menuXML.@action);
				menuResItem.filter = menuXML.@filter;
				menuResItem.depth = int(menuXML.@depth);
				menuResItem.ztype = String(menuXML.@ztype);


				var dblclick:String = menuXML.@dblclick;
				switch (dblclick)
				{
					case "both":
						addDblMenuRes(menuResItem);
						addRCMenuRes(menuResItem);
						break;
					case "true":
						addDblMenuRes(menuResItem);
						break;
					case "false":
					default:
						addRCMenuRes(menuResItem);
						break;
				}
			}
		}

		/**
		 * 添加双击菜单资源
		 * @param menuResItem
		 *
		 */
		private function addDblMenuRes(menuResItem:MenuResItem):void
		{
			log.debug("添加双击菜单资源 {0}", menuResItem);
			_dblclickMenuResArray.push(menuResItem);
		}

		/**
		 * 添加右键菜单资源
		 * @param menuResItem
		 *
		 */
		private function addRCMenuRes(menuResItem:MenuResItem):void
		{
			log.debug("添加右键菜单资源 {0}", menuResItem);
			_cMenuResArray.push(menuResItem);
			// 创建右键菜单节点
			var menuItem:ContextMenuItem = new ContextMenuItem(menuResItem.name);
			menuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, customCMenuItemHandler);
			_cMenuItem2ResMap.put(menuItem, menuResItem);
			_res2CMenuItemMap.put(menuResItem, menuItem);
		}

		/**
		 * 定制右键菜单item选中的捕获逻辑
		 * @param event
		 *
		 */
		protected function customCMenuItemHandler(event:ContextMenuEvent):void
		{
			var itemRes:MenuResItem = _cMenuItem2ResMap.get(event.target);

			if (itemRes == null)
			{
				return;
			}
			customCMenuItemHandlerWithRes(event.contextMenuOwner as Feature, itemRes);
		}

		/**
		 * 定制右键菜单item选中的捕获逻辑(含菜单资源对象)
		 * @param menuOwner
		 * @param itemRes
		 *
		 */
		protected function customCMenuItemHandlerWithRes(menuOwner:Feature, itemRes:MenuResItem):void
		{
			var features:Array = [];
			_topoCanvas.eachSelect(function(id:String, element:IElement):void
				{
					features.push(element.feature);
				});
			if (features.length > 0)
			{
				featuresCustomEventHandler(itemRes, features);
			}
			else
			{
				customEventHandler(itemRes, menuOwner);
			}
		}

		/**
		 * 捕获 定制事件 (支持多元素触发)
		 * @param itemRes
		 * @param features
		 *
		 */
		private function featuresCustomEventHandler(itemRes:MenuResItem, features:Array):void
		{
//			log.debug("触发批量菜单事件 {0} ON {1}", itemRes, features);
			switch (itemRes.type)
			{
				case Constants.MENU_TYPE_URL:
					var url:String = TopoUtil.parseMultMacro(itemRes.action, features, _topoCanvas);
					url = url.replace(/\$/g, "&");
					doAction_openUrl(url);
					break;
				case Constants.MENU_TYPE_EVENT:
					findFeaturesEventAndExecute(itemRes.action, Constants.MENU_ACTION_EVENTKEY_EVENTTYPE, Constants.MENU_ACTION_EVENTKEY_EVENTPROPERTY, features);
					extractFeaturesExtendEvent(itemRes.action, Constants.MENU_ACTION_EVENTKEY_EVENTTYPE, Constants.MENU_ACTION_EVENTKEY_EVENTPROPERTY, features);
					break;
				default:
					log.warn("菜单[{0}]未知操作类型: {1}", itemRes.name, itemRes.type);
					break;
			}
		}

		/**
		 * 捕获 定制事件
		 * @param itemRes
		 * @param feature
		 *
		 */
		private function customEventHandler(itemRes:MenuResItem, feature:Feature):void
		{
			log.debug("触发菜单事件 {0} ON {1}", itemRes, feature);
			switch (itemRes.type)
			{
				case Constants.MENU_TYPE_URL:
					//log.info("MENU_TYPE_URL");
					var url:String = TopoUtil.parseMacro(itemRes.action, feature ? feature.element : null, _topoCanvas);
					url = url.replace(/\$/g, "&");
					doAction_openUrl(url);
					break;
				case Constants.MENU_TYPE_EVENT:
					//log.info("MENU_TYPE_EVENT");
					findFeatureEventAndExecute(itemRes.action, Constants.MENU_ACTION_EVENTKEY_EVENTTYPE, Constants.MENU_ACTION_EVENTKEY_EVENTPROPERTY, feature);
					extractFeatureExtendEvent(itemRes.action, Constants.MENU_ACTION_EVENTKEY_EVENTTYPE, Constants.MENU_ACTION_EVENTKEY_EVENTPROPERTY, feature);
					break;
				default:
					log.warn("菜单[{0}]未知操作类型: {1}", itemRes.name, itemRes.type);
					break;
			}

		}

		/**
		 * 提取单个网元的扩展的事件,并且执行
		 * @param action
		 * @param eventTypeKey
		 * @param eventPropertyKey
		 * @param feature
		 *
		 */
		private function extractFeatureExtendEvent(action:String, eventTypeKey:String, eventPropertyKey:String, feature:Feature):void
		{
			var index:int = 1;
			while (findFeatureEventAndExecute(action, eventTypeKey + index, eventPropertyKey + index, feature))
			{
				index++
			}
		}

		/**
		 * 找到单个网元的事件并且执行
		 * @param action
		 * @param eventTypeKey
		 * @param eventPropertyKey
		 * @param feature
		 * @return
		 *
		 */
		private function findFeatureEventAndExecute(action:String, eventTypeKey:String, eventPropertyKey:String, feature:Feature):Boolean
		{
			log.debug("查找 {0}  {1}", eventTypeKey, eventPropertyKey);
			log.debug("findFeatureEventAndExecute");
//			log.debug(feature.element);
			// 事件类型
			var eventType:String = getActionContent(eventTypeKey, action);
			//log.info("findFeatureEventAndExecute zhong");
			if (StringUtils.isEmpty(eventType))
			{
				// 已经没有事件类型,返回false
				log.info("return false");
				return false;
			}
			// 属性值Map
			var propertiesStr:String = getActionContent(eventPropertyKey, action);
			propertiesStr = TopoUtil.parseMacro(propertiesStr, feature ? feature.element : null, _topoCanvas);
			var properties:IMap = splitStrToMap(propertiesStr);
			doAction_event(eventType, feature, properties, [feature]);
			return true;
		}

		/**
		 * 提取批量网元的扩展的事件,并且执行
		 * @param action
		 * @param eventTypeKey
		 * @param eventPropertyKey
		 * @param features
		 *
		 */
		private function extractFeaturesExtendEvent(action:String, eventTypeKey:String, eventPropertyKey:String, features:Array):void
		{
			var index:int = 1;
			while (findFeaturesEventAndExecute(action, eventTypeKey + index, eventPropertyKey + index, features))
			{
				index++
			}
		}

		/**
		 * 找到批量网元的事件并执行
		 * @param action
		 * @param eventTypeKey
		 * @param eventPropertyKey
		 * @param features
		 * @return
		 *
		 */
		private function findFeaturesEventAndExecute(action:String, eventTypeKey:String, eventPropertyKey:String, features:Array):Boolean
		{
			// 事件类型
			var eventType:String = getActionContent(eventTypeKey, action);
			if (StringUtils.isEmpty(eventType))
			{
				// 已经没有事件类型,返回false
				return false;
			}
			// 属性值Map
			var propertiesStr:String = getActionContent(eventPropertyKey, action);
			propertiesStr = TopoUtil.parseMultMacro(propertiesStr, features, _topoCanvas);
			var properties:IMap = splitStrToMap(propertiesStr);
			doAction_event(eventType, features[0], properties, features);
			return true;
		}

		/**
		 * 派发右键点击事件
		 * @param feature
		 *
		 */
		private function dispatchRightClickEvent(feature:Feature):void
		{
			// 直接派发给action
			_topoCanvas.action.handlerRightClick(feature);
		}

		/**
		 * 解析格式为 "id=1, name=测试, a=b" 的字符串成为Map对象
		 * @param str
		 * @return
		 *
		 */
		private function splitStrToMap(str:String):IMap
		{
			var map:IMap = new Map();
			if (StringUtils.isEmpty(str))
			{
				return map;
			}
			var array:Array = str.split(", ");
			array.forEach(function(ss:String, index:int, arr:Array):void
				{
					var splitStrIndex:int = ss.indexOf("=");
					if (splitStrIndex != -1)
					{
						map.put(StringUtil.trim(ss.substring(0, splitStrIndex)), StringUtil.trim(ss.substring(splitStrIndex + 1)));
					}
				});
			return map;
		}

		/**
		 * 获取Action中key对应的内容
		 * @param key
		 * @param action
		 * @return
		 *
		 */
		private function getActionContent(key:String, action:String):String
		{
			var split:String = key + "(";
			var start:int = action.indexOf(split);
			if (start == -1)
			{
				return "";
			}
			var end:int = action.indexOf(")", start)
				
				//log.info("getActionContent"+getActionContent);
			return action.substring(start + split.length, end);
		}

		/**
		 * 右键菜单操作: 执行内部关键字操作
		 * @param eventType
		 * @param feature 拓扑要素(null说明点击在画布空白处)
		 * @param properties
		 *
		 */
		private function doAction_event(eventType:String, feature:Feature, properties:IMap, features:Array):void
		{
//			log.debug("执行Event事件 type:{0}, feature:{1}, properties:{2}", eventType, feature, properties);
			_topoCanvas.dispatchEvent(new TopoEvent(eventType, feature, properties, features, _topoCanvas.mousePoint));
		}


		/**
		 * 右键菜单操作: 弹出url
		 * @param url
		 *
		 */
		private function doAction_openUrl(url:String):void
		{
			var openUrl:String = url.indexOf("http://") >= 0 ? url : _urlContext + url;
			log.debug("OPEN URL: {0}  url:{1}", openUrl, url);
			 navigateToURL(new URLRequest(openUrl));
//			var param:String = "status=no,toolbar=no,location=no,resizable=yes,menubar=no,width=" + _topoCanvas.stage.width * 0.9 + ",height=" + _topoCanvas.stage.height * 0.9;
			//ExternalInterface.call("function(){window.open('" + openUrl + "','','" + param + "')}");
//			ExternalInterface.call("function(){window.open(\"" + openUrl + "\",\"\",\"" + param + "\")}");

			
			//ExternalInterface.call("openUrl(\"" + openUrl + "\")");
		}
	}
}