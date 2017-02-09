package com.linkage.module.topo.framework.core.style.element.plane
{
	import com.ailk.common.system.utils.StringUtils;
	import com.linkage.module.topo.framework.Constants;
	import com.linkage.module.topo.framework.controller.event.ActionEvent;
	import com.linkage.module.topo.framework.core.Feature;
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.model.element.line.ILink;
	import com.linkage.module.topo.framework.core.model.element.line.Link;
	import com.linkage.module.topo.framework.core.model.element.plane.ITPGroup;
	import com.linkage.module.topo.framework.core.model.element.plane.ITPShape;
	import com.linkage.module.topo.framework.core.model.element.point.ITPPoint;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;
	import com.linkage.module.topo.framework.view.component.TopoLayer;
	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;
	import com.linkage.system.structure.map.IMap;
	import com.linkage.system.structure.map.Map;
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import mx.controls.Alert;

	/**
	 * 分组样式
	 * @author duangr
	 *
	 */
	public class GroupStyle extends ShapeStyle
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.core.style.element.plane.GroupStyle");

		public function GroupStyle(imageContext:String, fillImageContext:String)
		{
			super(imageContext, fillImageContext);
		}

		override public function afterMove(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):void
		{
			super.afterMove(feature, element, topoLayer, topoCanvas, attributes);

			var group:ITPGroup = element as ITPGroup;
			group.eachChild(function(id:String, element:ITPPoint):void
				{
					element.feature.afterMove();
				});
		}

		override public function refresh(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):void
		{
			super.refresh(feature, element, topoLayer, topoCanvas, attributes);
			var group:ITPGroup = element as ITPGroup;
			group.eachChild(function(id:String, element:ITPPoint):void
				{
					element.feature.refresh();
				});
		}

		override public function select(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):void
		{
			var group:ITPGroup = element as ITPGroup;
			if (group.expanded)
			{
				super.select(feature, element, topoLayer, topoCanvas, attributes);
			}
			else
			{
				defaultSelect(feature, element, topoLayer, topoCanvas, attributes);
			}
		}

		override public function unSelect(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):void
		{
			var group:ITPGroup = element as ITPGroup;
			if (group.expanded)
			{
				super.unSelect(feature, element, topoLayer, topoCanvas, attributes);
			}
			else
			{
				defaultUnSelect(feature, element, topoLayer, topoCanvas, attributes);
			}
		}

		public function isGroupAndOpened(element:Object):Boolean
		{
			return element is ITPGroup && (element as ITPGroup).expanded;
		}
		
		override public function draw(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):void
		{
			feature.visible = beforeDraw(feature, element, topoLayer, topoCanvas, attributes);
			if (feature.visible)
			{
				initDeepth(feature, element, topoLayer, topoCanvas);
				var group:ITPGroup = element as ITPGroup;

				var href:String = group.getExtendProperty("href");
				if(group.expanded && !StringUtils.isNullStr(href)){
					var myPattern:RegExp = /#/gi;
					navigateToURL(new URLRequest(href.replace(myPattern,"&")));
					group.expanded=false;
				}
				
				if (group.expanded)
				{
					
					// 展开,画形状
					revisePlaneXY(feature, group, topoLayer, topoCanvas);
					drawShapeWithStyle(feature, group, topoLayer, topoCanvas);
					if (group.oppoLinks != null && group.oppoLinks.length != 0)
					{
						group.oppoLinks.forEach(function(link:ILink, index:int, array:Array):void
							{
								link.visible = 0;
								link.feature.refresh();
							});
					}
				}
				else
				{
					// 闭合,画图标
					reviseXY(feature, group, topoLayer, topoCanvas);
					drawIcon(feature, group, group.closedIcon, group.labelTooltip, topoLayer, topoCanvas);

					if (group.oppoLinks != null && group.oppoLinks.length != 0)
					{
						group.eachChild(function(id:String, element:ITPPoint):void
							{
								// 刷新网元,目的是让网元隐藏,同时让关联链路隐藏
								element.feature.refresh();
							});

						group.oppoLinks.forEach(function(link:ILink, index:int, array:Array):void
							{
								// 对于临时链路,若对端也是分组,只能在分组都闭合时出现
//								if (link.toElement is ITPGroup && (link.toElement as ITPGroup).expanded)
								if(isGroupAndOpened(link.toElement) && isGroupAndOpened(link.fromElement) )
								{
									link.visible = 0;
								}
								else
								{
									link.visible = 1;
								}
								link.feature.refresh();
							});
					}
					else
					{
						var oppoLinkNumMap:IMap = new Map();
						group.eachChild(function(id:String, element:ITPPoint):void
							{
								// 刷新网元,目的是让网元隐藏,同时让关联链路隐藏
								element.feature.refresh();

								// 遍历网元的对端网元
								element.outLines.forEach(function(link:ILink, index:int, array:Array):void
									{
										var oppo:ITPPoint = link.toElement;
										oppoLinkNumMap.put(oppo, int(oppoLinkNumMap.get(oppo)) + 1);
									});
								element.inLines.forEach(function(link:ILink, index:int, array:Array):void
									{
										var oppo:ITPPoint = link.fromElement;
										oppoLinkNumMap.put(oppo, int(oppoLinkNumMap.get(oppo)) + 1);
									});
							});

//						log.debug("oppoLinkNumMap = {0}", oppoLinkNumMap);
						var oppoLinks:Array = [];
						oppoLinkNumMap.forEach(function(oppo:ITPPoint, linkNum:int):void
							{
								var link:ILink = new Link();
								link.id = "oppolink/" + group.id + "/" + oppo.id;
								if (linkNum > 1)
								{
									link.name = "(+" + linkNum + ")";
								}
								link.visible = 1;
								link.fromElement = group;
								link.toElement = oppo;
								// 给两端对象加链路的引用
								group.addOutLine(link);
								oppo.addInLine(link);
								//topoLayer.appendNormalLink(link, false, feature.creationComplete);
								topoLayer.appendNormalLink(link, false, true);
								oppoLinks.push(link);

							});
						group.oppoLinks = oppoLinks;
					}

				}
			}
			
			refreshAlarm(feature, element, topoLayer, topoCanvas, attributes);
			
		}
		override public function refreshAlarm(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):void
		{
			var group:ITPGroup = element as ITPGroup;
			if (group.expanded)
			{
					feature.filters.length = 0;
					feature.filters = null;
					return;
			}
			log.debug("[group refresh alarm ]{0},{1},{2},{3},{4}",feature,element,topoLayer,topoCanvas,attributes);
			super.refreshAlarm(feature, element, topoLayer, topoCanvas,attributes);
		}
		override protected function afterDrawShape(feature:Feature, shape:ITPShape, topoLayer:TopoLayer, topoCanvas:TopoCanvas):void
		{
			var group:ITPGroup = shape as ITPGroup;

			drawLabel(feature, group, group.name,false,false);
			// 形状画好后,要绘制里面的元素
			group.eachChild(function(id:String, element:ITPPoint):void
				{
					feature.addElement(element.feature);
					element.feature.refresh();
				});
		}

	}
}