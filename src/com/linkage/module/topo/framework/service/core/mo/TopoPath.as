package com.linkage.module.topo.framework.service.core.mo
{
	import com.linkage.module.topo.framework.view.component.TopoCanvas;

	/**
	 * 拓扑路径对象
	 * @author duangr
	 *
	 */
	public class TopoPath
	{
		private var _id:String = null;

		private var _name:String = null;

		private var _type:String = null;

		private var _topoName:String = null;


		public function TopoPath(canvas:TopoCanvas):void
		{
			_id = canvas.topoId;
			_name = canvas.topoViewName;
			_type = canvas.topoType;
			_topoName = canvas.topoName;
		}

		/**
		 * 判断两个路径是否相同
		 * @param path
		 * @return
		 *
		 */
		public function equals(path:TopoPath):Boolean
		{
			return this.id == path.id;
		}

		/**
		 * 拓扑id
		 */
		public function get id():String
		{
			return _id;
		}

		/**
		 * @private
		 */
		public function set id(value:String):void
		{
			_id = value;
		}

		/**
		 * 拓扑名称
		 */
		public function get name():String
		{
			return _name;
		}

		/**
		 * @private
		 */
		public function set name(value:String):void
		{
			_name = value;
		}

		/**
		 * 拓扑类型
		 */
		public function get type():String
		{
			return _type;
		}

		/**
		 * @private
		 */
		public function set type(value:String):void
		{
			_type = value;
		}

		/**
		 * 拓扑数据源名称
		 */
		public function get topoName():String
		{
			return _topoName;
		}

		public function set topoName(value:String):void
		{
			_topoName = value;
		}

		public function toString():String
		{
			return "{id:" + id + ",name:" + name + ",type:" + type + "}";
		}




	}
}