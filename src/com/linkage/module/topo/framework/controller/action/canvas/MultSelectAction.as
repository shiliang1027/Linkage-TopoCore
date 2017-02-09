package com.linkage.module.topo.framework.controller.action.canvas
{
	import com.linkage.module.topo.framework.Constants;
	import com.linkage.module.topo.framework.controller.event.CanvasEvent;
	import com.linkage.module.topo.framework.core.Feature;
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.model.element.point.ITPPoint;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;

	import flash.display.Graphics;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	import spark.components.Group;

	/**
	 * 多选模式 Action
	 * @author duangr
	 *
	 */
	public class MultSelectAction extends CanvasAction
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.controller.action.canvas.MultSelectAction");

		// 选择框粗细
		private var _selectAreaLineThickness:uint = Constants.DEFAULT_SELECTAREA_LINE_SIZE;
		// 选择框颜色
		private var _selectAreaLineColor:uint = Constants.DEFAULT_SELECTAREA_LINE_COLOR;
		// 框选区域
		private var _selectArea:Group = new Group();
		private var _selectAreaStartX:Number = 0;
		private var _selectAreaStartY:Number = 0;

		public function MultSelectAction(canvas:TopoCanvas)
		{
			super(canvas);
		}

		override public function get name():String
		{
			return "多选模式";
		}

		override public function afterActionEnabled():void
		{
			// 启用网元选择
			_canvas.selectEnabled = true;
		}

		override public function afterActionDisabled():void
		{
			// 禁用网元选择
			_canvas.selectEnabled = false;
		}

		override public function onDownFeature(event:MouseEvent, mouseCanvasPoint:Point, downFeature:Feature):void
		{
			// 选中对象
			if (event.ctrlKey)
			{
				// ctrl按下时,将新对象加入选择列表中
				_canvas.addToSelect(downFeature.element);
			}
			else
			{
				_canvas.setToSelect(downFeature.element);
			}
			_canvas.dispatchEvent(new CanvasEvent(CanvasEvent.SELECTED_CHANGED));
		}

		override public function onDownCanvas(event:MouseEvent, mouseCanvasPoint:Point):void
		{
			if (!event.ctrlKey)
			{
				//把已选中对象清空
				_canvas.clearAllSelect();
			}

			// 开始画框选区域
			selectAreaStart(mouseCanvasPoint.x, mouseCanvasPoint.y);
		}

		override public function onMoveWithDownCanvas(event:MouseEvent, mouseCanvasPoint:Point):void
		{
			selectAreaMoving(mouseCanvasPoint.x, mouseCanvasPoint.y);
		}

		override public function onMoveWithDownCanvasButUp(event:MouseEvent, mouseCanvasPoint:Point):void
		{
			selectAreaClear();
			_canvas.dispatchEvent(new CanvasEvent(CanvasEvent.SELECTED_CHANGED));
		}

		override public function onUpWithDownCanvasNoMove(event:MouseEvent, mouseCanvasPoint:Point, upFeature:Feature):void
		{
			selectAreaClear();
			_canvas.dispatchEvent(new CanvasEvent(CanvasEvent.SELECTED_CHANGED));
		}

		override public function onUpWithDownCanvasAndMove(event:MouseEvent, mouseCanvasPoint:Point, upFeature:Feature):void
		{
			if (!event.ctrlKey)
			{
				//把已选中对象清空
				_canvas.clearAllSelect();
			}

			selectAreaEnd(mouseCanvasPoint.x, mouseCanvasPoint.y);
			_canvas.dispatchEvent(new CanvasEvent(CanvasEvent.SELECTED_CHANGED));
		}

		override public function handlerRightClick(feature:Feature):void
		{
			// 选中元素时
			if (feature != null)
			{
				_canvas.setToSelect(feature.element);
			}
		}

		/**
		 * 开始绘制框选区域
		 * @param x 相对画布的X坐标
		 * @param y 相对画布的Y坐标
		 *
		 */
		private function selectAreaStart(x:Number, y:Number):void
		{
			if (!_canvas.contains(_selectArea))
			{
				_canvas.addElement(_selectArea);
			}
			_selectArea.visible = true;
			_selectAreaStartX = x;
			_selectAreaStartY = y;
			var g:Graphics = _selectArea.graphics;
			g.lineStyle(_selectAreaLineThickness, _selectAreaLineColor);

		}

		/**
		 * 框选区域移动变化中
		 * @param mousePoint 当前鼠标坐标
		 *
		 */
		private function selectAreaMoving(x:Number, y:Number):void
		{
			var g:Graphics = _selectArea.graphics;
			g.clear();
			g.lineStyle(_selectAreaLineThickness, _selectAreaLineColor);
			g.drawRect(_selectAreaStartX, _selectAreaStartY, x - _selectAreaStartX, y - _selectAreaStartY);
		}

		/**
		 * 框选区域绘制结束
		 * @param mousePoint 当前鼠标坐标
		 *
		 */
		private function selectAreaEnd(x:Number, y:Number):void
		{
			selectAreaClear();
			findSelectedElements(_selectAreaStartX, _selectAreaStartY, x, y);
		}

		/**
		 * 清除框选区域
		 *
		 */
		private function selectAreaClear():void
		{
			_selectArea.graphics.clear();
			_selectArea.visible = false;
		}

		/**
		 * 找出被框选住的元素对象
		 * @param sx 框选开始点x坐标
		 * @param sy 框选开始点y坐标
		 * @param ex 框选结束点x坐标
		 * @param ey 框选结束点y坐标
		 *
		 */
		private function findSelectedElements(sx:Number, sy:Number, ex:Number, ey:Number):void
		{
			if (sx == ex && sy == ey)
			{
				return;
			}
			// 找到框选区域左上和右下的坐标
			var minX:Number = Math.min(sx, ex);
			var minY:Number = Math.min(sy, ey);
			var maxX:Number = Math.max(sx, ex);
			var maxY:Number = Math.max(sy, ey);

			// 将相对画布的坐标转换为数据中的坐标
			var minPoint:Point = _canvas.globalToXY(minX, minY);
			var maxPoint:Point = _canvas.globalToXY(maxX, maxY);
			minX = minPoint.x;
			minY = minPoint.y;
			maxX = maxPoint.x;
			maxY = maxPoint.y;

			// 不选择链路
			_canvas.eachPoint(function(id:String, tpPoint:ITPPoint):void
				{
					checkElementMatch(tpPoint);
				});

			/**
			 * 验证元素是否满足框选区域
			 */
			function checkElementMatch(element:ITPPoint):void
			{
				var feature:Feature = element.feature;
				// 左上角和右下角同时选中才算是框选中
				if (feature.visible && checkXYMatch(element.x - feature.width / 2, element.y - feature.height / 2) && checkXYMatch(element.x + feature.width / 2, element.y + feature.height / 2))
				{
					_canvas.addToSelect(element);
				}
			}

			/**
			 * 验证坐标是否满足框选区域
			 */
			function checkXYMatch(x:Number, y:Number):Boolean
			{
				if (minX <= x && x <= maxX && minY <= y && y <= maxY)
				{
					return true;
				}
				else
				{
					return false;
				}
			}
		}
	}
}