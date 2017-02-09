package com.linkage.module.topo.framework.core.style.element.plane
{
	import com.linkage.module.topo.framework.core.Feature;
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.model.element.plane.ITPShape;
	import com.linkage.module.topo.framework.core.parser.ElementProperties;
	import com.linkage.module.topo.framework.core.style.element.plane.shapemarket.ShapeMaket;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;
	import com.linkage.module.topo.framework.view.component.TopoLayer;
	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.SpreadMethod;
	import flash.filters.BitmapFilterQuality;
	import flash.geom.Matrix;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;

	import mx.controls.Image;
	import mx.core.UIComponent;

	import spark.components.Group;
	import spark.filters.DropShadowFilter;

	/**
	 * 形状样式
	 * @author duangr
	 *
	 */
	public class ShapeStyle extends PlaneStyle
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.core.style.element.plane.ShapeStyle");

		// 形状超市
		private var _shapeMaket:ShapeMaket = ShapeMaket.getInstance();
		// 填充图标的上下文
		private var _fillImageContext:String = null;

		public function ShapeStyle(imageContext:String, fillImageContext:String)
		{
			super(imageContext);
			_fillImageContext = fillImageContext;
		}

		override public function draw(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):void
		{
			feature.visible = beforeDraw(feature, element, topoLayer, topoCanvas, attributes);
			if (feature.visible)
			{
				initDeepth(feature, element, topoLayer, topoCanvas);
				var shape:ITPShape = element as ITPShape;

				revisePlaneXY(feature, shape, topoLayer, topoCanvas);
				drawShapeWithStyle(feature, shape, topoLayer, topoCanvas);

			}
		}

		override public function select(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):void
		{

		}

		override public function unSelect(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):void
		{

		}

		/**
		 * 画带样式的形状<br/>
		 * 实际上Feature里面存在一个Group对象, 阴影效果,旋转,视角的处理都是对这个Group对象的处理.
		 *
		 * @param feature
		 * @param shape
		 * @param topoLayer
		 * @param topoCanvas
		 * @return
		 *
		 */
		protected function drawShapeWithStyle(feature:Feature, shape:ITPShape, topoLayer:TopoLayer, topoCanvas:TopoCanvas):void
		{
			var container:Group = new Group();
			// 内置的UI对象,禁用鼠标事件 (TODO:此处对分组是否有影响?)
			container.mouseEnabled = false;
			container.mouseChildren = false;
			container.x = container.y = 0;
			container.width = feature.width;
			container.height = feature.height;
			feature.addElement(container);

			drawShapeWithStyleGraphics(container, feature, shape, topoLayer, topoCanvas);

			if (shape.shadowEnable == 1)
			{
				// 画阴影效果
				drawShadow(container, shape);
			}

			// ---- 偏移成对应形状 ----
			initProjectionCenter(feature);
			clearRotateShape(container);
			rotateShape(container, shape);

			// 画完形状之后
			afterDrawShape(feature, shape, topoLayer, topoCanvas);
		}

		/**
		 * 设置透视角度
		 * @param ui
		 *
		 */
		protected function initProjectionCenter(ui:UIComponent):void
		{
			var pp:PerspectiveProjection = new PerspectiveProjection();
			pp.fieldOfView = 45;
			pp.projectionCenter = new Point(ui.width / 2, ui.height / 2);
			ui.transform.perspectiveProjection = pp;
		}

		/**
		 * 清理之前的转换
		 * @param ui
		 *
		 */
		protected function clearRotateShape(ui:UIComponent):void
		{
			ui.rotationX = 0;
			ui.transform.matrix = new Matrix();
		}

		/**
		 * 画具体的显示形状(默认画矩形,可重写)
		 * @param g
		 *
		 */
		protected function drawShape(g:Graphics, feature:Feature, shape:ITPShape):void
		{
			_shapeMaket.buildShapeStyle(shape).drawShape(g, feature, shape);
		}

		/**
		 * 旋转已形成形状
		 * @param ui
		 *
		 */
		protected function rotateShape(ui:UIComponent, shape:ITPShape):void
		{
			_shapeMaket.buildShapeStyle(shape).rotateShape(ui, shape);
		}

		/**
		 * 画阴影
		 * @param ui
		 * @param shape
		 *
		 */
		protected function drawShadow(ui:UIComponent, shape:ITPShape):void
		{
			var angle:Number = 90;
			if (shape.shapeType == ElementProperties.PROPERTYVALUE_SHAPE_TYPE_TRAPEZIUM)
			{
				// 如果是梯形,上小下大,阴影的光线反过来
				if (shape.parallelogramAngle < 0)
				{
					angle = -angle;
				}
			}
			ui.filters = [new DropShadowFilter(3, angle, shape.borderColor, shape.borderAlpha, 5, 5, 20, BitmapFilterQuality.MEDIUM)];
		}

		/**
		 * 使用画笔画带样式的形状(可重写)
		 * @param ui  画笔所在的ui对象
		 * @param feature
		 * @param shape
		 *
		 */
		protected function drawShapeWithStyleGraphics(ui:Group, feature:Feature, shape:ITPShape, topoLayer:TopoLayer, topoCanvas:TopoCanvas):void
		{
			var g:Graphics = ui.graphics;
			g.clear();
			// 样式
			var fillType:String = GradientType.LINEAR;
			var colors:Array = [shape.fillColorStart, shape.fillColorEnd];
			var alphas:Array = [shape.fillAlpha, shape.fillAlpha];
			var ratios:Array = [0, 255];
			var matr:Matrix = new Matrix();
			matr.createGradientBox(200, 200, Math.PI / 4, 50, 50);
			var spreadMethod:String = SpreadMethod.REFLECT;

			g.lineStyle(shape.borderWidth, shape.borderColor, shape.borderAlpha);
			// 判断是填充图片还是渐变色
			switch (shape.fillType)
			{
				case ElementProperties.PROPERTYVALUE_SHAPE_FILL_TYPE_IMAGE:
					// 填充图片
					_imageBuffer.loadBitmapData(_fillImageContext + "/" + shape.fillImage, function(bitmapData:BitmapData, width:Number, height:Number):void
						{
							g.beginBitmapFill(bitmapData);
							drawShape(g, feature, shape);
							g.endFill();
							creationComplete(feature);
						});
					break;
				case ElementProperties.PROPERTYVALUE_SHAPE_FILL_TYPE_FULLIMAGE:
					// 图片按比例缩放
					_imageBuffer.loadBitmapData(_fillImageContext + "/" + shape.fillImage, function(bitmapData:BitmapData, width:Number, height:Number):void
						{
							var image:Image = new Image();
							image.source = new Bitmap(bitmapData);
							// 缩放的图片,禁止其响应鼠标事件
							image.mouseEnabled = false;
							image.width = width;
							image.height = height;
							image.scaleX = ui.width / width;
							image.scaleY = ui.height / height;
							ui.addElement(image);

							creationComplete(feature);
						});
					break;
				case ElementProperties.PROPERTYVALUE_SHAPE_FILL_TYPE_COLOR:
				default:
					// 渐变色
					g.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);
					drawShape(g, feature, shape);
					g.endFill();
					creationComplete(feature);
					break;
			}
		}

		/**
		 * 画完形状之后
		 * @param feature
		 * @param shape
		 * @param topoCanvas
		 *
		 */
		protected function afterDrawShape(feature:Feature, shape:ITPShape, topoLayer:TopoLayer, topoCanvas:TopoCanvas):void
		{
			drawLabel(feature, shape, shape.name,false,false);
		}

	}
}