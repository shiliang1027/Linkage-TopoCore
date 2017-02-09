package com.linkage.module.topo.framework.core.style.element.line
{
	import com.linkage.module.topo.framework.core.ChildFeature;
	import com.linkage.module.topo.framework.core.Feature;
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.style.element.AbstractStyle;
	import com.linkage.module.topo.framework.util.AlarmConstants;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;
	import com.linkage.module.topo.framework.view.component.TopoLayer;
	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;
	
	import mx.effects.IEffectInstance;

	/**
	 * 线样式
	 * @author duangr
	 *
	 */
	public class LineStyle extends AbstractStyle
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.core.style.element.line.LineStyle");

		public function LineStyle()
		{
			super();
		}
		
		//CMNET流量增加
		override public function refreshAlarm(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):void
		{
			if (feature == null)
			{
				// 无告警对象,或者还没有网元图标,无需渲染
				return;
			}
			if(feature.fromElement && feature.toElement)
			{
				//渲染父的子对象最高级别颜色
				var effect:IEffectInstance = null;
				if(feature.fromChildMaxLevel && feature.fromChildMaxLevel>0 && feature.fromChildMaxLevel<5)
				{
					effect = feature.fromEffectInstance;
					if (effect)
					{
						effect.end();
					}
					switch (feature.fromChildMaxLevel)
					{
						case AlarmConstants.LEVEL1:
							feature.fromElement.filters = [AlarmConstants.LEVEL1_COLOR_FILTER];
							effect = _alarmConstants.level1Glow.createInstance(feature);
							break;
						case AlarmConstants.LEVEL2:
							feature.fromElement.filters = [AlarmConstants.LEVEL2_COLOR_FILTER];
							effect = _alarmConstants.level2Glow.createInstance(feature);
							break;
						case AlarmConstants.LEVEL3:
							feature.fromElement.filters = [AlarmConstants.LEVEL3_COLOR_FILTER];
							effect = _alarmConstants.level3Glow.createInstance(feature);
							break;
						case AlarmConstants.LEVEL4:
							feature.fromElement.filters = [AlarmConstants.LEVEL4_COLOR_FILTER];
							effect = _alarmConstants.level4Glow.createInstance(feature);
							break;
						default:
							log.error("渲染节点告警异常: (未知告警等级) {0}", feature.fromChildMaxLevel);
							break;
					}
					if (effect)
					{
						effect.end();
						effect.play();
					}
					feature.fromEffectInstance = effect;
				}
				else
				{
					feature.fromElement.filters.length = 0;
					feature.fromElement.filters = null;
				}
				
				if(feature.toChildMaxLevel && feature.toChildMaxLevel>0 && feature.toChildMaxLevel<5)
				{
					effect = feature.toEffectInstance;
					if (effect)
					{
						effect.end();
					}
					switch (feature.toChildMaxLevel)
					{
						case AlarmConstants.LEVEL1:
							feature.toElement.filters = [AlarmConstants.LEVEL1_COLOR_FILTER];
							effect = _alarmConstants.level1Glow.createInstance(feature);
							break;
						case AlarmConstants.LEVEL2:
							feature.toElement.filters = [AlarmConstants.LEVEL2_COLOR_FILTER];
							effect = _alarmConstants.level2Glow.createInstance(feature);
							break;
						case AlarmConstants.LEVEL3:
							feature.toElement.filters = [AlarmConstants.LEVEL3_COLOR_FILTER];
							effect = _alarmConstants.level3Glow.createInstance(feature);
							break;
						case AlarmConstants.LEVEL4:
							feature.toElement.filters = [AlarmConstants.LEVEL4_COLOR_FILTER];
							effect = _alarmConstants.level4Glow.createInstance(feature);
							break;
						default:
							log.error("渲染节点告警异常: (未知告警等级) {0}", feature.toChildMaxLevel);
							break;
					}
					if (effect)
					{
						effect.end();
						effect.play();
					}
					feature.toEffectInstance = effect;
				}
				else
				{
					feature.toElement.filters.length = 0;
					feature.toElement.filters = null;
				}	
			}
			
			//渲染子对象颜色
			feature.childMap.forEach(function(index:*, feature:ChildFeature):void
			{
				if(feature.fromElement)
				{
					// 告警效果渲染
					effect = feature.fromEffectInstance;
					if (effect)
					{
						effect.end();
					}
					if(feature.fromLevel > 0)
					{
						switch (feature.fromLevel)
						{
							case AlarmConstants.LEVEL1:
								feature.fromElement.filters = [AlarmConstants.LEVEL1_COLOR_FILTER];
								effect = _alarmConstants.level1Glow.createInstance(feature);
								break;
							case AlarmConstants.LEVEL2:
								feature.fromElement.filters = [AlarmConstants.LEVEL2_COLOR_FILTER];
								effect = _alarmConstants.level2Glow.createInstance(feature);
								break;
							case AlarmConstants.LEVEL3:
								feature.fromElement.filters = [AlarmConstants.LEVEL3_COLOR_FILTER];
								effect = _alarmConstants.level3Glow.createInstance(feature);
								break;
							case AlarmConstants.LEVEL4:
								feature.fromElement.filters = [AlarmConstants.LEVEL4_COLOR_FILTER];
								effect = _alarmConstants.level4Glow.createInstance(feature);
								break;
							default:
								log.error("渲染节点告警异常: (未知告警等级) {0}", feature.fromLevel);
								break;
						}
						if (effect)
						{
							effect.end();
							effect.play();
						}
						feature.fromEffectInstance = effect;
					}
					else
					{
						feature.fromElement.filters.length = 0;
						feature.fromElement.filters = null;
					}
				}
				if(feature.toElement)
				{
					// 告警效果渲染
					effect = feature.toEffectInstance;
					if (effect)
					{
						effect.end();
					}
					if(feature.toLevel > 0)
					{
						switch (feature.toLevel)
						{
							case AlarmConstants.LEVEL1:
								feature.toElement.filters = [AlarmConstants.LEVEL1_COLOR_FILTER];
								effect = _alarmConstants.level1Glow.createInstance(feature);
								break;
							case AlarmConstants.LEVEL2:
								feature.toElement.filters = [AlarmConstants.LEVEL2_COLOR_FILTER];
								effect = _alarmConstants.level2Glow.createInstance(feature);
								break;
							case AlarmConstants.LEVEL3:
								feature.toElement.filters = [AlarmConstants.LEVEL3_COLOR_FILTER];
								effect = _alarmConstants.level3Glow.createInstance(feature);
								break;
							case AlarmConstants.LEVEL4:
								feature.toElement.filters = [AlarmConstants.LEVEL4_COLOR_FILTER];
								effect = _alarmConstants.level4Glow.createInstance(feature);
								break;
							default:
								log.error("渲染节点告警异常: (未知告警等级) {0}", feature.toLevel);
								break;
						}
						if (effect)
						{
							effect.end();
							effect.play();
						}
						feature.toEffectInstance = effect;
					}
					else
					{
						feature.toElement.filters.length = 0;
						feature.toElement.filters = null;
					}
				}
			});
		}
		
		override protected function beforeDraw(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):Boolean
		{
			feature.removeAllElements();
			return super.beforeDraw(feature, element, topoLayer, topoCanvas, attributes);
		}

	}

}
