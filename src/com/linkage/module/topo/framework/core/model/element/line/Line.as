package com.linkage.module.topo.framework.core.model.element.line
{
	import com.linkage.module.topo.framework.core.model.element.Element;
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.parser.ElementProperties;
	import com.linkage.system.utils.StringUtils;

	import flash.errors.IllegalOperationError;

	public class Line extends Element implements ILine
	{
		public function Line()
		{
			super();
		}

		override public function get weight():uint
		{
			throw new IllegalOperationError("Line.weight has not been implemented by subclass.");
		}

		override public function get itemName():String
		{
			throw new IllegalOperationError("Line.itemName has not been implemented by subclass.");
		}

		public function get lineToolTip():String
		{
			return StringUtils.isEmpty(getExtendProperty(ElementProperties.LINE_TOOLTIP)) ? ElementProperties.DEFAULT_LINE_TOOLTIP : getExtendProperty(ElementProperties.LINE_TOOLTIP);
		}

		public function set lineToolTip(value:String):void
		{
			this.addExtendProperty(ElementProperties.LINE_TOOLTIP, value);
		}

		public function get lineColor():uint
		{
			return StringUtils.isEmpty(getExtendProperty(ElementProperties.LINE_COLOR)) ? ElementProperties.DEFAULT_LINE_COLOR : uint(getExtendProperty(ElementProperties.LINE_COLOR));
		}

		public function set lineColor(value:uint):void
		{
			this.addExtendProperty(ElementProperties.LINE_COLOR, String(value));
		}

		public function get lineWidth():Number
		{
			return StringUtils.isEmpty(getExtendProperty(ElementProperties.LINE_WIDTH)) ? ElementProperties.DEFAULT_LINE_WIDTH : Number(getExtendProperty(ElementProperties.LINE_WIDTH));
		}

		public function set lineWidth(value:Number):void
		{
			this.addExtendProperty(ElementProperties.LINE_WIDTH, String(value));
		}

		public function get lineAlpha():Number
		{
			return StringUtils.isEmpty(getExtendProperty(ElementProperties.LINE_ALPHA)) ? ElementProperties.DEFAULT_LINE_ALPHA : Number(getExtendProperty(ElementProperties.LINE_ALPHA));
		}

		public function set lineAlpha(value:Number):void
		{
			this.addExtendProperty(ElementProperties.LINE_ALPHA, String(value));
		}

		public function get lineSymbol():String
		{
			return StringUtils.isEmpty(getExtendProperty(ElementProperties.LINE_SYMBOL)) ? ElementProperties.DEFAULT_LINE_SYMBOL : getExtendProperty(ElementProperties.LINE_SYMBOL);
		}

		public function set lineSymbol(value:String):void
		{
			this.addExtendProperty(ElementProperties.LINE_SYMBOL, value);
		}

		public function get lineType():String
		{
			return StringUtils.isEmpty(getExtendProperty(ElementProperties.LINE_TYPE)) ? ElementProperties.DEFAULT_LINE_TYPE : getExtendProperty(ElementProperties.LINE_TYPE);
		}

		public function set lineType(value:String):void
		{
			this.addExtendProperty(ElementProperties.LINE_TYPE, value);
		}

		override public function copyFrom(element:IElement):void
		{
			super.copyFrom(element);
			var line:ILine = element as ILine;
			lineColor = line.lineColor;
			lineWidth = line.lineWidth;
			lineAlpha = line.lineAlpha;
			lineSymbol = line.lineSymbol;
			lineType = line.lineType;
		}

		override public function destroy():void
		{
			super.destroy();
		}

		override public function toString():String
		{
			return "Line(" + id + ": " + name + " / " + type + ")";
		}
	}
}