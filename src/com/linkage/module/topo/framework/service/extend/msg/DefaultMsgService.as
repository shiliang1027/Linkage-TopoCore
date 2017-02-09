package com.linkage.module.topo.framework.service.extend.msg
{
	import com.linkage.module.topo.framework.Constants;
	import com.linkage.module.topo.framework.controller.event.CanvasEvent;
	import com.linkage.module.topo.framework.service.Service;
	import com.linkage.module.topo.framework.util.MessageUtil;
	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	/**
	 * 默认的消息提示业务类
	 * @author duangr
	 *
	 */
	public class DefaultMsgService extends Service
	{

		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.service.extend.msg.DefaultMsgService");

		public function DefaultMsgService()
		{
			super();
		}

		override public function get name():String
		{
			return "默认消息业务逻辑";
		}

		override public function start():void
		{
			topoCanvas.addEventListener(CanvasEvent.LOAD_LAYER_ERROR, canvasEventHandler_LoadLayerError);

			topoCanvas.addEventListener(CanvasEvent.SAVELAYER_ASNEW_FAILURE, canvasEventHandler_ShowMsg);
			topoCanvas.addEventListener(CanvasEvent.SAVELAYER_ASCURRENT_FAILURE, canvasEventHandler_ShowMsg);
			topoCanvas.addEventListener(CanvasEvent.SAVE_ELEMENT_FAILURE, canvasEventHandler_ShowMsg);
			topoCanvas.addEventListener(CanvasEvent.SAVE_TOPO_FAILURE, canvasEventHandler_ShowMsg);
		}

		// 【加载拓扑数据异常】
		private function canvasEventHandler_LoadLayerError(event:CanvasEvent):void
		{
			MessageUtil.showMessage("拓扑图数据为空,不能绘制拓扑!");
		}

		// 【消息提示】
		private function canvasEventHandler_ShowMsg(event:CanvasEvent):void
		{
			MessageUtil.showMessage(event.getProperty(Constants.MAP_KEY_MSG));
		}
	}
}