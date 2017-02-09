package com.linkage.module.topo.framework.core.style.element.point
{
	import com.linkage.module.topo.framework.Constants;
	import com.linkage.module.topo.framework.core.Feature;
	import com.linkage.module.topo.framework.core.model.alarm.IAlarm;
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.model.element.point.INode;
	import com.linkage.module.topo.framework.util.AlarmConstants;
	import com.linkage.module.topo.framework.util.ImageBuffer;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;
	import com.linkage.module.topo.framework.view.component.TopoLayer;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;

	import mx.controls.Image;
	import mx.effects.IEffectInstance;
	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	/**
	 * 节点样式
	 * @author duangr
	 *
	 */
	public class NodeStyle extends PointStyle
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.core.style.element.point.NodeStyle");
		// 图标缓存类
		protected var _imageBuffer:ImageBuffer = ImageBuffer.getInstance();
		// 图标文件的上下文路径
		protected var _imageContext:String = null;

		public function NodeStyle(imageContext:String)
		{
			super();
			_imageContext = imageContext;
		}

		override public function draw(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):void
		{
			feature.visible = beforeDraw(feature, element, topoLayer, topoCanvas, attributes);
			if (feature.visible)
			{
				initDeepth(feature, element, topoLayer, topoCanvas);
				var node:INode = element as INode;

				reviseXY(feature, node, topoLayer, topoCanvas);
				drawIcon(feature, node, node.icon, node.labelTooltip, topoLayer, topoCanvas);
			}
		}

		/**
		 * 画图标
		 * @param feature
		 * @param node
		 * @param icon
		 * @param toolTip
		 * @param topoCanvas
		 *
		 */
		protected function drawIcon(feature:Feature, node:INode, icon:String, toolTip:String, topoLayer:TopoLayer, topoCanvas:TopoCanvas):void
		{
			feature.width = feature.height = Constants.DEFAULT_ICON_SIZE;

			_imageBuffer.loadBitmapData(_imageContext + "/" + icon, function(bitmapData:BitmapData, width:Number, height:Number):void
				{
					feature.removeAllElements();
					var image:Image = new Image();
					image.source = new Bitmap(bitmapData);
					if (node.iconWidth > 0 && node.iconHeight > 0)
					{
						// 设置过图标的大小,使用设置的值
						image.width = node.iconWidth;
						image.height = node.iconHeight;
					}
					else
					{
						// 使用图标真实的大小值
						image.width = width;
						image.height = height;
					}
					image.toolTip = toolTip;
					image.x = image.y = _padding;
					feature.addElementAt(image, 0);
					feature.icon = image;
					// 拓扑要素的大小等同于图片的大小
					feature.width = image.width + 2 * _padding;
					feature.height = image.height + 2 * _padding;
					// 数据库中的点作为对象中心点(不是左上点)
					var point:Point = topoLayer.xyToLocal(feature, node.x, node.y);
					feature.x = point.x - feature.width / 2;
					feature.y = point.y - feature.height / 2;

					afterDrawIcon(feature, node, topoLayer, topoCanvas);

					// 派发创建完成事件
					creationComplete(feature, true);
				});
		}

		/**
		 * 图标画完之后
		 * @param feature
		 * @param node
		 * @param topoCanvas
		 *
		 */
		protected function afterDrawIcon(feature:Feature, node:INode, topoLayer:TopoLayer, topoCanvas:TopoCanvas):void
		{
			drawLabel(feature, node, node.name,false,false);
//			log.info("afterDrawIcon");
//			log.info("node.name = "+node.name);
//			//log.info(node); 
			drawExtendComponents(feature);
			refreshAlarm(feature, node, topoLayer, topoCanvas);
		}

	}
}