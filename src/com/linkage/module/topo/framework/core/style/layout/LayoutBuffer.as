package com.linkage.module.topo.framework.core.style.layout
{
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.model.element.line.ILine;
	import com.linkage.module.topo.framework.core.parser.ElementProperties;
	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	/**
	 * 拓扑布局器缓存
	 * @author duangr
	 *
	 */
	public class LayoutBuffer
	{
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.core.style.layout.LayoutBuffer");
		// 单件实例
		private static var _instance:LayoutBuffer = null;
		private var _labelTopLayout:ILayout = new TopLayout();
		private var _labelBottomLayout:ILayout = new BottomLayout();
		private var _labelLeftLayout:ILayout = new LeftLayout();
		private var _labelRightLayout:ILayout = new RightLayout();
		private var _labelCenterLayout:ILayout = new CenterLayout();
		private var _labelHideLayout:ILayout = new HideLayout();

		public function LayoutBuffer(pvt:_PrivateClass)
		{
			if (pvt == null)
			{
				throw new ArgumentError("LayoutBuffer构造时,参数[pvt:_PrivateClass]不能为null!");
			}
		}

		/**
		 * 获取单件实例
		 * @return
		 *
		 */
		public static function getInstance():LayoutBuffer
		{
			if (_instance == null)
			{
				_instance = new LayoutBuffer(new _PrivateClass());
			}
			return _instance;
		}

		/**
		 * 获取Label布局器
		 * @param element
		 * @return
		 *
		 */
		public function buildLabelLayout(element:IElement):ILayout
		{
			var layout:ILayout = null;
			switch (element.labelLayout)
			{
				case ElementProperties.PROPERTYVALUE_LABEL_LAYOUT_LEFT:
					layout = _labelLeftLayout;
					break;
				case ElementProperties.PROPERTYVALUE_LABEL_LAYOUT_RIGHT:
					layout = _labelRightLayout;
					break;
				case ElementProperties.PROPERTYVALUE_LABEL_LAYOUT_TOP:
					layout = _labelTopLayout;
					break;
				case ElementProperties.PROPERTYVALUE_LABEL_LAYOUT_HIDE:
					// 若是隐藏布局,直接返回
					return _labelHideLayout;
					break;
				case ElementProperties.PROPERTYVALUE_LABEL_LAYOUT_BOTTOM:
				default:
					layout = _labelBottomLayout;
					break;
			}
			if (element is ILine)
			{ 
				return _labelCenterLayout;
			}
			return layout;
		}
	}
}

class _PrivateClass
{
	public function _PrivateClass()
	{

	}
}