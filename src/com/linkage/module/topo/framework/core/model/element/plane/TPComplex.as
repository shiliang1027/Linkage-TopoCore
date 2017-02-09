package com.linkage.module.topo.framework.core.model.element.plane
{
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.parser.ElementProperties;
	import com.linkage.system.utils.StringUtils;

	/**
	 * 复合对象(此对象主要有两种展现形式: 图标/形状)
	 * @author duangr
	 *
	 */
	public class TPComplex extends TPShape implements ITPComplex
	{

		public function TPComplex()
		{
			super();
		}

		public function set showType(value:String):void
		{
			this.addExtendProperty(ElementProperties.OBJECT_SHOW_TYPE, value);
		}

		public function get showType():String
		{
			var value:String = getExtendProperty(ElementProperties.OBJECT_SHOW_TYPE);
			return StringUtils.isEmpty(value) ? ElementProperties.DEFAULT_OBJECT_SHOW_TYPE : value;
		}

		override public function copyFrom(element:IElement):void
		{
			super.copyFrom(element);
			var complex:ITPComplex = element as ITPComplex;
			showType = complex.showType;
		}

		override public function toString():String
		{
			return "TPComplex(" + id + ": " + name + " : " + shapeType + ")(" + x + ", " + y + ") w:" + width + " h:" + height;
		}
	}
}