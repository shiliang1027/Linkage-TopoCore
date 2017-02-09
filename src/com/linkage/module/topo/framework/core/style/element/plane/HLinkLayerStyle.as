package com.linkage.module.topo.framework.core.style.element.plane
{
	import com.linkage.module.topo.framework.controller.event.FeatureEvent;
	import com.linkage.module.topo.framework.controller.menu.EmptyMenuManager;
	import com.linkage.module.topo.framework.core.Feature;
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.model.element.plane.IHLinkLayer;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;
	import com.linkage.module.topo.framework.view.component.TopoLayer;
	import com.linkage.system.utils.StringUtils;

	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	import spark.components.Group;

	/**
	 * 缩略图对象样式
	 * @author duangr
	 *
	 */
	public class HLinkLayerStyle extends ShapeStyle
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.core.style.element.plane.HLinkLayerStyle");

		public function HLinkLayerStyle(imageContext:String, fillImageContext:String)
		{
			super(imageContext, fillImageContext);
		}


		override public function draw(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):void
		{
			feature.visible = beforeDraw(feature, element, topoLayer, topoCanvas, attributes);
			if (feature.visible)
			{
				initDeepth(feature, element, topoLayer, topoCanvas);
				var hlinkLayer:IHLinkLayer = element as IHLinkLayer;

				revisePlaneXY(feature, hlinkLayer, topoLayer, topoCanvas);
				drawTopoLayer(feature, hlinkLayer, topoLayer, topoCanvas);
			}
		}

		private function drawTopoLayer(feature:Feature, hlinkLayer:IHLinkLayer, topoLayer:TopoLayer, topoCanvas:TopoCanvas):void
		{
			// 子对象不响应鼠标事件
			feature.mouseChildren = false;
			if (hlinkLayer.topoLayer == null)
			{
				buildTopoLayer(feature, hlinkLayer, topoCanvas);
			}
			else
			{
				feature.addElement(hlinkLayer.topoLayerContainer);
			}

			/// --- 填充背景 --- ///
			drawShapeWithStyleGraphics(hlinkLayer.topoLayerContainer, feature, hlinkLayer, topoLayer, topoCanvas);

			// ---- 画阴影 ----
			drawShadow(hlinkLayer.topoLayerContainer, hlinkLayer);

			/// --- 处理旋转逻辑 --- ///
			transformShape(hlinkLayer);

			afterDrawShape(feature, hlinkLayer, topoLayer, topoCanvas);

			// 获取数据的绘制画布
			var sourceTopoLayer:TopoLayer = hlinkLayer.topoLayer;
			// 获取数据的拓扑数据源名称
			var sourceTopoName:String = hlinkLayer.sourceTopoName;
			topoCanvas.loadTopoData(function(data:XML):void
				{
					sourceTopoLayer.dataXML = data;

					/// --- 处理缩放逻辑 --- ///
					var scaleX:Number = 1;
					var scaleY:Number = 1;
					if (sourceTopoLayer.viewBounds.rectangle.width >= sourceTopoLayer.dataBounds.rectangle.width && sourceTopoLayer.viewBounds.rectangle.height >= sourceTopoLayer.dataBounds.rectangle.
						height)
					{
						// 显示不需要缩放
					}
					else
					{
						scaleX = feature.width / (sourceTopoLayer.dataBounds.rectangle.width);
						scaleY = feature.height / (sourceTopoLayer.dataBounds.rectangle.height);

						sourceTopoLayer.viewBounds.afterViewZoom(scaleX / sourceTopoLayer.scaleX, scaleY / sourceTopoLayer.scaleY);
						sourceTopoLayer.scaleX = scaleX;
						sourceTopoLayer.scaleY = scaleY;
					}
					sourceTopoLayer.viewBounds.updateByDataBoundsCenter(sourceTopoLayer.dataBounds);
					sourceTopoLayer.viewBounds.refresh();

					topoLayerCreationComplete(feature, hlinkLayer, true);

				}, hlinkLayer.sourceId, sourceTopoName, true, hlinkLayer.sourceTopoType);

		}

		/**
		 * 内部层次创建完成
		 * @param feature
		 * @param hlinkLayer
		 * @param dispatchEvent
		 *
		 */
		final private function topoLayerCreationComplete(feature:Feature, hlinkLayer:IHLinkLayer, dispatchEvent:Boolean = false):void
		{
			if (hlinkLayer.topoLayerCreationComplete == false)
			{
				hlinkLayer.topoLayerCreationComplete = true;
				if (dispatchEvent)
				{
					feature.dispatchEvent(new FeatureEvent(FeatureEvent.TOPOLAYER_CREATION_COMPLETE, feature));
				}
			}
		}

		/**
		 * 构造TopoLayer对象
		 * @param topoCanvas
		 * @return
		 *
		 */
		private function buildTopoLayer(feature:Feature, hlinkLayer:IHLinkLayer, topoCanvas:TopoCanvas):void
		{
			var topoLayer:TopoLayer = new TopoLayer(topoCanvas);
			topoLayer.initTopoLayerSize(hlinkLayer.width, hlinkLayer.height);
			topoLayer.menuManager = EmptyMenuManager.getInstance();
			topoLayer.styleFactory = topoCanvas.styleFactory;
			topoLayer.parserFactory = topoCanvas.parserFactory;
			topoLayer.percentWidth = 100;
			topoLayer.percentHeight = 100;
			log.debug("===========================>{0}",topoLayer.parent);
			var topoLayerContainer:Group = new Group();
			topoLayerContainer.x = topoLayerContainer.y = 0;
			topoLayerContainer.width = feature.width;
			topoLayerContainer.height = feature.height;
			topoLayerContainer.addElement(topoLayer);
			// 禁用鼠标事件
			topoLayerContainer.mouseEnabled = false;
			topoLayerContainer.mouseChildren = false;

			feature.addElement(topoLayerContainer);

			hlinkLayer.topoLayer = topoLayer;
			hlinkLayer.topoLayerContainer = topoLayerContainer;

		}

		/**
		 * 处理转换形状的逻辑
		 * @param hlinkLayer
		 *
		 */
		private function transformShape(hlinkLayer:IHLinkLayer):void
		{
			initProjectionCenter(hlinkLayer.feature);
			clearRotateShape(hlinkLayer.topoLayerContainer);
			rotateShape(hlinkLayer.topoLayerContainer, hlinkLayer);
		}

	}
}