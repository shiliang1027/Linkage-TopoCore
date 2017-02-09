package com.linkage.module.topo.framework.util.loading
{

	/**
	 * 加载中的提示信息接口
	 * @author duangr
	 *
	 */
	public interface ILoadingInfo
	{

		/**
		 * 开始loading
		 *
		 */
		function loadingStart():void;

		/**
		 * 结束loading
		 *
		 */
		function loadingEnd():void;
	}
}