package com.linkage.module.topo.framework.view.component.toolbar
{
	import com.linkage.module.topo.framework.view.component.TopoCanvas;
	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	import flash.errors.IllegalOperationError;
	import flash.events.MouseEvent;

	import spark.components.Button;

	public class TopoIcon extends Button
	{

		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.view.component.toolbar.TopoIcon");
		// 拓扑图画布
		protected var _topoCanvas:TopoCanvas = null;
		// 图标按钮是否处于启用状态
		private var _iconEnabled:Boolean = false;
		// 权限的key
		private var _autyKey:String = null;

		public function TopoIcon()
		{
			super();
			this.buttonMode = true;
		}

		/**
		 * 拓扑图画布
		 */
		public function set topoCanvas(value:TopoCanvas):void
		{
			_topoCanvas = value;
		}

		/**
		 * 权限关键字
		 *
		 */
		public function get authKey():String
		{
			return _autyKey;
		}

		public function set authKey(value:String):void
		{
			_autyKey = value;
		}

		/**
		 * 显示此图标
		 *
		 */
		public function show():void
		{
			this.visible = true;
			this.includeInLayout = true;
			_iconEnabled = true;
		}

		/**
		 * 隐藏此图标
		 *
		 */
		public function hide():void
		{
			this.visible = false;
			this.includeInLayout = false;
			_iconEnabled = false;
		}

		/**
		 * 图标按钮是否处于启用状态
		 *
		 */
		public function get iconEnabled():Boolean
		{
			return _iconEnabled;
		}

	}
}