package com.linkage.module.topo.framework.core
{
	import com.ailk.common.system.structure.map.Map;
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.style.element.IStyle;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;
	import com.linkage.module.topo.framework.view.component.TopoLayer;
	import com.linkage.module.topo.framework.view.component.spareparts.BubbleText;
	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;
	
	import flash.utils.getQualifiedClassName;
	
	import mx.controls.Alert;
	import mx.controls.Image;
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	import mx.effects.IEffectInstance;
	
	import spark.components.Group;

	/**
	 * 拓扑要素类. 它包括对象模型,对象展现风格<br/>
	 * 此对象只能放在Sprite的子类中
	 * @author duangr
	 *
	 */
	public class Feature extends Group
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.core.Feature");
		// 自身绘制的父对象
		private var _topoLayer:TopoLayer = null;
		// 拓扑画布
		private var _topoCanvas:TopoCanvas = null;
		// 元素
		private var _element:IElement = null;
		// 样式
		private var _style:IStyle = null;
		// 图标对象
		private var _icon:Image = null;
		// 扩展的组件
		private var _extendComponents:Array = [];
		// 是否选中的标志
		private var _selected:Boolean = false;

		// 是否初始化完成的标志
		private var _creationComplete:Boolean = false;

		// 实现被选中效果的形状
//		private var _selectShape:Group = new Group();
		// 效果实例
		private var _effectInstance:IEffectInstance = null;
		
		// 气泡提示框
		private var _bubbleText:BubbleText = null;
		// 标签
		private var _textLabel:IVisualElement = null;
		// 最后选中的元素
		private var _lastSelectFeature:ChildFeature = null;
		//子对象数组(主要针对链路的)
		private var _childMap:Map = new Map();
		
		//子对象中最高起始端级别
		private var _fromChildMaxLevel:int = 5;
		//子对象中最高终止端级别
		private var _toChildMaxLevel:int = 5;
		
		//一根线分成起始端、终止端两部分
		private var _fromElement:Group = null;
		
		private var _toElement:Group = null;
		
		private var _fromEffectInstance:IEffectInstance = null;
		private var _toEffectInstance:IEffectInstance = null;
		public function Feature(topoLayer:TopoLayer, topoCanvas:TopoCanvas, element:IElement, style:IStyle)
		{
			super();
			_topoLayer = topoLayer;
			_topoCanvas = topoCanvas;
			_style = style;
			_element = element;
			
			_element.feature = this;

		}

		/**
		 * 画带样式的元素
		 */
		public function drawWithStyle():void
		{
			_style.draw(this, _element, _topoLayer, _topoCanvas);
		}

		/**
		 * 对象变化后刷新
		 */
		public function refresh():void
		{
			_element.refresh();
			_style.refresh(this, _element, _topoLayer, _topoCanvas);
		}

		/**
		 * 告警变化后刷新
		 *
		 */
		public function refreshAlarm():void
		{
			_style.refreshAlarm(this, _element, _topoLayer, _topoCanvas);
		}

		/**
		 * 对象移动之后刷新
		 *
		 */
		public function afterMove():void
		{
			_element.refresh();
			_style.afterMove(this, _element, _topoLayer, _topoCanvas);
		}

		/**
		 * 标签
		 */
		public function get textLabel():IVisualElement
		{
			return _textLabel;
		}
		
		/**
		 * 添加标签
		 */
		public function addTextLabel(element:IVisualElement):IVisualElement
		{
			_textLabel = element;
			return addElement(element);
		}
		
		// 选中子对象
		public function selectChildFeature(childFeature:ChildFeature):void
		{
			_childMap.forEach(function(index:*, feature:ChildFeature):void
			{
				if(feature == childFeature)
				{
					feature.selectStatue = true;
					_lastSelectFeature = feature;
				}
				else
				{
					feature.selectStatue = false;
				}
			});
		}
		
		//获取选中子对象Key
		public function get selectChildFeatureKey():String
		{
			if(_lastSelectFeature != null)
			{
				return _lastSelectFeature.featureKey;
			}
			return "1";
		}
		
		public function get childMap():Map  
		{
			return _childMap;
		}
		
		public function addFeatureLevel(node:Object):void
		{
			var port:String = null;
			if("-1" == node.port){
				if(node.type == "1")
				{
					if(node.level>0 && node.level <_fromChildMaxLevel)
					{
						_fromChildMaxLevel = node.level;
					}
				}else if(node.type == "2")
				{
					if(node.level>0 && node.level <_toChildMaxLevel)
					{
						_toChildMaxLevel = node.level;
					}
				}
			}else{
				_childMap.forEach(function(index:*, feature:ChildFeature):void
				{
					port = _element.getExtendProperty("mo_port_name1_" + index);
					if(port == node.port && node.type == "1")
					{
						feature.fromLevel = node.level;
						//给父起始端最高级别
						if(feature.fromLevel && feature.fromLevel>0 && feature.fromLevel<_fromChildMaxLevel)
						{
							_fromChildMaxLevel = feature.fromLevel;
						}
					}
					port = _element.getExtendProperty("mo_port_name2_" + index);
					if(port == node.port && node.type == "2")
					{
						feature.toLevel = node.level;
						//给父结束端最高级别
						if(feature.toLevel && feature.toLevel>0 && feature.toLevel<_toChildMaxLevel)
						{
							_toChildMaxLevel = feature.toLevel;
						}
					}
				});
			}
		}
		
		public function clearAllChildLevel():void
		{
			_childMap.forEach(function(index:*, feature:ChildFeature):void
			{
				feature.clearLevel();
			});
			_fromChildMaxLevel = 5;
			_toChildMaxLevel = 5;
		}
		
		public function get element():IElement
		{
			return _element;
		}

		/**
		 * 元素样式
		 */
		public function get style():IStyle
		{
			return _style;
		}

		public function set style(value:IStyle):void
		{
			_style = value;
		}

		/**
		 * 选中效果绘制区域
		 */
//		public function get selectShape():Group
//		{
//			return _selectShape;
//		}

		/**
		 * 选中对象
		 *
		 */
		public function select():void
		{
			//让子对象处于选中状态
			selectChildFeature(_lastSelectFeature);
			
			
			_selected = true;
			_style.select(this, _element, _topoLayer, _topoCanvas);
		}

		/**
		 * 取消选中
		 *
		 */
		public function unSelect():void
		{
			//让子对象处于不选中状态
			selectChildFeature(null);
			
			_selected = false;
			_style.unSelect(this, _element, _topoLayer, _topoCanvas);
		}

		/**
		 * 是否处于选中状态
		 * @return
		 *
		 */
		public function get selected():Boolean
		{
			return _selected;
		}

		/**
		 * 对象相对移动位置
		 * @param x
		 * @param y
		 *
		 */
		public function addMoveXY(x:Number, y:Number):void
		{
			this.x += x;
			this.y += y;
			_element.addMoveXY(x, y);
			afterMove();
		}

		/**
		 * 设置对象的新位置
		 * @param x
		 * @param y
		 *
		 */
		public function setMoveXY(x:Number, y:Number):void
		{
			addMoveXY(x - this.x, y - this.y);
		}

		/**
		 * 销毁对象
		 *
		 */
		public function destroy():void
		{
			_topoLayer = null;
			_topoCanvas = null;
			_element = null;
			_style = null;
			_icon = null;
			_extendComponents.length = 0;
			_extendComponents = null;
//			_selectShape = null;
		}

		override public function removeAllElements():void
		{
			super.removeAllElements();
			_childMap.forEach(function(index:*, feature:ChildFeature):void
			{
				feature.removeAllElements();
			});
		}
		
		override public function toString():String
		{
			return _element + " (" + this.x + "," + this.y + ")" + " w:" + this.width + " h:" + this.height;
		}

		/**
		 * 图标对象
		 *
		 */
		public function get icon():Image
		{
			return _icon;
		}

		public function set icon(value:Image):void
		{
			_icon = value;
		}

		/**
		 * 是否初始化完成的标志
		 *
		 */
		public function get creationComplete():Boolean
		{
			return _creationComplete;
		}

		public function set creationComplete(value:Boolean):void
		{
			_creationComplete = value;
		}

		/**
		 * 增加扩展的UI组件
		 * @param ui
		 *
		 */
		public function appendExtendComponent(ui:UIComponent):void
		{
			_extendComponents.push(ui);
			addElement(ui);
		}

		/**
		 * 扩展的UI组件数组
		 * @return
		 *
		 */
		public function get extendComponents():Array
		{
			return _extendComponents;
		}

		/**
		 * 清空扩展的UI组件
		 *
		 */
		public function clearExtendComponents():void
		{
			_extendComponents.forEach(function(item:UIComponent, index:int, array:Array):void
				{
					if (contains(item))
					{
						removeElement(item);
					}
				}, this);
			_extendComponents.length = 0;
		}

		/**
		 * 效果实例
		 */
		public function get effectInstance():IEffectInstance
		{
			return _effectInstance;
		}

		public function set effectInstance(value:IEffectInstance):void
		{
			_effectInstance = value;
		}

		/**
		 * 气泡提示框
		 */
		public function get bubbleText():BubbleText
		{
			return _bubbleText;
		}

		public function set bubbleText(value:BubbleText):void
		{
			_bubbleText = value;
		}

		public function get topoLayer():TopoLayer
		{
			return _topoLayer;
		}
		
		public function get topoCanvas():TopoCanvas
		{
			return _topoCanvas;
		}
		
		public function get fromChildMaxLevel():int
		{
			return _fromChildMaxLevel;
		}
	
		public function set fromChildMaxLevel(value:int):void
		{
			_fromChildMaxLevel = value;
		}
		
		public function get toChildMaxLevel():int
		{
			return _toChildMaxLevel;
		}
		
		public function set toChildMaxLevel(value:int):void
		{
			_toChildMaxLevel = value;
		}
		
		public function get fromElement():Group
		{
			return _fromElement;
		}
		
		public function set fromElement(value:Group):void
		{
			_fromElement = value;
			if(_fromElement)
			{
				_fromElement.mouseEnabled = false;
				_fromElement.mouseChildren = false;
			}
		}
		
		public function get toElement():Group
		{
			return _toElement;
		}
		
		public function set toElement(value:Group):void
		{
			_toElement = value;
			if(_toElement)
			{
				_toElement.mouseEnabled = false;
				_toElement.mouseChildren = false;
			}
		}
		
		public function get fromEffectInstance():IEffectInstance
		{
			return _fromEffectInstance;
		}
		
		public function set fromEffectInstance(value:IEffectInstance):void
		{
			_fromEffectInstance = value;
		}
		
		public function get toEffectInstance():IEffectInstance
		{
			return _toEffectInstance;
		}
		
		public function set toEffectInstance(value:IEffectInstance):void
		{
			_toEffectInstance = value;
		}
		
	}
}