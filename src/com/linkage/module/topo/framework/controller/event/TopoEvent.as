package com.linkage.module.topo.framework.controller.event
{
	import com.linkage.module.topo.framework.core.Feature;
	import com.linkage.system.structure.map.IMap;
	import com.linkage.system.structure.map.Map;

	import flash.events.Event;
	import flash.geom.Point;

	/**
	 * 拓扑操作事件
	 * @author duangr
	 *
	 */
	public class TopoEvent extends Event
	{
		/**
		 * 事件类型: DEBUG
		 */
		public static const DEBUG:String = "TopoEvent_DEBUG";
		/**
		 * 事件类型: 将临时属性保存到画布中
		 */
		public static const SAVE_TEMP_PROPERTY:String = "TopoEvent_SAVE_TEMP_PROPERTY";
		/**
		 * 事件类型: 将属性保存到画布中
		 */
		public static const SAVE_PROPERTY:String = "TopoEvent_SAVE_PROPERTY";
		/**
		 * 事件类型: 从画布中删除指定的属性
		 */
		public static const CLEAR_PROPERTY:String = "TopoEvent_CLEAR_PROPERTY";

		/**
		 * 事件类型: 图例显隐切换
		 */
		public static const LEGEND_TOGGLE:String = "TopoEvent_LEGEND_TOGGLE";
		/**
		 * 事件类型: 属性显隐切换
		 */
		public static const ATTRIBUTE_TOGGLE:String = "TopoEvent_ATTRIBUTE_TOGGLE";
		/**
		 * 事件类型: 统计面板显隐切换
		 */
		public static const STATISTIC_TOGGLE:String = "TopoEvent_STATISTIC_TOGGLE";
		/**
		 * 事件类型: 标尺显隐切换
		 */
		public static const SCALERULER_TOGGLE:String = "TopoEvent_SCALERULER_TOGGLE";
		/**
		 * 事件类型: 告警渲染配置
		 */
		public static const ALARM_RENDERER_CONFIG:String = "TopoEvent_ALARM_RENDERER_CONFIG";
		/**
		 * 事件类型: 装载告警流水
		 */
		public static const LOAD_FLOW_ALARM:String = "TopoEvent_LOAD_FLOW_ALARM";
		/**
		 * 事件类型: 同属性高亮
		 */
		public static const HIGHTLIGHT_SAME_CONNECT:String = "TopoEvent_HIGHTLIGHT_SAME_CONNECT";
		/**
		 * 事件类型: 高亮关联网元
		 */
		public static const HIGHTLIGHT_CONNECT:String = "TopoEvent_HIGHTLIGHT_CONNECT";
		/**
		 * 事件类型: 取消高亮
		 */
		public static const HIGHTLIGHT_CANCEL:String = "TopoEvent_HIGHTLIGHT_CANCEL";

		/**
		 * 事件类型: 返回上一层
		 */
		public static const GO_UP:String = "TopoEvent_GO_UP";
		/**
		 * 事件类型: 返回上一级(后退)
		 */
		public static const GO_BACK:String = "TopoEvent_GO_BACK";
		/**
		 * 事件类型: 进入下一层
		 */
		public static const GO_DOWN:String = "TopoEvent_GO_DOWN";
		/**
		 * 事件类型: 根据视图模板查看拓扑
		 */
		public static const GO_MODEL_VIEW:String = "TopoEvent_GO_MODEL_VIEW";
		/**
		 * 事件类型: 打开URL
		 */
		public static const OPEN_URL:String = "TopoEvent_OPEN_URL";
		/**
		 * 事件类型: 打开拓扑内部链接
		 */
		public static const OPEN_TOPO:String = "TopoEvent_OPEN_TOPO";
		/**
		 * 事件类型: 查看告警
		 */
		public static const VIEW_ALARM:String = "TopoEvent_VIEW_ALARM";
		/**
		 * 事件类型: 定位缩略图中的对象
		 */
		public static const LOCATE_LAYER_ELEMENT:String = "TopoEvent_LOCATE_LAYER_ELEMENT";

		/**
		 * 事件类型: 全选
		 */
		public static const SELECT_ALL:String = "TopoEvent_SELECT_ALL";
		/**
		 * 事件类型: 反选
		 */
		public static const SELECT_UNSELECTED:String = "TopoEvent_SELECT_UNSELECTED";
		/**
		 * 事件类型: 锁定当前层
		 */
		public static const LOCK_LAYER:String = "TopoEvent_LOCK_LAYER";
		/**
		 * 事件类型: 解锁当前层
		 */
		public static const UNLOCK_LAYER:String = "TopoEvent_UNLOCK_LAYER";
		/**
		 * 事件类型: 剪切
		 */
		public static const CUT:String = "TopoEvent_CUT";
		/**
		 * 事件类型: 取消剪切
		 */
		public static const CANCAL_CUT:String = "TopoEvent_CANCAL_CUT";
		/**
		 * 事件类型: 粘帖
		 */
		public static const PASTE:String = "TopoEvent_PASTE";
		/**
		 * 事件类型: 复制网元
		 */
		public static const COPY:String = "TopoEvent_COPY";
		/**
		 * 事件类型: 粘帖复制的对象
		 */
		public static const PASTE_COPY:String = "TopoEvent_PASTE_COPY";
		/**
		 * 事件类型: 取消复制
		 */
		public static const CANCAL_COPY:String = "TopoEvent_CANCAL_COPY";
		/**
		 * 事件类型: 保存拓扑
		 */
		public static const SAVE_TOPO:String = "TopoEvent_SAVE_TOPO";
		/**
		 * 事件类型: 属性配置
		 */
		public static const CONFIG_PROPERTY:String = "TopoEvent_CONFIG_PROPERTY";

		/**
		 * 事件类型: 分组展开闭合切换
		 */
		public static const GROUP_EXPANDED_TOGGLE:String = "TopoEvent_GROUP_EXPANDED_TOGGLE";
		/**
		 * 事件类型: 链路展开闭合切换
		 */
		public static const LINK_EXPANDED_TOGGLE:String = "TopoEvent_LINK_EXPANDED_TOGGLE";

		/**
		 * 事件类型: 显示简单布局面板(先选设备,再矩形布局)
		 */
		public static const SHOW_SIMPLE_LAYOUT:String = "TopoEvent_SHOW_SIMPLE_LAYOUT";
		/**
		 * 事件类型: 显示布局面板
		 */
		public static const SHOW_LAYOUT:String = "TopoEvent_SHOW_LAYOUT";
		/**
		 * 事件类型: 显示全部的网元
		 */
		public static const VIEW_ELEMENT_ALL:String = "TopoEvent_VIEW_ELEMENT_ALL";
		/**
		 * 事件类型: 显示可见的网元
		 */
		public static const VIEW_ELEMENT_VISIABLE:String = "TopoEvent_VIEW_ELEMENT_VISIABLE";
		/**
		 * 事件类型: 将元素设置为可见
		 */
		public static const ELEMENT_VISIABLE_TRUE:String = "TopoEvent_ELEMENT_VISIABLE_TRUE";
		/**
		 * 事件类型: 将元素设置为不可见
		 */
		public static const ELEMENT_VISIABLE_FALSE:String = "TopoEvent_ELEMENT_VISIABLE_FALSE";

		/**
		 * 事件类型: 删除元素
		 */
		public static const DELETE_ELEMENTS:String = "TopoEvent_DELETE_ELEMENTS";
		/**
		 * 事件类型: 删除一批网元之间相互关联的链路,若只有一个网元的话删除网元的全部关联链路
		 */
		public static const DELETE_CONNECT_LINKS:String = "TopoEvent_DELETE_CONNECT_LINKS";

		/**
		 * 事件类型: 编辑节点
		 */
		public static const MODIFY_NODE:String = "TopoEvent_MODIFY_NODE";
		/**
		 * 事件类型: 创建云图(网段)
		 */
		public static const CREATE_SEGMENT:String = "TopoEvent_CREATE_SEGMENT";
		/**
		 * 事件类型: 编辑云图(网段)
		 */
		public static const MODIFY_SEGMENT:String = "TopoEvent_MODIFY_SEGMENT";
		/**
		 * 事件类型: 创建云图(网段)镜像
		 */
		public static const CREATE_SEGMENT_MIRROR:String = "TopoEvent_CREATE_SEGMENT_MIRROR";
		/**
		 * 事件类型: 编辑云图(网段)镜像
		 */
		public static const MODIFY_SEGMENT_MIRROR:String = "TopoEvent_MODIFY_SEGMENT_MIRROR";
		/**
		 * 事件类型: 创建缩略图(创建缩略图的Action中触发)
		 */
		public static const CREATE_HLINKLAYER:String = "TopoEvent_CREATE_HLINKLAYER";
		/**
		 * 事件类型: 编辑缩略图
		 */
		public static const MODIFY_HLINKLAYER:String = "TopoEvent_MODIFY_HLINKLAYER";
		/**
		 * 事件类型: 创建形状对象(创建形状的Action中触发)
		 */
		public static const CREATE_SHAPE:String = "TopoEvent_CREATE_SHAPE";
		/**
		 * 事件类型: 编辑形状对象
		 */
		public static const MODIFY_SHAPE:String = "TopoEvent_MODIFY_SHAPE";
		/**
		 * 事件类型: 复制形状对象
		 */
		public static const COPY_SHAPE:String = "TopoEvent_COPY_SHAPE";

		/**
		 * 事件类型: 创建形状对象之图片(创建形状的Action中触发)
		 */
		public static const CREATE_SHAPE_PIC:String = "TopoEvent_CREATE_SHAPE_PIC";
		/**
		 * 事件类型: 编辑形状对象之图片
		 */
		public static const MODIFY_SHAPE_PIC:String = "TopoEvent_MODIFY_SHAPE_PIC";
		/**
		 * 事件类型: 复制形状对象之图片
		 */
		public static const COPY_SHAPE_PIC:String = "TopoEvent_COPY_SHAPE_PIC";

		/**
		 * 事件类型: 创建分组对象
		 */
		public static const CREATE_GROUP:String = "TopoEvent_CREATE_GROUP";
		/**
		 * 事件类型: 编辑分组对象
		 */
		public static const MODIFY_GROUP:String = "TopoEvent_MODIFY_GROUP";
		/**
		 * 事件类型: 添加对象到分组中
		 */
		public static const ADD_TO_GROUP:String = "TopoEvent_ADD_TO_GROUP";
		/**
		 * 事件类型: 从分组中删除对象
		 */
		public static const REMOVE_FROM_GROUP:String = "TopoEvent_REMOVE_FROM_GROUP";
		/**
		 * 事件类型: 删除分组对象
		 */
		public static const DELETE_GROUP:String = "TopoEvent_DELETE_GROUP";
		/**
		 * 事件类型: 创建文本对象
		 */
		public static const CREATE_TEXT:String = "TopoEvent_CREATE_TEXT";
		/**
		 * 事件类型: 编辑文本对象
		 */
		public static const MODIFY_TEXT:String = "TopoEvent_MODIFY_TEXT";
		/**
		 * 事件类型: 创建线对象(创建线对象的Action中触发)
		 */
		public static const CREATE_LINE:String = "TopoEvent_CREATE_LINE";
		/**
		 * 事件类型: 创建链路(创建链路的Action中触发)
		 */
		public static const CREATE_LINK:String = "TopoEvent_CREATE_LINK";
		/**
		 * 事件类型: 设为链路起点(菜单中触发)
		 */
		public static const SET_AS_LINK_START:String = "TopoEvent_SET_AS_LINK_START";
		/**
		 * 事件类型: 设为链路终点(菜单中触发)
		 */
		public static const SET_AS_LINK_END:String = "TopoEvent_SET_AS_LINK_END";

		/**
		 * 事件类型: 编辑视图对象
		 */
		public static const MODIFY_TPVIEW:String = "TopoEvent_MODIFY_TPVIEW";

		/**
		 * 事件类型: 展现创建线对象的面板
		 */
		public static const CREATE_LINE_PANEL_SHOW:String = "TopoEvent_CREATE_LINE_PANEL_SHOW";
		/**
		 * 事件类型: 关闭创建线对象的面板
		 */
		public static const CREATE_LINE_PANEL_HIDE:String = "TopoEvent_CREATE_LINE_PANEL_HIDE";
		/**
		 * 事件类型: 编辑线对象
		 */
		public static const MODIFY_LINE:String = "TopoEvent_MODIFY_LINE";
		/**
		 * 事件类型: 展现创建链路的面板
		 */
		public static const CREATE_LINK_PANEL_SHOW:String = "TopoEvent_CREATE_LINK_PANEL_SHOW";
		/**
		 * 事件类型: 关闭创建链路的面板
		 */
		public static const CREATE_LINK_PANEL_HIDE:String = "TopoEvent_CREATE_LINK_PANEL_HIDE";
		/**
		 * 事件类型: 编辑链路
		 */
		public static const MODIFY_LINK:String = "TopoEvent_MODIFY_LINK";
		/**
		 * 事件类型: 创建视图
		 */
		public static const CREATE_VIEW:String = "TopoEvent_CREATE_VIEW";
		/**
		 * 事件类型: 删除视图
		 */
		public static const DELETE_VIEW:String = "TopoEvent_DELETE_VIEW";

		/**
		 * 事件类型: 创建网格对象
		 */
		public static const CREATE_TPGRID:String = "TopoEvent_CREATE_TPGRID";
		/**
		 * 事件类型: 编辑网格对象
		 */
		public static const MODIFY_TPGRID:String = "TopoEvent_MODIFY_TPGRID";
		/**
		 * 事件类型: 图例load事件
		 */
		public static const TopoEvent_LOAD_LINKDESCPANELS:String = "TopoEvent_LOAD_LINKDESCPANELS";

		// 单个元素
		private var _feature:Feature = null;
		// 多个元素
		private var _features:Array = null;
		// 鼠标相对画布位置
		private var _mousePoint:Point = null;
		// 属性容器
		private var _properties:IMap = null;

		public function TopoEvent(type:String, feature:Feature = null, properties:IMap = null, features:Array = null, mousePoint:Point = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			_feature = feature;
			_features = features;
			_properties = properties;
			_mousePoint = mousePoint;
			if (_properties == null)
			{
				_properties = new Map();
			}
		}

		/**
		 * 拓扑要素对象
		 *
		 */
		public function get feature():Feature
		{
			return _feature;
		}

		public function get features():Array
		{
			return _features;
		}

		/**
		 * 属性Map容器
		 */
		public function get properties():IMap
		{
			return _properties;
		}

		/**
		 * 鼠标相对画布位置
		 * @return
		 *
		 */
		public function get mousePoint():Point
		{
			return _mousePoint;
		}

		public function getProperty(key:String):*
		{
			return _properties.get(key);
		}

		public function setProperty(key:String, value:*):void
		{
			_properties.put(key, value);
		}

		override public function clone():Event
		{
			return new TopoEvent(type, _feature, _properties, _features, _mousePoint, bubbles, cancelable);
		}

		override public function toString():String
		{
			return "[TopoEvent] " + mousePoint + " " + type;
		}
	}
}