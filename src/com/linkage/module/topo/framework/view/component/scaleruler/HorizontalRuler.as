package com.linkage.module.topo.framework.view.component.scaleruler
{
	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;
	import com.linkage.system.utils.UnitUtil;

	import flash.display.LineScaleMode;

	import mx.graphics.SolidColorStroke;

	import spark.components.Group;
	import spark.components.Label;
	import spark.effects.Resize;
	import spark.primitives.Line;

	/**
	 * 横向标尺
	 * @author duangr
	 *
	 */
	public class HorizontalRuler extends Group
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.view.component.scaleruler.HorizontalRuler");
		private var _lastWidth:Number = 0;
		private var _lastHeight:Number = 0;

		// 横向标尺线
		private var _horizontalTrunkLine:Line;
		// 横向标尺长度
		private var _horizontalLength:Number = 10000;
		// 横向标尺高度
		private var _horizontalHeight:Number = 25;
		// 是否首次创建完成
		private var _creationComplete:Boolean = false;
		// 刻度尺的步长
		private var _scaleStep:int = 10;
		// 刻度尺单位
		private var _uint:String = "px";

		public function HorizontalRuler()
		{
			super();
			this.clipAndEnableScrolling = true;
		}

		[Inspectable(category="General", enumeration="px,mm,cm", defaultValue="px")]
		public function set unit(value:String):void
		{
			_uint = value;
		}

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if (!_creationComplete)
			{
				initRuler();
				_creationComplete = true;
			}
		}

		/**
		 * 初始化标尺
		 *
		 */
		private function initRuler():void
		{
			var color:uint = getStyle("color");
			_horizontalTrunkLine = new Line();
			_horizontalTrunkLine.stroke = new SolidColorStroke(color, 1, 1, false, LineScaleMode.NONE);

			_horizontalTrunkLine.xFrom = 0;
			_horizontalTrunkLine.yFrom = _horizontalHeight;
			_horizontalTrunkLine.xTo = _horizontalTrunkLine.xFrom + _horizontalLength;
			_horizontalTrunkLine.yTo = _horizontalTrunkLine.yFrom;
			this.addElement(_horizontalTrunkLine);

			switch (_uint)
			{
				case "mm":
					drawByMM();
					break;
				case "cm":
					drawByCM();
					break;
				case "px":
				default:
					drawByPx();
			}
		}

		/**
		 * 按像素来绘制
		 *
		 */
		private function drawByPx():void
		{
			// 步长=10px
			_scaleStep = 10;
			var color:uint = getStyle("color");
			for (var i:Number = 0; i < _horizontalLength / _scaleStep; i++)
			{
				var _line:Line = new Line();
				var _ySpacing:Number = 5;
				_line.stroke = new SolidColorStroke(color, 1, 1, false, LineScaleMode.NONE);
				_line.xFrom = i * _scaleStep + _horizontalTrunkLine.xFrom;
				_line.yFrom = _horizontalTrunkLine.yFrom;
				_line.xTo = _line.xFrom;
				if (i % 10 == 0)
				{
					_ySpacing = 20;
					var _label:Label = new Label();
					_label.text = String(i * _scaleStep);
					_label.toolTip = _label.text;
					_label.x = i * _scaleStep + _horizontalTrunkLine.xFrom + 1;
					_label.y = _horizontalTrunkLine.yFrom - _ySpacing;
					this.addElement(_label);

				}
				else if (i % 5 == 0)
				{
					_ySpacing = 10;
				}
				_line.yTo = _horizontalTrunkLine.yFrom - _ySpacing;
				this.addElement(_line);
			}

		}

		/**
		 * 按毫米来绘制
		 *
		 */
		private function drawByMM():void
		{
			// 步长=10mm
			_scaleStep = 10;
			var color:uint = getStyle("color");
			var mm2px:Number = UnitUtil.mm2px(1);
			var steppx:Number = _scaleStep * mm2px;
			for (var i:Number = 0; i < _horizontalLength / steppx; i++)
			{
				var _line:Line = new Line();
				var _ySpacing:Number = 5;
				_line.stroke = new SolidColorStroke(color, 1, 1, false, LineScaleMode.NONE);
				_line.xFrom = i * steppx + _horizontalTrunkLine.xFrom;
				_line.yFrom = _horizontalTrunkLine.yFrom;
				_line.xTo = _line.xFrom;
				if (i % 10 == 0)
				{
					_ySpacing = 20;
					var _label:Label = new Label();
					_label.text = String(i * _scaleStep);
					_label.toolTip = _label.text;
					_label.x = i * steppx + _horizontalTrunkLine.xFrom + 1;
					_label.y = _horizontalTrunkLine.yFrom - _ySpacing;
					this.addElement(_label);

				}
				else if (i % 5 == 0)
				{
					_ySpacing = 10;
					var _label2:Label = new Label();
					_label2.text = String(i * _scaleStep);
					_label2.toolTip = _label2.text;
					_label2.x = i * steppx + _horizontalTrunkLine.xFrom + 1;
					_label2.y = _horizontalTrunkLine.yFrom - 20;
					this.addElement(_label2);
				}
				_line.yTo = _horizontalTrunkLine.yFrom - _ySpacing;
				this.addElement(_line);
			}
		}

		/**
		 * 按厘米来绘制
		 *
		 */
		private function drawByCM():void
		{
			// 步长=1cm
			_scaleStep = 1;
			var color:uint = getStyle("color");
			var cm2px:Number = UnitUtil.mm2px(10);
			var steppx:Number = _scaleStep * cm2px;
			for (var i:Number = 0; i < _horizontalLength / steppx; i++)
			{
				var _line:Line = new Line();
				var _ySpacing:Number = 5;
				_line.stroke = new SolidColorStroke(color, 1, 1, false, LineScaleMode.NONE);
				_line.xFrom = i * steppx + _horizontalTrunkLine.xFrom;
				_line.yFrom = _horizontalTrunkLine.yFrom;
				_line.xTo = _line.xFrom;
				if (i % 10 == 0)
				{
					_ySpacing = 20;
					var _label:Label = new Label();
					_label.text = String(i * _scaleStep);
					_label.toolTip = _label.text;
					_label.x = i * steppx + _horizontalTrunkLine.xFrom + 1;
					_label.y = _horizontalTrunkLine.yFrom - _ySpacing;
					this.addElement(_label);

				}
				else if (i % 5 == 0)
				{
					_ySpacing = 10;
					var _label2:Label = new Label();
					_label2.text = String(i * _scaleStep);
					_label2.toolTip = _label2.text;
					_label2.x = i * steppx + _horizontalTrunkLine.xFrom + 1;
					_label2.y = _horizontalTrunkLine.yFrom - 20;
					this.addElement(_label2);
				}
				_line.yTo = _horizontalTrunkLine.yFrom - _ySpacing;
				this.addElement(_line);
			}
		}
	}
}