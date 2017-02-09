package com.linkage.module.topo.framework.controller.action.canvas
{
	import com.linkage.module.topo.framework.Constants;
	import com.linkage.module.topo.framework.controller.event.TopoEvent;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;
	import com.linkage.system.structure.map.IMap;
	import com.linkage.system.structure.map.Map;

	import flash.display.Graphics;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;

	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	import spark.components.Group;

	/**
	 * 创建缩略图模式
	 * @author duangr
	 *
	 */
	public class CreateHLinkLayerAction extends CreateShapeAction
	{
		// log
		private static const log:ILogger = Log.getLogger("com.linkage.module.topo.framework.controller.action.canvas.CreateHLinkLayerAction");

		public function CreateHLinkLayerAction(canvas:TopoCanvas)
		{
			super(canvas);
		}

		override public function get name():String
		{
			return "创建缩略图模式";
		}

		/**
		 * 抛出创建事件的事件类型
		 *
		 */
		override protected function get eventType():String
		{
			return TopoEvent.CREATE_HLINKLAYER;
		}

		/**
		 * 选择框的粗细
		 * @return
		 *
		 */
		override protected function get selectAreaLineThickness():uint
		{
			return Constants.DEFAULT_CREATEHLINKLAYER_SELECTAREA_LINE_SIZE;
		}

		/**
		 * 选择框的颜色
		 * @return
		 *
		 */
		override protected function get selectAreaLineColor():uint
		{
			return Constants.DEFAULT_CREATEHLINKLAYER_SELECTAREA_LINE_COLOR;
		}
	}
}