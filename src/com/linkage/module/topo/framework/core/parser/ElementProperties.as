package com.linkage.module.topo.framework.core.parser
{

	/**
	 * 元素支持的属性
	 * @author duangr
	 *
	 */
	public class ElementProperties
	{
		/**
		 * 元素: 图标的宽度
		 */
		public static const ICON_WIDTH:String = "icon.width";
		/**
		 * 元素: 图标的高度
		 */
		public static const ICON_HEIGHT:String = "icon.height";

		/**
		 * 元素: 名称的布局方式
		 */
		public static const LABEL_LAYOUT:String = "label.layout";
		/**
		 * 元素: tooltip提示内容
		 */
		public static const LABEL_TOOLTIP:String = "label.tooltip";
		/**
		 * 元素: 名称的最大宽度
		 */
		public static const LABEL_MAXWIDTH:String = "label.maxwidth";

		/**
		 * 线:线的提示信息
		 */
		public static const LINE_TOOLTIP:String = "line.tooltip";
		/**
		 * 线:线的起点
		 */
		public static const LINE_FROM_POINT:String = "line.from.point";
		/**
		 * 线:线的终点
		 */
		public static const LINE_TO_POINT:String = "line.to.point";
		/**
		 * 线:线的拐点(或者贝塞尔控制点)
		 */
		public static const LINE_FLEX_POINTS:String = "line.flex.points";
		/**
		 * 线:线颜色
		 */
		public static const LINE_COLOR:String = "line.color";
		/**
		 * 线:线宽度
		 */
		public static const LINE_WIDTH:String = "line.width";
		/**
		 * 线:线透明度
		 */
		public static const LINE_ALPHA:String = "line.alpha";
		/**
		 * 线:线的符号 (solid:实线, dash:虚线)
		 */
		public static const LINE_SYMBOL:String = "line.symbol";
		/**
		 * 线:线的类型 (straight:直线, bessel2: 二级贝塞尔曲线)
		 */
		public static const LINE_TYPE:String = "line.type";

		/**
		 * 链路: 二级贝塞尔曲线沿直线中心点垂直偏移量(可正负,正代表偏移后的点在中心点一二相限)
		 */
		public static const LINK_BESSEL2_OFFSETV:String = "link.bessel2.offsetV";
		/**
		 * 链路: 折线
		 */
		public static const LINK_POLY_LOCATION:String = "link.poly.location";
		
		/**
		 * 链路:实际链路数量
		 */
		public static const LINK_COUNT:String = "link.count";
		/**
		 * 链路:默认状态 (close:闭合, open:展开)
		 */
		public static const LINK_DEFAULT_STATUS:String = "link.default.status";
		/**
		 * 链路:展开后间隙
		 */
		public static const LINK_OPEN_GAP:String = "link.open.gap";
		/**
		 * 链路: 展开后贝塞尔控制点沿链路方向偏移量
		 */
		public static const LINK_OPEN_OFFSETH:String = "link.open.offsetH";
		/**
		 * 链路: 展开后多条线交汇处的类型
		 */
		public static const LINK_OPEN_TYPE:String = "link.open.type";
		/**
		 * 链路:是否启用起点箭头 (true:显示, false:隐藏)
		 */
		public static const LINK_FROM_ARROW:String = "link.from.arrow";
		/**
		 * 链路:起点箭头类型 (head: 箭头, tail:箭尾)
		 */
		public static const LINK_FROM_ARROW_TYPE:String = "link.from.arrow.type";
		/**
		 * 链路:起点箭头高度
		 */
		public static const LINK_FROM_ARROW_HEIGHT:String = "link.from.arrow.height";
		/**
		 * 链路:起点箭头宽度
		 */
		public static const LINK_FROM_ARROW_WIDTH:String = "link.from.arrow.width";
		/**
		 * 链路:起点的缩略图对象id
		 */
		public static const LINK_FROM_LAYER:String = "link.from.layer";
		/**
		 * 链路:是否启用终点箭头 (true:显示, false:隐藏)
		 */
		public static const LINK_TO_ARROW:String = "link.to.arrow";
		/**
		 * 链路:终点箭头类型 (head: 箭头, tail:箭尾)
		 */
		public static const LINK_TO_ARROW_TYPE:String = "link.to.arrow.type";
		/**
		 * 链路:终点箭头高度
		 */
		public static const LINK_TO_ARROW_HEIGHT:String = "link.to.arrow.height";
		/**
		 * 链路:终点箭头宽度
		 */
		public static const LINK_TO_ARROW_WIDTH:String = "link.to.arrow.width";
		/**
		 * 链路:终点的缩略图对象id
		 */
		public static const LINK_TO_LAYER:String = "link.to.layer";

		/**
		 * 对象:外部超链接url
		 */
		public static const OBJECT_URL:String = "obj.url";
		/**
		 * 对象:文本内容
		 */
		public static const OBJECT_TEXT:String = "obj.text";
		/**
		 * 对象:文本颜色
		 */
		public static const OBJECT_TEXT_COLOR:String = "obj.text.color";
		/**
		 * 对象:文本字体大小
		 */
		public static const OBJECT_TEXT_SIZE:String = "obj.text.size";
		/**
		 * 对象:内部链接id
		 */
		public static const OBJECT_TOPO_ID:String = "obj.topo.id";
		/**
		 * 对象:内部链接名称
		 */
		public static const OBJECT_TOPO_NAME:String = "obj.topo.name";
		/**
		 * 对象:内部链接数据源
		 */
		public static const OBJECT_TOPO_TOPONAME:String = "obj.topo.toponame";
		/**
		 * 对象:内部链接的类型
		 */
		public static const OBJECT_TOPO_TYPE:String = "obj.topo.type";
		/**
		 * 对象:内部链接打开方式 (new:新窗口打开,  this:自身窗口打开)
		 */
		public static const OBJECT_TOPO_OPENTYPE:String = "obj.topo.opentype";
		/**
		 * 对象:展示类型 (icon: 图标展现, shape:形状展现 )
		 */
		public static const OBJECT_SHOW_TYPE:String = "obj.show.type";
		/**
		 * 对象:缩略图获取数据的id
		 */
		public static const OBJECT_TOPO_SOURCE_ID:String = "obj.topo.source.id";
		/**
		 * 对象:缩略图获取数据的名称
		 */
		public static const OBJECT_TOPO_SOURCE_NAME:String = "obj.topo.source.name";
		/**
		 * 对象:缩略图获取数据的拓扑数据源
		 */
		public static const OBJECT_TOPO_SOURCE_TOPONAME:String = "obj.topo.source.toponame";
		/**
		 * 对象:缩略图获取数据的类型
		 */
		public static const OBJECT_TOPO_SOURCE_TYPE:String = "obj.topo.source.type";
		/**
		 * 对象:缩略图获取数据的参数
		 */
		public static const OBJECT_TOPO_SOURCE_PARAM:String = "obj.topo.source.param";


		/**
		 * 形状: 形状类型
		 */
		public static const SHAPE_TYPE:String = "shape.type";
		/**
		 * 形状: 形状 平行四边形的角度
		 */
		public static const SHAPE_PARALLELOGRAM_ANGLE:String = "shape.parallelogram.angle";
		/**
		 * 形状: 填充方式(color:颜色, image:图片)
		 */
		public static const SHAPE_FILL_TYPE:String = "shape.fill.type";
		/**
		 * 形状: 填充颜色(开始颜色)
		 */
		public static const SHAPE_FILL_COLOR_START:String = "shape.fill.color.start";
		/**
		 * 形状: 填充颜色(结束颜色)
		 */
		public static const SHAPE_FILL_COLOR_END:String = "shape.fill.color.end";
		/**
		 * 形状: 填充图片
		 */
		public static const SHAPE_FILL_IMAGE:String = "shape.fill.image";
		/**
		 * 形状: 填充透明度
		 */
		public static const SHAPE_FILL_ALPHA:String = "shape.fill.alpha";
		/**
		 * 形状: 边框颜色
		 */
		public static const SHAPE_BORDER_COLOR:String = "shape.border.color";
		/**
		 * 形状: 边框透明度
		 */
		public static const SHAPE_BORDER_ALPHA:String = "shape.border.alpha";
		/**
		 * 形状: 边框宽度
		 */
		public static const SHAPE_BORDER_WIDTH:String = "shape.border.width";
		/**
		 * 形状: 是否启用阴影
		 */
		public static const SHAPE_SHADOW_ENABLE:String = "shape.shadow.enable";
		/**
		 * 分组: 默认状态 (open: 展开, close:闭合)
		 */
		public static const GROUP_DEFAULT_STATUS:String = "group.default.status";
		/**
		 * 分组: 闭合时图标
		 */
		public static const GROUP_CLOSED_ICON:String = "group.closed.icon";
		/**
		 * 网格: 行数量
		 */
		public static const GRID_ROW_COUNT:String = "grid.row.count";
		/**
		 * 网格: 每行的占比,如: 0.4,0.6
		 */
		public static const GRID_ROW_PERCENTS:String = "grid.row.percents";
		/**
		 * 网格: 每行对应的序号(是数组)
		 */
		public static const GRID_ROW_SERIAL:String = "grid.row.serial";
		/**
		 * 网格: 行Label的布局
		 */
		public static const GRID_ROW_LABEL_LAYOUT:String = "grid.row.label.layout";
		/**
		 * 网格: 行Label的显示范围的宽度
		 */
		public static const GRID_ROW_LABEL_RECTWIDTH:String = "grid.row.label.rectwidth";
		/**
		 * 网格: 行Label的填充颜色
		 */
		public static const GRID_ROW_LABEL_FILL_COLOR:String = "grid.row.label.fill.color";
		/**
		 * 网格: 行Label的填充透明度
		 */
		public static const GRID_ROW_LABEL_FILL_ALPHA:String = "grid.row.label.fill.alpha";
		/**
		 * 网格: 行Label的边框透明度
		 */
		public static const GRID_ROW_LABEL_BORDER_ALPHA:String = "grid.row.label.border.aplha";

		/**
		 * 网格: 列数量
		 */
		public static const GRID_COLUMN_COUNT:String = "grid.column.count";
		/**
		 * 网格: 每列的占比,如: 0.4,0.6
		 */
		public static const GRID_COLUMN_PERCENTS:String = "grid.column.percents";
		/**
		 * 网格: 每列对应的序号(是数组)
		 */
		public static const GRID_COLUMN_SERIAL:String = "grid.column.serial";
		/**
		 * 网格: 列Label的布局
		 */
		public static const GRID_COLUMN_LABEL_LAYOUT:String = "grid.column.label.layout";
		/**
		 * 网格: 列Label的显示范围的高度
		 */
		public static const GRID_COLUMN_LABEL_RECTHEIGHT:String = "grid.column.label.rectheight";
		/**
		 * 网格: 列Label的填充颜色
		 */
		public static const GRID_COLUMN_LABEL_FILL_COLOR:String = "grid.column.label.fill.color";
		/**
		 * 网格: 列Label的填充透明度
		 */
		public static const GRID_COLUMN_LABEL_FILL_ALPHA:String = "grid.column.label.fill.alpha";
		/**
		 * 网格: 列Label的边框透明度
		 */
		public static const GRID_COLUMN_LABEL_BORDER_ALPHA:String = "grid.column.label.border.aplha";

		/**
		 * 网格: Label的拼装格式(行-列 / 列-行)
		 */
		public static const GRID_LABEL_SPELL:String = "grid.label.spell";

		/**
		 * 网格: 边框宽度
		 */
		public static const GRID_BORDER_WIDTH:String = "grid.border.width";
		/**
		 * 网格: 边框颜色
		 */
		public static const GRID_BORDER_COLOR:String = "grid.border.color";
		/**
		 * 网格: 边框透明度
		 */
		public static const GRID_BORDER_ALPHA:String = "grid.border.alpha";
		/**
		 * 网格: 边框的符号(实线,虚线)
		 */
		public static const GRID_BORDER_SYMBOL:String = "grid.border.symbol";
		/**
		 * 网格: CELL填充颜色(开始颜色)
		 */
		public static const GRID_CELL_FILL_COLOR_START:String = "grid.cell.fill.color.start";
		/**
		 * 网格: CELL填充颜色(结束颜色)
		 */
		public static const GRID_CELL_FILL_COLOR_END:String = "grid.cell.fill.color.end";
		/**
		 * 网格: CELL填充透明度
		 */
		public static const GRID_CELL_FILL_ALPHA:String = "grid.cell.fill.alpha";

		// ---------------------------- 固定属性可选值 -----------------------------
		/**
		 * 属性值: Netview中的类型 -> segment
		 */
		public static const PROPERTYVALUE_NETVIEW_TYPE_SEGMENT:String = "segment";
		/**
		 * 属性值: Netview中的类型 -> view
		 */
		public static const PROPERTYVALUE_NETVIEW_TYPE_VIEW:String = "view";
		/**
		 * 属性值: Label布局方式  -> 底部
		 */
		public static const PROPERTYVALUE_LABEL_LAYOUT_BOTTOM:String = "bottom";
		/**
		 * 属性值: Label布局方式  -> 顶部
		 */
		public static const PROPERTYVALUE_LABEL_LAYOUT_TOP:String = "top";
		/**
		 * 属性值: Label布局方式  -> 左边
		 */
		public static const PROPERTYVALUE_LABEL_LAYOUT_LEFT:String = "left";
		/**
		 * 属性值: Label布局方式  -> 右边
		 */
		public static const PROPERTYVALUE_LABEL_LAYOUT_RIGHT:String = "right";
		/**
		 * 属性值: Label布局方式  -> 隐藏
		 */
		public static const PROPERTYVALUE_LABEL_LAYOUT_HIDE:String = "hide";
		/**
		 * 属性值: 线 线的符号  -> solid:实线
		 */
		public static const PROPERTYVALUE_LINE_SYMBOL_SOLID:String = "solid";
		/**
		 * 属性值: 线 线的符号  ->  dash:虚线
		 */
		public static const PROPERTYVALUE_LINE_SYMBOL_DASH:String = "dash";
		/**
		 * 属性值: 线 类型 -> 直线
		 */
		public static const PROPERTYVALUE_LINE_TYPE_STRAIGHT:String = "straight";
		/**
		 * 属性值: 线 类型 -> 折线
		 */
		public static const PROPERTYVALUE_LINE_TYPE_POLY:String = "poly";
		
		/**
		 * 属性值: 线 类型 -> 二级贝塞尔曲线
		 */
		public static const PROPERTYVALUE_LINE_TYPE_BESSEL2:String = "bessel2";
		/**
		 * 属性值: 链路 默认状态 -> 展开
		 */
		public static const PROPERTYVALUE_LINK_DEFAULT_STATUS_OPEN:String = "open";
		/**
		 * 属性值: 链路 默认状态 -> 闭合
		 */
		public static const PROPERTYVALUE_LINK_DEFAULT_STATUS_CLOSE:String = "close";
		/**
		 * 属性值: 链路 展开后交汇处类型 -> 圆弧
		 */
		public static const PROPERTYVALUE_LINK_OPEN_TYPE_ARC:String = "arc";
		/**
		 * 属性值: 链路 展开后交汇处类型 -> 三角直连
		 */
		public static const PROPERTYVALUE_LINK_OPEN_TYPE_TRIANGLE:String = "triangle";
		/**
		 * 属性值: 链路 展开后交汇处类型 -> 平行(不画交汇线)
		 */
		public static const PROPERTYVALUE_LINK_OPEN_TYPE_PARALLEL:String = "parallel";
		/**
		 * 属性值: 链路 箭头是否启用 -> 启用
		 */
		public static const PROPERTYVALUE_LINK_ARROW_TRUE:String = "true";
		/**
		 * 属性值: 链路 箭头是否启用 -> 禁用
		 */
		public static const PROPERTYVALUE_LINK_ARROW_FALSE:String = "false";
		/**
		 * 属性值: 链路 箭头类型 -> 三角形箭头
		 */
		public static const PROPERTYVALUE_LINK_ARROW_TYPE_DELTA:String = "delta";
		/**
		 * 属性值: Shape  shape_type -> 平行四边形
		 */
		public static const PROPERTYVALUE_SHAPE_TYPE_PARALLELOGRAM:String = "parallelogram";
		/**
		 * 属性值: Shape shape_type -> 圆形
		 */
		public static const PROPERTYVALUE_SHAPE_TYPE_CIRCLE:String = "circle";
		/**
		 * 属性值: Shape shape_type -> 椭圆形
		 */
		public static const PROPERTYVALUE_SHAPE_TYPE_ELLIPSE:String = "ellipse";
		/**
		 * 属性值: Shape shape_type -> 矩形
		 */
		public static const PROPERTYVALUE_SHAPE_TYPE_RECTANGLE:String = "rectangle";
		/**
		 * 属性值: Shape  shape_type -> 梯形
		 */
		public static const PROPERTYVALUE_SHAPE_TYPE_TRAPEZIUM:String = "trapezium";
		/**
		 * 属性值: Shape  填充类型 -> 颜色
		 */
		public static const PROPERTYVALUE_SHAPE_FILL_TYPE_COLOR:String = "color";
		/**
		 * 属性值: Shape  填充类型 -> 图片
		 */
		public static const PROPERTYVALUE_SHAPE_FILL_TYPE_IMAGE:String = "image";
		/**
		 * 属性值: Shape  填充类型 -> 图片(整张图片按比例缩放)
		 */
		public static const PROPERTYVALUE_SHAPE_FILL_TYPE_FULLIMAGE:String = "fullimage";
		/**
		 * 属性值: 分组 默认状态 -> 展开
		 */
		public static const PROPERTYVALUE_GROUP_DEFAULT_STATUS_OPEN:String = "open";
		/**
		 * 属性值: 分组 默认状态 -> 闭合
		 */
		public static const PROPERTYVALUE_GROUP_DEFAULT_STATUS_CLOSE:String = "close";

		/**
		 * 属性值: 对象 内部链接 链接对象类型 -> 网段
		 */
		public static const PROPERTYVALUE_OBJECT_TOPO_TYPE_SEGMENT:String = "segment";
		/**
		 * 属性值: 对象 内部链接 链接对象类型 -> 视图
		 */
		public static const PROPERTYVALUE_OBJECT_TOPO_TYPE_VIEW:String = "view";
		/**
		 * 属性值: 对象 - 内部链接 打开方式 -> 新窗口打开
		 */
		public static const PROPERTYVALUE_OBJECT_TOPO_OPENTYPE_NEW:String = "new";
		/**
		 * 属性值: 对象 - 内部链接 打开方式 -> 当前拓扑切换
		 */
		public static const PROPERTYVALUE_OBJECT_TOPO_OPENTYPE_THIS:String = "this";
		/**
		 * 属性值: 对象 -  展现形式 -> 图标展现
		 */
		public static const PROPERTYVALUE_OBJECT_SHOW_TYPE_ICON:String = "icon";
		/**
		 * 属性值: 对象 -  展现形式 -> 形状展现
		 */
		public static const PROPERTYVALUE_OBJECT_SHOW_TYPE_SHAPE:String = "shape";

		/**
		 * 属性值: 对象 - type -> 形状
		 */
		public static const PROPERTYVALUE_OBJECT_TYPE_SHAPE:String = "ztype.shape";
		/**
		 * 属性值: 对象 - type -> 线
		 */
		public static const PROPERTYVALUE_OBJECT_TYPE_LINE:String = "ztype.line";
		/**
		 * 属性值: 对象 - type -> 文本
		 */
		public static const PROPERTYVALUE_OBJECT_TYPE_TEXT:String = "ztype.text";
		/**
		 * 属性值: 对象 - type -> URL连接
		 */
		public static const PROPERTYVALUE_OBJECT_TYPE_HLINK_URL:String = "ztype.url";
		/**
		 * 属性值: 对象 - type -> 拓扑内部链接
		 */
		public static const PROPERTYVALUE_OBJECT_TYPE_HLINK_TOPO:String = "ztype.topo";
		/**
		 * 属性值: 对象 - type -> 立体层次链接
		 */
		public static const PROPERTYVALUE_OBJECT_TYPE_HLINK_LAYER:String = "ztype.layer";
		/**
		 * 属性值: 对象 - type -> 视图对象
		 */
		public static const PROPERTYVALUE_OBJECT_TYPE_VIEW:String = "ztype.view";
		/**
		 * 属性值: 对象 - type -> 简单/通用的对象
		 */
		public static const PROPERTYVALUE_OBJECT_TYPE_OBJECT:String = "ztype.obj";
		/**
		 * 属性值: 对象 - type -> 网格对象
		 */
		public static const PROPERTYVALUE_OBJECT_TYPE_GRID:String = "ztype.grid";

		/**
		 * 属性值: Link - type -> 普通链路
		 */
		public static const PROPERTYVALUE_LINK_TYPE_NORMAL:String = "link";
		/**
		 * 属性值: Link - type -> 缩略图间链路
		 */
		public static const PROPERTYVALUE_LINK_TYPE_LAYER:String = "link.layer";

		/**
		 * 属性值: Grid - 行Label布局 -> 左侧
		 */
		public static const PROPERTYVALUE_GRID_ROW_LABEL_LAYOUT_LEFT:String = "left";
		/**
		 * 属性值: Grid - 行Label布局 -> 右侧
		 */
		public static const PROPERTYVALUE_GRID_ROW_LABEL_LAYOUT_RIGHT:String = "right";
		/**
		 * 属性值: Grid - 列Label布局 -> 顶部
		 */
		public static const PROPERTYVALUE_GRID_COLUMN_LABEL_LAYOUT_TOP:String = "top";
		/**
		 * 属性值: Grid - 列Label布局 -> 底部
		 */
		public static const PROPERTYVALUE_GRID_COLUMN_LABEL_LAYOUT_BOTTOM:String = "bottom";
		/**
		 * 属性值: Grid - Label布局 -> 隐藏
		 */
		public static const PROPERTYVALUE_GRID_LABEL_LAYOUT_HIDE:String = "hide";
		/**
		 * 属性值: Grid - Label拼写格式 -> 行列
		 */
		public static const PROPERTYVALUE_GRID_LABEL_SPELL_RC:String = "rowcolumn";
		/**
		 * 属性值: Grid - Label拼写格式 -> 列行
		 */
		public static const PROPERTYVALUE_GRID_LABEL_SPELL_CR:String = "columnrow";

		// ---------------------------- 默认值 -----------------------------
		/**
		 * 默认值: 图标的宽度
		 */
		public static const DEFAULT_ICON_WIDTH:Number = -1;
		/**
		 * 默认值: 图标的高度
		 */
		public static const DEFAULT_ICON_HEIGHT:Number = -1;
		/**
		 * 默认值: Label布局方式
		 */
		public static const DEFAULT_LABEL_LAYOUT:String = PROPERTYVALUE_LABEL_LAYOUT_BOTTOM;
		/**
		 * 默认值: Label的最大宽度
		 */
		public static const DEFAULT_LABEL_MAXWIDTH:Number = -1;
		/**
		 * 默认值: 线的提示信息
		 */
		public static const DEFAULT_LINE_TOOLTIP:String = "";
		/**
		 * 默认值: 线颜色
		 */
		public static const DEFAULT_LINE_COLOR:uint = 0x43dee7;
		/**
		 * 默认值: 线选中时颜色
		 */
		public static const DEFAULT_LINE_COLOR_SELECTED:uint = 0xf1f1f1;
		/**
		 * 默认值: 线粗细
		 */
		public static const DEFAULT_LINE_WIDTH:Number = 2;
		/**
		 * 默认值: 线透明度
		 */
		public static const DEFAULT_LINE_ALPHA:Number = 1;
		/**
		 * 默认值: 线的符号 (solid:实线)
		 */
		public static const DEFAULT_LINE_SYMBOL:String = PROPERTYVALUE_LINE_SYMBOL_SOLID;
		/**
		 * 默认值: 线的类型 (straight:直线)
		 */
		public static const DEFAULT_LINE_TYPE:String = PROPERTYVALUE_LINE_TYPE_STRAIGHT;

		/**
		 * 默认值: 链路默认状态 (闭合)
		 */
		public static const DEFAULT_LINK_DEFAULT_STATUS:String = PROPERTYVALUE_LINK_DEFAULT_STATUS_CLOSE;
		/**
		 * 默认值: 链路的物理链路数量
		 */
		public static const DEFAULT_LINK_COUNT:uint = 0;
		/**
		 * 默认值: 链路二级贝塞尔控制点沿中心点垂直偏移量
		 */
		public static const DEFAULT_LINK_BESSEL2_OFFSETV:Number = 40;
		/**
		 * 默认值: 链路展开后间隙
		 */
		public static const DEFAULT_LINK_OPEN_GAP:Number = 5;
		/**
		 * 默认值: 链路展开后三级贝塞尔曲线控制点沿链路方向偏移量
		 */
		public static const DEFAULT_LINK_OPEN_OFFSETH:Number = 10;
		/**
		 * 默认值: 链路展开后多条线交汇处类型
		 */
		public static const DEFAULT_LINK_OPEN_TYPE:String = PROPERTYVALUE_LINK_OPEN_TYPE_TRIANGLE;
		/**
		 * 默认值: 链路箭头类型
		 */
		public static const DEFAULT_LINK_ARROW_TYPE:String = PROPERTYVALUE_LINK_ARROW_TYPE_DELTA;
		/**
		 * 默认值: 链路箭头高度
		 */
		public static const DEFAULT_LINK_ARROW_HEIGHT:Number = 10;
		/**
		 * 默认值: 链路箭头宽度
		 */
		public static const DEFAULT_LINK_ARROW_WIDTH:Number = 10;
		/**
		 * 默认值: 缩略图间链路 颜色
		 */
		public static const DEFAULT_LAYERLINK_COLOR:uint = 0xc7da3d;
		/**
		 * 默认值: 缩略图间链路 粗细
		 */
		public static const DEFAULT_LAYERLINK_WIDTH:Number = 4;
		/**
		 * 默认值: 形状类型
		 */
		public static const DEFAULT_SHAPE_TYPE:String = PROPERTYVALUE_SHAPE_TYPE_RECTANGLE;
		/**
		 * 默认值: 形状 平行四边形的倾斜角度(向右倾斜35度)
		 */
		public static const DEFAULT_SHAPE_PARALLELOGRAM_ANGLE:Number = 35;
		/**
		 * 默认值: 形状填充类型
		 */
		public static const DEFAULT_SHAPE_FILL_TYPE:String = PROPERTYVALUE_SHAPE_FILL_TYPE_COLOR;
		/**
		 * 默认值: 形状填充颜色(开始色)
		 */
		public static const DEFAULT_SHAPE_FILL_COLOR_START:uint = 0x003550;
		/**
		 * 默认值: 形状填充颜色(结束色)
		 */
		public static const DEFAULT_SHAPE_FILL_COLOR_END:uint = 0x185A86;
		/**
		 * 默认值: 形状透明度
		 */
		public static const DEFAULT_SHAPE_FILL_ALPHA:Number = 0.7;
		/**
		 * 默认值: 形状边框颜色
		 */
		public static const DEFAULT_SHAPE_BORDER_COLOR:uint = 0x27A2AD;
		/**
		 * 默认值: 形状边框宽度
		 */
		public static const DEFAULT_SHAPE_BORDER_WIDTH:Number = 2;
		/**
		 * 默认值: 形状边框透明度
		 */
		public static const DEFAULT_SHAPE_BORDER_ALPHA:Number = 0.7;
		/**
		 * 默认值: 形状是否启用阴影效果(启用)
		 */
		public static const DEFAULT_SHAPE_SHADOW_ENABLE:Number = 1;
		/**
		 * 默认值: 分组图标
		 */
		public static const DEFAULT_GROUP_CLOSED_ICON:String = "group.png";
		/**
		 * 默认值: 分组默认状态
		 */
		public static const DEFAULT_GROUP_DEFAULT_STATUS:String = PROPERTYVALUE_GROUP_DEFAULT_STATUS_CLOSE;

		/**
		 * 默认值: 对象.文本字体颜色
		 */
		public static const DEFAULT_OBJECT_TEXT_COLOR:uint = 0x999900;
		/**
		 * 默认值: 对象.文本字体大小
		 */
		public static const DEFAULT_OBJECT_TEXT_SIZE:int = 12;

		/**
		 * 默认值: 对象.展现形式  图标展现
		 */
		public static const DEFAULT_OBJECT_SHOW_TYPE:String = PROPERTYVALUE_OBJECT_SHOW_TYPE_ICON;
		/**
		 * 默认值: 对象.内部链接对象 链接对象类型
		 */
		public static const DEFAULT_OBJECT_TOPO_TYPE:String = PROPERTYVALUE_OBJECT_TOPO_TYPE_SEGMENT;
		/**
		 * 默认值: 对象.内部链接对象 打开方式
		 */
		public static const DEFAULT_OBJECT_TOPO_OPENTYPE:String = PROPERTYVALUE_OBJECT_TOPO_OPENTYPE_THIS;
		/**
		 * 默认值: 对象.内部链接对象 图层展现时的形状类型
		 */
		public static const DEFAULT_OBJECT_TOPO_SHAPE_TYPE:String = PROPERTYVALUE_SHAPE_TYPE_RECTANGLE;
		/**
		 * 默认值: Grid.行数量
		 */
		public static const DEFAULT_GRID_ROW_COUNT:uint = 1;
		/**
		 * 默认值: Grid.列数量
		 */
		public static const DEFAULT_GRID_COLUMN_COUNT:uint = 1;
		/**
		 * 默认值: Grid.行Label布局
		 */
		public static const DEFAULT_GRID_ROW_LABEL_LAYOUT:String = PROPERTYVALUE_GRID_ROW_LABEL_LAYOUT_LEFT;
		/**
		 * 默认值: Grid.行Label的显示范围的宽度
		 */
		public static const DEFAULT_GRID_ROW_LABEL_RECTWIDTH:Number = -1;
		/**
		 * 默认值: Grid.行Label的填充色
		 */
		public static const DEFAULT_GRID_ROW_LABEL_FILL_COLOR:uint = 0x395f84;
		/**
		 * 默认值: Grid.行Label的填充透明度(负数时使用CELL填充透明度)
		 */
		public static const DEFAULT_GRID_ROW_LABEL_FILL_ALPHA:Number = -1;
		/**
		 * 默认值: Grid.行Label边框透明度(负数时使用边框透明度)
		 */
		public static const DEFAULT_GRID_ROW_LABEL_BORDER_ALPHA:Number = -1;

		/**
		 * 默认值: Grid.列Label布局
		 */
		public static const DEFAULT_GRID_COLUMN_LABEL_LAYOUT:String = PROPERTYVALUE_GRID_COLUMN_LABEL_LAYOUT_TOP;
		/**
		 * 默认值: Grid.列Label的显示范围的高度
		 */
		public static const DEFAULT_GRID_COLUMN_LABEL_RECTHEIGHT:Number = -1;
		/**
		 * 默认值: Grid.列Label的填充色
		 */
		public static const DEFAULT_GRID_COLUMN_LABEL_FILL_COLOR:uint = 0x395f84;
		/**
		 * 默认值: Grid.列Label的填充透明度(负数时使用CELL填充透明度)
		 */
		public static const DEFAULT_GRID_COLUMN_LABEL_FILL_ALPHA:Number = -1;
		/**
		 * 默认值: Grid.列Label边框透明度(负数时使用边框透明度)
		 */
		public static const DEFAULT_GRID_COLUMN_LABEL_BORDER_ALPHA:Number = -1;

		/**
		 * 默认值: Grid.Label拼写格式
		 */
		public static const DEFAULT_GRID_LABEL_SPELL:String = PROPERTYVALUE_GRID_LABEL_SPELL_CR;
		/**
		 * 默认值: Grid.边框颜色
		 */
		public static const DEFAULT_GRID_BORDER_COLOR:uint = 0x27A2AD;
		/**
		 * 默认值: Grid.边框宽度
		 */
		public static const DEFAULT_GRID_BORDER_WIDTH:Number = 2;
		/**
		 * 默认值: Grid.边框透明度
		 */
		public static const DEFAULT_GRID_BORDER_ALPHA:Number = 1;
		/**
		 * 默认值: Grid.边框模式(实线,虚线)
		 */
		public static const DEFAULT_GRID_BORDER_SYMBOL:String = PROPERTYVALUE_LINE_SYMBOL_SOLID;
		/**
		 * 默认值: Grid.Cell填充颜色(开始色)
		 */
		public static const DEFAULT_GRID_CELL_FILL_COLOR_START:uint = 0x003550;
		/**
		 * 默认值: Grid.Cell填充颜色(结束色)
		 */
		public static const DEFAULT_GRID_CELL_FILL_COLOR_END:uint = 0x185A86;
		/**
		 * 默认值: Grid.Cell填充透明度
		 */
		public static const DEFAULT_GRID_CELL_FILL_ALPHA:Number = 0.1;

	}
}