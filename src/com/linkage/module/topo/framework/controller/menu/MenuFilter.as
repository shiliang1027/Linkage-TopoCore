package com.linkage.module.topo.framework.controller.menu
{


	import com.linkage.module.topo.framework.core.Feature;
	import com.linkage.module.topo.framework.util.TopoUtil;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;
	import com.linkage.system.utils.StringUtils;

	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;
	import mx.utils.StringUtil;
	/**
	 * 菜单过滤器,验证告警和菜单是否匹配
	 * @author duangr
	 *
	 */
	public class MenuFilter
	{
		// log
		private static var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.controller.menu.MenuFilter");

		/**
		 * 验证菜单是否匹配传入的单个拓扑要素
		 * @param menuRes
		 * @param feature
		 * @param canvas
		 * @return
		 *
		 */
		public static function acceptFeature(menuRes:MenuResItem, feature:Feature, canvas:TopoCanvas):Boolean
		{
//			log.debug("acceptFeature {0} feature:{1}", menuRes, feature);
			if (feature == null || menuRes == null)
			{
				// 没有元素或者菜单,直接false
				return false;
			}
			// 先验证 ActionWeight 和 ElementWeight
			if ((menuRes.actionWeight & canvas.action.weight) != canvas.action.weight)
			{
				return false;
			}
			if ((menuRes.elementWeight & feature.element.weight) != feature.element.weight)
			{
				return false;
			}
			// 再验证 filter
			if (StringUtils.isEmpty(menuRes.filter))
			{
				// 过滤规则不存在,直接true
				return true;
			}
			return extractComplexLogic(TopoUtil.parseMacro(menuRes.filter, feature.element, canvas));
		}

		/**
		 * 验证菜单能否在画布空白处出现
		 * @param menuRes
		 * @param canvas
		 * @return
		 *
		 */
		public static function acceptCanvas(menuRes:MenuResItem, canvas:TopoCanvas):Boolean
		{
//			log.debug("acceptCanvas {0} ", menuRes);
			// 先验证 ActionWeight 和 ElementWeight
			if ((menuRes.actionWeight & canvas.action.weight) != canvas.action.weight)
			{
				return false;
			}
			if ((menuRes.elementWeight & canvas.weight) != canvas.weight)
			{
				return false;
			}
			// 再验证 filter
			if (StringUtils.isEmpty(menuRes.filter))
			{
				// 过滤规则不存在,直接true
				return true;
			}
			return extractComplexLogic(TopoUtil.parseMacro(menuRes.filter, canvas, canvas));
		}

		/**
		 * 验证菜单是否匹配传入的一批拓扑要素
		 * @param menuRes
		 * @param features
		 * @param canvas
		 * @return
		 *
		 */
		public static function acceptFeatures(menuRes:MenuResItem, features:Array, canvas:TopoCanvas):Boolean
		{
//			log.debug("acceptFeatures {0} num:{1}", menuRes, features.length);
			if (features == null || features.length == 0 || menuRes == null)
			{
				// 没有元素或者菜单,直接false
				return false;
			}
			// 验证菜单是否支持批量
			if (features.length > 1 && menuRes.multiple == false)
			{
				// 菜单不支持批量时,直接false
				return false;
			}

			return features.every(function(feature:Feature, index:int, array:Array):Boolean
				{
					return acceptFeature(menuRes, feature, canvas);
				});
		}

		/**
		 * 提取复合逻辑, 含括号的逻辑,注意 只能出现一维括号,不允许括号的嵌套
		 * @param input
		 * @return
		 *
		 */
		private static function extractComplexLogic(input:String):Boolean
		{
			if (input == null)
			{
				return false;
			}
			// 先判断是否存在 ") or (" 或者 ") and ("  
			if (input.indexOf(") or (") != -1)
			{
				var orArray:Array = input.substring(1, input.length - 1).split(") or (");
				return orArray.some(function(item:String, index:int, array:Array):Boolean
					{
						return extractSepartor(item);
					});
			}
			if (input.indexOf(") and (") != -1)
			{
				var andArray:Array = input.substring(1, input.length - 1).split(") and (");
				return andArray.every(function(item:String, index:int, array:Array):Boolean
					{
						return extractSepartor(item);
					});
			}
			return extractSepartor(input);
		}


		/**
		 * 提取分隔符 ( or  或者  and ,不能同时出现),注意前后都有空格
		 * @param s
		 * @return
		 *
		 */
		private static function extractSepartor(input:String):Boolean
		{
//			log.debug("extractSepartor {0}", input);
			if (input == null)
			{
				return false;
			}
			if (input.indexOf(" and ") != -1)
			{
				var andArray:Array = input.split(" and ");
				return andArray.every(function(item:String, index:int, array:Array):Boolean
					{
						return accept(item);
					});
			}
			if (input.indexOf(" or ") != -1)
			{
				var orArray:Array = input.split(" or ");
				return orArray.some(function(item:String, index:int, array:Array):Boolean
					{
						return accept(item);
					});
			}
			return accept(input);
		}

		/**
		 * 验证字符串是否pass (支持 notNull(),isNull(), ==, !=, >, >=, <, <=, RegExp(正则表达式)test(待验证字符)pxEgeR )
		 * @param s
		 * @return
		 *
		 */
		private static function accept(s:String):Boolean
		{
			if (s == null)
			{
				return false;
			}
			var array:Array = null;
			var leftNumber:Number = NaN;
			var rightNumber:Number = NaN;

			var pos:int = 0;
			var end:int = 0;
			if (s.indexOf("notNull(") != -1)
			{
				pos = s.indexOf("notNull(");
				end = s.indexOf(")", pos);
				return StringUtil.trim(s.substring(pos + 8, end)) != TopoUtil.MACRO_NULL;
			}
			else if (s.indexOf("isNull(") != -1)
			{
				pos = s.indexOf("isNull(");
				end = s.indexOf(")", pos);
				return StringUtil.trim(s.substring(pos + 7, end)) == TopoUtil.MACRO_NULL;
			}

			else if (s.indexOf("!=") != -1)
			{
				// != 逻辑
				array = s.split("!=");

				if (array.length == 2)
				{
					return StringUtil.trim(array[0]) != StringUtil.trim(array[1]);
				}
				return false;
			}
			else if (s.indexOf("==") != -1)
			{
				// == 逻辑
				array = s.split("==");

				if (array.length == 2)
				{
					return StringUtil.trim(array[0]) == StringUtil.trim(array[1]);
				}
				return false;
			}
			else if (s.indexOf(">=") != -1)
			{
				// >= 逻辑
				array = s.split(">=");

				if (array.length == 2)
				{
					leftNumber = Number(StringUtil.trim(array[0]));
					rightNumber = Number(StringUtil.trim(array[1]));
					if (isNaN(leftNumber) || isNaN(rightNumber))
					{
						return false;
					}
					return leftNumber >= rightNumber;
				}
				return false;
			}
			else if (s.indexOf("<=") != -1)
			{
				// <= 逻辑
				array = s.split("<=");

				if (array.length == 2)
				{
					leftNumber = Number(StringUtil.trim(array[0]));
					rightNumber = Number(StringUtil.trim(array[1]));
					if (isNaN(leftNumber) || isNaN(rightNumber))
					{
						return false;
					}
					return leftNumber <= rightNumber;
				}
				return false;
			}
			else if (s.indexOf(">") != -1)
			{
				// >= 逻辑
				array = s.split(">");

				if (array.length == 2)
				{
					leftNumber = Number(StringUtil.trim(array[0]));
					rightNumber = Number(StringUtil.trim(array[1]));
					if (isNaN(leftNumber) || isNaN(rightNumber))
					{
						return false;
					}
					return leftNumber > rightNumber;
				}
				return false;
			}
			else if (s.indexOf("<") != -1)
			{
				// <= 逻辑
				array = s.split("<");

				if (array.length == 2)
				{
					leftNumber = Number(StringUtil.trim(array[0]));
					rightNumber = Number(StringUtil.trim(array[1]));
					if (isNaN(leftNumber) || isNaN(rightNumber))
					{
						return false;
					}
					return leftNumber < rightNumber;
				}
				return false;
			}
			else if (s.indexOf("RegExp(") != -1 && s.indexOf(")test(") != -1 && s.indexOf(")pxEgeR") != -1)
			{
				var index1:int = s.indexOf("RegExp(");
				var index2:int = s.indexOf(")test(", index1);
				var index3:int = s.indexOf(")pxEgeR", index2);
				var regStr:String = s.substring(index1 + 7, index2);
				var testValue:String = s.substring(index2 + 6, index3);
				var reg:RegExp = parseRegExp(regStr);
				if (reg)
				{
					return reg.test(testValue);
				}
				else
				{
					log.error("正则表达式格式错误 regStr={0} testValue={1}", regStr, testValue);
					return false;
				}
			}
			return false;
		}

		/**
		 * 将字符串解析成正则表达式对象
		 * @param input
		 * @return
		 *
		 */
		private static function parseRegExp(input:String):RegExp
		{
			log.debug("[parseRegExp] original = {0}", input);
			if (input == null)
			{
				log.error("[parseRegExp] 正则表达式不能为空");
				return null;
			}
			var startIndex:int = input.indexOf("/");
			var lastIndex:int = input.lastIndexOf("/");
			if (startIndex == -1 || lastIndex == -1 || startIndex == lastIndex)
			{
				log.error("[parseRegExp] 正则表达式格式错误 {0}", input);
				return null;
			}
			var re:String = input.substring(startIndex + 1, lastIndex);
			var flags:String = input.substr(lastIndex + 1);
			log.debug("[parseRegExp] 解析结果 re={0} flags={1}", re, flags);
			return new RegExp(re, flags);
		}
	}
}