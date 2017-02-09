package com.linkage.module.topo.framework.controller.menu
{
	import mx.collections.ArrayCollection;

	/**
	 * 菜单资源对象
	 * @author duangr
	 *
	 */
	public class MenuResItem
	{
		// 菜单名称
		private var _name:String = null;
		// 是否允许匹配出现
		private var _multiple:Boolean = false;
		// 菜单图标
		private var _icon:String = null;

		// Action的权重
		private var _actionWeight:uint = 0;
		// 元素对象的权重
		private var _elementWeight:uint = 0;

		// 菜单的类型 (url|msg|action)
		private var _type:String = null;
		// 菜单操作
		private var _action:String = null;
		// 菜单过滤字符串
		private var _filter:String = null;
		// 子菜单
		private var _submenu:ArrayCollection = null;
		// 菜单的深度(对于双击的菜单,启用深度最大的菜单)
		private var _depth:int = 0;
		// 出现菜单的类型(如:static_view)
		private var _ztype:String = null;


		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function get multiple():Boolean
		{
			return _multiple;
		}

		public function set multiple(value:Boolean):void
		{
			_multiple = value;
		}

		public function get icon():String
		{
			return _icon;
		}

		public function set icon(value:String):void
		{
			_icon = value;
		}

		public function get actionWeight():uint
		{
			return _actionWeight;
		}

		public function set actionWeight(value:uint):void
		{
			_actionWeight = value;
		}

		public function get elementWeight():uint
		{
			return _elementWeight;
		}

		public function set elementWeight(value:uint):void
		{
			_elementWeight = value;
		}


		public function get action():String
		{
			return _action;
		}

		public function set action(value:String):void
		{
			_action = value;
		}

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}

		public function get filter():String
		{
			return _filter;
		}

		public function set filter(value:String):void
		{
			_filter = value;
		}

		public function get ztype():String
		{
			return _ztype;
		}

		public function set ztype(value:String):void
		{
			_ztype = value;
		}

		public function get depth():int
		{
			return _depth;
		}

		public function set depth(value:int):void
		{
			_depth = value;
		}

		public function toString():String
		{
			return "MenuResItem(" + name + " / " + type + " / " + ztype + " / multiple=" + multiple + ") " + action;
		}
	}
}