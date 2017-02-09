package com.linkage.module.topo.framework.core.parser
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
	import com.linkage.module.topo.framework.core.model.element.plane.ITPView;
	import com.linkage.module.topo.framework.core.model.element.point.INode;
	import com.linkage.module.topo.framework.core.model.element.point.ISegment;
	import com.linkage.module.topo.framework.core.model.element.point.ITPObject;
	import com.linkage.module.topo.framework.core.model.element.point.ITPText;
	import com.linkage.module.topo.framework.core.parser.element.IElementParser;
	import com.linkage.module.topo.framework.core.parser.element.xml.line.LayerLinkXMLParser;
	import com.linkage.module.topo.framework.core.parser.element.xml.line.LinkXMLParser;
	import com.linkage.module.topo.framework.core.parser.element.xml.line.TPLineXMLParser;
	import com.linkage.module.topo.framework.core.parser.element.xml.plane.HLinkLayerXMLParser;
	import com.linkage.module.topo.framework.core.parser.element.xml.plane.HLinkTopoXMLParser;
	import com.linkage.module.topo.framework.core.parser.element.xml.plane.TPComplexXMLParser;
	import com.linkage.module.topo.framework.core.parser.element.xml.plane.TPGridXMLParser;
	import com.linkage.module.topo.framework.core.parser.element.xml.plane.TPGroupXMLParser;
	import com.linkage.module.topo.framework.core.parser.element.xml.plane.TPShapeXMLParser;
	import com.linkage.module.topo.framework.core.parser.element.xml.plane.TPViewXMLParser;
	import com.linkage.module.topo.framework.core.parser.element.xml.point.HLinkUrlXMLParser;
	import com.linkage.module.topo.framework.core.parser.element.xml.point.NodeXMLParser;
	import com.linkage.module.topo.framework.core.parser.element.xml.point.SegmentXMLParser;
	import com.linkage.module.topo.framework.core.parser.element.xml.point.TPObjectXMLParser;
	import com.linkage.module.topo.framework.core.parser.element.xml.point.TPTextXMLParser;

	/**
	 * XML数据解析器工厂类
	 * @author duangr
	 *
	 */
	public class XmlParserFactory implements IParserFactory
	{
		// 节点解析器
		private var _nodeParser:IElementParser = null;
		// 网段解析器
		private var _segmentParser:IElementParser = null;
		// 链路解析器
		private var _linkParser:IElementParser = null;
		// 线解析器
		private var _tplineParser:IElementParser = null;
		// 缩略图间链路解析器
		private var _layerLinkParser:IElementParser = null;
		// 分组解析器
		private var _groupParser:IElementParser = null;
		// 形状解析器
		private var _shapeParser:IElementParser = null;
		// 复合对象解析器
		private var _complexParser:IElementParser = null;
		// 文本解析器
		private var _textParser:IElementParser = null;
		// url链接解析器
		private var _hlinkUrlParser:IElementParser = null;
		// 内部拓扑链接解析器
		private var _hlinkTopoParser:IElementParser = null;
		// 立体层次解析器
		private var _hlinkLayerParser:IElementParser = null;
		// 视图解析器
		private var _viewParser:IElementParser = null;
		// 拓扑内置简单对象解析器
		private var _tpObjectParser:IElementParser = null;
		// 拓扑网格对象解析器
		private var _tpGridParser:IElementParser = null;

		public function XmlParserFactory()
		{
			_nodeParser = new NodeXMLParser();
			_segmentParser = new SegmentXMLParser();
			_linkParser = new LinkXMLParser();
			_tplineParser = new TPLineXMLParser();
			_layerLinkParser = new LayerLinkXMLParser();
			_shapeParser = new TPShapeXMLParser();
			_complexParser = new TPComplexXMLParser();
			_groupParser = new TPGroupXMLParser();
			_textParser = new TPTextXMLParser();
			_hlinkUrlParser = new HLinkUrlXMLParser();
			_hlinkTopoParser = new HLinkTopoXMLParser();
			_hlinkLayerParser = new HLinkLayerXMLParser();
			_viewParser = new TPViewXMLParser();
			_tpObjectParser = new TPObjectXMLParser();
			_tpGridParser = new TPGridXMLParser();
		}

		public function buildElementParser(element:IElement):IElementParser
		{
			var parser:IElementParser = null;

			// 面
			if (element is IHLinkLayer)
			{
				parser = _hlinkLayerParser;
			}
			else if (element is IHLinkUrl)
			{
				parser = _hlinkUrlParser;
			}
			else if (element is IHLinkTopo)
			{
				parser = _hlinkTopoParser;
			}
			else if (element is ITPView)
			{
				parser = _viewParser;
			}
			else if (element is ITPGroup)
			{
				parser = _groupParser;
			}
			else if (element is ITPComplex)
			{
				parser = _complexParser;
			}
			else if (element is ITPShape)
			{
				parser = _shapeParser;
			}
			else if (element is ITPGrid)
			{
				parser = _tpGridParser;
			}
			// 点
			else if (element is ITPText)
			{
				parser = _textParser;
			}
			else if (element is ITPObject)
			{
				parser = _tpObjectParser;
			}
			else if (element is ISegment)
			{
				parser = _segmentParser;
			}
			else if (element is INode)
			{
				parser = _nodeParser;
			}
			// 线
			else if (element is ILayerLink)
			{
				parser = _layerLinkParser;
			}
			else if (element is ILink)
			{
				parser = _linkParser;
			}
			else if (element is ITPLine)
			{
				parser = _tplineParser;
			}

			return parser;
		}
	}
}