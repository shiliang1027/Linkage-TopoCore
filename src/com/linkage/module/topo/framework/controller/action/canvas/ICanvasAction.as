package com.linkage.module.topo.framework.controller.action.canvas
{
	import com.linkage.module.topo.framework.controller.action.IAction;
	import com.linkage.module.topo.framework.core.Feature;

	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 * 画布Action的接口<br/>
	 * 主要把事件细化为:
	 * <table>
	 * <tr><td>触发条件</td><td>说明</td></tr>
	 * <tr><td>[MouseDown]点击到Feature上</td><td>  </td></tr>
	 * <tr><td>[MouseDown]点击到空白处</td><td> </td></tr>
	 * <tr><td>[MouseMove]没点击->移动</td><td></td></tr>
	 * <tr><td>[MouseMove]点击到Feature上->移动</td><td></td></tr>
	 * <tr><td>[MouseMove]点击到Feature上->移动(此时左键已经弹起)</td><td>异常情况,UP时不在画布上</td></tr>
	 * <tr><td>[MouseMove]点击到空白处->移动</td><td></td></tr>
	 * <tr><td>[MouseMove]点击到空白处->移动(此时左键已经弹起)</td><td>异常情况,UP时不在画布上</td></tr>
	 * <tr><td>[MouseUp]点击到Feature上->弹起</td><td></td></tr>
	 * <tr><td>[MouseUp]点击到Feature上->移动->弹起</td><td></td></tr>
	 * <tr><td>[MouseUp]点击到空白处->弹起</td><td></td></tr>
	 * <tr><td>[MouseUp]点击到空白处->移动->弹起</td><td></td></tr>
	 * <tr><td></td><td></td></tr>
	 * </table>
	 *
	 *
	 * @author duangr
	 *
	 */
	public interface ICanvasAction extends IAction
	{
		/**
		 * Action启用之后,子类可重写此方法
		 *
		 */
		function afterActionEnabled():void;

		/**
		 * Action禁用之后,子类可重写此方法
		 *
		 */
		function afterActionDisabled():void;

		/**
		 * [MouseDown]点击到Feature上
		 * @param event
		 * @param mouseCanvasPoint 鼠标相对画布的坐标
		 * @param downFeature
		 *
		 */
		function onDownFeature(event:MouseEvent, mouseCanvasPoint:Point, downFeature:Feature):void;

		/**
		 * [MouseDown]点击到空白处
		 * @param event
		 * @param mouseCanvasPoint 鼠标相对画布的坐标
		 *
		 */
		function onDownCanvas(event:MouseEvent, mouseCanvasPoint:Point):void;

		/**
		 * [MouseMove]没点击->移动
		 * @param event
		 * @param mouseCanvasPoint 鼠标相对画布的坐标
		 */
		function onMoveWithoutDown(event:MouseEvent, mouseCanvasPoint:Point):void;

		/**
		 * [MouseMove]点击到Feature上->移动
		 * @param event
		 * @param mouseCanvasPoint 鼠标相对画布的坐标
		 * @param downFeature
		 *
		 */
		function onMoveWithDownFeature(event:MouseEvent, mouseCanvasPoint:Point, downFeature:Feature):void;

		/**
		 * [MouseMove]点击到Feature上->移动(此时左键已经弹起)
		 * @param event
		 * @param mouseCanvasPoint 鼠标相对画布的坐标
		 * @param downFeature
		 *
		 */
		function onMoveWithDownFeatureButUp(event:MouseEvent, mouseCanvasPoint:Point, downFeature:Feature):void;

		/**
		 * [MouseMove]点击到空白处->移动
		 * @param event
		 * @param mouseCanvasPoint 鼠标相对画布的坐标
		 *
		 */
		function onMoveWithDownCanvas(event:MouseEvent, mouseCanvasPoint:Point):void;

		/**
		 * [MouseMove]点击到空白处->移动(此时左键已经弹起)
		 * @param event
		 * @param mouseCanvasPoint 鼠标相对画布的坐标
		 *
		 */
		function onMoveWithDownCanvasButUp(event:MouseEvent, mouseCanvasPoint:Point):void;

		/**
		 * [MouseUp]点击到Feature上->弹起
		 * @param event
		 * @param mouseCanvasPoint 鼠标相对画布的坐标
		 * @param downFeature
		 * @param upFeature
		 *
		 */
		function onUpWithDownFeatureNoMove(event:MouseEvent, mouseCanvasPoint:Point, downFeature:Feature, upFeature:Feature):void;

		/**
		 * [MouseUp]点击到Feature上->移动->弹起
		 * @param event
		 * @param mouseCanvasPoint 鼠标相对画布的坐标
		 * @param downFeature
		 * @param upFeature
		 *
		 */
		function onUpWithDownFeatureAndMove(event:MouseEvent, mouseCanvasPoint:Point, downFeature:Feature, upFeature:Feature):void;

		/**
		 * [MouseUp]点击到空白处->弹起
		 * @param event
		 * @param mouseCanvasPoint 鼠标相对画布的坐标
		 * @param upFeature
		 *
		 */
		function onUpWithDownCanvasNoMove(event:MouseEvent, mouseCanvasPoint:Point, upFeature:Feature):void;

		/**
		 * [MouseUp]点击到空白处->移动->弹起
		 * @param event
		 * @param mouseCanvasPoint 鼠标相对画布的坐标
		 * @param upFeature
		 *
		 */
		function onUpWithDownCanvasAndMove(event:MouseEvent, mouseCanvasPoint:Point, upFeature:Feature):void;

		/**
		 * [MouseWheel] 在画布上面滚轮滚动
		 * @param event
		 * @param mouseCanvasPoint
		 *
		 */
		function onMouseWheelCanvas(event:MouseEvent, mouseCanvasPoint:Point):void;

		/**
		 * [DoubleClick] 双击到Feature上
		 * @param event
		 * @param mouseCanvasPoint 鼠标相对画布的坐标
		 * @param downFeature
		 *
		 */
		function onDoubleClickFeature(event:MouseEvent, mouseCanvasPoint:Point, downFeature:Feature):void;

		/**
		 * [DoubleClick] 双击到空白处
		 * @param event
		 * @param mouseCanvasPoint 鼠标相对画布的坐标
		 *
		 */
		function onDoubleClickCanvas(event:MouseEvent, mouseCanvasPoint:Point):void;
	}
}