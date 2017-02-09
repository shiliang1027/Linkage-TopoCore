package com.linkage.module.topo.framework.core.model.element
{
	import com.linkage.module.topo.framework.core.Feature;
	import com.linkage.module.topo.framework.core.model.alarm.IAlarm;
	import com.linkage.module.topo.framework.core.parser.ElementProperties;
	import com.linkage.module.topo.framework.core.parser.element.IElementParser;
	import com.linkage.module.topo.framework.view.component.TopoLayer;
	import com.linkage.system.structure.map.IMap;
	import com.linkage.system.structure.map.Map;
	import com.linkage.system.utils.StringUtils;

	import flash.events.EventDispatcher;
	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	/**
	 * 元素
	 * @author duangr
	 *
	 */
	public class Element extends EventDispatcher implements IElement
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.core.model.element.Element");
		// 数据解析器
		private var _parser:IElementParser = null;
		// 扩展属性容器
		private var _extendProperties:IMap = new Map();
		// 元素编号
		private var _id:String = null;
		// 元素名称
		private var _name:String = null;
		// 元素类型
		private var _type:String = null;
		// 元素样式
		private var _style:String = null;
		// z-index
		private var _zindex:int = 0;
		// 是否显示(0隐藏，1显示)
		private var _visible:int = 1;
		// 告警对象
		private var _alarm:IAlarm = null;
		// 元素是否发生变化
		private var _changed:Boolean = false;
		// 拓扑展现要素
		private var _feature:Feature = null;
		//客户端端口
		private var _cteName:String = null;
		//服务器端口
		private var _steName:String = null;
		
		private var _ctePort:String = null;
		//服务器端口
		private var _stePort:String = null;
		
		private var _circuit_code:String = null;
		private var _textLabel:String = null;


		public function Element()
		{
		}

		public function get weight():uint
		{
			return 0;
		}

		public function get itemName():String
		{
			throw new Error("Element.itemName must be implement by subclass");
		}

		public function get id():String
		{
			return _id;
		}

		public function set id(id:String):void
		{
			this._id = id;
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(name:String):void
		{
			this._name = name;
		}
		
		public function get type():String
		{
			return _type;
		}

		public function set type(type:String):void
		{
			this._type = type;
		}
		public function get textLabel():String
		{
			return _textLabel;
		}

		public function set textLabel(type:String):void
		{
			this._textLabel = textLabel;
		}

		public function get style():String
		{
			return this._style;
		}

		public function set style(value:String):void
		{
			this._style = value;
		}

		public function get zindex():int
		{
			return _zindex;
		}

		public function set zindex(value:int):void
		{
			this._zindex = value;
		}


		public function get visible():int
		{
			return _visible;
		}

		public function set visible(visible:int):void
		{
			this._visible = visible;
		}
		
		public function get cteName():String
		{
			return _cteName;
		}
		
		public function set cteName(value:String):void
		{
			this._cteName = value;
		}
		public function get steName():String
		{
			return _steName;
		}
		
		public function set steName(value:String):void
		{
			this._steName = value;
		}
		public function get ctePort():String
		{
			return _ctePort;
		}
		
		public function set ctePort(value:String):void
		{
			this._ctePort = value;
		}
		
		public function get stePort():String
		{
			return _stePort;
		}
		
		public function set stePort(value:String):void
		{
			this._stePort = value;
		}
		public function get circuit_code():String
		{
			return _circuit_code;
		}
		
		public function set circuit_code(value:String):void
		{
			this._circuit_code = value;
		}


		public function addMoveXY(x:Number, y:Number):void
		{
			// 空方法
		}

		public function get labelLayout():String
		{
			return StringUtils.isEmpty(getExtendProperty(ElementProperties.LABEL_LAYOUT)) ? ElementProperties.DEFAULT_LABEL_LAYOUT : getExtendProperty(ElementProperties.LABEL_LAYOUT);
		}

		public function set labelLayout(value:String):void
		{
			this.addExtendProperty(ElementProperties.LABEL_LAYOUT, value);
		}

		public function get labelTooltip():String
		{
			return StringUtils.isEmpty(getExtendProperty(ElementProperties.LABEL_TOOLTIP)) ? name : getExtendProperty(ElementProperties.LABEL_TOOLTIP);
		}

		public function set labelTooltip(value:String):void
		{
			this.addExtendProperty(ElementProperties.LABEL_TOOLTIP, value);
		}

		public function get labelMaxWidth():Number
		{
			return StringUtils.isEmpty(getExtendProperty(ElementProperties.LABEL_MAXWIDTH)) ? ElementProperties.DEFAULT_LABEL_MAXWIDTH : Number(getExtendProperty(ElementProperties.LABEL_MAXWIDTH));
		}

		public function set labelMaxWidth(value:Number):void
		{
			this.addExtendProperty(ElementProperties.LABEL_MAXWIDTH, String(value));
		}

		public function get feature():Feature
		{
			return this._feature;
		}

		public function set feature(value:Feature):void
		{
			this._feature = value;
		}

		public function copyFrom(element:IElement):void
		{
			id = element.id;
			name = element.name;
			type = element.type;
			style = element.style;
			zindex = element.zindex;
			visible = element.visible;
			element.eachExtendProperty(function(key:String, value:String):void
				{
					addExtendProperty(key, value);
				});

		}

		public function parseData(parser:IElementParser, data:Object, topoCanvas:TopoLayer):Boolean
		{
			return parser.parse(this, data, topoCanvas);
		}

		public function output(parser:IElementParser):*
		{
			return parser.output(this);
		}

		public function get alarmEnabled():Boolean
		{
			return false;
		}

		public function get alarm():IAlarm
		{
			return _alarm;
		}

		public function set alarm(value:IAlarm):void
		{
			this._alarm = value;
		}

		public function get changed():Boolean
		{
			return _changed;
		}

		public function set changed(value:Boolean):void
		{
			_changed = value;
		}

		public function refresh():void
		{

		}

		public function destroy():void
		{
			_parser = null;
			_extendProperties.clear();
			_extendProperties = null;
			_alarm = null;
			_feature = null;
		}

		public function clearExtendProperties():void
		{
			_extendProperties.clear();
		}

		public function addExtendProperty(key:String, value:String):void
		{
			_extendProperties.put(key, value);
		}

		public function removeExtendProperty(key:String):void
		{
			_extendProperties.remove(key);
		}

		public function eachExtendProperty(callback:Function, thisObject:* = null):void
		{
			_extendProperties.forEach(function(key:*, value:*):void
				{
					callback.call(thisObject, key, value);
				});
		}

		public function getExtendProperty(key:String):String
		{
			return _extendProperties.get(key);
		}

		public function getProperty(key:String):String
		{
			var returnValue:String = null;

			switch (key)
			{
				case "id":
					returnValue = this._id;
					break;
				case "name":
					returnValue = this._name;
					break;
				case "type":
					returnValue = this._type;
					break;
				case "zindex":
					returnValue = this._zindex.toString();
					break;
				case "visible":
					returnValue = this._visible.toString();
					break;
				default:
					// 从属性容器里面取数据
					returnValue = getExtendProperty(key);
					break;
			}
			return returnValue;
		}

		public function eachProperty(callback:Function, thisObject:* = null):void
		{
			if (callback == null)
			{
				return;
			}
			callback.call(thisObject, "id", this._id);
			callback.call(thisObject, "name", this._name);
			callback.call(thisObject, "type", this._type);
			callback.call(thisObject, "zindex", this._zindex);
			callback.call(thisObject, "visible", this._visible);
			callback.call(thisObject, "alarm", this._alarm);

			eachExtendProperty(callback, thisObject);
		}

		public function resetElementIndex(index:int = -1):void
		{
		}

		override public function toString():String
		{
			return "Element(" + id + ": " + name + " / " + type + ")";
		}
	}
}