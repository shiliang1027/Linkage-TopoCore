package com.linkage.module.topo.framework.util.loading
{

	/**
	 * 空的加载中提示信息
	 * @author duangr
	 *
	 */
	public class EmptyLoadingInfo implements ILoadingInfo
	{
		public function EmptyLoadingInfo()
		{
		}

		public function loadingStart():void
		{
			// 空逻辑
		}

		public function loadingEnd():void
		{
			// 空逻辑
		}

		public function toString():String
		{
			return "(空 Loading消息)";
		}
	}
}