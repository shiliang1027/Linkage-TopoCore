package com.linkage.module.topo.framework.service.extend.msg
{
	import com.linkage.module.topo.framework.service.Service;
	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	/**
	 * 空的消息提示业务类
	 * @author duangr
	 *
	 */
	public class EmptyMsgService extends Service
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.service.extend.msg.EmptyMsgService");

		public function EmptyMsgService()
		{
			super();
		}

		override public function get name():String
		{
			return "空消息业务逻辑";
		}

		override public function start():void
		{
		}
	}
}