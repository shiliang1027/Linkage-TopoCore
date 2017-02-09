package com.linkage.module.topo.framework.controller.action.canvas
{
	import com.linkage.module.topo.framework.controller.event.TopoEvent;
	import com.linkage.module.topo.framework.core.Feature;
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.model.element.plane.ITPGroup;
	import com.linkage.module.topo.framework.core.model.element.point.ITPPoint;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;
	import com.linkage.system.structure.map.IMap;
	import com.linkage.system.structure.map.Map;

	import flash.events.MouseEvent;
	import flash.geom.Point;

	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	/**
	 * 分组监听器模式 Action
	 * @author duangr
	 *
	 */
	public class GroupMonitorAction extends CanvasAction
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.controller.action.canvas.GroupMonitorAction");

		public function GroupMonitorAction(canvas:TopoCanvas)
		{
			super(canvas);
		}

		override public function get name():String
		{
			return "分组监听器模式";
		}


		override public function onUpWithDownFeatureNoMove(event:MouseEvent, mouseCanvasPoint:Point, downFeature:Feature, upFeature:Feature):void
		{
			groupMonitor(upFeature);
		}

		override public function onUpWithDownFeatureAndMove(event:MouseEvent, mouseCanvasPoint:Point, downFeature:Feature, upFeature:Feature):void
		{
			groupMonitor(upFeature);
		}

		// 监控分组添加新元素的事件
		private function groupMonitor(upFeature:Feature):void
		{
//			log.debug("监控分组添加新元素的事件 {0}", upFeature);
			if (upFeature == null)
			{
				// 鼠标up时不在元素上,退出
				return;
			}
			var group:ITPGroup = upFeature.element as ITPGroup;
			if (group == null)
			{
				// 鼠标up的对象不是分组,判断对象是否存在groupOwner
				var tpPoint:ITPPoint = upFeature.element as ITPPoint;
				if (tpPoint)
				{
					group = tpPoint.groupOwner;
				}
			}
			if (group == null)
			{
				// 若分组还是不存在,则退出
				return;
			}
			if (!_canvas.hasFeatureSelected())
			{
				// 没有框选元素,退出
				return;
			}
			var includeSelf:Boolean = false;

			var addToGroupElements:Array = [];
			_canvas.eachSelect(function(id:String, element:IElement):void
				{
					if (id == group.id)
					{
						includeSelf = true;
						return;
					}
					var tpPoint:ITPPoint = element as ITPPoint;
					if (tpPoint && tpPoint.groupOwner == null)
					{
						addToGroupElements.push(tpPoint);
					}
				});
			if (includeSelf)
			{
				return;
			}

			if (addToGroupElements.length > 0)
			{
				var properties:IMap = new Map();
				properties.put("elements", addToGroupElements);
				_canvas.dispatchEvent(new TopoEvent(TopoEvent.ADD_TO_GROUP, group.feature, properties));
			}

		}

	}
}