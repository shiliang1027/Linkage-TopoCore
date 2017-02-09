package com.linkage.module.topo.framework.view.component.spareparts
{
	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	import flash.display.GradientType;
	import flash.display.InterpolationMethod;
	import flash.display.SpreadMethod;

	import mx.controls.Text;

	public class BubbleText extends Text
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.view.component.spareparts.BubbleText");

		// 文本和边框直接的距离
		private var _textPaddingTop:Number = 2;
		private var _textPaddingBottom:Number = 2;
		private var _textPaddingLeft:Number = 8;
		private var _textPaddingRight:Number = 8;
		// 气泡的方向角度
		private var _direction:String = "righttop";
		// 最小的宽度
		private var _minWidth:Number = 15;
		// 箭头距离最近边界的距离
		private var _arrowPadding:Number = 8;
		// 箭头的宽度
		private var _arrowWidth:Number = 10;
		// 箭头的高度
		private var _arrowHeight:Number = 10;

		public function BubbleText()
		{
			super();
			visible = false;
			includeInLayout = false;
		}

		/**
		 * 气泡的方向,分为 左上,左下,右上,右下 四个方向角度
		 */
		[Inspectable(category="General", enumeration="lefttop,leftbottom,righttop,rightbottom", defaultValue="righttop")]
		public function get direction():String
		{
			return _direction;
		}

		/**
		 * @private
		 */
		public function set direction(value:String):void
		{
			_direction = value;
		}

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);

			var isTop:Boolean = true;
			var isLeft:Boolean = true;
			switch (_direction)
			{
				case "lefttop":
					isTop = true;
					isLeft = true;
					break;
				case "leftbottom":
					isTop = false;
					isLeft = true;
					break;
				case "rightbottom":
					isTop = false;
					isLeft = false;
					break;
				case "righttop":
				default:
					isTop = true;
					isLeft = false;
					break;
			}

			// 抽取样式
			var bgColor:uint = getStyle('backgroundColor');
			var bgAlpha:Number = getStyle('backgroundAlpha');
			var bdColor:uint = getStyle('borderColor');
			var bdWidth:Number = getStyle('borderWidth');
			var bdAlpha:Number = getStyle('borderAlpha');

//			log.error("isTop = " + isTop + " isLeft = " + isLeft);
//			log.warn("this(" + x + "," + y + ")w:" + width + " h:" + height + "  textField(" + textField.x + "," + textField.y + ")w:" + textField.width + " h:" + textField.height + " text=" + textField.
//				text + " textWidth:" + textField.textWidth + " textHeight:" + textField.textHeight);
//			log.warn("bgColor=" + bgColor + " bgAlpha=" + bgAlpha + " bdColor=" + bdColor + " bdWidth=" + bdWidth + " bdAlpha=" + bdAlpha);

			// 文本区域
			textField.width = textField.textWidth + 10; // 防止换行
			textField.height = textField.textHeight;
			if (textField.width < _minWidth)
			{
				textField.width = _minWidth;
			}
			textField.x = textField.x + (isLeft ? -(textField.width + _textPaddingRight) : _textPaddingLeft);
			textField.y = textField.y + (isTop ? -(textField.height + _textPaddingBottom + _arrowHeight) : _textPaddingTop + _arrowHeight);
			this.width = textField.width + _textPaddingLeft + _textPaddingRight;

			// 一些坐标属性
			var calHeight:Number = textField.height + _textPaddingTop + _textPaddingBottom;
			var calWidth:Number = textField.width + _textPaddingLeft + _textPaddingRight;
			var bodyX:Number = -3 + (isLeft ? -(textField.width + _textPaddingLeft + _textPaddingRight) : 0);
			var bodyY:Number = isTop ? -(textField.height + _textPaddingTop + _textPaddingBottom + _arrowHeight) : _arrowHeight;
			var arrowPoint1X:Number = isLeft ? -_arrowPadding : _arrowPadding;
			var arrowPoint2X:Number = arrowPoint1X + (isLeft ? -_arrowWidth : _arrowWidth);
			var arrowPointY:Number = isTop ? -_arrowHeight : _arrowHeight;

			// 绘制主体区域
			this.graphics.clear();
			this.graphics.beginFill(bgColor, bgAlpha);
//			this.graphics.beginGradientFill(GradientType.RADIAL, [bgColor, 0xffffff, bgColor], [1, 0.6, 1], [60, 120, 180], null, SpreadMethod.PAD, InterpolationMethod.RGB, 0);
			this.graphics.lineStyle(bdWidth, bdColor, bdAlpha);
			this.graphics.drawRoundRect(bodyX, bodyY, calWidth, calHeight, 12, 12);
			// 绘制箭头区域
			this.graphics.moveTo(arrowPoint1X, arrowPointY);
			this.graphics.lineTo(0, 0);
			this.graphics.lineTo(arrowPoint2X, arrowPointY);
			this.graphics.endFill();
		}
	}
}