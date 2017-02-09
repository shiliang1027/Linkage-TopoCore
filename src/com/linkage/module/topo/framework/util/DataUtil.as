package com.linkage.module.topo.framework.util
{
	import com.linkage.module.topo.framework.Constants;
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.model.element.line.ILink;
	import com.linkage.module.topo.framework.core.model.element.plane.ITPGroup;
	import com.linkage.module.topo.framework.core.model.element.point.INode;
	import com.linkage.module.topo.framework.core.model.element.point.ISegment;
	import com.linkage.module.topo.framework.core.model.element.point.ITPPoint;
	import com.linkage.module.topo.framework.core.parser.IParserFactory;
	import com.linkage.module.topo.framework.data.IDataSource;
	import com.linkage.module.topo.framework.view.component.TopoLayer;
	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;
	import com.linkage.system.structure.map.IMap;
	import com.linkage.system.structure.map.Map;
	import com.linkage.system.utils.StringUtils;

	import mx.utils.StringUtil;

	public class DataUtil
	{
		// log
		private static var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.util.DataUtil");
		// 拓扑图额外参数容器
		private static var _paramsMap:IMap = new Map();
		// 拓扑图字符串形式的参数
		private static var _params:String = "";

		/**
		 * 添加参数(这些参数都会发给MC)
		 * @param key
		 * @param value
		 *
		 */
		public static function addParameter(key:String, value:String):void
		{
			_paramsMap.put(key, value);
			_params += "<map key=\"" + key + "\">" + value + "</map>";
		}

		/**
		 * 获取参数值
		 * @param key
		 * @return
		 *
		 */
		public static function getParameter(key:String):String
		{
			return _paramsMap.get(key);
		}


		/**
		 * 根据单个主题和内容拼装XML
		 * @param topic
		 * @param data
		 * @return
		 *
		 */
		public static function buildXML(topic:String, data:String):String
		{
			return "<?xml version=\"1.0\" encoding=\"GBK\" ?><WebTopo><NetView><Action><topic>" + topic + "</topic><data>" + data + _params + "</data></Action></NetView></WebTopo>";
		}

		/**
		 * 根据单个key和value构造属性XML
		 * @param key
		 * @param value
		 * @return
		 *
		 */
		public static function buildPropertyXML(key:String, value:*):String
		{
			return "<p k=\"" + key + "\">" + String(value) + "</p>"
		}

		/**
		 * 根据单个key和value构造XML
		 * @param key
		 * @param value
		 * @return
		 *
		 */
		public static function buildMapXML(key:String, value:*):String
		{
			return "<map key=\"" + key + "\"><![CDATA[" + String(value) + "]]></map>";
		}

		/**
		 *	根据key和list构造XML
		 * @param key
		 * @param list
		 * @return
		 *
		 */
		public static function buildListXML(key:String, list:Array):String
		{
			var xml:String = "<list key=\"" + key + "\">";
			for each (var s:Object in list)
			{
				xml += "<val>" + s + "</val>";
			}
			xml += "</list>"
			return xml;
		}

		/**
		 * 后台操作返回的结果对象map
		 * @param xml
		 * @return
		 *
		 */
		public static function getActionResultMap(xml:XML):IMap
		{
			var map:IMap = new Map();
			if (xml == null)
			{
				return map;
			}
			// 返回结果嵌套的比较深
			try
			{
				//  WebTopo -> NetView -> ActionResult -> data
				var datas:XMLList = xml.child("NetView")[0].child("ActionResult")[0].child("data")[0].children();
				for each (var e:XML in datas)
				{
					map.put(String(e.@key), StringUtil.trim(String(e)));
				}
			}
			catch (e:Error)
			{
				log.error("getActionResultMap异常: {0}", e);
			}
			return map;
		}

		/**
		 * 判断返回的结果是否成功
		 * @param xml
		 * @return
		 *
		 */
		public static function isResultSuccess(xml:XML):Boolean
		{
			var flag:Boolean = false;

			// 返回结果嵌套的比较深
			//  WebTopo -> NetView -> ActionResult -> data
			var datas:XMLList = xml.child(0).child(0).child(0).children();
			for each (var e:XML in datas)
			{
				if (e.@key == "success")
				{
					if (e.toString() == "1")
					{
						flag = true;

					}
					else
					{
						flag = false;
					}
					break;
				}
			}
			return flag;
		}

		/**
		 * 构造整个拓扑图的输出
		 * @param topoLayer
		 * @param id
		 * @return
		 *
		 */
		public static function buildOutputWebtopo(topoLayer:TopoLayer, id:String = null):String
		{
			var nodes:Array = [];
			topoLayer.eachNode(function(id:String, node:INode):void
				{
					nodes.push(node);
				});
			var segments:Array = [];
			topoLayer.eachSegment(function(id:String, segment:ISegment):void
				{
					segments.push(segment);
				});
			var groups:Array = [];
			topoLayer.eachGroup(function(id:String, group:ITPGroup):void
				{
					groups.push(group);
				});
			var links:Array = [];
			topoLayer.eachLink(function(id:String, link:ILink):void
				{
					links.push(link);
				});
			var objects:Array = [];
			topoLayer.eachObject(function(id:String, element:IElement):void
				{
					objects.push(element);
				});

			return buildOutputWebtopoWrapper(buildOutputNodes(nodes, topoLayer.parserFactory) + buildOutputSegments(segments, topoLayer.parserFactory) + buildOutputObjects(objects, topoLayer.parserFactory) +
				buildOutputGroups(groups, topoLayer.parserFactory) + buildOutputLinks(links, topoLayer.parserFactory), id);
		}

		/**
		 * 构造完整的webopo的输出,数据是传入的
		 *
		 * @param data
		 * @param id
		 * @return
		 *
		 */
		public static function buildOutputWebtopoWrapper(data:String, id:String = null):String
		{

			return "<WebTopo><NetView id=\"" + (StringUtils.isNullStr(id) ? "" : id) + "\">" + data + "</NetView></WebTopo>";
		}

		/**
		 * 构造单个对象的输出格式
		 * @param element
		 * @param parserFactory
		 * @return
		 *
		 */
		public static function buildOutputElement(element:IElement, parserFactory:IParserFactory):String
		{
			var outputArray:Array = [];
			outputArray.push("<" + element.itemName + "s>");
			outputArray.push(element.output(parserFactory.buildElementParser(element)));
			outputArray.push("</" + element.itemName + "s>");
			return outputArray.join("");
		}

		/**
		 * 构造节点的输出格式
		 * @param nodes
		 * @param parserFactory
		 * @return
		 *
		 */
		public static function buildOutputNodes(nodes:Array, parserFactory:IParserFactory):String
		{
			var outputArray:Array = [];
			outputArray.push("<Nodes>");
			nodes.forEach(function(item:INode, index:int, array:Array):void
				{
					outputArray.push(item.output(parserFactory.buildElementParser(item)));
				});
			outputArray.push("</Nodes>");
			return outputArray.join("");
		}

		/**
		 * 构造网段的输出格式
		 * @param nodes
		 * @param parserFactory
		 * @return
		 *
		 */
		public static function buildOutputSegments(segments:Array, parserFactory:IParserFactory):String
		{
			var outputArray:Array = [];
			outputArray.push("<Segments>");
			segments.forEach(function(item:ISegment, index:int, array:Array):void
				{
					outputArray.push(item.output(parserFactory.buildElementParser(item)));
				});
			outputArray.push("</Segments>");
			return outputArray.join("");
		}

		/**
		 * 构造分组的输出格式
		 * @param groups
		 * @param parserFactory
		 * @return
		 *
		 */
		public static function buildOutputGroups(groups:Array, parserFactory:IParserFactory):String
		{
			var outputArray:Array = [];
			outputArray.push("<Groups>");
			groups.forEach(function(item:ITPGroup, index:int, array:Array):void
				{
					outputArray.push(item.output(parserFactory.buildElementParser(item)));
				});
			outputArray.push("</Groups>");
			return outputArray.join("");
		}

		/**
		 * 构造链路的输出格式
		 * @param groups
		 * @param parserFactory
		 * @return
		 *
		 */
		public static function buildOutputLinks(links:Array, parserFactory:IParserFactory):String
		{
			var outputArray:Array = [];
			outputArray.push("<Links>");
			links.forEach(function(item:ILink, index:int, array:Array):void
				{
					outputArray.push(item.output(parserFactory.buildElementParser(item)));
				});
			outputArray.push("</Links>");
			return outputArray.join("");
		}

		/**
		 * 构造对象的输出格式
		 * @param objects
		 * @param parserFactory
		 * @return
		 *
		 */
		public static function buildOutputObjects(objects:Array, parserFactory:IParserFactory):String
		{
			var outputArray:Array = [];
			outputArray.push("<Objects>");
			objects.forEach(function(item:IElement, index:int, array:Array):void
				{
					outputArray.push(item.output(parserFactory.buildElementParser(item)));
				});
			outputArray.push("</Objects>");
			return outputArray.join("");
		}

		/**
		 * 构造TopoSql: 大于
		 * @param key
		 * @param value
		 * @return
		 *
		 */
		public static function buildTopoSqlMoreThan(key:String, value:String):String
		{
			return key + ">" + value;
		}

		/**
		 * 构造TopoSql: 小于
		 * @param key
		 * @param value
		 * @return
		 *
		 */
		public static function buildTopoSqlLessThan(key:String, value:String):String
		{
			return key + "<" + value;
		}

		/**
		 * 构造TopoSql: 等于
		 * @param key
		 * @param value
		 * @return
		 *
		 */
		public static function buildTopoSqlEqual(key:String, value:String):String
		{
			return key + "=" + value;
		}

		/**
		 * 构造TopoSql: 不小于(&gt;=)
		 * @param key
		 * @param value
		 * @return
		 *
		 */
		public static function buildTopoSqlNoLessThan(key:String, value:String):String
		{
			return key + ">=" + value;
		}

		/**
		 * 构造TopoSql: 不大于(&lt;=)
		 * @param key
		 * @param value
		 * @return
		 *
		 */
		public static function buildTopoSqlNoMoreThan(key:String, value:String):String
		{
			return key + "<=" + value;
		}

		/**
		 * 构造TopoSql: 不等于(!=)
		 * @param key
		 * @param value
		 * @return
		 *
		 */
		public static function buildTopoSqlNoEqual(key:String, value:String):String
		{
			return key + "!=" + value;
		}

		/**
		 * 构造TopoSql: 被包含于
		 * @param key
		 * @param values
		 * @return
		 *
		 */
		public static function buildTopoSqlExist(key:String, values:Array):String
		{
			return key + " exist [" + values.join(",") + "]";
		}

		/**
		 * 构造TopoSql: 不被包含于
		 * @param key
		 * @param values
		 * @return
		 *
		 */
		public static function buildTopoSqlNoExist(key:String, values:Array):String
		{
			return key + " not exist [" + values.join(",") + "]";
		}

		/**
		 * 构造TopoSql: 包含
		 * @param key
		 * @param values
		 * @return
		 *
		 */
		public static function buildTopoSqlLike(key:String, value:String):String
		{
			return key + " like " + value;
		}

		/**
		 * 构造TopoSql: 不包含
		 * @param key
		 * @param values
		 * @return
		 *
		 */
		public static function buildTopoSqlNoLike(key:String, value:String):String
		{
			return key + " not like " + value;
		}

		/**
		 * 构造最终的TopoSql: AND逻辑
		 * @param array
		 * @return
		 *
		 */
		public static function buildFinalTopoSql_And(array:Array):String
		{
			return array.join(" AND ");
		}

		/**
		 * 保存元素的扩展属性
		 * @param dataSource
		 * @param pid 网元pid
		 * @param topoName
		 * @param element
		 * @param success 成功后回调,格式为: function(map:IMap):void{ ... }
		 * @param complete 不管成功还是失败的回调,无参数
		 * @param error 失败后回调,无参数
		 *
		 */
		public static function saveElementExtendProperties(dataSource:IDataSource, pid:String, topoName:String, element:IElement, success:Function, complete:Function = null, error:Function = null):void
		{
			var properties:Array = [];
			element.eachExtendProperty(function(key:String, value:String):void
				{
					properties.push(DataUtil.buildPropertyXML(key, value));
				});

			var data:String = DataUtil.buildMapXML(Constants.XML_KEY_ELEMENTXML, "<Elements><Element>" + properties.join("") + "</Element></Elements>");
			data += DataUtil.buildMapXML(Constants.XML_KEY_PID, pid);
			data += DataUtil.buildListXML(Constants.XML_KEY_ID, [element.id]);
			data = DataUtil.buildXML(Constants.TP_MC_MODIFY_ELEMENTATTRIBUTE, data);

			dataSource.notify(topoName, data, function(result:String):void
				{
					success.call(null, DataUtil.getActionResultMap(new XML(result)));
				}, function():void
				{
					TopoUtil.noParamCallBack(complete);
				}, function():void
				{
					TopoUtil.noParamCallBack(error);
				});
		}
	}
}

