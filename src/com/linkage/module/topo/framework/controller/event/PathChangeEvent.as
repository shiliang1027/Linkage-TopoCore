package com.linkage.module.topo.framework.controller.event
{
	import com.linkage.module.topo.framework.service.core.mo.TopoPath;

	import flash.events.Event;

	/**
	 * 拓扑路径层次切换事件
	 * @author duangr
	 *
	 */
	public class PathChangeEvent extends Event
	{
		/**
		 * 事件类型: 准备切换路径(此时停止鹰眼的监听事件)
		 */
		public static const PREPARE_CHANGE_PATH:String = "PathChangeEvent_PREPARE_CHANGE_PATH";
		/**
		 * 事件类型: 进入新的层次
		 */
		public static const NEW_PATH:String = "PathChangeEvent_NEW_PATH";

		/**
		 * 事件类型: 清除指定层次之后的全部层次
		 */
		public static const CLEAR_AFTER_PATH:String = "PathChangeEvent_CLEAR_AFTER_PATH";

		/**
		 * 事件类型: 清除全部层次
		 */
		public static const CLEAR_ALL_PATH:String = "PathChangeEvent_CLEAR_ALL_PATH";

		/**
		 * 事件类型: 定位到已有的层次
		 */
		public static const LOCATE_PATH:String = "PathChangeEvent_LOCATE_PATH";

		/**
		 * 事件类型: 移除指定的层次
		 */
		public static const REMOVE_PATH:String = "PathChangeEvent_REMOVE_PATH";

		private var _path:TopoPath = null;

		public function PathChangeEvent(type:String, path:TopoPath, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			_path = path;
		}

		/**
		 * 目标Path
		 */
		public function get path():TopoPath
		{
			return _path;
		}


	}
}