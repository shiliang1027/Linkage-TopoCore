package com.linkage.module.topo.framework.util
{
	import spark.effects.AnimateFilter;
	import spark.effects.animation.MotionPath;
	import spark.effects.animation.RepeatBehavior;
	import spark.effects.animation.SimpleMotionPath;
	import spark.filters.ColorMatrixFilter;
	import spark.filters.GlowFilter;

	/**
	 * 告警颜色
	 * @author duangr
	 *
	 */
	public class AlarmConstants
	{
		//
		public static const KEY_ALARM_TYPES:String = "alarmTypes";
		public static const KEY_ALARM_LEVELS:String = "alarmLevels";

		public static const XML_KEY_TYPE:String = "type";
		// 告警类型 (设备/性能/业务质量)
		/**
		 * 告警类型: 设备告警
		 */
		public static const ALARM_TYPE_DEVICE:uint = 1;
		/**
		 * 告警类型: 性能告警
		 */
		public static const ALARM_TYPE_PERFORMANCE:uint = 2;
		/**
		 * 告警类型: 业务质量告警
		 */
		public static const ALARM_TYPE_BUSINESS:uint = 3;

		// 告警的等级
		public static const LEVEL1:uint = 1;
		public static const LEVEL2:uint = 2;
		public static const LEVEL3:uint = 3;
		public static const LEVEL4:uint = 4;

		// ---- 颜色 -----
		public static const LEVEL1_COLOR:uint = 0xff0000;
		public static const LEVEL2_COLOR:uint = 0xffa500;
//		public static const LEVEL3_COLOR:uint = 0xffff00;
		public static const LEVEL3_COLOR:uint = 0xc7c700;
		public static const LEVEL4_COLOR:uint = 0x4169e1; // 0xccffff 

		// ---- 颜色滤镜 -----
		// 算法原则： 让 白色 0xff 尽量保持白色不变，其他的颜色转换为指定的颜色
		// 转换算法为: (255-color) /3 /255 作为系数, 偏移量为 color
		// ff0000
		public static const LEVEL1_COLOR_FILTER:ColorMatrixFilter = new ColorMatrixFilter([0, 0, 0, 0, 255].concat([1, 1, 1, 0, -370], [1, 1, 1, 0, -370], [0, 0, 0, 1, 0])); //[0, 0, 0, 0, 255, 1, 1, 1, 0, -370, 1, 1, 1, 0, -370, 0, 0, 0, 1, 0]
		// ffa500  (a5=165)
		public static const LEVEL2_COLOR_FILTER:ColorMatrixFilter = new ColorMatrixFilter([0, 0, 0, 0, 255].concat([0.116, 0.116, 0.116, 0, 140], [1, 1, 1, 0, -370], [0, 0, 0, 1, 0])); //[0, 0, 0, 0, 255, 0.116, 0.116, 0.116, 0, 140, 1, 1, 1, 0, -370, 0, 0, 0, 1, 0]
		// ffff00
//		public static const LEVEL3_COLOR_FILTER:ColorMatrixFilter = new ColorMatrixFilter([0, 0, 0, 0, 255].concat([0, 0, 0, 0, 255], [1, 1, 1, 0, -370], [0, 0, 0, 1, 0])); //[0, 0, 0, 0, 255, 0, 0, 0, 0, 255, 1, 1, 1, 0, -370, 0, 0, 0, 1, 0]
		public static const LEVEL3_COLOR_FILTER:ColorMatrixFilter = new ColorMatrixFilter([0.067, 0.067, 0.067, 0, 255].concat([0.067, 0.067, 0.067, 0, 189], [1, 1, 1, 0, -370], [0, 0, 0, 1, 0])); //[0, 0, 0, 0, 255, 0, 0, 0, 0, 255, 1, 1, 1, 0, -370, 0, 0, 0, 1, 0]
		//3级的时候颜色太浅  把第一个176改为255
		//public static const LEVEL3_COLOR_FILTER:ColorMatrixFilter = new ColorMatrixFilter([0.067, 0.067, 0.067, 0, 176].concat([0.067, 0.067, 0.067, 0, 189], [1, 1, 1, 0, -370], [0, 0, 0, 1, 0])); //[0, 0, 0, 0, 255, 0, 0, 0, 0, 255, 1, 1, 1, 0, -370, 0, 0, 0, 1, 0]
		// 规范中 ccffff  (0xcc=204) 颜色偏白，使用 0x00ffff  (33ccff  (0x33=51))  0x4169e1 (0x41=65 0x69=105 0xe1=225)
		// 0xccffff (0xcc=204) = [0.067, 0.067, 0.067, 0, 204].concat([0, 0, 0, 0, 255],[0, 0, 0, 0, 255],[0, 0, 0, 1, 0])
		// 0x00ffff = [1, 1, 1, 0, -370].concat([0, 0, 0, 0, 255], [0, 0, 0, 0, 255], [0, 0, 0, 1, 0])
		// 0x33ccff (0x33=51 0xcc=204) = [0.26, 0.26, 0.26, 0, 200].concat([0.067, 0.067, 0.067, 0, 204],[0, 0, 0, 0, 255], [0, 0, 0, 1, 0])
		// 0x4169e1 (0x41=65 0x69=105 0xe1=225) = [0.248, 0.248, 0.248, 0, 65].concat([0.196, 0.196, 0.196, 0, 105], [0.039, 0.039, 0.039, 0, 225], [0, 0, 0, 1, 0])
		public static const LEVEL4_COLOR_FILTER:ColorMatrixFilter = new ColorMatrixFilter([0.248, 0.248, 0.248, 0, 65].concat([0.196, 0.196, 0.196, 0, 105], [0.039, 0.039, 0.039, 0, 225], [0, 0, 0, 1,
			0]));
		// [新颜色,使用中] 0x3cc0e6 (0x3c=60 0xc0=192 0xe6=230) = [0.255, 0.255, 0.255, 0, 60].concat([0.0824, 0.0824, 0.0824, 0, 192], [0.0327, 0.0327, 0.0327, 0, 230], [0, 0, 0, 1, 0])
//		public static const LEVEL4_COLOR_FILTER:ColorMatrixFilter = new ColorMatrixFilter([0.255, 0.255, 0.255, 0, 60].concat([0.0824, 0.0824, 0.0824, 0, 192], [0.0327, 0.0327, 0.0327, 0, 230], [0, 0,
//			0, 1, 0]));
		// ---- 发光效果 -----
		// 一级告警效果
		private var _level1_animate:AnimateFilter = new AnimateFilter();
		// 二级告警效果
		private var _level2_animate:AnimateFilter = new AnimateFilter();
		// 三级告警效果
		private var _level3_animate:AnimateFilter = new AnimateFilter();
		// 四级告警效果
		private var _level4_animate:AnimateFilter = new AnimateFilter();

		// ---- 定位对象的发光效果 -----
		private static const SEARCH_COLOR:uint = 0xccffff;
		private var _search_animate:AnimateFilter = new AnimateFilter();

		// 单件实例
		private static var _instance:AlarmConstants = null;

		public function AlarmConstants(pvt:_PrivateClass)
		{
			if (pvt == null)
			{
				throw new ArgumentError("AlarmConstants构造时,参数[pvt:_PrivateClass]不能为null!");
			}
			var blurFrom:int = 0;
			var blurTo:int = 64;
			var repeatCount:int = 4;
			var duration:Number = 1000;

			// 一级告警
			_level1_animate.bitmapFilter = new GlowFilter();
			_level1_animate.repeatCount = repeatCount;
			_level1_animate.duration = duration;
			_level1_animate.repeatBehavior = RepeatBehavior.REVERSE;
			var level1Paths:Vector.<MotionPath> = new Vector.<MotionPath>;
			level1Paths.push(new SimpleMotionPath("color", LEVEL1_COLOR, LEVEL1_COLOR));
			level1Paths.push(new SimpleMotionPath("blurX", blurFrom, blurTo));
			level1Paths.push(new SimpleMotionPath("blurY", blurFrom, blurTo));
			_level1_animate.motionPaths = level1Paths;
			// 二级告警
			_level2_animate.bitmapFilter = new GlowFilter();
			_level2_animate.repeatCount = repeatCount;
			_level2_animate.duration = duration;
			_level2_animate.repeatBehavior = RepeatBehavior.REVERSE;
			var level2Paths:Vector.<MotionPath> = new Vector.<MotionPath>;
			level2Paths.push(new SimpleMotionPath("color", LEVEL2_COLOR, LEVEL2_COLOR));
			level2Paths.push(new SimpleMotionPath("blurX", blurFrom, blurTo));
			level2Paths.push(new SimpleMotionPath("blurY", blurFrom, blurTo));
			_level2_animate.motionPaths = level2Paths;
			// 三级告警
			_level3_animate.bitmapFilter = new GlowFilter();
			_level3_animate.repeatCount = repeatCount;
			_level3_animate.duration = duration;
			_level3_animate.repeatBehavior = RepeatBehavior.REVERSE;
			var level3Paths:Vector.<MotionPath> = new Vector.<MotionPath>;
			level3Paths.push(new SimpleMotionPath("color", LEVEL3_COLOR, LEVEL3_COLOR));
			level3Paths.push(new SimpleMotionPath("blurX", blurFrom, blurTo));
			level3Paths.push(new SimpleMotionPath("blurY", blurFrom, blurTo));
			_level3_animate.motionPaths = level3Paths;
			// 四级告警
			_level4_animate.bitmapFilter = new GlowFilter();
			_level4_animate.repeatCount = repeatCount;
			_level4_animate.duration = duration;
			_level4_animate.repeatBehavior = RepeatBehavior.REVERSE;
			var level4Paths:Vector.<MotionPath> = new Vector.<MotionPath>;
			level4Paths.push(new SimpleMotionPath("color", LEVEL4_COLOR, LEVEL4_COLOR));
			level4Paths.push(new SimpleMotionPath("blurX", blurFrom, blurTo));
			level4Paths.push(new SimpleMotionPath("blurY", blurFrom, blurTo));
			_level4_animate.motionPaths = level4Paths;

			// 网元查找定位后发光
			_search_animate.bitmapFilter = new GlowFilter();
			_search_animate.repeatCount = 8;
			_search_animate.duration = duration;
			_search_animate.repeatBehavior = RepeatBehavior.REVERSE;
			var searchPaths:Vector.<MotionPath> = new Vector.<MotionPath>;
			searchPaths.push(new SimpleMotionPath("color", SEARCH_COLOR, SEARCH_COLOR));
			searchPaths.push(new SimpleMotionPath("blurX", blurFrom, 128));
			searchPaths.push(new SimpleMotionPath("blurY", blurFrom, 128));
			_search_animate.motionPaths = searchPaths;

		}

		/**
		 * 获取单件实例
		 * @return
		 *
		 */
		public static function getInstance():AlarmConstants
		{
			if (_instance == null)
			{
				_instance = new AlarmConstants(new _PrivateClass());
			}
			return _instance;
		}

		/**
		 * 一级告警发光效果
		 *
		 */
		public function get level1Glow():AnimateFilter
		{
			return _level1_animate;
		}

		/**
		 * 二级告警发光效果
		 *
		 */
		public function get level2Glow():AnimateFilter
		{
			return _level2_animate;
		}

		/**
		 * 三级告警发光效果
		 *
		 */
		public function get level3Glow():AnimateFilter
		{
			return _level3_animate;
		}

		/**
		 * 四级告警发光效果
		 *
		 */
		public function get level4Glow():AnimateFilter
		{
			return _level4_animate;
		}

		/**
		 * 网元搜索定位后发光效果
		 *
		 */
		public function get searchGlow():AnimateFilter
		{
			return _search_animate;
		}
	}
}

class _PrivateClass
{
	public function _PrivateClass()
	{

	}
}