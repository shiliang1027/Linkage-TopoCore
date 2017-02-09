package com.linkage.module.topo.framework.util
{
	import com.adobe.serialization.json.JSON;
	import com.linkage.module.topo.framework.core.ChildFeature;
	import com.linkage.module.topo.framework.core.Feature;
	import com.linkage.module.topo.framework.core.IGetProperty;
	import com.linkage.module.topo.framework.core.model.element.point.ITPPoint;
	import com.linkage.module.topo.framework.util.serial.ISerial;
	import com.linkage.module.topo.framework.view.component.ICanvasExtendPanel;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;
	import com.linkage.module.topo.framework.view.component.toolbar.TopoToolBar;
	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;
	import com.linkage.system.utils.StringUtils;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	import mx.validators.Validator;

	/**
	 * 拓扑工具类
	 * @author duangr
	 *
	 */
	public class TopoUtil
	{
		// log
		private static var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.util.TopoUtil");
		/**
		 * 宏解析后为null
		 */
		public static const MACRO_NULL:String = "NULL";


		/**
		 * 格式化上下文,返回 /cms 的格式
		 * @param context
		 * @return
		 *
		 */
		public static function formatContext(context:String):String
		{
			return context;
//			if (StringUtils.startsWith(context, "/"))
//			{
//				context = context.substr(1);
//			}
//			if (StringUtils.endsWith(context, "/"))
//			{
//				context = context.substring(0, context.length - 1);
//			}
//			return "/" + context; 
		}

		/**
		 * 将JSON字符串转换为对象
		 * @param str
		 * @return
		 *
		 */
		public static function jsonDecode(str:String):Object
		{
			if (str == null)
			{
				return null;
			}
			return com.adobe.serialization.json.JSON.decode(str.replace(/\'/g, "\""));
		}

		/**
		 * 查找目标对象(或其父对象)是否为拓扑要素,找不到返回空
		 * @param target
		 * @return
		 *
		 */
		public static function findTargetFeature(target:Object):Feature
		{
			if (target == null)
			{
				return null;
			}

			while (!(target is Feature))
			{
				if (target is TopoCanvas)
				{
					return null;
				}
				target = target.parent;

				if (target == null || target == target.parent)
				{
					return null;
				}
			}
			var result:Feature = target as Feature;
			if (result == null)
			{
				return null;
			}
			return result;
		}
		
		/**
		 * 查找目标对象(或其父对象)是否为拓扑要素,找不到返回空
		 * @param target
		 * @return
		 *
		 */
		public static function findTargetChildFeature(target:Object):ChildFeature
		{
			if (target == null)
			{
				return null;
			}
			
			while (!(target is ChildFeature))
			{
				if (target is TopoCanvas)
				{
					return null;
				}
				target = target.parent;
				
				if (target == null || target == target.parent)
				{
					return null;
				}
			}
			var result:ChildFeature = target as ChildFeature;
			if (result == null)
			{
				return null;
			}
			return result;
		}

		/**
		 * 判断对象是否在扩展面板内
		 * @param target
		 * @return
		 *
		 */
		public static function isInExtendPanel(target:Object):Boolean
		{

			if (target == null)
			{
				return false;
			}

			while (!(target is ICanvasExtendPanel))
			{
				target = target.parent;

				if (target == null || target == target.parent)
				{
					return false;
				}
			}
			return target != null;
		}

		/**
		 * 判断对象是否在工具条内
		 * @param target
		 * @return
		 *
		 */
		public static function isInToolBar(target:Object):Boolean
		{
			if (target == null)
			{
				return false;
			}

			while (!(target is TopoToolBar))
			{
				target = target.parent;

				if (target == null || target == target.parent)
				{
					return false;
				}
			}
			return target != null;
		}

		/**
		 * 判断对象是否在画布内
		 * @param target
		 * @return
		 *
		 */
		public static function isInCanvas(target:Object):Boolean
		{
			return !isInExtendPanel(target) && !isInToolBar(target);
		}



		/**
		 * 找到鼠标相对画布的位置
		 * @param event 鼠标事件
		 * @param canvas 画布
		 * @return
		 *
		 */
		public static function findMousePoint(event:MouseEvent, canvas:TopoCanvas):Point
		{
			var feature:Feature = findTargetFeature(event.target);
			var x:Number = event.localX;
			var y:Number = event.localY;
			if (feature != null)
			{
				// 鼠标在Feature上面
				var point:Point = findRelativeLocation(event.target as DisplayObjectContainer, canvas);
				x += point.x;
				y += point.y;
			}
			else
			{
				// 鼠标在空白处,直接获取画布中鼠标的坐标
				x = canvas.mouseX;
				y = canvas.mouseY;
			}
			var p:Point = new Point(x, y);

			return p;
		}

		/**
		 * 获取父子两对象的相对位置
		 * @param child 子对象
		 * @param parent 父对象
		 * @param point 初始化位置坐标
		 * @return
		 *
		 */
		public static function findRelativeLocation(child:DisplayObjectContainer, parent:DisplayObjectContainer, point:Point = null):Point
		{
			if (point == null)
			{
				point = new Point(0, 0);
			}

			point.x += child.x;
			point.y += child.y;
			if (child.parent != parent)
			{
				findRelativeLocation(child.parent, parent, point);
			}
			return point;
		}

		/**
		 * 解析宏表达式 (替换 $[*] 之间的内容)
		 * @param input
		 * @param element 元素对象
		 * @param canvas 画布对象
		 * @return
		 *
		 */
		public static function parseMacro(input:String, element:IGetProperty, canvas:IGetProperty):String
		{
			//log.info("parseMacro");
			if (input == null)
			{
				return null;
			}

			var pos:int = -1;
			var end:int = -1;
			var originalValue:String = null;
			var replaceValue:String = null;
			for (pos = input.indexOf("$["); pos != -1; pos = input.indexOf("$["))
			{

				end = input.indexOf("]", pos);

				//log.info("for 循环中");
				if (end == -1)
				{
					return input;
				}
				originalValue = input.substring(pos + 2, end);
				if (StringUtils.startsWithIgnoreCase(originalValue, "canvas:"))
				{
					//log.info(" canvas.getProperty");
					replaceValue = canvas.getProperty(originalValue.substring(7));
				}
				else
				{
					//log.info(" element.getProperty");
					replaceValue = element.getProperty(originalValue);
				}
				if (replaceValue != null)
				{
					log.debug("TopoUtil.parseMacro 找到$[{0}]属性", replaceValue);
					input = input.replace("$[" + originalValue + "]", replaceValue);
				}
				else
				{
					log.debug("TopoUtil.parseMacro 没有找到$[{0}]属性", originalValue);
					input = input.replace("$[" + originalValue + "]", MACRO_NULL);
				}

			}
			return input;
		}

		/**
		 * 解析批量宏表达式
		 * @param input
		 * @param features
		 * @return
		 *
		 */
		public static function parseMultMacro(input:String, features:Array, canvas:IGetProperty):String
		{
			// $MULT_START$[gather_id],$[alarmuniqueid],$[neid];$MULT_END
			if (input == null || features.length == 0)
			{
				return null;
			}

			var pos:int = -1;
			var end:int = -1;
			var originalValue:String = null;
			var replaceValue:String = null;

			var splitStart:String = "$MULT_START";
			var splitEnd:String = "$MULT_END";
			for (pos = input.indexOf(splitStart); pos != -1; pos = input.indexOf(splitStart))
			{
				end = input.indexOf(splitEnd, pos);
				if (end == -1)
				{
					return input;
				}
				originalValue = input.substring(pos + splitStart.length, end);
				replaceValue = "";
				features.forEach(function(item:Feature, index:int, array:Array):void
					{
						replaceValue += parseMacro(originalValue, item.element, canvas);
					});
				input = input.replace(splitStart + originalValue + splitEnd, replaceValue);
			}
			return parseMacro(input, (features[0] as Feature).element, canvas);
		}

		/**
		 * 检查验证器(通过返回0,不通过返回-1)
		 * @param validator
		 * @return
		 *
		 */
		public static function checkValidator(validator:Validator):int
		{
			return validator.validate().results == null ? 0 : -1;
		}

		/**
		 * 检查一批验证器,每个验证器都要走过,最终返回验证结果是否全部通过
		 * @param validators
		 * @return
		 *
		 */
		public static function checkValidators(validators:Array):Boolean
		{
			var num:int = 0;
			validators.forEach(function(validator:Validator, index:int, arr:Array):void
				{
					num += checkValidator(validator);
				});
			return num == 0
		}

		/**
		 * 根据两端对象的大小,修正A连接点坐标 (将两端对象中心点修正成为两端对象的边缘点)
		 * @param feature
		 * @param pointA
		 * @param pointZ
		 * @return
		 *
		 */
		public static function reviseAPoint(feature:Feature, pointA:Point, pointZ:Point):Point
		{

			// tanα = (y2-y1)/(x2-x1) = P / (width/2)  ==>  P = (width/2) * ((y2-y1)/(x2-x1))
			var p:Number = (feature.width * (pointZ.y - pointA.y)) / (2 * (pointZ.x - pointA.x));

			// tanβ = (x2-x1)/(y2-y1) = Q / (height/2)  ==> Q = (height/2) * ((x2-x1)/(y2-y1))
			var q:Number = (feature.height * (pointZ.x - pointA.x)) / (2 * (pointZ.y - pointA.y))

			var x:Number = 0;
			var y:Number = 0;

			// 逻辑如下:
			// 如果 \P\< h/2
			//            x2 >  x1 :  x' = x1 + w/2
			//            x2 <= x1 :  x' = x1 - w/2
			//            y2 >  y1 :  y' = y1 + |P|
			//            y2 <= y1 :  y' = y1 - |P|
			// 如果 \P\>= h/2
			//            x2 >  x1 :  x' = x1 + |Q|
			//            x2 <= x1 :  x' = x1 - |Q|
			//            y2 >  y1 :  y' = y1 + h/2
			//            y2 <= y1 :  y' = y1 - h/2
			// end
			if (Math.abs(p) < (feature.height / 2))
			{
				if (pointZ.x > pointA.x)
				{
					x = pointA.x + feature.width / 2;
				}
				else
				{
					x = pointA.x - feature.width / 2;
				}
				if (pointZ.y > pointA.y)
				{
					y = pointA.y + Math.abs(p);
				}
				else
				{
					y = pointA.y - Math.abs(p);
				}
			}
			else
			{
				if (pointZ.x > pointA.x)
				{
					x = pointA.x + Math.abs(q);
				}
				else
				{
					x = pointA.x - Math.abs(q);
				}
				if (pointZ.y > pointA.y)
				{
					y = pointA.y + (feature.height / 2);
				}
				else
				{
					y = pointA.y - (feature.height / 2);
				}
			}
			return new Point(x, y);
		}

		/**
		 * 显示UI对象
		 * @param ui
		 *
		 */
		public static function showUI(ui:UIComponent):void
		{
			ui.visible = true;
			ui.includeInLayout = true;
		}

		/**
		 * 隐藏UI对象
		 * @param ui
		 *
		 */
		public static function hideUI(ui:UIComponent):void
		{
			ui.visible = false;
			ui.includeInLayout = false;
		}

		/**
		 * 执行无参数的回调
		 * @param callback
		 *
		 */
		public static function noParamCallBack(callback:Function):void
		{
			if (callback != null)
			{
				callback.call();
			}
		}

		/**
		 * 截取xml文件,将 最后一个 ">" 后面的内容去掉
		 * @param input
		 * @return
		 *
		 */
		public static function subXmlStr(input:String):String
		{
			var index:int = input.lastIndexOf(">");
			if (index != -1)
			{
				return input.substring(0, index + 1);
			}
			else
			{
				return input;
			}
		}

		/**
		 * 找到在画布上绘制的对象(如果对象在分组中,找到直接放在画布中的分组对象)
		 * @param element
		 * @return
		 *
		 */
		public static function findElementDrawOnCanvas(element:ITPPoint):ITPPoint
		{
			var result:ITPPoint = element;
			while (result.groupOwner != null)
			{
				result = result.groupOwner;
			}
			return result;
		}

		/**
		 * 找到平均的百分比数组
		 */
		public static function findAvgPercent(count:int):Array
		{
			var array:Array = [];
			var avg:Number = Number((1 / count).toFixed(4));
			var total:Number = 0;
			for (var i:int = 0; i < count; i++)
			{
				if (i == count - 1)
				{
					// 防止全部加起来不是1,数组最后使用1-前面全部
					array.push(Number((1 - total).toFixed(4)));
				}
				else
				{
					array.push(avg);
					total += avg;
				}
			}
			return array;
		}

		/**
		 * 找到连续序号的数组
		 */
		public static function findSerial(count:int, serial:ISerial):Array
		{
			var array:Array = [];
			for (var i:int = 0; i < count; i++)
			{
				if (i == 0)
				{
					array.push(serial.current);
				}
				else
				{
					array.push(serial.next());
				}
			}
			return array;

		}

	}
}