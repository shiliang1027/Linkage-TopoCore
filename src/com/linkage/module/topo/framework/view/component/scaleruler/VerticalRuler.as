package com.linkage.module.topo.framework.view.component.scaleruler
{
	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;
	import com.linkage.system.utils.UnitUtil;

	import flash.display.LineScaleMode;

	import mx.graphics.SolidColorStroke;

	import spark.components.Group;
	import spark.components.Label;
	import spark.primitives.Line;


	/**
	 * 纵向标尺
	 * @author duangr
	 *
	 */
	public class VerticalRuler extends Group
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.view.component.scaleruler.VerticalRuler");
		private var _lastWidth:Number = 0;
		private var _lastHeight:Number = 0;

		// 纵向标尺线
		private var _verticalTrunkLine:Line;
		//纵向标尺长度
		private var _verticalLength:Number = 10000;
		// 纵向标尺宽度
		private var _verticalWidth:Number = 25;
		// 是否首次创建完成
		private var _creationComplete:Boolean = false;
		// 刻度尺的步长
		private var _scaleStep:int = 10;
		// 刻度尺单位
		private var _uint:String = "px";

		public function VerticalRuler()
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
			_verticalTrunkLine = new Line();
			_verticalTrunkLine.stroke = new SolidColorStroke(color, 1, 1, false, LineScaleMode.NONE);

			_verticalTrunkLine.xFrom = _verticalWidth;
			_verticalTrunkLine.yFrom = 0;
			_verticalTrunkLine.xTo = _verticalTrunkLine.xFrom;
			_verticalTrunkLine.yTo = _verticalTrunkLine.yFrom + _verticalLength;
			this.addElement(_verticalTrunkLine);

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
			for (var j:Number = 0; j < _verticalLength / _scaleStep; j++)
			{
				var _xSpacing:Number = 5;
				var _lineV:Line = new Line();
				_lineV.stroke = new SolidColorStroke(color, 1, 1, false, LineScaleMode.NONE);
				if (j % 10 == 0)
				{
					_xSpacing = 20;
					var _labelV:Label = new Label();
					_labelV.text = String(j * _scaleStep);
					_labelV.toolTip = _labelV.text;
					_labelV.x = (_verticalTrunkLine.xFrom - _xSpacing) * 3;
					_labelV.y = j * _scaleStep + _verticalTrunkLine.yFrom;
					_labelV.rotation = 90;
					this.addElement(_labelV);
				}
				else if (j % 5 == 0)
				{
					_xSpacing = 10;
				}
				_lineV.xFrom = _verticalTrunkLine.xFrom - _xSpacing;
				_lineV.yFrom = j * _scaleStep + _verticalTrunkLine.yFrom;
				_lineV.xTo = _verticalWidth;
				_lineV.yTo = j * _scaleStep + _verticalTrunkLine.yFrom;
				this.addElement(_lineV);
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
			for (var j:Number = 0; j < _verticalLength / steppx; j++)
			{
				var _xSpacing:Number = 5;
				var _lineV:Line = new Line();
				_lineV.stroke = new SolidColorStroke(color, 1, 1, false, LineScaleMode.NONE);
				if (j % 10 == 0)
				{
					_xSpacing = 20;
					var _labelV:Label = new Label();
					_labelV.text = String(j * _scaleStep);
					_labelV.toolTip = _labelV.text;
					_labelV.x = (_verticalTrunkLine.xFrom - _xSpacing) * 3;
					_labelV.y = j * steppx + _verticalTrunkLine.yFrom;
					_labelV.rotation = 90;
					this.addElement(_labelV);
				}
				else if (j % 5 == 0)
				{
					_xSpacing = 10;
					var _labelV2:Label = new Label();
					_labelV2.text = String(j * _scaleStep);
					_labelV2.toolTip = _labelV2.text;
					_labelV2.x = (_verticalTrunkLine.xFrom - 20) * 3;
					_labelV2.y = j * steppx + _verticalTrunkLine.yFrom;
					_labelV2.rotation = 90;
					this.addElement(_labelV2);
				}
				_lineV.xFrom = _verticalTrunkLine.xFrom - _xSpacing;
				_lineV.yFrom = j * steppx + _verticalTrunkLine.yFrom;
				_lineV.xTo = _verticalWidth;
				_lineV.yTo = j * steppx + _verticalTrunkLine.yFrom;
				this.addElement(_lineV);
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
			for (var j:Number = 0; j < _verticalLength / steppx; j++)
			{
				var _xSpacing:Number = 5;
				var _lineV:Line = new Line();
				_lineV.stroke = new SolidColorStroke(color, 1, 1, false, LineScaleMode.NONE);
				if (j % 10 == 0)
				{
					_xSpacing = 20;
					var _labelV:Label = new Label();
					_labelV.text = String(j * _scaleStep);
					_labelV.toolTip = _labelV.text;
					_labelV.x = (_verticalTrunkLine.xFrom - _xSpacing) * 3;
					_labelV.y = j * steppx + _verticalTrunkLine.yFrom;
					_labelV.rotation = 90;
					this.addElement(_labelV);
				}
				else if (j % 5 == 0)
				{
					_xSpacing = 10;
					var _labelV2:Label = new Label();
					_labelV2.text = String(j * _scaleStep);
					_labelV2.toolTip = _labelV2.text;
					_labelV2.x = (_verticalTrunkLine.xFrom - 20) * 3;
					_labelV2.y = j * steppx + _verticalTrunkLine.yFrom;
					_labelV2.rotation = 90;
					this.addElement(_labelV2);
				}
				_lineV.xFrom = _verticalTrunkLine.xFrom - _xSpacing;
				_lineV.yFrom = j * steppx + _verticalTrunkLine.yFrom;
				_lineV.xTo = _verticalWidth;
				_lineV.yTo = j * steppx + _verticalTrunkLine.yFrom;
				this.addElement(_lineV);
			}
		}
	}
}