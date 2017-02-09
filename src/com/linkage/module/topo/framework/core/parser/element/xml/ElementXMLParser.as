package com.linkage.module.topo.framework.core.parser.element.xml
{

	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.parser.ElementProperties;
	import com.linkage.module.topo.framework.core.parser.element.IElementParser;
	import com.linkage.module.topo.framework.util.DataUtil;
	import com.linkage.module.topo.framework.view.component.TopoLayer;
	import com.linkage.system.structure.map.IMap;
	import com.linkage.system.structure.map.Map;
	import com.linkage.system.utils.StringUtils;

	/**
	 * 元素XML数据解析器
	 * @author duangr
	 *
	 */
	public class ElementXMLParser implements IElementParser
	{
		// 不需要output的扩展属性以及对应值
		private var _notOutputExtendPropertys:IMap = new Map();

		public function ElementXMLParser()
		{
			appendNotOutputExtendProperty(ElementProperties.LABEL_LAYOUT, ElementProperties.DEFAULT_LABEL_LAYOUT);
			appendNotOutputExtendProperty(ElementProperties.LABEL_TOOLTIP, "");
		}

		public function parse(e:IElement, data:Object, topoCanvas:TopoLayer):Boolean
		{
			e.id = data.@id;
			e.name = data.@name;
			e.type = data.@type;
			e.style = data.@style;
			e.zindex = int(data.@zindex);
			e.visible = int(data.@visible);

			for each (var o:Object in data.p)
			{
				e.addExtendProperty(o.@k, o.toString());
			}
			return true;
		}

		final public function output(e:IElement):*
		{
			return "<" + e.itemName + " " + this.outputCommonAttr(e) + ">" + outputExtendProperties(e) + "</" + e.itemName + ">";
		}

		/**
		 * 输出公共的XML属性部分
		 * @param e
		 * @return
		 *
		 */
		protected function outputCommonAttr(e:IElement):String
		{
			return "id=\"" + trimNull(e.id) + "\" name=\"" + trimNull(e.name)  +"\"  type=\"" + trimNull(e.type) + "\" visible=\"" + e.visible + "\" style=\"" + trimNull(e.style) + "\" zindex=\"" + e.
				zindex + "\"";
		}

		/**
		 * 输出扩展属性部分
		 * @param e
		 * @return
		 *
		 */
		private function outputExtendProperties(e:IElement):String
		{
			var extendProperties:Array = [];
			e.eachExtendProperty(function(key:String, value:String):void
				{
					if (!StringUtils.isNullStr(value) && checkOutputExtendProperty(key, value))
					{
						extendProperties.push(DataUtil.buildPropertyXML(key, value));
					}
				});
			return extendProperties.join("");
		}

		/**
		 * 验证扩展属性是否满足output的条件
		 * @param key
		 * @param value
		 * @return
		 *
		 */
		private function checkOutputExtendProperty(key:String, value:String):Boolean
		{
			var defaultValue:String = _notOutputExtendPropertys.get(key);
			if (defaultValue != null)
			{
				return value != defaultValue;
			}
			return true;
		}

		/**
		 * 添加不需要 output的扩展属性以及对应值
		 * @param key
		 * @param value
		 *
		 */
		protected function appendNotOutputExtendProperty(key:String, value:*):void
		{
			_notOutputExtendPropertys.put(key, String(value));
		}

		/**
		 * 替换NULL
		 * @param input
		 * @return
		 *
		 */
		protected function trimNull(input:String):String
		{
			return input ? input : "";
		}

	}
}