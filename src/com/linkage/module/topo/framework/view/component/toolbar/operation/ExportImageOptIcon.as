package com.linkage.module.topo.framework.view.component.toolbar.operation
{
	import com.linkage.module.topo.framework.util.MessageUtil;

	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.net.FileReference;
	import flash.utils.getDefinitionByName;

	import mx.core.ClassFactory;
	import mx.core.UIComponent;
	import mx.formatters.DateFormatter;
	import mx.graphics.codec.PNGEncoder;
	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	import spark.components.SkinnableContainer;

	/**
	 * 导出图片  图标类
	 * @author duangr
	 *
	 */
	public class ExportImageOptIcon extends TopoOptIcon
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.view.component.toolbar.operation.ExportImageOptIcon");
		// PNG编码转换
		private var _encoder:PNGEncoder = new PNGEncoder();
		// 日期格式化
		private var _formatter:DateFormatter = new DateFormatter();

		// 导出图片功能,具有背景样式的温床
		private var _hotbed:SkinnableContainer = null;
		// 拓扑画布的内容绘制容器
		private var _bgShape:UIComponent = null;


		public function ExportImageOptIcon()
		{
			super();
			this.toolTip = "导出图片";
			authKey = "ExportImage";
			_formatter.formatString = "YYYY-MM-DD";

			_hotbed = new SkinnableContainer();
			_hotbed.styleName = "background";
			_hotbed.visible = false;
			_hotbed.includeInLayout = false;

			_bgShape = new UIComponent();
			
			//设置背景颜色
			_hotbed.setStyle("backgroundColor",0x0B4C72);
//			_hotbed.setStyle("backgroundColor","#7FFFD4");
			_hotbed.addElement(_bgShape);
		}


		override protected function onMouseClick(event:MouseEvent):void
		{
			var fr:Object = new FileReference();

			if (fr.hasOwnProperty("save"))
			{
				fr.save(_encoder.encode(findBitmapData()), _topoCanvas.topoViewName + "(" + _formatter.format(new Date()) + ").png");
			}
			else
			{
				MessageUtil.showMessage("请安装Flash Player 10或以上版本运行");
			}

		}

		/**
		 * 找到需要导出的位图数据
		 * @return
		 *
		 */
		private function findBitmapData():BitmapData
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
			var exportData:BitmapData = new BitmapData(bitmapData.width, bitmapData.height, true, 0);
			exportData.draw(_hotbed);
			// 导出后,再移除
			this.parentApplication.removeElement(_hotbed);
			_bgShape.graphics.clear();
			return exportData;
		}
	}
}