package com.linkage.module.topo.framework.util.loading
{

	/**
	 * 加载过程中的提示信息管理类(单件类)
	 * @author duangr
	 *
	 */
	public class LoadingManager
	{
		// 加载中的消息提示
		private var _loadingInfo:ILoadingInfo = null;
		// 空的消息提示
		private var _emptyLoadingInfo:ILoadingInfo = new EmptyLoadingInfo();

		// 单件实例
		private static var _instance:LoadingManager = null;

		public function LoadingManager(pvt:_PrivateClass)
		{
			if (pvt == null)
			{
				throw new ArgumentError("ImageBuffer构造时,参数[pvt:_PrivateClass]不能为null!");
			}
		}

		/**
		 * 获取单件实例
		 * @return
		 *
		 */
		public static function getInstance():LoadingManager
		{
			if (_instance == null)
			{
				_instance = new LoadingManager(new _PrivateClass());
			}
			return _instance;
		}

		/**
		 * 加载中提示信息类
		 */
		public function get loadingInfo():ILoadingInfo
		{
			return _loadingInfo == null ? _emptyLoadingInfo : _loadingInfo;
		}

		public function set loadingInfo(value:ILoadingInfo):void
		{
			_loadingInfo = value;
		}

	}
}

class _PrivateClass
{
	public function _PrivateClass()
	{

	}
}