package com.linkage.module.topo.framework.controller.event
{
	import com.linkage.module.topo.framework.core.Feature;
	import com.linkage.system.structure.map.IMap;
	import com.linkage.system.structure.map.Map;

	import flash.events.Event;

	/**
	 * 画布事件
	 * @author duangr
	 *
	 */
	public class CanvasEvent extends Event
	{
		/**
		 * 事件类型: 比例尺变化后的通知事件
		 */
		public static const SCALE_CHANGED:String = "CanvasEvent_SCALE_CHANGED";
		/**
		 * 事件类型: 数据变化后的通知事件(不一定是整个层次数据的变化)
		 */
		public static const DATA_CHANGED:String = "CanvasEvent_DATA_CHANGED";
		/**
		 * 事件类型: 显示区域变化后的通知事件
		 */
		public static const VIEWBOUNDS_CHANGED:String = "CanvasEvent_VIEWBOUNDS_CHANGED";
		/**
		 * 事件类型: 准备加载新拓扑层次前的通知事件
		 */
		public static const PREPARE_LOAD_LAYER:String = "CanvasEvent_PREPARE_LOAD_LAYER";
		/**
		 * 事件类型: 加载拓扑数据异常时的通知事件(数据格式不对)
		 */
		public static const LOAD_LAYER_ERROR:String = "CanvasEvent_LOAD_LAYER_ERROR";
		/**
		 * 事件类型: 拓扑层次切换后的通知事件
		 */
		public static const LAYER_CHANGED:String = "CanvasEvent_LAYER_CHANGED";
		/**
		 * 事件类型: 告警变化后的通知事件
		 */
		public static const ALARM_CHANGED:String = "CanvasEvent_ALARM_CHANGED";
		/**
		 * 事件类型: 当前选中对象变化后的通知事件
		 */
		public static const SELECTED_CHANGED:String = "CanvasEvent_SELECTED_CHANGED";
		/**
		 * 事件类型: 选中某一元素后的通知事件
		 */
		public static const SET_TO_SELECTED:String = "CanvasEvent_SET_TO_SELECTED";
		/**
		 * 事件类型: 告警渲染规则变更后的通知事件
		 */
		public static const ALARM_RENDERER_CHANGE:String = "CanvasEvent_ALARM_RENDERER_CHANGE";
		/**
		 * 事件类型: 告警渲染规则变更后通知刷新告警的通知事件
		 */
		public static const ALARM_RENDERER_CHANGE_REFRESH:String = "CanvasEvent_ALARM_RENDERER_CHANGE_REFRESH";

		/**
		 * 事件类型: 另存为新拓扑层次成功后通知事件
		 */
		public static const SAVELAYER_ASNEW_SUCCESS:String = "CanvasEvent_SAVELAYER_ASNEW_SUCCESS";
		/**
		 * 事件类型: 另存为新拓扑层次失败后通知事件
		 */
		public static const SAVELAYER_ASNEW_FAILURE:String = "CanvasEvent_SAVELAYER_ASNEW_FAILURE";
		/**
		 * 事件类型: 重新保存当前拓扑层次成功后通知事件
		 */
		public static const SAVELAYER_ASCURRENT_SUCCESS:String = "CanvasEvent_SAVELAYER_ASCURRENT_SUCCESS";
		/**
		 * 事件类型: 重新保存当前拓扑层次失败后通知事件
		 */
		public static const SAVELAYER_ASCURRENT_FAILURE:String = "CanvasEvent_SAVELAYER_ASCURRENT_FAILURE";
		/**
		 * 事件类型: 保存element成功后通知事件
		 */
		public static const SAVE_ELEMENT_SUCCESS:String = "CanvasEvent_SAVE_ELEMENT_SUCCESS";
		/**
		 * 事件类型:保存element失败后通知事件
		 */
		public static const SAVE_ELEMENT_FAILURE:String = "CanvasEvent_SAVE_ELEMENT_FAILURE";
		/**
		 * 事件类型: 通知保存拓扑成功后通知事件
		 */
		public static const SAVE_TOPO_SUCCESS:String = "CanvasEvent_SAVE_TOPO_SUCCESS";
		/**
		 * 事件类型:通知保存拓扑失败后通知事件
		 */
		public static const SAVE_TOPO_FAILURE:String = "CanvasEvent_SAVE_TOPO_FAILURE";
//		/**
//		 * 事件类型:定位网元成功后通知事件
//		 */
//		public static const LOCATE_ELEMENT_SUCCESS:String = "CanvasEvent_LOCATE_ELEMENT_SUCCESS";
//		/**
//		 * 事件类型:定位网元失败后通知事件
//		 */
//		public static const LOCATE_ELEMENT_FAILURE:String = "CanvasEvent_LOCATE_ELEMENT_FAILURE";


		// 单个元素
		private var _feature:Feature = null;
		// 多个元素
		private var _features:Array = null;
		// 属性容器
		private var _properties:IMap = null;

		public function CanvasEvent(type:String, feature:Feature = null, properties:IMap = null, features:Array = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			_feature = feature;
			_features = features;
			_properties = properties;
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
			return new CanvasEvent(type, _feature, _properties, _features, bubbles, cancelable);
		}

		override public function toString():String
		{
			return "[CanvasEvent] " + type;
		}
	}
}