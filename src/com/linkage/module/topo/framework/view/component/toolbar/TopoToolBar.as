package com.linkage.module.topo.framework.view.component.toolbar
{
	import com.linkage.module.topo.framework.view.component.TopoCanvas;
	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	import mx.core.IVisualElement;

	import spark.components.BorderContainer;
	import spark.events.ElementExistenceEvent;
	import spark.layouts.HorizontalLayout;

	/**
	 * 拓扑工具栏
	 * @author duangr
	 *
	 */
	public class TopoToolBar extends BorderContainer
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.view.component.toolbar.TopoToolBar");
		// 拓扑图画布
		private var _topoCanvas:TopoCanvas = null;
		// 是否启用权限过滤控制内部权限的工具条图标
		private var _authEnabled:Boolean = false;
		// 权限过滤的关键字数组
		private var _authKeys:Array = null;

		public function TopoToolBar()
		{
			super();
			this.styleName = "panelStyle";
			this.height = 24;
			var layout:HorizontalLayout = new HorizontalLayout();
			layout.verticalAlign = "middle";
			layout.horizontalAlign = "center";
			layout.gap = 5;
			layout.paddingRight = 8;
			layout.paddingLeft = 8;
			this.layout = layout;

			this.addEventListener(ElementExistenceEvent.ELEMENT_ADD, function(event:ElementExistenceEvent):void
				{
					if (event.element is TopoIcon)
					{
						var topoIcon:TopoIcon = event.element as TopoIcon;
						topoIcon.topoCanvas = _topoCanvas;

						if (_authEnabled && (_authKeys == null || _authKeys.indexOf(topoIcon.authKey) == -1))
						{
							// 无权限
							topoIcon.hide();
						}
						else
						{
							// 有权限
							topoIcon.show();
						}
					}
				});

		}

		/**
		 * 拓扑图画布
		 */
		public function set topoCanvas(value:TopoCanvas):void
		{
			_topoCanvas = value;
		}

		/**
		 * 权限key的数组
		 */
		public function set authKeys(value:Array):void
		{
			_authKeys = value;
			checkAuth();
		}

		/**
		 * 是否启用权限过滤(不启用的话将默认都显示)
		 *
		 */
		public function set authEnabled(value:Boolean):void
		{
			_authEnabled = value;
			checkAuth();
		}

		/**
		 * 校验权限
		 *
		 */
		private function checkAuth():void
		{
			var i:int = 0;
			var element:IVisualElement = null;
			if (!_authEnabled)
			{
				for (i = 0; i < this.numElements; i++)
				{
					element = this.getElementAt(i);
					if (element is TopoIcon)
					{
						(element as TopoIcon).show();
					}
				}
			}
			else
			{
				for (i = 0; i < this.numElements; i++)
				{
					element = this.getElementAt(i);
					if (element is TopoIcon)
					{
						var topoIcon:TopoIcon = element as TopoIcon;
						if (_authKeys != null && _authKeys.indexOf(topoIcon.authKey) != -1)
						{
							// 有权限
							topoIcon.show();
						}
						else
						{
							// 无权限
							topoIcon.hide();
						}
					}
				}
			}
		}

	}
}