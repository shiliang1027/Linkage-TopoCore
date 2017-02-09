package com.linkage.module.topo.framework.core.model.element.plane
{

	/**
	 * 复合对象
	 * @author duangr
	 *
	 */
	public interface ITPComplex extends ITPShape
	{
		/**
		 * 展现形式
		 */
		function set showType(value:String):void;
		function get showType():String;
	}
}