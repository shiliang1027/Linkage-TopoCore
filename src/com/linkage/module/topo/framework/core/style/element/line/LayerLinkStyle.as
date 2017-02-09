package com.linkage.module.topo.framework.core.style.element.line
{
	import com.linkage.module.topo.framework.controller.event.FeatureEvent;
	import com.linkage.module.topo.framework.core.Feature;
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.model.element.line.ILayerLink;
	import com.linkage.module.topo.framework.core.model.element.plane.IHLinkLayer;
	import com.linkage.module.topo.framework.core.model.element.point.ITPPoint;
	import com.linkage.module.topo.framework.util.TopoUtil;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;
	import com.linkage.module.topo.framework.view.component.TopoLayer;

	import flash.geom.Point;

	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	/**
	 * 缩略图间链路样式
	 * @author duangr
	 *
	 */
	public class LayerLinkStyle extends LinkStyle
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.core.style.element.line.LayerLinkStyle");

		public function LayerLinkStyle()
		{
			super();
		}

		override public function draw(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):void
		{
			var layerLink:ILayerLink = element as ILayerLink;
			var fromLayer:IHLinkLayer = layerLink.fromLayer;
			var toLayer:IHLinkLayer = layerLink.toLayer;
			// 先保证两端的缩略图初始化完毕
			if (fromLayer.topoLayerCreationComplete && toLayer.topoLayerCreationComplete)
			{
				checkLayerElement();
			}
			else
			{
				if (!fromLayer.topoLayerCreationComplete)
				{
					fromLayer.feature.addEventListener(FeatureEvent.TOPOLAYER_CREATION_COMPLETE, handler_topoLayerCreationComplete);
				}
				if (!toLayer.topoLayerCreationComplete)
				{
					toLayer.feature.addEventListener(FeatureEvent.TOPOLAYER_CREATION_COMPLETE, handler_topoLayerCreationComplete);
				}
			}

			function handler_topoLayerCreationComplete(event:FeatureEvent):void
			{
				// 删除监听的事件
				(event.target as Feature).removeEventListener(FeatureEvent.TOPOLAYER_CREATION_COMPLETE, handler_topoLayerCreationComplete);
				if (fromLayer.topoLayerCreationComplete && toLayer.topoLayerCreationComplete)
				{
					checkLayerElement();
				}
			}


			/**
			 * 缩略图初始化完毕后,再验证缩略图中网元是否初始化完毕
			 */
			function checkLayerElement():void
			{
				layerLink.fromElement = fromLayer.topoLayer.findElementById(layerLink.fromElementId) as ITPPoint;
				layerLink.toElement = toLayer.topoLayer.findElementById(layerLink.toElementId) as ITPPoint;

				// 再保证缩略图中的网元初始化完毕
				var fromFeature:Feature = layerLink.fromElement.feature;
				var toFeature:Feature = layerLink.toElement.feature;

				if (fromFeature.creationComplete && toFeature.creationComplete)
				{
					initLinkStyle(feature, layerLink, topoLayer, topoCanvas);
				}
				else
				{
					if (!fromFeature.creationComplete)
					{
						fromFeature.addEventListener(FeatureEvent.CREATION_COMPLETE, handler_creationComplete);
					}
					if (!toFeature.creationComplete)
					{
						toFeature.addEventListener(FeatureEvent.CREATION_COMPLETE, handler_creationComplete);
					}
				}

				function handler_creationComplete(event:FeatureEvent):void
				{
					// 删除监听的事件
					(event.target as Feature).removeEventListener(FeatureEvent.CREATION_COMPLETE, handler_creationComplete);

					if (fromFeature.creationComplete && toFeature.creationComplete)
					{
						initLinkStyle(feature, layerLink, topoLayer, topoCanvas);
					}
				}
			}


		}

		override protected function initDeepth(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas):void
		{
			// 链路不要每次刷新都算深度
			if (feature.creationComplete)
			{
				return;
			}
			var layerLink:ILayerLink = element as ILayerLink;
			var fromLayer:ITPPoint = TopoUtil.findElementDrawOnCanvas(layerLink.fromLayer);
			var toLayer:ITPPoint = TopoUtil.findElementDrawOnCanvas(layerLink.toLayer);

			// 参照元素为最低层次的元素
			var referElement:IElement = null;
			// 【做法】修正链路的 elementIndex,位于两端缩略图中间,具体讲就是位于最低缩略图的上面
			if (fromLayer.zindex == toLayer.zindex)
			{
				// 深度相同时,找到 elementIndex 最小的作为参照
				referElement = topoLayer.getElementIndex(fromLayer.feature) < topoLayer.getElementIndex(toLayer.feature) ? fromLayer : toLayer;
			}
			else
			{
				// 深度不同时,找到 深度最小的作为参照
				referElement = (fromLayer.zindex < toLayer.zindex) ? fromLayer : toLayer;
			}
			// 链路和低层次元素处于同一 zindex,但是链路elementIndex要比元素高(默认链路是后加入的,已经低了)
			feature.depth = referElement.zindex;
			// 先把链路放在元素的下面,然后再交换下位置到元素的上面,防止数组越界
			topoLayer.setElementIndex(feature, topoLayer.getElementIndex(referElement.feature));
			topoLayer.swapElements(feature, referElement.feature);

		}


		override protected function findFromToPoints(feature:Feature, topoLayer:TopoLayer):DoublePoints
		{
			var layerLink:ILayerLink = feature.element as ILayerLink;

			// [准备工作]两端缩略图对象
			var fromTopoLayer:TopoLayer = layerLink.fromLayer.topoLayer;
			var toTopoLayer:TopoLayer = layerLink.toLayer.topoLayer;

			// [准备工作]两端网元Feature
			var fromFeature:Feature = layerLink.fromElement.feature;
			var toFeature:Feature = layerLink.toElement.feature;

			// [1]缩略图中起点相对画布的坐标
			var fromPointInLayer:Point = fromTopoLayer.localToLayer(fromFeature);
			fromPointInLayer.x += fromFeature.width / 2;
			fromPointInLayer.y += fromFeature.height / 2;
			// [2]缩略图中终点相对画布的坐标
			var toPointInLayer:Point = toTopoLayer.localToLayer(toFeature);
			toPointInLayer.x += toFeature.width / 2;
			toPointInLayer.y += toFeature.height / 2;

			// [3]将缩略图中相对画布的坐标转换为相对舞台的坐标,然后再转换为相对当前画布的坐标
			var fromPoint:Point = topoLayer.globalToLocal(fromTopoLayer.localToGlobal(fromPointInLayer));
			var toPoint:Point = topoLayer.globalToLocal(toTopoLayer.localToGlobal(toPointInLayer));

//			log.debug("找到缩略图中两点坐标: {0} - {1}", fromPoint, toPoint);
			return new DoublePoints(fromPoint, toPoint);
		}

		override protected function reviseFromToPoint(feature:Feature, fromPoint:Point, toPoint:Point):void
		{
			// 由于线是在Feature里面绘制的,要将内部点的坐标再减去自身的坐标
			fromPoint.x = fromPoint.x - feature.x;
			fromPoint.y = fromPoint.y - feature.y;
			toPoint.x = toPoint.x - feature.x;
			toPoint.y = toPoint.y - feature.y;
		}
	}
}