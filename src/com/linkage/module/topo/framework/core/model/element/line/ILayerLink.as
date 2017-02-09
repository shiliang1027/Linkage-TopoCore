package com.linkage.module.topo.framework.core.model.element.line
{
	import com.linkage.module.topo.framework.core.model.element.plane.IHLinkLayer;

	/**
	 * 缩略图之间的链路 接口
	 * @author duangr
	 *
	 */
	public interface ILayerLink extends ILink
	{
		/**
		 * 始端网元所处的缩略图id
		 */
		function get fromLayerId():String;
		function set fromLayerId(value:String):void;

		/**
		 * 终端网元所处的缩略图id
		 */
		function get toLayerId():String;
		function set toLayerId(value:String):void;

		/**
		 * 起点网元的id
		 */
		function get fromElementId():String;
		function set fromElementId(value:String):void;

		/**
		 * 终点网元的id
		 */
		function get toElementId():String;
		function set toElementId(value:String):void;

		/**
		 * 始端网元所处的缩略图
		 */
		function get fromLayer():IHLinkLayer;
		function set fromLayer(value:IHLinkLayer):void;

		/**
		 * 终端网元所处的缩略图
		 */
		function get toLayer():IHLinkLayer;
		function set toLayer(value:IHLinkLayer):void;

	}
}