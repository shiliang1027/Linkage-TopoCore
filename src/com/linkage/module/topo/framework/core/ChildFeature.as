package com.linkage.module.topo.framework.core
{
	import mx.core.IVisualElement;
	import mx.effects.IEffectInstance;
	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;
	
	import spark.components.Group;

	/**
	 * 
	 *拓扑要素类. 它包括对象模型,对象展现风格<br/>
	 */
	public class ChildFeature extends Group
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.core.ChildFeature");
		//对象的顺序
		private var _featureKey:String = null;
		//选中状态
		private var _selectStatue:Boolean = false;
		//起始端子对象(主要针对链路的)
		private var _fromEffectInstance:IEffectInstance = null;
		private var _fromFilterArray:Array = null;
		private var _fromElement:Group = null;
		//终止端子对象(主要针对链路的)
		private var _toEffectInstance:IEffectInstance = null;
		private var _toFilterArray:Array = null;
		private var _toElement:Group = null;
		//起始端级别
		private var _fromLevel:int = 0;
		//终止端级别
		private var _toLevel:int = 0;
		
		/**
		 *添加起始端对象 
		 */
		public function addFromElement(element:Group):void
		{
			//添加到容器里面
			addElement(element);
			
			//添加到容器里面
			_fromElement = element;
			
			//添加渲染规则
			if(_fromFilterArray && _fromFilterArray.length > 0)
			{
				_fromElement.filters = _fromFilterArray;
			}
			
			if(_fromElement)
			{
				_fromElement.mouseEnabled = false;
				_fromElement.mouseChildren = false;
			}
		}
		
		/**
		 *添加终止端对象 
		 */
		public function addToElement(element:Group):void
		{
			//添加到容器里面
			addElement(element);
			
			//添加到容器里面
			_toElement = element;
			
			//添加渲染规则
			if(_toFilterArray && _toFilterArray.length > 0)
			{
				_toElement.filters = _fromFilterArray;
			}
			
			if(_toElement)
			{
				_toElement.mouseEnabled = false;
				_toElement.mouseChildren = false;
			}
		}
		
		override public function removeAllElements():void
		{
			super.removeAllElements();
			
			if(_fromElement)
			{
				_fromFilterArray = _fromElement.filters;
			}
			if(_toElement)
			{
				_toFilterArray = _toElement.filters;
			}
			
			_fromElement = null;
			_toElement = null;
		}
		
		public function clearLevel():void
		{
			_fromFilterArray = null;
			_toFilterArray = null;
			
			_fromLevel = 0;
			_toLevel = 0;
		}
		
		public function get toEffectInstance():IEffectInstance
		{
			return _toEffectInstance;
		}
		
		public function set toEffectInstance(value:IEffectInstance):void
		{
			_toEffectInstance = value;
		}
		
		public function get fromEffectInstance():IEffectInstance
		{
			return _fromEffectInstance;
		}
		
		public function set fromEffectInstance(value:IEffectInstance):void
		{
			_fromEffectInstance = value;
		}
		
		public function set selectStatue(value:Boolean):void
		{
			_selectStatue = value;
		}
		
		public function get selectStatue():Boolean
		{
			return _selectStatue;
		}
		
		public function set featureKey(value:String):void
		{
			_featureKey = value;
		}
		
		public function get featureKey():String
		{
			return _featureKey;
		}
		
		public function set fromFilterArray(value:Array):void
		{
			_fromFilterArray = value;
		}
		
		public function set toFilterArray(value:Array):void
		{
			_toFilterArray = value;
		}
		
		public function set fromLevel(value:int):void
		{
			_fromLevel = value;
		}
		
		public function get fromLevel():int
		{
			return _fromLevel;
		}
		
		public function set toLevel(value:int):void
		{
			_toLevel = value;
		}
		
		public function get toLevel():int
		{
			return _toLevel;
		}
		
		public function get fromElement():Group
		{
			return _fromElement;
		}
		
		public function get toElement():Group
		{
			return _toElement;
		}
	}
}