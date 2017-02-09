package com.linkage.module.topo.framework.controller.action.canvas
{
	import com.linkage.module.topo.framework.controller.event.TopoEvent;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;
	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	/**
	 * 创建图片对象模式
	 * @author duangr
	 *
	 */
	public class CreatePicAction extends CreateShapeAction
	{
		// log
		private static const log:ILogger = Log.getLoggerByClass(CreatePicAction);

		public function CreatePicAction(canvas:TopoCanvas)
		{
			super(canvas);
		}

		override public function get name():String
		{
			return "创建图片对象模式";
		}

		/**
		 * 抛出创建事件的事件类型
		 *
		 */
		override protected function get eventType():String
		{
			return TopoEvent.CREATE_SHAPE_PIC;
		}

	}
}