package com.linkage.module.topo.framework.core.style.element.plane
{
	import com.linkage.module.topo.framework.Constants;
	import com.linkage.module.topo.framework.core.Feature;
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.model.element.plane.ITPGrid;
	import com.linkage.module.topo.framework.core.model.element.plane.cell.ITPCell;
	import com.linkage.module.topo.framework.core.model.element.plane.cell.TPCell;
	import com.linkage.module.topo.framework.core.parser.ElementProperties;
	import com.linkage.module.topo.framework.util.MathUtil;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;
	import com.linkage.module.topo.framework.view.component.TopoLayer;
	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;
	import com.linkage.system.utils.StringUtils;

	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	import flash.geom.Point;

	import spark.components.Label;

	/**
	 * 网格对象的样式
	 * @author duangr
	 *
	 */
	public class TPGridStyle extends PlaneStyle
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.core.style.element.plane.TPGridStyle");

		public function TPGridStyle(imageContext:String)
		{
			super(imageContext);
		}

		override public function draw(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):void
		{
			feature.visible = beforeDraw(feature, element, topoLayer, topoCanvas, attributes);
			if (feature.visible)
			{
				initDeepth(feature, element, topoLayer, topoCanvas);
				var tpGrid:ITPGrid = element as ITPGrid;

				revisePlaneXY(feature, tpGrid, topoLayer, topoCanvas);

				// 在绘制时构造cell
				generateCells(feature, tpGrid, topoLayer, topoCanvas);
				drawTPGridWithStyle(feature, tpGrid, topoLayer, topoCanvas);

				// 派发创建完成事件
				creationComplete(feature, true);
			}
		}

		override public function select(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):void
		{
			feature.filters = [Constants.DEFAULT_SELECTED_PLANE_FILTER];
		}

		override public function unSelect(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):void
		{
			feature.filters.length = 0;
			feature.filters = null;
		}

		/**
		 * 画带样式的网格对象
		 *
		 * @param feature
		 * @param tpGrid
		 * @param topoLayer
		 * @param topoCanvas
		 *
		 */
		private function drawTPGridWithStyle(feature:Feature, tpGrid:ITPGrid, topoLayer:TopoLayer, topoCanvas:TopoCanvas):void
		{
			var fillType:String = GradientType.LINEAR;
			var colors:Array = [tpGrid.cellFillColorStart, tpGrid.cellFillColorEnd];
			var alphas:Array = [tpGrid.cellFillAlpha, tpGrid.cellFillAlpha];
			var ratios:Array = [0, 255];
			var matr:Matrix = new Matrix();
			matr.createGradientBox(200, 200, Math.PI / 4, 50, 50);
			var spreadMethod:String = SpreadMethod.REFLECT;

			var g:Graphics = feature.graphics;
			g.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);
			g.lineStyle(tpGrid.borderWidth, tpGrid.borderColor, 0);
			// 先绘制整体的边框里面的填充
			g.drawRect(0, 0, feature.width, feature.height);

			g.lineStyle(tpGrid.borderWidth, tpGrid.borderColor, tpGrid.borderAlpha);

			// 绘制边框和内部的分割线
			switch (tpGrid.borderSymbol)
			{
				case ElementProperties.PROPERTYVALUE_LINE_SYMBOL_DASH:
					drawBorderAndSplitsDash(g, feature, tpGrid, topoLayer, topoCanvas);
					break;
				case ElementProperties.PROPERTYVALUE_LINE_SYMBOL_SOLID:
				default:
					drawBorderAndSplitsSolid(g, feature, tpGrid, topoLayer, topoCanvas);
					break;
			}
			g.endFill();

			// 更换画笔的样式,绘制行的label框,并填写序号
			g.lineStyle(tpGrid.borderWidth, tpGrid.borderColor, tpGrid.rowLabelBorderAlpha);
			g.beginFill(tpGrid.rowLabelFillColor, tpGrid.rowLabelFillAlpha);
			drawRowLabelRect(g, feature, tpGrid, topoLayer, topoCanvas);
			g.endFill();

			// 更换画笔的样式,绘制列的label框,并填写序号
			g.lineStyle(tpGrid.borderWidth, tpGrid.borderColor, tpGrid.columnLabelBorderAlpha);
			g.beginFill(tpGrid.columnLabelFillColor, tpGrid.columnLabelFillAlpha);
			drawColumnLabelRect(g, feature, tpGrid, topoLayer, topoCanvas);
			g.endFill();

		}

		/**
		 * 创建Grid中的cell对象
		 *
		 * @param feature
		 * @param tpGrid
		 * @param topoLayer
		 * @param topoCanvas
		 *
		 */
		private function generateCells(feature:Feature, tpGrid:ITPGrid, topoLayer:TopoLayer, topoCanvas:TopoCanvas):void
		{
			// 行的计数器
			var r:int, percent_r:Number, lastPercent_r:Number;
			// 列的计数器
			var c:int, percent_c:Number, lastPercent_c:Number;
			// cell的宽和高
			var cell_w:Number, cell_h:Number;
			// cell左上角的坐标
			var cell_x:Number, cell_y:Number;
			// grid的宽和高
			var grid_w:Number = feature.width;
			var grid_h:Number = feature.height;

			tpGrid.clearCells();

			// 左上角点转换为相对画布中的坐标
			var canvasP:Point = topoLayer.localToLayer(feature);
			// 再次修正为相对数据库中的坐标
			var dbP:Point = topoLayer.globalToXY(canvasP.x, canvasP.y);

			// 先遍历行,再遍历列
			var rowNum:int = tpGrid.rowCount;
			var rowPercents:Array = tpGrid.rowPercents;
			var rowSerial:Array = tpGrid.rowSerial;
			var columnNum:int = tpGrid.columnCount;
			var columnPercents:Array = tpGrid.columnPercents;
			var columnSerial:Array = tpGrid.columnSerial;
			for (r = 0, percent_r = 0, lastPercent_r = 0; r < rowNum; r++)
			{
				percent_r = rowPercents[r];
				cell_h = grid_h * percent_r;
				cell_y = grid_h * lastPercent_r;

				for (c = 0, percent_c = 0, lastPercent_c = 0; c < columnNum; c++)
				{
					percent_c = columnPercents[c];
					cell_w = grid_w * percent_c;
					cell_x = grid_w * lastPercent_c;

					// 创建cell对象
					var cell:ITPCell = new TPCell();
					cell.width = cell_w;
					cell.height = cell_h;
					cell.centerPoint = new Point(dbP.x + cell_x + cell_w / 2, dbP.y + cell_y + cell_h / 2);
					cell.rowSerial = rowSerial[r];
					cell.columnSerial = columnSerial[c];
					tpGrid.appendCell(cell);

					lastPercent_c += percent_c;
				}
				lastPercent_r += percent_r;
			}
		}

		/**
		 * 绘制实线的边框和分隔线
		 * @param g
		 * @param feature
		 * @param tpGrid
		 * @param topoLayer
		 * @param topoCanvas
		 *
		 */
		private function drawBorderAndSplitsSolid(g:Graphics, feature:Feature, tpGrid:ITPGrid, topoLayer:TopoLayer, topoCanvas:TopoCanvas):void
		{
			var i:int = 0;
			var percent:Number = 0;
			// grid的宽和高
			var grid_w:Number = feature.width;
			var grid_h:Number = feature.height;

			MathUtil.drawStraightSolidLine(g, new Point(0, 0), new Point(grid_w, 0));
			MathUtil.drawStraightSolidLine(g, new Point(grid_w, 0), new Point(grid_w, grid_h));
			MathUtil.drawStraightSolidLine(g, new Point(grid_w, grid_h), new Point(0, grid_h));
			MathUtil.drawStraightSolidLine(g, new Point(0, grid_h), new Point(0, 0));

			// 画行的分割线
			var rowNum:int = tpGrid.rowCount;
			var rowPercents:Array = tpGrid.rowPercents;
			for (i = 0, percent = 0; i < rowNum - 1; i++)
			{
				percent += rowPercents[i];

				MathUtil.drawStraightSolidLine(g, new Point(0, grid_h * percent), new Point(grid_w, grid_h * percent));
			}

			// 画列的分割线
			var columnNum:int = tpGrid.columnCount;
			var columnPercents:Array = tpGrid.columnPercents;
			for (i = 0, percent = 0; i < columnNum - 1; i++)
			{
				percent += columnPercents[i];

				MathUtil.drawStraightSolidLine(g, new Point(grid_w * percent, 0), new Point(grid_w * percent, grid_h));
			}
		}

		/**
		 * 绘制虚线的边框和分隔线
		 * @param g
		 * @param feature
		 * @param tpGrid
		 * @param topoLayer
		 * @param topoCanvas
		 *
		 */
		private function drawBorderAndSplitsDash(g:Graphics, feature:Feature, tpGrid:ITPGrid, topoLayer:TopoLayer, topoCanvas:TopoCanvas):void
		{
			var i:int = 0;
			var percent:Number = 0;
			// grid的宽和高
			var grid_w:Number = feature.width;
			var grid_h:Number = feature.height;
			var dashLen:Number = 5;
			var dashGap:Number = 5;

			MathUtil.drawStraightDashLine(g, new Point(0, 0), new Point(grid_w, 0), dashLen, dashGap);
			MathUtil.drawStraightDashLine(g, new Point(grid_w, 0), new Point(grid_w, grid_h), dashLen, dashGap);
			MathUtil.drawStraightDashLine(g, new Point(grid_w, grid_h), new Point(0, grid_h), dashLen, dashGap);
			MathUtil.drawStraightDashLine(g, new Point(0, grid_h), new Point(0, 0), dashLen, dashGap);

			// 画行的分割线
			var rowNum:int = tpGrid.rowCount;
			var rowPercents:Array = tpGrid.rowPercents;
			for (i = 0, percent = 0; i < rowNum - 1; i++)
			{
				percent += rowPercents[i];

				MathUtil.drawStraightDashLine(g, new Point(0, grid_h * percent), new Point(grid_w, grid_h * percent), dashLen, dashGap);
			}

			// 画列的分割线
			var columnNum:int = tpGrid.columnCount;
			var columnPercents:Array = tpGrid.columnPercents;
			for (i = 0, percent = 0; i < columnNum - 1; i++)
			{
				percent += columnPercents[i];

				MathUtil.drawStraightDashLine(g, new Point(grid_w * percent, 0), new Point(grid_w * percent, grid_h), dashLen, dashGap);
			}
		}

		/**
		 * 绘制行label的框框和里面填写的序号
		 *
		 * @param g
		 * @param feature
		 * @param tpGrid
		 * @param topoLayer
		 * @param topoCanvas
		 *
		 */
		private function drawRowLabelRect(g:Graphics, feature:Feature, tpGrid:ITPGrid, topoLayer:TopoLayer, topoCanvas:TopoCanvas):void
		{
			var textMargin:Number = 2; // 文字外补丁
			var fontSize:Number = feature.getStyle("fontSize");
			var i:int, percent:Number, lastPercent:Number;
			var startY:Number, endY:Number;
			var totalHeight:Number = feature.height; // 网格的总高度
			var totalWidth:Number = feature.width; // 网格的总宽度
			var rectWidth:Number = tpGrid.rowLabelRectWidth; // label框的宽度(高度随横向分割线一致)

			// 画行的序号
			var rowNum:int = tpGrid.rowCount;
			var rowPercents:Array = tpGrid.rowPercents;
			var rowSerial:Array = tpGrid.rowSerial;

			// 如果label框的宽度小于0,需要根据里面的序号找到最宽的,要保证label框都能将全部序号放进去显示
			if (rectWidth < 0)
			{
				var strlen:int = 0;
				rowSerial.forEach(function(item:String, index:int, array:Array):void
					{
						strlen = Math.max(StringUtils.getStrLen(item), strlen);
					});
				// 此处对宽度做了个修正, 单纯的 strlen * fontSize /2 宽度还是不够,需要根据 strlen 的个数额外增加宽度
				rectWidth = strlen * fontSize / 2 + fontSize * (1 + strlen / 16) + textMargin * 2;
			}

			for (i = 0, percent = 0, lastPercent = 0; i < rowNum; i++)
			{
				percent = rowPercents[i];

				// 找到在Y轴上交界的两个点
				startY = totalHeight * lastPercent;
				endY = startY + totalHeight * percent;

				// 画行的label
				var rowLabel:Label = new Label();
				rowLabel.text = rowSerial[i];
				rowLabel.toolTip = rowLabel.text;
				// label的宽高 = 显示框大小 - 外补丁
				rowLabel.width = rectWidth - 2 * textMargin;
				rowLabel.height = totalHeight * percent - 2 * textMargin;
				// 设置样式(行居中,列居中)
				rowLabel.setStyle("textAlign", "center");
				rowLabel.setStyle("verticalAlign", "middle");

				switch (tpGrid.rowLabelLayout)
				{
					case ElementProperties.PROPERTYVALUE_GRID_ROW_LABEL_LAYOUT_LEFT: // 左侧
						// 画label的显示框
						g.moveTo(0, startY);
						g.lineTo(-rectWidth, startY);
						g.lineTo(-rectWidth, endY);
						g.lineTo(0, endY);
						// label
						rowLabel.x = -rectWidth + textMargin;
						rowLabel.y = startY + textMargin;
						feature.addElement(rowLabel);
						break;
					case ElementProperties.PROPERTYVALUE_GRID_ROW_LABEL_LAYOUT_RIGHT: // 右侧
						// 画label的显示框
						g.moveTo(totalWidth, startY);
						g.lineTo(totalWidth + rectWidth, startY);
						g.lineTo(totalWidth + rectWidth, endY);
						g.lineTo(totalWidth, endY);
						// label
						rowLabel.x = totalWidth + textMargin;
						rowLabel.y = startY + textMargin;
						feature.addElement(rowLabel);
						break;
					case ElementProperties.PROPERTYVALUE_GRID_LABEL_LAYOUT_HIDE:
					default:
						// 不绘制
						break;
				}
				lastPercent += percent;
			}
		}

		/**
		 * 绘制列Label的框框和里面填写的序号
		 * @param g
		 * @param feature
		 * @param tpGrid
		 * @param topoLayer
		 * @param topoCanvas
		 *
		 */
		private function drawColumnLabelRect(g:Graphics, feature:Feature, tpGrid:ITPGrid, topoLayer:TopoLayer, topoCanvas:TopoCanvas):void
		{
			var textMargin:Number = 2; // 文字外补丁
			var fontSize:Number = feature.getStyle("fontSize");
			var i:int, percent:Number, lastPercent:Number;
			var startX:Number, endX:Number;
			var totalHeight:Number = feature.height; // 网格的总高度
			var totalWidth:Number = feature.width; // 网格的总宽度
			var rectHeight:Number = tpGrid.columnLabelRectHeight; // label框的高度(宽度随纵向分割线一致)

			// 画列的序号
			var columnNum:int = tpGrid.columnCount;
			var columnPercents:Array = tpGrid.columnPercents;
			var columnSerial:Array = tpGrid.columnSerial;

			// 如果label框的高度小于0,不考虑序号换行显示,要保证根据样式不同都能放入一行文字
			if (rectHeight < 0)
			{
				rectHeight = fontSize * 1.2 + textMargin * 2;
			}

			for (i = 0, percent = 0, lastPercent = 0; i < columnNum; i++)
			{
				percent = columnPercents[i];

				// 找到在X轴上交界的两个点
				startX = totalWidth * lastPercent;
				endX = startX + totalWidth * percent;

				// 画列的label
				var colLabel:Label = new Label();
				colLabel.text = columnSerial[i];
				colLabel.toolTip = colLabel.text;
				// label的宽高 = 显示框大小 - 外补丁
				colLabel.width = totalWidth * percent - 2 * textMargin;
				colLabel.height = rectHeight - 2 * textMargin;
				// 设置样式(行居中,列居中)
				colLabel.setStyle("textAlign", "center");
				colLabel.setStyle("verticalAlign", "middle");

				switch (tpGrid.columnLabelLayout)
				{
					case ElementProperties.PROPERTYVALUE_GRID_COLUMN_LABEL_LAYOUT_TOP: //顶部
						// 画label的显示框
						g.moveTo(startX, 0);
						g.lineTo(startX, -rectHeight);
						g.lineTo(endX, -rectHeight);
						g.lineTo(endX, 0);
						// label
						colLabel.x = startX + textMargin;
						colLabel.y = -rectHeight + textMargin;
						feature.addElement(colLabel);
						break;
					case ElementProperties.PROPERTYVALUE_GRID_COLUMN_LABEL_LAYOUT_BOTTOM: // 底部
						// 画label的显示框
						g.moveTo(startX, totalHeight);
						g.lineTo(startX, totalHeight + rectHeight);
						g.lineTo(endX, totalHeight + rectHeight);
						g.lineTo(endX, totalHeight);
						// label
						colLabel.x = startX + textMargin;
						colLabel.y = totalHeight + textMargin;
						feature.addElement(colLabel);
						break;
					case ElementProperties.PROPERTYVALUE_GRID_LABEL_LAYOUT_HIDE:
					default:
						// 不绘制
						break;
				}
				lastPercent += percent;
			}
		}

	}
}