package com.linkage.module.topo.framework.core.model.element.plane
{
	import com.linkage.module.topo.framework.Constants;
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.parser.ElementProperties;
	import com.linkage.system.utils.StringUtils;
	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	/**
	 * 拓扑形状对象
	 * @author duangr
	 *
	 */
	public class TPShape extends TPPlane implements ITPShape
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.core.model.element.plane.TPShape");

		public function TPShape()
		{
			super();
			this.type = ElementProperties.PROPERTYVALUE_OBJECT_TYPE_SHAPE;
		}

		public function get shapeType():String
		{
			return StringUtils.isEmpty(getExtendProperty(ElementProperties.SHAPE_TYPE)) ? ElementProperties.DEFAULT_SHAPE_TYPE : getExtendProperty(ElementProperties.SHAPE_TYPE);
		}

		public function set shapeType(value:String):void
		{
			this.addExtendProperty(ElementProperties.SHAPE_TYPE, value);
		}

		public function get parallelogramAngle():Number
		{
			return StringUtils.isEmpty(getExtendProperty(ElementProperties.SHAPE_PARALLELOGRAM_ANGLE)) ? ElementProperties.DEFAULT_SHAPE_PARALLELOGRAM_ANGLE : Number(getExtendProperty(ElementProperties.
				SHAPE_PARALLELOGRAM_ANGLE));
		}

		public function set parallelogramAngle(value:Number):void
		{
			this.addExtendProperty(ElementProperties.SHAPE_PARALLELOGRAM_ANGLE, String(value));
		}

		public function get fillType():String
		{
			return StringUtils.isEmpty(getExtendProperty(ElementProperties.SHAPE_FILL_TYPE)) ? ElementProperties.DEFAULT_SHAPE_FILL_TYPE : getExtendProperty(ElementProperties.SHAPE_FILL_TYPE);
		}

		public function set fillType(value:String):void
		{
			this.addExtendProperty(ElementProperties.SHAPE_FILL_TYPE, value);
		}

		public function get fillColorStart():uint
		{
			return StringUtils.isEmpty(getExtendProperty(ElementProperties.SHAPE_FILL_COLOR_START)) ? ElementProperties.DEFAULT_SHAPE_FILL_COLOR_START : uint(getExtendProperty(ElementProperties.SHAPE_FILL_COLOR_START));
		}

		public function set fillColorStart(value:uint):void
		{
			this.addExtendProperty(ElementProperties.SHAPE_FILL_COLOR_START, String(value));
		}

		public function get fillColorEnd():uint
		{
			return StringUtils.isEmpty(getExtendProperty(ElementProperties.SHAPE_FILL_COLOR_END)) ? ElementProperties.DEFAULT_SHAPE_FILL_COLOR_END : uint(getExtendProperty(ElementProperties.SHAPE_FILL_COLOR_END));
		}

		public function set fillColorEnd(value:uint):void
		{
			this.addExtendProperty(ElementProperties.SHAPE_FILL_COLOR_END, String(value));
		}

		public function get fillImage():String
		{
			return StringUtils.isEmpty(getExtendProperty(ElementProperties.SHAPE_FILL_IMAGE)) ? "" : getExtendProperty(ElementProperties.SHAPE_FILL_IMAGE);
		}

		public function set fillImage(value:String):void
		{
			this.addExtendProperty(ElementProperties.SHAPE_FILL_IMAGE, value);
		}

		public function get fillAlpha():Number
		{
			return StringUtils.isEmpty(getExtendProperty(ElementProperties.SHAPE_FILL_ALPHA)) ? ElementProperties.DEFAULT_SHAPE_FILL_ALPHA : Number(getExtendProperty(ElementProperties.SHAPE_FILL_ALPHA));
		}

		public function set fillAlpha(value:Number):void
		{
			this.addExtendProperty(ElementProperties.SHAPE_FILL_ALPHA, String(value));
		}

		public function get borderColor():uint
		{
			return StringUtils.isEmpty(getExtendProperty(ElementProperties.SHAPE_BORDER_COLOR)) ? ElementProperties.DEFAULT_SHAPE_BORDER_COLOR : uint(getExtendProperty(ElementProperties.SHAPE_BORDER_COLOR));
		}

		public function set borderColor(value:uint):void
		{
			this.addExtendProperty(ElementProperties.SHAPE_BORDER_COLOR, String(value));
		}

		public function get borderWidth():Number
		{
			return StringUtils.isEmpty(getExtendProperty(ElementProperties.SHAPE_BORDER_WIDTH)) ? ElementProperties.DEFAULT_SHAPE_BORDER_WIDTH : Number(getExtendProperty(ElementProperties.SHAPE_BORDER_WIDTH));
		}

		public function set borderWidth(value:Number):void
		{
			this.addExtendProperty(ElementProperties.SHAPE_BORDER_WIDTH, String(value));
		}

		public function get borderAlpha():Number
		{
			return StringUtils.isEmpty(getExtendProperty(ElementProperties.SHAPE_BORDER_ALPHA)) ? ElementProperties.DEFAULT_SHAPE_BORDER_ALPHA : Number(getExtendProperty(ElementProperties.SHAPE_BORDER_ALPHA));
		}

		public function set borderAlpha(value:Number):void
		{
			this.addExtendProperty(ElementProperties.SHAPE_BORDER_ALPHA, String(value));
		}

		public function get shadowEnable():Number
		{
			return StringUtils.isEmpty(getExtendProperty(ElementProperties.SHAPE_SHADOW_ENABLE)) ? ElementProperties.DEFAULT_SHAPE_SHADOW_ENABLE : Number(getExtendProperty(ElementProperties.SHAPE_SHADOW_ENABLE));
		}

		public function set shadowEnable(value:Number):void
		{
			this.addExtendProperty(ElementProperties.SHAPE_SHADOW_ENABLE, String(value));
		}

		override public function get weight():uint
		{
			return Constants.WEIGHT_ELEMENT_SHAPE;
		}

		override public function get itemName():String
		{
			return Constants.ITEM_NAME_TPSHAPE;
		}

		override public function copyFrom(element:IElement):void
		{
			super.copyFrom(element);
			var shape:ITPShape = element as ITPShape;
			shapeType = shape.shapeType;
			parallelogramAngle = shape.parallelogramAngle;
			fillType = shape.fillType;
			fillColorStart = shape.fillColorStart;
			fillColorEnd = shape.fillColorEnd;
			fillImage = shape.fillImage;
			fillAlpha = shape.fillAlpha;
			borderColor = shape.borderColor;
			borderWidth = shape.borderWidth;
			borderAlpha = shape.borderAlpha;
			shadowEnable = shape.shadowEnable;
		}

		override public function toString():String
		{
			return "TPShape(" + id + ": " + name + " : " + shapeType + ")(" + x + ", " + y + ") w:" + width + " h:" + height;
		}
	}
}