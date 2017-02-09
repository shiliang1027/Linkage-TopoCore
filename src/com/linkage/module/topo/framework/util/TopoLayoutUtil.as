package com.linkage.module.topo.framework.util
{
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.model.element.plane.ITPGrid;
	import com.linkage.module.topo.framework.core.model.element.plane.ITPPlane;
	import com.linkage.module.topo.framework.core.model.element.point.INode;
	import com.linkage.module.topo.framework.core.model.element.point.ITPPoint;
	import com.linkage.module.topo.framework.view.component.TopoLayer;

	/**
	 * 拓扑布局工具类
	 * @author duangr
	 *
	 */
	public class TopoLayoutUtil
	{
		/**
		 * 布局当前选中的网元,采用一行布局的方式
		 *
		 * @param topoLayer 画布
		 * @param gap 布局时网元间间隙(列间隙)
		 * @param wrapPolicy 包装策略,入参为: obj:*,element:ITPPoint.<br/>
		 * 		obj: 待包装的对象,若排序需要可以增加一些属性. element: 对象自身.<br/>
		 * 		例如: function(obj:*,element:ITPPoint):void{ ... }
		 * @param sortPolicy 布局策略,入参为: tpPoints:Array 待排序的数组.<br/>
		 * 		数组中每个元素是个对象,格式为: {id:'',name:'',x:'',y:'',element:''}<br/>
		 * 		例如: function(tpPoints:Array):void{ ... }
		 *
		 */
		public static function layoutSelectedOneRow(topoLayer:TopoLayer, gap:Number, wrapPolicy:Function = null, sortPolicy:Function = null):void
		{
			// 布局起始点
			var startX:Number = Number.MAX_VALUE;
			var startY:Number = Number.MAX_VALUE;

			var tpPoints:Array = [];
			if (wrapPolicy == null)
			{
				wrapPolicy = wrapPolicy_default;
			}
			topoLayer.eachSelect(function(id:String, element:IElement):void
				{
					if (element is ITPPoint)
					{
						var tpPoint:ITPPoint = element as ITPPoint;
						startX = Math.min(startX, tpPoint.feature.x);
						startY = Math.min(startY, tpPoint.feature.y);
						tpPoints.push(wrapPolicy.call(null, {id: id, element: tpPoint}, tpPoint));
					}
				});
			// 排序
			if (sortPolicy == null)
			{
				sortPolicyByX_ASC.call(null, tpPoints);
			}
			else
			{
				sortPolicy.call(null, tpPoints);
			}

			// 排序后修改坐标
			// 当前布局点坐标
			var currentX:Number = startX;
			var currentY:Number = startY;
			// 一行布局
			tpPoints.forEach(function(item:*, index:int, array:Array):void
				{
					var tpPoint:ITPPoint = item.element as ITPPoint;
					if (index == 0)
					{
						// 第一个对象
						currentX = startX;
					}
					else
					{
						// 后面的对象布局时要加上前一个对象的宽度
						currentX += (array[index - 1].element as ITPPoint).feature.width + gap;
					}
					tpPoint.feature.setMoveXY(currentX, currentY);
				});


		}

		/**
		 * 布局当前选中的网元,采用一列布局的方式
		 *
		 * @param topoLayer 画布
		 * @param gap 布局时网元间间隙 (行间隙)
		 * @param wrapPolicy 包装策略,入参为: obj:*,element:ITPPoint.<br/>
		 * 		obj: 待包装的对象,若排序需要可以增加一些属性. element: 对象自身.<br/>
		 * 		例如: function(obj:*,element:ITPPoint):void{ ... }
		 * @param sortPolicy 布局策略,入参为: tpPoints:Array 待排序的数组.<br/>
		 * 		数组中每个元素是个对象,格式为: {id:'',name:'',x:'',y:'',element:''}<br/>
		 * 		例如: function(tpPoints:Array):void{ ... }
		 *
		 */
		public static function layoutSelectedOneColumn(topoLayer:TopoLayer, gap:Number, wrapPolicy:Function = null, sortPolicy:Function = null):void
		{
			// 布局起始点
			var startX:Number = Number.MAX_VALUE;
			var startY:Number = Number.MAX_VALUE;

			var tpPoints:Array = [];
			if (wrapPolicy == null)
			{
				wrapPolicy = wrapPolicy_default;
			}
			topoLayer.eachSelect(function(id:String, element:IElement):void
				{
					if (element is ITPPoint)
					{
						var tpPoint:ITPPoint = element as ITPPoint;
						startX = Math.min(startX, tpPoint.feature.x);
						startY = Math.min(startY, tpPoint.feature.y);
//						tpPoints.push({id: id, name: tpPoint.name, x: tpPoint.x, y: tpPoint.y, element: tpPoint});
						tpPoints.push(wrapPolicy.call(null, {id: id, element: tpPoint}, tpPoint));
					}
				});
			// 排序
			if (sortPolicy == null)
			{
				sortPolicyByY_ASC.call(null, tpPoints);
			}
			else
			{
				sortPolicy.call(null, tpPoints);
			}

			// 排序后修改坐标
			// 当前布局点坐标
			var currentX:Number = startX;
			var currentY:Number = startY;
			// 一列布局
			tpPoints.forEach(function(item:*, index:int, array:Array):void
				{
					var tpPoint:ITPPoint = item.element as ITPPoint;
					if (index == 0)
					{
						// 第一个对象
						currentY = startY;
					}
					else
					{
						// 后面的对象布局时要加上前一个对象的宽度
						currentY += (array[index - 1].element as ITPPoint).feature.height + gap;
					}
					tpPoint.feature.setMoveXY(currentX, currentY);
				});

		}

		/**
		 * [排序策略] 按x坐标递增排序
		 * @param tpPoints
		 *
		 */
		public static function sortPolicyByX_ASC(tpPoints:Array):void
		{
			tpPoints.sortOn("x", Array.NUMERIC);
		}

		/**
		 * [排序策略] 按y坐标递增排序
		 * @param tpPoints
		 *
		 */
		public static function sortPolicyByY_ASC(tpPoints:Array):void
		{
			tpPoints.sortOn("y", Array.NUMERIC);
		}

		/**
		 * [包装策略]对象的默认包装策略
		 * @param obj 待包装的对象
		 * @param element 对应的ITPPoint对象
		 * @return
		 *
		 */
		public static function wrapPolicy_default(obj:*, element:ITPPoint):*
		{
			obj.name = element.name;
			obj.x = element.x;
			obj.y = element.y
			return obj;
		}

//		public static function wrapPolicy_TPGridSerial(obj:*, element:ITPPoint):*
//		{
//			if (element is ITPGrid)
//			{
//				var tpGrid:ITPGrid = element as ITPGrid;
//				obj.rowSerial = tpGrid.rowSerial.join(",");
//				obj.columnSerial = tpGrid.columnSerial.join(",");
//			}
//			return obj;
//		}
//
//		public static function sortPolicyByTPGridRowSerial(tpPoints:Array):void
//		{
//			tpPoints.sortOn("rowSerial");
//		}
//
//		public static function sortPolicyByTPGridColumnSerial(tpPoints:Array):void
//		{
//			tpPoints.sortOn("columnSerial");
//		}

	}
}