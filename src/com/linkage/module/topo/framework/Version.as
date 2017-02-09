package com.linkage.module.topo.framework
{
	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	public class Version
	{
		// log
		private var log:ILogger = Log.getLoggerByClass(Version);
		/**
		 * 版本号
		 *
		 * <p>历史版本回顾:</p>
		 *
		 * <ul>
		 * <li><b>1.1.11.120621</b> 增加图片对象(基于形状实现)</li>
		 * <li><b>1.1.10.120523</b> 树选择修改为分步加载方式</li>
		 * <li><b>1.1.9.120508</b>  增加TopoNameBuffer,将正则表达式搜索过的符合条件的toponame缓存起来</li>
		 * <li><b>1.1.8.120506</b>  加载拓扑的方法loadTopo增加标志位，当topoName参数为空时控制是否使用当前画布的topoName(默认为true,集客那边不使用当前画布的topoName 为false)</li>
		 * <li><b>1.1.7.120427</b>  更换字体默认颜色DEFAULT_OBJECT_TEXT_COLOR:uint = 0x999900</li>
		 * <li><b>1.1.6.120217</b>  鹰眼,标尺的样式可定制</li>
		 * <li><b>1.1.5.120209</b>  修正高亮时,移动网元后都变亮的bug</li>
		 * <li><b>1.1.4.111228</b>  增加标尺显隐切换按钮,标尺可按照mm,cm,px三种单位显示</li>
		 * <li><b>1.1.3.111226</b>  增加画布的标尺对象</li>
		 * <li><b>1.1.2.111222</b>  修改拓扑搜索机制,通过传入需要搜索的正则表达式去拓扑服务查询符合条件的toponame;加载拓扑可不传toponame,拓扑服务会自动判断</li>
		 * <li><b>1.1.1.111220</b>  修改面板机制,提高首次打开时的速度</li>
		 * <li><b>1.0.28.111214</b> 增加工具条上面按钮权限控制</li>
		 * <li><b>1.0.27.111209</b> 增加传输网元拓扑定位后高亮关联网元功能</li>
		 * <li><b>1.0.26.111207</b> 增加比例尺,修改loading提示机制,定位网元后高亮关联网元</li>
		 * <li><b>1.0.25.111206</b> 增加批量保存对象的接口</li>
		 * <li><b>1.0.24.111205</b> 修正选中对象移动时晃动不稳的bug</li>
		 * <li><b>1.0.23.111202</b> 可自定义icon的宽高;可设置label的提示内容(默认为name);可设置label的最大宽度(自动换行)</li>
		 * <li><b>1.0.22.111130</b> 增加Grid对象</li>
		 * <li><b>1.0.21.111117</b> 增加是否渲染告警数量的配置项</li>
		 * <li><b>1.0.20.111110</b> 告警渲染默认显示1,2,3,4级的告警</li>
		 * <li><b>1.0.19.111103</b> 集客的toponame不再写死,在包装器中配置,key=jkTopoNames</li>
		 * <li><b>1.0.18.111101</b> 修正拓扑树展开后由于排序子节点产生的布局的bug</li>
		 * <li><b>1.0.17.111028</b> 增加链路选中后tooltip功能</li>
		 * <li><b>1.0.16.111027</b> 增加拓扑树节点按名称排序功能</li>
		 * <li><b>1.0.15.111026</b> 修正链路名称不居中的bug,修正移动链路名称不重绘的bug(都是1.0.13产生的bug); 修改4级告警的颜色</li>
		 * <li><b>1.0.14.111026</b> 导航条太长时增加收缩显示的功能</li>
		 * <li><b>1.0.13.111025</b> 修正添加线对象后不能画链路的bug</li>
		 * <li><b>1.0.12</b> 获取拓扑树的接口中增加topoSql</li>
		 * <li><b>1.0.11</b> 修正线对象移动后不能保存的bug</li>
		 * <li><b>1.0.10</b> 增加线对象的绘制; 修正创建形状,缩略图坐标偏移的bug</li>
		 * <li><b>1.0.9</b> 拓扑树中增加展现网元的状态(0:隐藏,1:可见,2:全部)</li>
		 * <li><b>1.0.8</b> 形状中增加是否启用阴影的配置项</li>
		 * <li><b>1.0.7</b> 二次高亮功能; 一屏显示时只会缩小不会放大</li>
		 * </ul>
		 */
		public static const VERSION:String = "1.1.11.120620";

		/**
		 * 拓扑图版本信息
		 * @return
		 *
		 */
		public static function get info():String
		{
			return "[Topo Framework] " + VERSION;
		}
	}
}