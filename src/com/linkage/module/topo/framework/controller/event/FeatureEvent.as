package com.linkage.module.topo.framework.controller.event
{
	import com.linkage.module.topo.framework.core.Feature;
	import com.linkage.module.topo.framework.core.model.element.IElement;

	import flash.events.Event;

	/**
	 * 拓扑要素事件
	 * @author duangr
	 *
	 */
	public class FeatureEvent extends Event
	{
		/**
		 * 事件类型: 右键点击事件
		 */
		public static const RIGHT_CLICK:String = "FeatureEvent_RIGHT_CLICK";
		/**
		 * 事件类型: 创建完成事件
		 */
		public static const CREATION_COMPLETE:String = "FeatureEvent_CREATION_COMPLETE";
		/**
		 * 事件类型: 拓扑层次创建完成事件
		 */
		public static const TOPOLAYER_CREATION_COMPLETE:String = "FeatureEvent_TOPOLAYER_CREATION_COMPLETE";

		private var _feature:Feature = null;

		public function FeatureEvent(type:String, feature:Feature, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			this._feature = feature;
		}

		public function get feature():Feature
		{
			return _feature;
		}

	}
}