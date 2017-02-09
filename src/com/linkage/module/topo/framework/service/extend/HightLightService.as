package com.linkage.module.topo.framework.service.extend
{
	import com.linkage.module.topo.framework.Constants;
	import com.linkage.module.topo.framework.controller.event.CanvasEvent;
	import com.linkage.module.topo.framework.controller.event.TopoEvent;
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.model.element.line.ILink;
	import com.linkage.module.topo.framework.core.model.element.plane.ITPGroup;
	import com.linkage.module.topo.framework.core.model.element.point.ITPPoint;
	import com.linkage.module.topo.framework.service.Service;
	import com.linkage.system.structure.map.IMap;
	import com.linkage.system.structure.map.Map;

	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	/**
	 * 高亮的业务逻辑
	 * @author duangr
	 *
	 */
	public class HightLightService extends Service
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.service.extend.HightLightService");
		// 低亮系数
		private static const LOWLIGHT_COEFFICIENT:Number = 0.2;
		// 高亮的网元容器
		private var _hightLightMap:IMap = new Map();
		// 灰化的网元容器
		private var _lowLightMap:IMap = new Map();

		public function HightLightService()
		{
			super();
		}

		override public function get name():String
		{
			return "高亮的业务逻辑";
		}

		override public function set attributes(attr:Object):void
		{
		}

		override public function start():void
		{
			topoCanvas.addEventListener(TopoEvent.HIGHTLIGHT_SAME_CONNECT, topoEventHandler_Same_HightLightConnect);
			topoCanvas.addEventListener(TopoEvent.HIGHTLIGHT_CONNECT, topoEventHandler_HightLightConnect);
			topoCanvas.addEventListener(TopoEvent.HIGHTLIGHT_CANCEL, topoEventHandler_HightLightCancel);
		}

		// 【 同属性高亮】
		private function topoEventHandler_Same_HightLightConnect(event:TopoEvent):void
		{
			
		var key:String = event.getProperty("key");
		var value:String =	event.getProperty("value");
			log.info("【 同属性高亮】key="+key+",value="+value);
			var element:IElement = event.feature.element;
			if (!(element is ITPPoint))
			{
				// 链路不高亮关联网元p9
				return;
			}
			var tpPoint:ITPPoint = element as ITPPoint;
			// 若自己已经在高亮,不清空已有的高亮数据,将此网元的关联网元继续高亮
			if (_hightLightMap.get(tpPoint.id) != null)
			{
				clearLastLowLight();
				
			}
			else
			{
				clearLastHightLight();
			}
			// 高亮关联网元
			addHightLightTPPoint(tpPoint);
			// 高亮的同时选中网元
			topoCanvas.dispatchEvent(new CanvasEvent(CanvasEvent.SELECTED_CHANGED));
			
			topoCanvas.eachElement(function(id:String, theElement:IElement):void
			{
				if(theElement.getProperty(key) && theElement.getProperty(key)==value)
				{
					addHightLightTPPoint(theElement as ITPPoint);
				}
				else
				{
					// 不高亮的对象,就减少透明度
					_lowLightMap.put(theElement, theElement.feature.alpha);
					theElement.feature.alpha *= LOWLIGHT_COEFFICIENT;
				}
			});
			topoCanvas.addExtendProperty(Constants.PROPERTY_CANVAS_HIGHTLIGHT, "true");
		}
		// 【高亮关联网元】
		private function topoEventHandler_HightLightConnect(event:TopoEvent):void
		{
			log.info("【高亮关联网元】");
			// --------------------------
			// 高亮关联网元功能,
			// 若当前选中网元已经处于高亮状态,不会影响当前正在高亮的网元,会将选中网元的关联网元也跟着高亮;
			// 若当前选中网元不处于高亮状态,会清空之前的高亮效果,仅把当前网元以及关联网元告警.
			// --------------------------
			var element:IElement = event.feature.element;
			if (!(element is ITPPoint))
			{
				// 链路不高亮关联网元
				return;
			}
			var tpPoint:ITPPoint = element as ITPPoint;
			log.debug("高亮关联网元 {0}", tpPoint);
			// 若自己已经在高亮,不清空已有的高亮数据,将此网元的关联网元继续高亮
			if (_hightLightMap.get(tpPoint.id) != null)
			{
				clearLastLowLight();
			}
			else
			{
				clearLastHightLight();
			}
			// 高亮关联网元
			addHightLightTPPoint(tpPoint);
			tpPoint.outLines.forEach(function(link:ILink, index:int, array:Array):void
				{
					addHightLightLink(link);
					addHightLightTPPoint(link.toElement);
				});
			tpPoint.inLines.forEach(function(link:ILink, index:int, array:Array):void
				{
					addHightLightLink(link);
					addHightLightTPPoint(link.fromElement);
				});
			// 高亮的同时选中网元
			topoCanvas.dispatchEvent(new CanvasEvent(CanvasEvent.SELECTED_CHANGED));
			topoCanvas.eachElement(function(id:String, element:IElement):void
				{
					// 不高亮的对象,就减少透明度
					if (_hightLightMap.get(id) == null)
					{
						_lowLightMap.put(element, element.feature.alpha);
						element.feature.alpha *= LOWLIGHT_COEFFICIENT;
					}
				});
			topoCanvas.addExtendProperty(Constants.PROPERTY_CANVAS_HIGHTLIGHT, "true");
		}

		// 【取消高亮】
		private function topoEventHandler_HightLightCancel(event:TopoEvent):void
		{
			clearLastHightLight();
			topoCanvas.addExtendProperty(Constants.PROPERTY_CANVAS_HIGHTLIGHT, "false");
		}

		/**
		 * 添加高亮的对象
		 * @param tpPoint
		 *
		 */
		private function addHightLightTPPoint(tpPoint:ITPPoint):void
		{
			_hightLightMap.put(tpPoint.id, tpPoint);
			topoCanvas.addToSelect(tpPoint);
			if (tpPoint.groupOwner)
			{
				addHightLightTPGroup(tpPoint.groupOwner);
			}
		}

		/**
		 * 添加高亮的分组(因为对象在分组中,因此分组也要高亮)
		 * @param tpGroup
		 *
		 */
		private function addHightLightTPGroup(tpGroup:ITPGroup):void
		{
			_hightLightMap.put(tpGroup.id, tpGroup);
			if (tpGroup.groupOwner)
			{
				addHightLightTPGroup(tpGroup.groupOwner);
			}
		}

		/**
		 * 添加告警的链路
		 * @param link
		 *
		 */
		private function addHightLightLink(link:ILink):void
		{
			_hightLightMap.put(link.id, link);
		}

		/**
		 * 清除上次高亮效果
		 *
		 */
		private function clearLastHightLight():void
		{
			clearLastLowLight();
			_hightLightMap.clear();
		}

		/**
		 * 清除上次的灰化效果,但是不清除高亮网元容器
		 *
		 */
		private function clearLastLowLight():void
		{
			_lowLightMap.forEach(function(element:IElement, alpha:Number):void
				{
					element.feature.alpha /= LOWLIGHT_COEFFICIENT;
				})
			_lowLightMap.clear();
		}
	}
}