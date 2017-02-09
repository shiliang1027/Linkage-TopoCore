package com.linkage.module.topo.framework
{
	import spark.filters.ColorMatrixFilter;

	/**
	 * 常量定义类
	 * @author duangr
	 *
	 */
	public final class Constants
	{
		/**
		 * 默认值: 画布的内补丁,数据+内补丁=数据边界
		 */
		public static const DEFAULT_CANVAS_PADDING:int = 150; //150;
		/**
		 *  默认值: 选中时边框的颜色
		 */
		public static const DEFAULT_SELECTED_BORDER_COLOR:uint = 0x43dee7;
		/**
		 * 默认值: 面对象选中时边框的颜色的filter (0xf1f1f1)
		 */
		public static const DEFAULT_SELECTED_PLANE_FILTER:ColorMatrixFilter = new ColorMatrixFilter([0, 0, 0, 0, 241].concat([0, 0, 0, 0, 241], [0, 0, 0, 0, 241], [0, 0, 0, 1, 0]));
		/**
		 *  默认值: 元素label的颜色
		 */
		public static const DEFAULT_LABEL_COLOR:uint = 0xFFFFFF;
		/**
		 * 默认值: 框选框的颜色
		 */
		public static const DEFAULT_SELECTAREA_LINE_COLOR:uint = 0xff0000;
		/**
		 * 默认值: 框选框的粗细
		 */
		public static const DEFAULT_SELECTAREA_LINE_SIZE:uint = 1;
		/**
		 * 默认值: 创建形状模式下框选框颜色
		 */
		public static const DEFAULT_CREATESHAPE_SELECTAREA_LINE_COLOR:uint = 0x00ff00;
		/**
		 * 默认值: 创建形状模式下框选框的粗细
		 */
		public static const DEFAULT_CREATESHAPE_SELECTAREA_LINE_SIZE:uint = 1;
		/**
		 * 默认值: 创建缩略图模式下框选框颜色
		 */
		public static const DEFAULT_CREATEHLINKLAYER_SELECTAREA_LINE_COLOR:uint = 0x00ff00;
		/**
		 * 默认值: 创建缩略图模式下框选框的粗细
		 */
		public static const DEFAULT_CREATEHLINKLAYER_SELECTAREA_LINE_SIZE:uint = 1;
		/**
		 * 默认值: 创建链路模式下线的颜色
		 */
		public static const DEFAULT_CREATELINK_LINE_COLOR:uint = 0x00ff00;
		/**
		 * 默认值: 创建链路模式下线的粗细
		 */
		public static const DEFAULT_CREATELINK_LINE_SIZE:uint = 4;
		/**
		 * 默认值: 图标的默认大小
		 */
		public static const DEFAULT_ICON_SIZE:Number = 32;
		/**
		 * 默认值: 元素显示时的透明度
		 */
		public static const DEFAULT_FEATURE_ALPHA_SHOW:Number = 1;
		/**
		 * 默认值: 元素隐藏时的透明度
		 */
		public static const DEFAULT_FEATURE_ALPHA_HIDE:Number = 0.5;
		/**
		 * 默认值: 拓扑数据源名称
		 */
		public static const DEFAULT_TOPONAME:String = "default-topo";
		/**
		 * 默认值: 网段对象的默认图标
		 */
		public static const DEFAULT_SEGMENT_ICON:String = "segment.png";

		// --------------- 页面传入参数 --------------
		/**
		 * 页面传入参数: 用户信息
		 */
		public static const PARAM_USER:String = "user";

		/**
		 * 页面传入参数: 会话id
		 */
		public static const PARAM_SESSIONID:String = "sessionId";

		/**
		 * 页面传入参数: 远程图标上下文路径
		 */
		public static const PARAM_ICON_CONTEXT:String = "iconContext";
		/**
		 * 页面传入参数: 远程填充图标上下文路径
		 */
		public static const PARAM_ICONFILL_CONTEXT:String = "iconFillContext";

		/**
		 * 页面传入参数: URL上下文路径(url相对ip:port之外的路径)
		 */
		public static const PARAM_URL_CONTEXT:String = "urlContext";

		/**
		 * 页面传入参数: 默认打开的拓扑图层次id
		 */
		public static const PARAM_TOPOID:String = "id";
		/**
		 * 页面传入参数: 默认打开的拓扑图层次的数据源名称
		 */
		public static const PARAM_TOPONAME:String = "topoName";
		/**
		 * 页面传入参数: 默认打开的拓扑图层次类型
		 */
		public static const PARAM_TOPOTYPE:String = "type";
		/**
		 * 页面传入参数: 拓扑树默认加载的层级
		 */
		public static const PARAM_TREELEVEL:String = "treeLevel";
		/**
		 * 页面传入参数: 拓扑树显示网元的状态   0:隐藏; 1:显示; 2:全部
		 */
		public static const PARAM_TREEVISIBLE:String = "treeVisible";
		/**
		 * 页面传入参数: 是否允许渲染告警数量
		 */
		public static const PARAM_RENDERALARMNUM_ENABLED:String = "renderAlarmNumEnabled";
		/**
		 * 页面传入参数: 拓扑工具栏图标按钮的权限关键字
		 */
		public static const PARAM_TOOLBAR_AUTHKEYS:String = "toolbarAuthKeys";

		// -------------- 权重 --------------
		/**
		 * 权重值: Canvas [二进制] 1
		 */
		public static const WEIGHT_CANVAS:uint = 1;
		/**
		 * 权重值: Node [二进制] 10
		 */
		public static const WEIGHT_ELEMENT_NODE:uint = 2;
		/**
		 * 权重值: Segment [二进制] 100
		 */
		public static const WEIGHT_ELEMENT_SEGMENT:uint = 4;
		/**
		 * 权重值: Link [二进制] 1000
		 */
		public static const WEIGHT_ELEMENT_LINK:uint = 8;
		/**
		 * 权重值: Group [二进制] 10000
		 */
		public static const WEIGHT_ELEMENT_GROUP:uint = 16;
		/**
		 * 权重值: TPShape (ztype.shape) [二进制] 100000
		 */
		public static const WEIGHT_ELEMENT_SHAPE:uint = 32;
		/**
		 * 权重值: TPText (ztype.text) [二进制] 1000000
		 */
		public static const WEIGHT_ELEMENT_TEXT:uint = 64;
		/**
		 * 权重值: HLinkUrl (ztype.url) [二进制] 10000000
		 */
		public static const WEIGHT_ELEMENT_HLINKURL:uint = 128;
		/**
		 * 权重值: HLinkTopo (ztype.topo) [二进制] 100000000
		 */
		public static const WEIGHT_ELEMENT_HLINKTOPO:uint = 256;
		/**
		 * 权重值: HLinkLayer (ztype.layer) [二进制] 1000000000
		 */
		public static const WEIGHT_ELEMENT_HLINKLAYER:uint = 512;
		/**
		 * 权重值: TPLine (ztype.line) [二进制] 10000000000
		 */
		public static const WEIGHT_ELEMENT_LINE:uint = 1024;
		/**
		 * 权重值: TPView  (ztype.view) [二进制] 100000000000
		 */
		public static const WEIGHT_ELEMENT_VIEW:uint = 2048;
		/**
		 * 权重值: LayerLink(缩略图间链路,是Link对象中的子类 link.layer) [二进制] 1000000000000
		 */
		public static const WEIGHT_ELEMENT_LAYERLINK:uint = 4096;
		/**
		 * 权重值: TPObject(ztype.obj) [二进制] 10000000000000
		 */
		public static const WEIGHT_ELEMENT_TPOBJECT:uint = 8192;
		/**
		 * 权重值: TPGrid(ztype.grid) [二进制] 100000000000000
		 */
		public static const WEIGHT_ELEMENT_TPGRID:uint = 16384;

		// ---------------- 模式 -------------------
		/**
		 * 权重值: ACTION 选择模式 [二进制] 1
		 */
		public static const WEIGHT_ACTION_SELECT:uint = 1;
		/**
		 * 权重值: ACTION 编辑模式 [二进制] 10
		 */
		public static const WEIGHT_ACTION_EDIT:uint = 2;
		/**
		 * 权重值: ACTION 链路编辑模式 [二进制] 100
		 */
		public static const WEIGHT_ACTION_LINK_EDIT:uint = 4;

		// -------------- 对象类型 --------------
		/**
		 * 节点名称: Node
		 */
		public static const ITEM_NAME_NODE:String = "Node";
		/**
		 * 节点名称: Segment
		 */
		public static const ITEM_NAME_SEGMENT:String = "Segment";
		/**
		 * 节点名称: TPGroup
		 */
		public static const ITEM_NAME_TPGROUP:String = "Group";
		/**
		 * 节点名称: Link
		 */
		public static const ITEM_NAME_LINK:String = "Link";
		/**
		 * 节点名称: LayerLink
		 */
		public static const ITEM_NAME_LAYERLINK:String = "Link";
		/**
		 * 节点名称: TPLine
		 */
		public static const ITEM_NAME_TPLINE:String = "Object";
		/**
		 * 节点名称: TPText
		 */
		public static const ITEM_NAME_TPTEXT:String = "Object";
		/**
		 * 节点名称: TPShape
		 */
		public static const ITEM_NAME_TPSHAPE:String = "Object";
		/**
		 * 节点名称: HLinkLayer
		 */
		public static const ITEM_NAME_HLINKLAYER:String = "Object";
		/**
		 * 节点名称: HLinkTopo
		 */
		public static const ITEM_NAME_HLINKTOPO:String = "Object";
		/**
		 * 节点名称: HLinkUrl
		 */
		public static const ITEM_NAME_HLINKURL:String = "Object";
		/**
		 * 节点名称: TPView
		 */
		public static const ITEM_NAME_TPVIEW:String = "Object";
		/**
		 * 节点名称: TPObject
		 */
		public static const ITEM_NAME_TPOBJECT:String = "Object";
		/**
		 * 节点名称: TPGrid
		 */
		public static const ITEM_NAME_TPGRID:String = "Object";

		// -------------- 菜单类型 --------------
		/**
		 * 菜单类型: 外部事件 URL型
		 */
		public static const MENU_TYPE_URL:String = "url";
		/**
		 * 菜单类型: 内部事件
		 */
		public static const MENU_TYPE_EVENT:String = "event";
		/**
		 * 菜单ACTION中event类型支持的KEY: EventType
		 */
		public static const MENU_ACTION_EVENTKEY_EVENTTYPE:String = "EventType";
		/**
		 * 菜单ACTION中event类型支持的KEY: EventProperty
		 */
		public static const MENU_ACTION_EVENTKEY_EVENTPROPERTY:String = "EventProperty";
		/**
		 * 菜单构造类型: 静态视图
		 */
		public static const MENU_ZTYPE_STATIC_VIEW:String = "static_view";


		// ----------- webtopo向MC发起事件 -----------
		/**
		 * 向MC发起事件: 修改节点图标
		 */
		public static const TP_MC_MODIFY_NODEICON_TYPE:String = "TP_MC_MODIFY_NODEICON_TYPE";
		/**
		 * 向MC发起事件: 添加批量的元素(包括设备,网段,对象,链路,分组等)
		 */
		public static const TP_MC_ADD_WEBTOPO:String = "TP_MC_ADD_WEBTOPO";
		/**
		 * 向MC发起事件: 添加对象
		 */
		public static const TP_MC_ADD_OBJECT:String = "TP_MC_ADD_OBJECT";
		/**
		 * 向MC发起事件: 添加设备
		 */
		public static const TP_MC_ADD_DEVICE:String = "TP_MC_ADD_DEVICE";
		/**
		 * 向MC发起事件: 添加网段
		 */
		public static const TP_MC_ADD_SEGMENT:String = "TP_MC_ADD_SEGMENT";
		/**
		 * 向MC发起事件: 添加链路
		 */
		public static const TP_MC_ADD_LINK:String = "TP_MC_ADD_LINK";
		/**
		 * 向MC发起事件: 添加分组
		 */
		public static const TP_MC_ADD_GROUP:String = "TP_MC_ADD_GROUP";
		/**
		 * 向MC发起事件: 向分组中添加元素
		 */
		public static const TP_MC_ADD_ELEMENTS_TO_GROUP:String = "TP_MC_ADD_ELEMENTS_TO_GROUP";
		/**
		 * 向MC发起事件: 从分组中删除元素
		 */
		public static const TP_MC_REMOVE_ELEMENTS_FROM_GROUP:String = "TP_MC_REMOVE_ELEMENTS_FROM_GROUP";
		/**
		 * 向MC发起事件: 添加视图
		 */
		public static const TP_MC_ADD_TOPOVIEW:String = "TP_MC_ADD_TOPOVIEW";
		/**
		 * 向MC发起事件：删除视图(批量接口)
		 */
		public static const TP_MC_REMOVE_TOPOVIEW:String = "TP_MC_REMOVE_TOPOVIEW";
		/**
		 * 向MC发起事件: 删除网元
		 */
		public static const TP_MC_REMOVE_ELEMENTS:String = "TP_MC_REMOVE_ELEMENTS";
		/**
		 * 向MC发起事件: 删除网元(从视图中删除)
		 */
		public static const TP_MC_REMOVE_ELEMENTS_FROM_TOPOVIEW:String = "TP_MC_REMOVE_ELEMENTS_FROM_TOPOVIEW";
		/**
		 * 向MC发起事件：修改网元
		 */
		public static const TP_MC_MODIFY_ELEMENTS:String = "TP_MC_MODIFY_ELEMENTS";
		/**
		 * 向MC发起事件：显示隐藏网元
		 */
		public static const TP_MC_MD_VISIBLE_ELEMENTS:String = "TP_MC_MD_VISIBLE_ELEMENTS";
		/**
		 * 向MC发起事件：导入网元
		 */
		public static const TP_MC_IMPORT_ELEMENTS:String = "TP_MC_IMPORT_ELEMENTS";
		/**
		 * 向MC发起事件：导入集团资源
		 */
		public static const TP_MC_IMPORT_JTKH:String = "TP_MC_IMPORT_JTKH";
		/**
		 * 向MC发起事件：修改网元属性
		 */
		public static const TP_MC_MODIFY_ELEMENTATTRIBUTE:String = "TP_MC_MODIFY_ELEMENTATTRIBUTE";
		/**
		 * 向MC发起事件：自动生成链路
		 */
		public static const TP_MC_CREATE_ELEMENTS_LINK:String = "TP_MC_CREATE_ELEMENTS_LINK";
		/**
		 * 向MC发起事件：自动生成拓扑
		 */
		public static const TP_MC_CREATE_ACCESS_TOPO:String = "TP_MC_CREATE_ACCESS_TOPO";
		/**
		 * 向MC发起事件：自动生成指定网元的链路
		 */
		public static const TP_MC_AUTOFIND_ELEMENTS_LINK:String = "TP_MC_AUTOFIND_ELEMENTS_LINK";
		/**
		 * 向MC发起事件：集客、专线、告警对应数量
		 */
		public static const TP_MC_JKRESOURCE_STATISTIC:String = "TP_MC_JKRESOURCE_STATISTIC";
		/**
		 * 向MC发起事件：网元类型统计设备和告警设备数
		 */
		public static const TP_MC_RESOURCE_STATISTIC:String = "TP_MC_RESOURCE_STATISTIC";
		/**
		 * 向MC发起事件：根据(segment)pid来找到其下面的所以包含的网元节点。
		 */
		public static const TP_MC_ALARM_NEINFO:String = "TP_MC_ALARM_NEINFO";
		/**
		 * 向MC发起事件：获取网元的工程状态<br>
		 * 返回的数据格式为<br>
		 * <pre>
		 * &lt;WorkStatus&gt;
		 *  &lt;${id}&gt;work_stat&lt;/${id}&gt;
		 * &lt;/WorkStatus&gt;
		 * </pre>
		 */
		public static const TP_MC_ELEMENTS_WORK_STATS:String = "TP_MC_ELEMENTS_WORK_STATS";
		/**
		 * 向MC发起事件：对称布局
		 */
		public static const TP_MC_SPRING_LAYOUT:String = "TP_MC_SPRING_LAYOUT";
		/**
		 * 向MC发起事件：树形布局
		 */
		public static const TP_MC_TREE_LAYOUT:String = "TP_MC_TREE_LAYOUT";
		/**
		 * 向MC发起事件：圆形布局
		 */
		public static const TP_MC_CIRCLE_LAYOUT:String = "TP_MC_CIRCLE_LAYOUT";
		/**
		 * 向MC发起事件：复制拓扑对象
		 */
		public static const TP_MC_PASTE_COPY:String = "TP_MC_PASTE_COPY";
		/**
		 * 向MC发起事件：复制拓扑对象到视图中
		 */
		public static const TP_MC_PASTE_COPY_INVIEW:String = "TP_MC_PASTE_COPY_INVIEW";
		/**
		 * 向MC发起事件：获取有告警的传输电路
		 */
		public static const TP_MC_PRINT_ALARMED_CIRCUIT:String = "TP_MC_PRINT_ALARMED_CIRCUIT";


		// ------------------ 与后台交互xml中的KEY ---------------------
		/**
		 * 与后台交互xml中的KEY: 元素xml
		 */
		public static const XML_KEY_ELEMENTXML:String = "elementxml";
		/**
		 * 与后台交互xml中的KEY: 操作是否成功标致
		 */
		public static const XML_KEY_SUCCESS:String = "success";
		/**
		 * 与后台交互xml中的KEY: 操作结果的提示信息
		 */
		public static const XML_KEY_MSG:String = "msg";
		/**
		 * 与后台交互xml中的KEY: 元素的id
		 */
		public static const XML_KEY_ID:String = "id";
		/**
		 * 与后台交互xml中的KEY: 元素的pid
		 */
		public static const XML_KEY_PID:String = "pid";
		/**
		 * 与后台交互xml中的KEY: 元素的类型/网元类型
		 */
		public static const XML_KEY_TYPE:String = "type";
		/**
		 * 与后台交互xml中的KEY: 图标名称
		 */
		public static const XML_KEY_ICONNAME:String = "iconname";
		/**
		 * 与后台交互xml中的KEY: 元素的路径名称
		 */
		public static const XML_KEY_PATH:String = "path";
		/**
		 * 与后台交互xml中的KEY: 元素的路径id
		 */
		public static const XML_KEY_PATHPID:String = "pathPid";
		/**
		 * 与后台交互xml中的KEY: 一组元素的id
		 */
		public static const XML_KEY_OBJIDS:String = "objids";
		/**
		 * 与后台交互xml中的KEY: 一组子元素的id
		 */
		public static const XML_KEY_CHILDIDS:String = "childids";
		/**
		 * 与后台交互xml中的KEY: 网络类型
		 */
		public static const XML_KEY_NET_TYPE:String = "netType";
		/**
		 * 与后台交互xml中的KEY: 行间隙
		 */
		public static const XML_KEY_ROWGAP:String = "rowGap";
		/**
		 * 与后台交互xml中的KEY: 列间隙
		 */
		public static const XML_KEY_COLUMNGAP:String = "columnGap";
		/**
		 * 与后台交互xml中的KEY: 显示/隐藏状态
		 */
		public static const XML_KEY_VISIBLE:String = "visible";
		/**
		 * 与后台交互xml中的KEY: x坐标
		 */
		public static const XML_KEY_X:String = "x";
		/**
		 * 与后台交互xml中的KEY: y坐标
		 */
		public static const XML_KEY_Y:String = "y";
		/**
		 * 与后台交互xml中的KEY: 布局方式
		 */
		public static const XML_KEY_LAYOUT_TYPE:String = "layoutType";
		/**
		 * 与后台交互xml中的KEY: 视图id
		 */
		public static const XML_KEY_TOPOVIEW_ID:String = "topoview_id";
		/**
		 * 与后台交互xml中的KEY: 视图名称
		 */
		public static const XML_KEY_TOPOVIEW_NAME:String = "topoview_name";
		/**
		 * 与后台交互xml中的KEY: 是否包含子网
		 */
		public static const XML_KEY_ISINCLUDESUBNET:String = "isIncludeSubNet";
		/**
		 * 与后台交互xml中的KEY: 半径
		 */
		public static const XML_KEY_RADIUS:String = "radius";
		/**
		 * 与后台交互xml中的KEY: 节点间隙
		 */
		public static const XML_KEY_NODEGAP:String = "nodeGap";
		/**
		 * 与后台交互xml中的KEY: 扇形角度
		 */
		public static const XML_KEY_FANANGLE:String = "fanAngle";
		/**
		 * 与后台交互xml中的KEY: 根的pid
		 */
		public static const XML_KEY_ROOTPID:String = "rootpid";
		/**
		 * 与后台交互xml中的KEY: 是否使用当前对象的id入库保存
		 */
		public static const XML_KEY_CURID_ENABLED:String = "curid_enabled";

		// --------------- 对象支持的属性KEY ---------------
		/**
		 * 属性: 画布 -> 是否可以后退(返回上级)
		 */
		public static const PROPERTY_CANVAS_GOBACKENABLE:String = "goback_enable";
		/**
		 * 属性: 画布 -> 是否存在已被剪切对象
		 */
		public static const PROPERTY_CANVAS_HASCUT:String = "has_cut";
		/**
		 * 属性: 画布 -> 是否存在已被剪切对象
		 */
		public static const PROPERTY_CANVAS_HASCOPY:String = "has_copy";
		/**
		 * 属性: 画布 -> 是否处于锁定状态
		 */
		public static const PROPERTY_CANVAS_ISLOCKED:String = "isLocked";
		/**
		 * 属性: 画布 -> 是否处于高亮关联网元状态
		 */
		public static const PROPERTY_CANVAS_HIGHTLIGHT:String = "hightlightState";

		// --------------- 告警 ---------------
		/**
		 * 告警类型: 全部告警
		 */
		public static const ALARM_TYPE_ALL:String = "0";
		/**
		 * 告警类型: 设备告警
		 */
		public static const ALARM_TYPE_DEVICE:String = "1";
		/**
		 * 告警类型: 性能告警
		 */
		public static const ALARM_TYPE_PERFORMANCE:String = "2";

		// ---------------- 搜索类型 -------------
		/**
		 * 搜索类型: 全部
		 */
		public static const SEARCH_TYPE_ALL:String = "0";
		/**
		 * 搜索类型: 集客
		 */
		public static const SEARCH_TYPE_CUSTOMER:String = "1";
		/**
		 * 搜索类型: 网元
		 */
		public static const SEARCH_TYPE_NET:String = "2";

		// ---------------- 拓扑树网元显示状态 -------------
		/**
		 * 拓扑树网元显示状态: 只显示隐藏的
		 */
		public static const TREE_VISIBLE_HIDE:String = "0";
		/**
		 * 拓扑树网元显示状态: 只显示可见的
		 */
		public static const TREE_VISIBLE_SHOW:String = "1";

		// ---------------- 布局方式 -------------
		/**
		 * 布局方式: 对称布局
		 */
		public static const LAYOUT_TYPE_SPRING:String = "Spring";
		/**
		 * 布局方式: 圆形布局
		 */
		public static const LAYOUT_TYPE_CIRCLE:String = "Circle";
		/**
		 * 布局方式: 树形布局
		 */
		public static const LAYOUT_TYPE_TREE:String = "Tree";
		/**
		 * 布局方式: 倒树布局
		 */
		public static const LAYOUT_TYPE_INVERSETREE:String = "InverseTree";
		/**
		 * 布局方式: 矩形布局
		 */
		public static const LAYOUT_TYPE_RECTANGLE:String = "Rectangle";
		/**
		 * 布局方式: 普通布局
		 */
		public static const LAYOUT_TYPE_COMMON:String = "SelfDefine";
		/**
		 * 布局方式: 左对齐
		 */
		public static const LAYOUT_TYPE_LEFT:String = "Left";
		/**
		 * 布局方式: 右对齐
		 */
		public static const LAYOUT_TYPE_RIGHT:String = "Right";
		/**
		 * 布局方式: 上对齐
		 */
		public static const LAYOUT_TYPE_TOP:String = "Top";
		/**
		 * 布局方式: 下对齐
		 */
		public static const LAYOUT_TYPE_BOTTOM:String = "Bottom";
		/**
		 * 布局方式: 横向等间距
		 */
		public static const LAYOUT_TYPE_HC:String = "Hc";
		/**
		 * 布局方式: 竖向等间距
		 */
		public static const LAYOUT_TYPE_VC:String = "Vc";

		// ---------------- TopoSql 允许的类型 -------------
		/**
		 * TopoSql的类型: Node
		 */
		public static const TOPOSQL_TYPE_NODE:String = "node";
		/**
		 * TopoSql的类型: Segment
		 */
		public static const TOPOSQL_TYPE_SEGMENT:String = "segment";
		/**
		 * TopoSql的类型: Group
		 */
		public static const TOPOSQL_TYPE_GROUP:String = "group";
		/**
		 * TopoSql的类型: Link
		 */
		public static const TOPOSQL_TYPE_LINK:String = "link";
		/**
		 * TopoSql的类型: Object
		 */
		public static const TOPOSQL_TYPE_OBJECT:String = "object";

		// ---------------- 顶层的 几个pid -------------
		/**
		 * 顶层PID: 全部
		 */
		public static const TOP_PID_ALL:String = "root";
		/**
		 * 顶层PID: 网络设备
		 */
		public static const TOP_PID_NET:String = "1/0";
		/**
		 * 顶层PID: 视图
		 */
		public static const TOP_PID_VIEW:String = "2/0";
		/**
		 * 顶层PID: 业务
		 */
		public static const TOP_PID_SERVICE:String = "3/0";
		/**
		 * 顶层PID: 集团客户
		 */
		public static const TOP_PID_JTKH:String = "1/jtkh";


		// ----------------- Event Map中的key -------------------
		/**
		 * Map Key: 消息
		 */
		public static const MAP_KEY_MSG:String = "msg";
		/**
		 * Map Key: 变化前的X轴比例尺
		 */
		public static const MAP_KEY_SCALEX_BEFORE:String = "scaleX_before";
		/**
		 * Map Key: 变化前的Y轴比例尺
		 */
		public static const MAP_KEY_SCALEY_BEFORE:String = "scaleY_before";
		/**
		 * Map Key: 变化后的X轴比例尺
		 */
		public static const MAP_KEY_SCALEX_AFTER:String = "scaleX_after";
		/**
		 * Map Key: 变化后的Y轴比例尺
		 */
		public static const MAP_KEY_SCALEY_AFTER:String = "scaleY_after";
	}
}