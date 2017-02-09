package com.linkage.module.topo.framework.core.style.element
{
	import com.linkage.module.topo.framework.Constants;
	import com.linkage.module.topo.framework.controller.event.FeatureEvent;
	import com.linkage.module.topo.framework.core.Feature;
	import com.linkage.module.topo.framework.core.model.alarm.IAlarm;
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.style.layout.ILayout;
	import com.linkage.module.topo.framework.core.style.layout.LayoutBuffer;
	import com.linkage.module.topo.framework.core.style.layout.LeftCenterLayout;
	import com.linkage.module.topo.framework.core.style.layout.LeftLayout;
	import com.linkage.module.topo.framework.core.style.layout.RightCenterLayout;
	import com.linkage.module.topo.framework.util.AlarmConstants;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;
	import com.linkage.module.topo.framework.view.component.TopoLayer;
	import com.linkage.module.topo.framework.view.component.spareparts.BubbleText;
	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;
	import com.linkage.system.utils.StringUtils;
	
	import flash.display.Graphics;
	import flash.errors.IllegalOperationError;
	import flash.geom.Point;
	import flash.utils.setTimeout;
	
	import mx.controls.Text;
	import mx.core.UIComponent;
	import mx.effects.IEffectInstance;
	
	import spark.components.Label;

	public class AbstractStyle implements IStyle
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.core.style.element.AbstractStyle");
		
		// 布局器缓存
		private var _layoutBuffer:LayoutBuffer = LayoutBuffer.getInstance();
		/**
		 * 要素的内补丁
		 */
		protected var _padding:int = 2;
		
		var point:Point;

		// 告警常量
		protected var _alarmConstants:AlarmConstants = AlarmConstants.getInstance();

		public function AbstractStyle()
		{
		}

		public function draw(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):void
		{
			feature.visible = beforeDraw(feature, element, topoLayer, topoCanvas, attributes);
			throw new IllegalOperationError("Function draw(feature:Feature, element:IElement, topoCanvas:TopoCanvas, attributes:Object = null) from abstract class AbstractStyle has not been implemented by subclass.");
		}

		public function afterMove(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):void
		{
			throw new IllegalOperationError("Function afterMove(feature:Feature, element:IElement, topoCanvas:TopoCanvas, attributes:Object = null) from abstract class AbstractStyle has not been implemented by subclass.");
		}

		public function refresh(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):void
		{
			draw(feature, element, topoLayer, topoCanvas, attributes);
			if (feature.selected)
			{
				select(feature, element, topoLayer, topoCanvas, attributes);
			}
		}

		public function refreshAlarm(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):void
		{
			if (feature.visible == false)
			{
				return;
			}
			log.debug("渲染告警 {0} {1}", element, element.alarm);

			var alarm:IAlarm = element.alarm;
			if (alarm == null || feature == null)
			{
				// 无告警对象,或者还没有网元图标,无需渲染
				log.error("测试alarm或者feature是否为空？=" + (alarm == null || feature == null));
				return;
			}
			// 悬浮气泡显示
			var bubbleText:BubbleText = feature.bubbleText;
			if (bubbleText == null)
			{
				bubbleText = new BubbleText();
				bubbleText.mouseChildren = false;
				feature.bubbleText = bubbleText;
				feature.addElement(bubbleText);
			}
			else
			{
				if (!feature.contains(bubbleText))
				{
					feature.addElement(bubbleText);
				}
			}
			bubbleText.x = feature.width - 10;
			bubbleText.y = 0;


			// 告警效果渲染
			var effect:IEffectInstance = feature.effectInstance;
			log.error("element.id={0}",element.id);
			log.error("feature={0}",feature);
//			if(element.id == "1/1a0e0e52-3da2-459b-a2f3-c491097c3398"){
////				feature.visible = false;
//				if (effect)
//				{
//					effect.end();
//				}
//				feature.filters.length = 0;
//				feature.filters = null;
//				bubbleText.visible = false;
//				return;
//			}
			if (effect)
			{
				effect.end();
			}

			if (alarm.hasAlarm())
			{
//				bubbleText.text = String(alarm.maxLevelNum());
				bubbleText.text = String(alarm.level1+alarm.level2+alarm.level3+alarm.level4);
				if (topoCanvas.renderAlarmNumEnabled)
				{
					bubbleText.visible = true;
				}
				log.debug("渲染告警(有告警) {0} {1}  maxlevel:{2}", element, alarm, alarm.maxLevel());
				switch (alarm.maxLevel())
				{
					case AlarmConstants.LEVEL1:
						feature.filters = [AlarmConstants.LEVEL1_COLOR_FILTER];
						effect = _alarmConstants.level1Glow.createInstance(feature);
						bubbleText.setStyle("backgroundColor", AlarmConstants.LEVEL1_COLOR);
						break;
					case AlarmConstants.LEVEL2:
						feature.filters = [AlarmConstants.LEVEL2_COLOR_FILTER];
						effect = _alarmConstants.level2Glow.createInstance(feature);
						bubbleText.setStyle("backgroundColor", AlarmConstants.LEVEL2_COLOR);
						break;
					case AlarmConstants.LEVEL3:
						feature.filters = [AlarmConstants.LEVEL3_COLOR_FILTER];
						effect = _alarmConstants.level3Glow.createInstance(feature);
						bubbleText.setStyle("backgroundColor", AlarmConstants.LEVEL3_COLOR);
						break;
					case AlarmConstants.LEVEL4:
						feature.filters = [AlarmConstants.LEVEL4_COLOR_FILTER];
						effect = _alarmConstants.level4Glow.createInstance(feature);
						bubbleText.setStyle("backgroundColor", AlarmConstants.LEVEL4_COLOR);
						break;
					default:
						log.error("渲染节点告警异常: (未知告警等级) {0}", alarm.maxLevel());
						break;
				}
				if (effect)
				{
					effect.end();
					effect.play();
				}
				feature.effectInstance = effect;
			}
			else
			{
				log.error("没有告警，不需要渲染{0}",feature);
				feature.filters.length = 0;
				feature.filters = null;
				bubbleText.visible = false;
			}
		}

		public function select(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):void
		{
			//drawSelectLabel(feature, element, element.name,true);
			defaultSelect(feature, element, topoLayer, topoCanvas, attributes);
		}

		public function unSelect(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):void
		{
			//drawSelectLabel(feature, element, element.name,false);
			defaultUnSelect(feature, element, topoLayer, topoCanvas, attributes);
		}

		protected function drawSelectLabel(feature:Feature, element:IElement, text:String,isSelect:Boolean):Label
		{
			if (!StringUtils.isEmpty(text)) 
			{
				//如果 以前存在直接删除 
				var label:Label = feature.textLabel as Label;
				if(label == null)
				{
					label = new Label();
					label.toolTip = text;
					label.setStyle("textAlign", "center");
					feature.addTextLabel(_layoutBuffer.buildLabelLayout(element).layoutLabel(text, label, feature));
				}
				if(isSelect == false && text.length > 12)
				{
					label.text = text.slice(0,12)+"…";
				}else{
					label.text = text;
				}
				return label;
			}
			return null;
		}
		/**
		 * 默认的选中逻辑
		 * @param feature
		 * @param element
		 * @param topoCanvas
		 * @param attributes
		 *
		 */
		protected function defaultSelect(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):void
		{
			if (feature.creationComplete == false)
			{
				setTimeout(function():void
					{
						defaultSelect(feature, element, topoLayer, topoCanvas, attributes);
					}, 500);
				return;
			}

			var padding:int = _padding;
			var offset:int = 1; // 边框相对容器周侧的距离
			var thickness:int = 2; // 边框的厚度
			var color:int = Constants.DEFAULT_SELECTED_BORDER_COLOR; // 边框的颜色
			// 选中对象(默认在对象容器外围画2个像素的框框)
//			var g:Graphics = feature.selectShape.graphics;
			var g:Graphics = feature.graphics;
			g.clear();
			g.lineStyle(thickness, color);
			g.moveTo(padding - offset, padding - offset);
			g.lineTo(feature.width - padding + offset, padding - offset);
			g.lineTo(feature.width - padding + offset, feature.height - padding + offset);
			g.lineTo(padding - offset, feature.height - padding + offset);
			g.lineTo(padding - offset, padding - offset);
//			if (!feature.contains(feature.selectShape))
//			{
//				feature.addElement(feature.selectShape);
//			}
		}

		/**
		 * 默认的取消选中逻辑
		 * @param feature
		 * @param element
		 * @param topoCanvas
		 * @param attributes
		 *
		 */
		protected function defaultUnSelect(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):void
		{
			if (feature.creationComplete == false)
			{
				setTimeout(function():void
					{
						defaultUnSelect(feature, element, topoLayer, topoCanvas, attributes);
					}, 500);
				return;
			}
//			feature.selectShape.graphics.clear();
			feature.graphics.clear();
		}

		/**
		 * 初始化深度
		 * @param feature
		 * @param element
		 * @param topoLayer
		 * @param topoCanvas
		 *
		 */
		protected function initDeepth(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas):void
		{
			if (feature.creationComplete)
			{
				return;
			}
			feature.depth = element.zindex;
		}

		/**
		 * 画label
		 * @param feature
		 * @param node
		 *
		 */
		protected function drawLabel(feature:Feature, element:IElement, text:String,isSelect:Boolean,isLabel:Boolean):Label
		{
			if (!StringUtils.isEmpty(text))
			{
				var label:Label = new Label();
				label.setStyle("textAlign", "center");
				
			/*	if(isLabel == false)
				{
					label.text = text;
				}else
				{
					if(isSelect == false)
					{
						if(text.length >= 10)
						{
							label.text = text.slice(0,10)+"…";
						}else{
							label.text = text;
						}
					}else
					{
						label.text = text;
						
					}
				}*/
				//过长换行处理
				var maxLength:Number=15;
				var begin:Number=0;
				var strLength:Number=text.length/maxLength;
				var newstr:String=text.substr(begin,maxLength);
				while(strLength>1){
					strLength--;
					begin=begin+maxLength;
					newstr=newstr+"\r\n"+text.substr(begin,maxLength);
				}
				
				label.text = newstr;
				
//				label.text=text;
//				label.maxWidth=180;
//				feature.addElement(label);
//				_layoutBuffer.buildLabelLayout(element).layoutLabel(text, label, feature);
				feature.addElement(_layoutBuffer.buildLabelLayout(element).layoutLabel(text, label, feature));
				return label;
			}
			return null;
		}
		
		protected function drawLeftLineLabel(feature:Feature, element:IElement, name:String,port:String,fromPoint:Point,toPoint:Point,isSelected:Boolean):Label
		{
				var label:Label = new Label();
				label.setStyle("textAlign", "left");
				
				if(isSelected == false)
				{
					/*if(name == null || name == "")
					{
						if(port == null || port == "")
						{
							label.text = " ";
						}else
						{
							if(port.length >= 10)
							{
								label.text = port.slice(0,10)+"…";
							}else{
								label.text = port;
							}
						}
						
					}else
					{
						if(port == null || port == "")
						{
							label.text = name;
						}else
						{
							if(name.length + port.length >= 10)
							{
								label.text =(name+port).slice(0,12)+"…";
							}else{
								label.text =name+port;
							}
						}
					}*/
					
				}else{
					if(name == null || name == "")
					{
						if(port == null || port == "")
						{
							label.text = " ";
						}else{
							label.text = port;
						}
						
					}else
					{
						if(port == null || port == "")
						{
							label.text = name;
						}else
						{
							label.text =name+port;
						}
					}
				}
				
				if(label.text == "0")
				{
					label.text = " ";
				}
//				feature.addTextLabel(new LeftCenterLayout().layoutPointLabel(label.text, label, feature,fromPoint,toPoint));
				feature.addElement(new LeftCenterLayout().layoutPointLabel(label.text, label, feature,fromPoint,toPoint));
				return label;
			
		}
		
		protected function drawRightLineLabel(feature:Feature, element:IElement,name:String,port:String,fromPoint:Point,toPoint:Point,isSelected:Boolean):Label
		{
				var label:Label = new Label();
				label.setStyle("textAlign", "left");
				
				if(isSelected == false)
				{
					/*LOG.INFO("RIGHT FALSE"+NAME);
					IF(NAME == NULL || NAME == "")
					{
						IF(PORT == NULL || PORT == "")
						{
							LABEL.TEXT = " ";
						}ELSE
						{
							IF(PORT.LENGTH >= 10)
							{
								LABEL.TEXT = PORT.SLICE(0,10)+"…";
							}ELSE{
								LABEL.TEXT = PORT;
							}
						}
						
					}ELSE
					{
						IF(PORT == NULL || PORT == "")
						{
							LABEL.TEXT = NAME;
						}ELSE
						{
							IF(NAME.LENGTH + PORT.LENGTH >= 10)
							{
								LABEL.TEXT =(NAME+PORT).SLICE(0,12)+"…";
							}ELSE{
								LABEL.TEXT =NAME+PORT;
							}
						}
					}*/
					
				}else{
					log.info("Right true"+name);
					if(name == null || name == "")
					{
						if(port == null || port == "")
						{
							label.text = " ";
						}else{
							label.text = port;
						}
						
					}else
					{
						if(port == null || port == "")
						{
							label.text = name;
						}else
						{
							label.text =name+port;
						}
					}
				}
				
				if(label.text == "0")
				{
					label.text = " ";
				}
				
//				feature.addTextLabel(new RightCenterLayout().layoutPointLabel(label.text, label, feature,fromPoint,toPoint));
				feature.addElement(new RightCenterLayout().layoutPointLabel(label.text, label, feature,fromPoint,toPoint));
				return label;
			
		}

		/**
		 * 绘制扩展的UI组件
		 * @param feature
		 *
		 */
		protected function drawExtendComponents(feature:Feature):void
		{
			feature.extendComponents.forEach(function(item:UIComponent, index:int, array:Array):void
				{
					feature.addElement(item);
				});
		}

		/**
		 * 画图之前调用的方法
		 * @param feature
		 * @param element
		 * @param topoCanvas
		 * @param attributes
		 *
		 */
		protected function beforeDraw(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):Boolean
		{
			var flag:Boolean = feature.parent != null && (topoLayer.viewAllEnabled ? true : (element.visible == 1));
			if (flag)
			{
				// 允许显示,但 是否显示属性为 不显示,要修改透明度进行标示
				// 正常显示时,要保留之前的透明度(主要考虑到高亮功能)
				feature.alpha = (element.visible == 0) ? Constants.DEFAULT_FEATURE_ALPHA_HIDE : Constants.DEFAULT_FEATURE_ALPHA_SHOW * feature.alpha;
			}
			return flag;
		}

		/**
		 * 创建完成
		 * @param feature
		 * @param dispatchEvent
		 *
		 */
		final protected function creationComplete(feature:Feature, dispatchEvent:Boolean = false):void
		{
			if (feature.creationComplete == false)
			{
				feature.creationComplete = true;
				if (dispatchEvent)
				{
					feature.dispatchEvent(new FeatureEvent(FeatureEvent.CREATION_COMPLETE, feature));
				}
			}
		}
	}
}