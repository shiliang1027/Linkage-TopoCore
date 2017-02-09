package com.linkage.module.topo.framework.core.style.element.plane.shapemarket
{
	import com.linkage.module.topo.framework.core.model.element.plane.ITPShape;
	import com.linkage.module.topo.framework.core.parser.ElementProperties;

	/**
	 * 形状超市
	 * @author duangr
	 *
	 */
	public class ShapeMaket
	{
		// 矩形形状
		private var _rectangleStyle:IShapeStyle = new RectangleShapeStyle();
		// 平行四边形形状
		private var _parallelogramStyle:IShapeStyle = new ParallelogramShapeStyle();
		// 圆形
		private var _circleStyle:IShapeStyle = new CircleShapeStyle();
		// 椭圆
		private var _ellipseStyle:IShapeStyle = new EllipseShapeStyle();
		// 梯形
		private var _trapeziumStyle:IShapeStyle = new TrapeziumShapeStyle();


		// 单件实例
		private static var _instance:ShapeMaket = null;

		public function ShapeMaket(pvt:_PrivateClass)
		{
			if (pvt == null)
			{
				throw new ArgumentError("MatrixBuffer构造时,参数[pvt:_PrivateClass]不能为null!");
			}
		}

		/**
		 * 获取单件实例
		 * @return
		 *
		 */
		public static function getInstance():ShapeMaket
		{
			if (_instance == null)
			{
				_instance = new ShapeMaket(new _PrivateClass());
			}
			return _instance;
		}

		/**
		 * 构造形状对应的形状样式
		 * @param shape
		 * @return
		 *
		 */
		public function buildShapeStyle(shape:ITPShape):IShapeStyle
		{
			var style:IShapeStyle = null;
			switch (shape.shapeType)
			{
				case ElementProperties.PROPERTYVALUE_SHAPE_TYPE_PARALLELOGRAM: // 平行四边形
					style = _parallelogramStyle;
					break;
				case ElementProperties.PROPERTYVALUE_SHAPE_TYPE_CIRCLE: // 圆形
					style = _circleStyle;
					break;
				case ElementProperties.PROPERTYVALUE_SHAPE_TYPE_ELLIPSE: // 椭圆
					style = _ellipseStyle;
					break;
				case ElementProperties.PROPERTYVALUE_SHAPE_TYPE_TRAPEZIUM: // 梯形
					style = _trapeziumStyle;
					break;
				case ElementProperties.PROPERTYVALUE_SHAPE_TYPE_RECTANGLE: //矩形
				default:
					style = _rectangleStyle;
					break;
			}
			return style;
		}

	}
}

class _PrivateClass
{
	public function _PrivateClass()
	{

	}
}