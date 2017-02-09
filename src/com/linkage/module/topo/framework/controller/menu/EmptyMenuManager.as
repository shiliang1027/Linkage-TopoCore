package com.linkage.module.topo.framework.controller.menu
{
	import com.linkage.module.topo.framework.core.Feature;

	import flash.display.InteractiveObject;

	/**
	 * 空菜单管理器(方法全部为空)
	 * @author duangr
	 *
	 */
	public class EmptyMenuManager implements IMenuManager
	{
		private static var _instance:IMenuManager = null;

		public function EmptyMenuManager(pvt:_PrivateClass)
		{
			if (pvt == null)
			{
				throw new ArgumentError("EmptyMenuManager构造时,参数[pvt:_PrivateClass]不能为null!");
			}
		}

		/**
		 * 获取单件实例
		 * @return
		 *
		 */
		public static function getInstance():IMenuManager
		{
			if (_instance == null)
			{
				_instance = new EmptyMenuManager(new _PrivateClass());
			}
			return _instance;
		}

		public function initialize(menuXML:XML, urlContext:String):void
		{
		}

		public function set menuOwner(menuOwner:InteractiveObject):void
		{
		}

		public function onDoubleClick(feature:Feature):void
		{
		}

		public function clear():void
		{
		}

		public function set version(value:String):void
		{

		}
	}
}

class _PrivateClass
{
	public function _PrivateClass()
	{

	}
}