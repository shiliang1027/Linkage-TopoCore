package com.linkage.module.topo.framework.util
{
	import mx.controls.Alert;
	import mx.events.CloseEvent;

	/**
	 * 消息工具类
	 * @author duangr
	 *
	 */
	public class MessageUtil
	{
		public function MessageUtil()
		{
		}

		/**
		 * 展现消息
		 * @param text
		 *
		 */
		public static function showMessage(text:String):void
		{
			Alert.show(text, "提示信息");
		}

		/**
		 * 确认信息
		 * @param text
		 * @param yes 按下yes按钮后回调(无参数)
		 * @param no 按下no按钮后回调(无参数)
		 *
		 */
		public static function confirm(text:String, yes:Function, no:Function = null):void
		{
			Alert.show(text, "确认信息", Alert.YES | Alert.NO, null, function(event:CloseEvent):void
				{
					switch (event.detail)
					{
						case Alert.YES:
							if (yes != null)
							{
								yes.call();
							}
							break;
						case Alert.NO:
							if (no != null)
							{
								no.call();
							}
							break;
					}
				});
		}
	}
}