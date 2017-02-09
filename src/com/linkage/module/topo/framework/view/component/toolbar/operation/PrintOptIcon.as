package com.linkage.module.topo.framework.view.component.toolbar.operation
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;

	import mx.core.IUIComponent;
	import mx.core.UIComponent;
	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;
	import mx.printing.FlexPrintJob;
	import mx.printing.FlexPrintJobScaleType;

	import spark.components.SkinnableContainer;

	/**
	 * 打印 图标类
	 * @author duangr
	 *
	 */
	public class PrintOptIcon extends TopoOptIcon
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.view.component.toolbar.operation.PrintOptIcon");

		// 导出图片功能,具有背景样式的温床
		private var _hotbed:SkinnableContainer = null;
		// 拓扑画布的内容绘制容器
		private var _bgShape:UIComponent = null;

		public function PrintOptIcon()
		{
			super();
			this.toolTip = "打印";
			authKey = "Print";

			_hotbed = new SkinnableContainer();
			_hotbed.styleName = "background";
			_hotbed.visible = false;
			_hotbed.includeInLayout = false;

			_bgShape = new UIComponent();
			_hotbed.setStyle("backgroundColor",0x0B4C72);
//			_hotbed.setStyle("backgroundColor","#7FFFD4");
			_hotbed.addElement(_bgShape);
		}

		override protected function onMouseClick(event:MouseEvent):void
		{
			var job:FlexPrintJob = new FlexPrintJob();
			job.printAsBitmap = true;
			if (job.start())
			{

				var bitmapData:BitmapData = _topoCanvas.exportAllCanvasAsBitmapData();

				// 绘制拓扑背景
				_bgShape.graphics.clear();
				_bgShape.graphics.beginBitmapFill(bitmapData);
				_bgShape.graphics.drawRect(0, 0, bitmapData.width, bitmapData.height);
				_bgShape.graphics.endFill();
				_bgShape.validateNow();

				_hotbed.width = bitmapData.width;
				_hotbed.height = bitmapData.height;

				// 导出前,先放入
				this.parentApplication.addElement(_hotbed);
				_hotbed.validateNow();

				job.addObject(_hotbed, FlexPrintJobScaleType.SHOW_ALL);
				job.send();

				// 导出后,再移除
				this.parentApplication.removeElement(_hotbed);
				_bgShape.graphics.clear();
			}
		}

	}
}