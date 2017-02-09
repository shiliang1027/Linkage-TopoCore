package com.linkage.module.topo.framework.core.style.element
{
	import com.linkage.module.topo.framework.core.Feature;
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.view.component.TopoCanvas;
	import com.linkage.module.topo.framework.view.component.TopoLayer;

	/**
	 * 元素样式接口
	 * @author duangr
	 *
	 */
	public interface IStyle
	{
		/**
		 * 绘制元素
		 * @param feature
		 * @param element
		 * @param topoCanvas
		 * @param attributes
		 *
		 */
		function draw(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):void;

		/**
		 * 元素移动之后刷新事件
		 * @param feature
		 * @param element
		 * @param topoCanvas
		 * @param attributes
		 *
		 */
		function afterMove(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):void;

		/**
		 * 元素属性变化后刷新展现
		 * @param feature
		 * @param element
		 * @param topoCanvas
		 * @param attributes
		 *
		 */
		function refresh(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):void;

		/**
		 * 告警变化后刷新展现
		 * @param feature
		 * @param element
		 * @param topoCanvas
		 * @param attributes
		 *
		 */
		function refreshAlarm(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):void;

		/**
		 * 选中状态渲染
		 */
		function select(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):void;

		/**
		 * 取消选中状态
		 * @param feature
		 * @param element
		 * @param topoCanvas
		 * @param attributes
		 *
		 */
		function unSelect(feature:Feature, element:IElement, topoLayer:TopoLayer, topoCanvas:TopoCanvas, attributes:Object = null):void;
	}
}