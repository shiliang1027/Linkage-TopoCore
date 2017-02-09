package com.linkage.module.topo.framework.core.style
{
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.model.element.line.ILayerLink;
	import com.linkage.module.topo.framework.core.model.element.line.ILink;
	import com.linkage.module.topo.framework.core.model.element.line.ITPLine;
	import com.linkage.module.topo.framework.core.model.element.plane.IHLinkLayer;
	import com.linkage.module.topo.framework.core.model.element.plane.IHLinkTopo;
	import com.linkage.module.topo.framework.core.model.element.plane.IHLinkUrl;
	import com.linkage.module.topo.framework.core.model.element.plane.ITPComplex;
	import com.linkage.module.topo.framework.core.model.element.plane.ITPGrid;
	import com.linkage.module.topo.framework.core.model.element.plane.ITPGroup;
	import com.linkage.module.topo.framework.core.model.element.plane.ITPShape;
	import com.linkage.module.topo.framework.core.model.element.point.INode;
	import com.linkage.module.topo.framework.core.model.element.point.ISegment;
	import com.linkage.module.topo.framework.core.model.element.point.ITPObject;
	import com.linkage.module.topo.framework.core.model.element.point.ITPText;
	import com.linkage.module.topo.framework.core.style.element.IStyle;
	import com.linkage.module.topo.framework.core.style.element.line.LayerLinkStyle;
	import com.linkage.module.topo.framework.core.style.element.line.LinkStyle;
	import com.linkage.module.topo.framework.core.style.element.line.TPLineStyle;
	import com.linkage.module.topo.framework.core.style.element.plane.ComplexStyle;
	import com.linkage.module.topo.framework.core.style.element.plane.GroupStyle;
	import com.linkage.module.topo.framework.core.style.element.plane.HLinkLayerStyle;
	import com.linkage.module.topo.framework.core.style.element.plane.HLinkTopoStyle;
	import com.linkage.module.topo.framework.core.style.element.plane.HLinkUrlStyle;
	import com.linkage.module.topo.framework.core.style.element.plane.ShapeStyle;
	import com.linkage.module.topo.framework.core.style.element.plane.TPGridStyle;
	import com.linkage.module.topo.framework.core.style.element.point.NodeStyle;
	import com.linkage.module.topo.framework.core.style.element.point.SegmentStyle;
	import com.linkage.module.topo.framework.core.style.element.point.TPObjectStyle;
	import com.linkage.module.topo.framework.core.style.element.point.TPTextStyle;
	import com.linkage.module.topo.framework.util.TopoUtil;

	/**
	 * 样式工厂类(默认)
	 * @author duangr
	 *
	 */
	public class StyleFactory implements IStyleFactory
	{
		// 图标路径上下文
		private var _iconContext:String = null;
		// 填充图片路径上下文
		private var _fillImageContext:String = null;
		// 转换矩阵容器
		private var _matrixBuffer:MatrixBuffer = MatrixBuffer.getInstance();
		// ----------------- style ----------------
		// 节点对象样式
		private var _nodeStyle:IStyle = null;
		// 网段对象样式
		private var _segmentStyle:IStyle = null;
		// 链路对象样式
		private var _linkStyle:IStyle = null;
		// 线的样式
		private var _tplineStyle:IStyle = null;
		// 缩略图间链路样式
		private var _layerLinkStyle:IStyle = null;

		// 分组的样式
		private var _groupStyle:IStyle = null;

		// 文本对象样式
		private var _textStyle:IStyle = null;
		// 简单对象样式
		private var _tpObjectStyle:IStyle = null;

		// 形状的样式
		private var _shapeStyle:IStyle = null;
		// 复合的样式
		private var _complexStyle:IStyle = null;
		// 缩略图样式
		private var _hlinkLayerStyle:IStyle = null;
		// 内部链接对象样式
		private var _hlinkTopoStyle:IStyle = null;
		// 外部链接对象样式 
		private var _hlinkUrlStyle:IStyle = null;
		// 网格对象样式
		private var _tpGridStyle:IStyle = null;



		public function StyleFactory(iconContext:String, fillImageContext:String = null)
		{
			_iconContext = TopoUtil.formatContext(iconContext);
			_fillImageContext = fillImageContext == null ? _iconContext : TopoUtil.formatContext(fillImageContext);

			// 初始化style
			_nodeStyle = new NodeStyle(_iconContext);
			_segmentStyle = new SegmentStyle(_iconContext);
			_linkStyle = new LinkStyle();
			_tplineStyle = new TPLineStyle();
			_layerLinkStyle = new LayerLinkStyle();

			// 文本对象
			_textStyle = new TPTextStyle();
			_tpObjectStyle = new TPObjectStyle(_iconContext);

			// 分组样式
			_groupStyle = new GroupStyle(_iconContext, _fillImageContext);
			// 形状样式
			_shapeStyle = new ShapeStyle(_iconContext, _fillImageContext);
			// 复合对象样式
			_complexStyle = new ComplexStyle(_iconContext, _fillImageContext);
			// 缩略图样式
			_hlinkLayerStyle = new HLinkLayerStyle(_iconContext, _fillImageContext);
			// 内部链接样式
			_hlinkTopoStyle = new HLinkTopoStyle(_iconContext, _fillImageContext);
			// 外部链接样式
			_hlinkUrlStyle = new HLinkUrlStyle(_iconContext, _fillImageContext);

			// 网格对象样式
			_tpGridStyle = new TPGridStyle(_iconContext);

		}

		public function buildStyle(element:IElement):IStyle
		{
			var style:IStyle = null;
			// 面
			if (element is IHLinkLayer)
			{
				style = _hlinkLayerStyle;
			}
			else if (element is IHLinkUrl)
			{
				style = _hlinkUrlStyle;
			}
			else if (element is IHLinkTopo)
			{
				style = _hlinkTopoStyle;
			}
			else if (element is ITPGroup)
			{
				style = _groupStyle;
			}
			else if (element is ITPComplex)
			{
				style = _complexStyle;
			}
			else if (element is ITPShape)
			{
				style = _shapeStyle;
			}
			else if (element is ITPGrid)
			{
				style = _tpGridStyle;
			}
			// 点
			else if (element is ITPText)
			{
				style = _textStyle;
			}
			else if (element is ITPObject)
			{
				style = _tpObjectStyle
			}
			else if (element is ISegment)
			{
				style = _segmentStyle;
			}
			else if (element is INode)
			{
				style = _nodeStyle;
			}
			// 线
			else if (element is ILayerLink)
			{
				style = _layerLinkStyle;
			}
			else if (element is ILink)
			{
				style = _linkStyle;
			}
			else if (element is ITPLine)
			{
				style = _tplineStyle;
			}

			return style;
		}

	}
}