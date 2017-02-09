package com.linkage.module.topo.framework.core.model.element.plane
{
	import com.linkage.module.topo.framework.Constants;
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.model.element.plane.cell.ITPCell;
	import com.linkage.module.topo.framework.core.parser.ElementProperties;
	import com.linkage.module.topo.framework.util.TopoUtil;
	import com.linkage.system.utils.StringUtils;

	/**
	 * 网格对象
	 * @author duangr
	 *
	 */
	public class TPGrid extends TPPlane implements ITPGrid
	{
		/**
		 * 分隔符
		 */
		public static const SPLIT_CHAR:String = ",";

		// cell数组
		private var _cells:Array = [];

		public function TPGrid()
		{
			super();
			this.type = ElementProperties.PROPERTYVALUE_OBJECT_TYPE_GRID;
		}

		override public function getProperty(key:String):String
		{
			var returnValue:String = super.getProperty(key);

			if (returnValue != null)
			{
				return returnValue;
			}

			switch (key)
			{
				case "cells":
					returnValue = this._cells.toString();
					break;
				default:
					break;
			}
			return returnValue;
		}

		override public function eachProperty(callback:Function, thisObject:* = null):void
		{
			if (callback == null)
			{
				return;
			}
			callback.call(thisObject, "cells", this._cells.toString());
			super.eachProperty(callback, thisObject);
		}

		[Bindable]
		public function get borderColor():uint
		{
			return StringUtils.isEmpty(getExtendProperty(ElementProperties.GRID_BORDER_COLOR)) ? ElementProperties.DEFAULT_GRID_BORDER_COLOR : uint(getExtendProperty(ElementProperties.GRID_BORDER_COLOR));
		}

		public function set borderColor(value:uint):void
		{
			this.addExtendProperty(ElementProperties.GRID_BORDER_COLOR, String(value));
		}

		[Bindable]
		public function get borderWidth():Number
		{
			return StringUtils.isEmpty(getExtendProperty(ElementProperties.GRID_BORDER_WIDTH)) ? ElementProperties.DEFAULT_GRID_BORDER_WIDTH : Number(getExtendProperty(ElementProperties.GRID_BORDER_WIDTH));
		}

		public function set borderWidth(value:Number):void
		{
			this.addExtendProperty(ElementProperties.GRID_BORDER_WIDTH, String(value));
		}

		[Bindable]
		public function get borderAlpha():Number
		{
			return StringUtils.isEmpty(getExtendProperty(ElementProperties.GRID_BORDER_ALPHA)) ? ElementProperties.DEFAULT_GRID_BORDER_ALPHA : Number(getExtendProperty(ElementProperties.GRID_BORDER_ALPHA));
		}

		public function set borderAlpha(value:Number):void
		{
			this.addExtendProperty(ElementProperties.GRID_BORDER_ALPHA, String(value));
		}

		public function get borderSymbol():String
		{
			return StringUtils.isEmpty(getExtendProperty(ElementProperties.GRID_BORDER_SYMBOL)) ? ElementProperties.DEFAULT_GRID_BORDER_SYMBOL : getExtendProperty(ElementProperties.GRID_BORDER_SYMBOL);
		}

		public function set borderSymbol(value:String):void
		{
			this.addExtendProperty(ElementProperties.GRID_BORDER_SYMBOL, String(value));
		}


		[Bindable]
		public function get cellFillColorStart():uint
		{
			return StringUtils.isEmpty(getExtendProperty(ElementProperties.GRID_CELL_FILL_COLOR_START)) ? ElementProperties.DEFAULT_GRID_CELL_FILL_COLOR_START : uint(getExtendProperty(ElementProperties.
				GRID_CELL_FILL_COLOR_START));
		}

		public function set cellFillColorStart(value:uint):void
		{
			this.addExtendProperty(ElementProperties.GRID_CELL_FILL_COLOR_START, String(value));
		}

		[Bindable]
		public function get cellFillColorEnd():uint
		{
			return StringUtils.isEmpty(getExtendProperty(ElementProperties.GRID_CELL_FILL_COLOR_END)) ? ElementProperties.DEFAULT_GRID_CELL_FILL_COLOR_END : uint(getExtendProperty(ElementProperties.GRID_CELL_FILL_COLOR_END));
		}

		public function set cellFillColorEnd(value:uint):void
		{
			this.addExtendProperty(ElementProperties.GRID_CELL_FILL_COLOR_END, String(value));
		}

		[Bindable]
		public function get cellFillAlpha():Number
		{
			return StringUtils.isEmpty(getExtendProperty(ElementProperties.GRID_CELL_FILL_ALPHA)) ? ElementProperties.DEFAULT_GRID_CELL_FILL_ALPHA : Number(getExtendProperty(ElementProperties.GRID_CELL_FILL_ALPHA));
		}

		public function set cellFillAlpha(value:Number):void
		{
			this.addExtendProperty(ElementProperties.GRID_CELL_FILL_ALPHA, String(value));
		}

		[Bindable]
		public function get rowCount():uint
		{
			return StringUtils.isEmpty(getExtendProperty(ElementProperties.GRID_ROW_COUNT)) ? ElementProperties.DEFAULT_GRID_ROW_COUNT : uint(getExtendProperty(ElementProperties.GRID_ROW_COUNT));
		}

		public function set rowCount(value:uint):void
		{
			this.addExtendProperty(ElementProperties.GRID_ROW_COUNT, String(value));
		}

		/**
		 * 解析百分比
		 * @param value
		 * @return
		 *
		 */
		private function parsePercents(value:String):Array
		{
			var array:Array = null;
			if (StringUtils.isEmpty(value))
			{
				array = TopoUtil.findAvgPercent(rowCount);
			}
			else
			{
				array = value.split(SPLIT_CHAR);
				array.forEach(function(item:*, index:int, arr:Array):void
					{
						arr[index] = Number(item);
					});
			}
			return array;
		}

		/**
		 * 解析序号
		 * @param value
		 * @param count
		 * @return
		 *
		 */
		private function parseSerial(value:String, count:int):Array
		{
			if (StringUtils.isEmpty(value))
			{
				var array:Array = [];
				for (var i:int = 0; i < count; i++)
				{
					array.push("");
				}
				return array;
			}
			else
			{
				return value.split(SPLIT_CHAR);
			}
		}

		[Bindable]
		public function get rowPercents():Array
		{
			return parsePercents(getExtendProperty(ElementProperties.GRID_ROW_PERCENTS));
		}

		public function set rowPercents(value:Array):void
		{
			this.addExtendProperty(ElementProperties.GRID_ROW_PERCENTS, value.join(SPLIT_CHAR));
		}

		[Bindable]
		public function get rowSerial():Array
		{
			var value:String = getExtendProperty(ElementProperties.GRID_ROW_SERIAL);
			return parseSerial(value, rowCount);
		}

		public function set rowSerial(value:Array):void
		{
			this.addExtendProperty(ElementProperties.GRID_ROW_SERIAL, value.join(SPLIT_CHAR));
		}

		[Bindable]
		public function get rowLabelLayout():String
		{
			return StringUtils.isEmpty(getExtendProperty(ElementProperties.GRID_ROW_LABEL_LAYOUT)) ? ElementProperties.DEFAULT_GRID_ROW_LABEL_LAYOUT : getExtendProperty(ElementProperties.GRID_ROW_LABEL_LAYOUT);
		}

		public function set rowLabelLayout(value:String):void
		{
			this.addExtendProperty(ElementProperties.GRID_ROW_LABEL_LAYOUT, value);
		}

		[Bindable]
		public function get rowLabelRectWidth():Number
		{
			return StringUtils.isEmpty(getExtendProperty(ElementProperties.GRID_ROW_LABEL_RECTWIDTH)) ? ElementProperties.DEFAULT_GRID_ROW_LABEL_RECTWIDTH : Number(getExtendProperty(ElementProperties.
				GRID_ROW_LABEL_RECTWIDTH));
		}

		public function set rowLabelRectWidth(value:Number):void
		{
			this.addExtendProperty(ElementProperties.GRID_ROW_LABEL_RECTWIDTH, String(value));
		}

		[Bindable]
		public function get rowLabelFillColor():uint
		{
			return StringUtils.isEmpty(getExtendProperty(ElementProperties.GRID_ROW_LABEL_FILL_COLOR)) ? ElementProperties.DEFAULT_GRID_ROW_LABEL_FILL_COLOR : uint(getExtendProperty(ElementProperties.
				GRID_ROW_LABEL_FILL_COLOR));
		}

		public function set rowLabelFillColor(value:uint):void
		{
			this.addExtendProperty(ElementProperties.GRID_ROW_LABEL_FILL_COLOR, String(value));
		}

		[Bindable]
		public function get rowLabelFillAlpha():Number
		{
			var alpha:Number = StringUtils.isEmpty(getExtendProperty(ElementProperties.GRID_ROW_LABEL_FILL_ALPHA)) ? ElementProperties.DEFAULT_GRID_ROW_LABEL_FILL_ALPHA : Number(getExtendProperty(ElementProperties.
				GRID_ROW_LABEL_FILL_ALPHA));
			return alpha < 0 ? cellFillAlpha : alpha;
		}

		public function set rowLabelFillAlpha(value:Number):void
		{
			this.addExtendProperty(ElementProperties.GRID_ROW_LABEL_FILL_ALPHA, String(value));
		}

		[Bindable]
		public function get rowLabelBorderAlpha():Number
		{
			var alpha:Number = StringUtils.isEmpty(getExtendProperty(ElementProperties.GRID_ROW_LABEL_BORDER_ALPHA)) ? ElementProperties.DEFAULT_GRID_ROW_LABEL_BORDER_ALPHA : Number(getExtendProperty(ElementProperties.
				GRID_ROW_LABEL_BORDER_ALPHA));

			return alpha < 0 ? borderAlpha : alpha;
		}

		public function set rowLabelBorderAlpha(value:Number):void
		{
			this.addExtendProperty(ElementProperties.GRID_ROW_LABEL_BORDER_ALPHA, String(value));
		}

		[Bindable]
		public function get columnCount():uint
		{
			return StringUtils.isEmpty(getExtendProperty(ElementProperties.GRID_COLUMN_COUNT)) ? ElementProperties.DEFAULT_GRID_COLUMN_COUNT : uint(getExtendProperty(ElementProperties.GRID_COLUMN_COUNT));
		}

		public function set columnCount(value:uint):void
		{
			this.addExtendProperty(ElementProperties.GRID_COLUMN_COUNT, String(value));
		}

		[Bindable]
		public function get columnPercents():Array
		{
			return parsePercents(getExtendProperty(ElementProperties.GRID_COLUMN_PERCENTS));
		}

		public function set columnPercents(value:Array):void
		{
			this.addExtendProperty(ElementProperties.GRID_COLUMN_PERCENTS, value.join(SPLIT_CHAR));
		}

		[Bindable]
		public function get columnSerial():Array
		{
			var value:String = getExtendProperty(ElementProperties.GRID_COLUMN_SERIAL);
			return parseSerial(value, columnCount);
		}

		public function set columnSerial(value:Array):void
		{
			this.addExtendProperty(ElementProperties.GRID_COLUMN_SERIAL, value.join(SPLIT_CHAR));
		}

		[Bindable]
		public function get columnLabelLayout():String
		{
			return StringUtils.isEmpty(getExtendProperty(ElementProperties.GRID_COLUMN_LABEL_LAYOUT)) ? ElementProperties.DEFAULT_GRID_COLUMN_LABEL_LAYOUT : getExtendProperty(ElementProperties.GRID_COLUMN_LABEL_LAYOUT);
		}

		public function set columnLabelLayout(value:String):void
		{
			this.addExtendProperty(ElementProperties.GRID_COLUMN_LABEL_LAYOUT, value);
		}

		[Bindable]
		public function get columnLabelRectHeight():Number
		{
			return StringUtils.isEmpty(getExtendProperty(ElementProperties.GRID_COLUMN_LABEL_RECTHEIGHT)) ? ElementProperties.DEFAULT_GRID_COLUMN_LABEL_RECTHEIGHT : Number(getExtendProperty(ElementProperties.
				GRID_COLUMN_LABEL_RECTHEIGHT));
		}

		public function set columnLabelRectHeight(value:Number):void
		{
			this.addExtendProperty(ElementProperties.GRID_COLUMN_LABEL_RECTHEIGHT, String(value));
		}

		[Bindable]
		public function get columnLabelFillColor():uint
		{
			return StringUtils.isEmpty(getExtendProperty(ElementProperties.GRID_COLUMN_LABEL_FILL_COLOR)) ? ElementProperties.DEFAULT_GRID_COLUMN_LABEL_FILL_COLOR : uint(getExtendProperty(ElementProperties.
				GRID_COLUMN_LABEL_FILL_COLOR));
		}

		public function set columnLabelFillColor(value:uint):void
		{
			this.addExtendProperty(ElementProperties.GRID_COLUMN_LABEL_FILL_COLOR, String(value));
		}

		[Bindable]
		public function get columnLabelFillAlpha():Number
		{
			var alpha:Number = StringUtils.isEmpty(getExtendProperty(ElementProperties.GRID_COLUMN_LABEL_FILL_ALPHA)) ? ElementProperties.DEFAULT_GRID_COLUMN_LABEL_FILL_ALPHA : Number(getExtendProperty(ElementProperties.
				GRID_COLUMN_LABEL_FILL_ALPHA));
			return alpha < 0 ? cellFillAlpha : alpha;
		}

		public function set columnLabelFillAlpha(value:Number):void
		{
			this.addExtendProperty(ElementProperties.GRID_COLUMN_LABEL_FILL_ALPHA, String(value));
		}

		[Bindable]
		public function get columnLabelBorderAlpha():Number
		{
			var alpha:Number = StringUtils.isEmpty(getExtendProperty(ElementProperties.GRID_COLUMN_LABEL_BORDER_ALPHA)) ? ElementProperties.DEFAULT_GRID_COLUMN_LABEL_BORDER_ALPHA : Number(getExtendProperty(ElementProperties.
				GRID_COLUMN_LABEL_BORDER_ALPHA));
			return alpha < 0 ? borderAlpha : alpha;
		}

		public function set columnLabelBorderAlpha(value:Number):void
		{
			this.addExtendProperty(ElementProperties.GRID_COLUMN_LABEL_BORDER_ALPHA, String(value));
		}

		[Bindable]
		public function get labelSpell():String
		{
			return StringUtils.isEmpty(getExtendProperty(ElementProperties.GRID_LABEL_SPELL)) ? ElementProperties.DEFAULT_GRID_LABEL_SPELL : getExtendProperty(ElementProperties.GRID_LABEL_SPELL);
		}

		public function set labelSpell(value:String):void
		{
			this.addExtendProperty(ElementProperties.GRID_LABEL_SPELL, value);
		}

		public function appendCell(cell:ITPCell):void
		{
			_cells.push(cell);
		}

		public function clearCells():void
		{
			_cells.length = 0;
		}

		public function eachCell(callback:Function):void
		{
			if (callback == null)
			{
				return;
			}
			_cells.forEach(function(item:ITPCell, index:int, array:Array):void
				{
					callback.call(null, item);
				});
		}

		public function get cellNum():int
		{
			return _cells.length;
		}

		override public function get weight():uint
		{
			return Constants.WEIGHT_ELEMENT_TPGRID;
		}

		override public function get itemName():String
		{
			return Constants.ITEM_NAME_TPGRID;
		}

		override public function copyFrom(element:IElement):void
		{
			super.copyFrom(element);
			var tpGrid:ITPGrid = element as ITPGrid;
			rowCount = tpGrid.rowCount;
			rowPercents = tpGrid.rowPercents;
			rowSerial = tpGrid.rowSerial;
			rowLabelLayout = tpGrid.rowLabelLayout;
			columnCount = tpGrid.columnCount;
			columnPercents = tpGrid.columnPercents;
			columnSerial = tpGrid.columnSerial;
			columnLabelLayout = tpGrid.columnLabelLayout;
			labelSpell = tpGrid.labelSpell;
		}

		override public function destroy():void
		{
			super.destroy();
			_cells.length = 0;
			_cells = null;
		}

		override public function toString():String
		{
			return "TPGrid(" + id + ": " + name + " / " + type + " / (" + x + "," + y + ") w:" + width + " h:" + height + ")";
		}
	}
}