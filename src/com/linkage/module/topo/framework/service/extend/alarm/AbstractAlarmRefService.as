package com.linkage.module.topo.framework.service.extend.alarm
{
	import com.linkage.module.topo.framework.controller.event.CanvasEvent;
	import com.linkage.module.topo.framework.core.model.element.plane.IHLinkLayer;
	import com.linkage.module.topo.framework.service.Service;
	import com.linkage.module.topo.framework.view.component.TopoLayer;
	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;
	
	import flash.errors.IllegalOperationError;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;

	/**
	 * 告警刷新业务抽象类,负责周期性的刷新拓扑图上面的告警
	 * @author duangr
	 *
	 */
	public class AbstractAlarmRefService extends Service
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.service.extend.alarm.AbstractAlarmRefService");

		// ----- 告警相关 -----
		// 告警刷新周期
		private var _refPeriod:uint = 20000;
		// 刷新告警定时器 Timer (30s)
		private var _alarmTimer:Timer = null;
		// 是否允许刷新告警
		private var _alarmRefreshEnable:Boolean = false;


		public var ui:UIComponent;

		/**
		 * 构造方法
		 * @param refPeriod 告警刷新的周期
		 *
		 */
		public function AbstractAlarmRefService()
		{
			super();
		}

		/**
		 * 告警刷新周期
		 *
		 */
		public function set refPeriod(value:uint):void
		{
			_refPeriod = value;
		}

		override public function get name():String
		{
			return "告警刷新抽象业务逻辑";
		}

		override public function start():void
		{
			if (_refPeriod <= 0)
			{
				throw new IllegalOperationError("property refPeriod must >0.");
			}
			_alarmTimer = new Timer(_refPeriod);
			// 告警刷新定时器
			_alarmTimer.addEventListener(TimerEvent.TIMER, onAlarmTimer);
//			// 画布事件
//			topoCanvas.addEventListener(CanvasEvent.ALARM_RENDERER_CHANGE_REFRESH, canvasEventHandler_AlarmRendererChangeRefresh);
//			topoCanvas.addEventListener(CanvasEvent.PREPARE_LOAD_LAYER, canvasEventHandler_PrepareLoadLayer);
			topoCanvas.addEventListener(CanvasEvent.LAYER_CHANGED, canvasEventHandler_LayerChanged);
			_alarmTimer.start();
		}
		override public function pause():void
		{
			if(_alarmTimer&&_alarmTimer.running){
				_alarmTimer.stop();
			}
		}
		
		override public function restore():void
		{
			if(_alarmTimer && !_alarmTimer.running){
				_alarmTimer.reset();
				_alarmTimer.start();
				onAlarmTimer();
			}
		}
		// 【告警渲染规则变化后通知刷新】
//		private function canvasEventHandler_AlarmRendererChangeRefresh(event:CanvasEvent):void
//		{
////			stopAutoLoadAlarms();
////			startAutoLoadAlarms();
//			if(_alarmTimer&& _alarmTimer.running){
//				_alarmTimer.reset();
//				_alarmTimer.start();
//			}
//		}
//
//		// 【准备加载新拓扑数据前的通知事件】
//		private function canvasEventHandler_PrepareLoadLayer(event:CanvasEvent):void
//		{
////			stopAutoLoadAlarms();
//			if(_alarmTimer&& _alarmTimer.running){
//				_alarmTimer.reset();
//				_alarmTimer.start();
//			}
//		}
//
		// 【拓扑层次切换后的通知事件】
		private function canvasEventHandler_LayerChanged(event:CanvasEvent):void
		{
//			startAutoLoadAlarms();
			if(_alarmTimer&& _alarmTimer.running){
				_alarmTimer.reset();
				_alarmTimer.start();
				onAlarmTimer();
			}
		}

		/**
		 * 启动自动刷新告警
		 *
		 */
//		private function startAutoLoadAlarms():void
//		{
//			if (topoCanvas.alarmEnabled)
//			{
//				_alarmRefreshEnable = true;
//				loadAlarms();
//				_alarmTimer.start();
////				topoCanvas.addEventListener(CanvasEvent.ALARM_RENDERER_CHANGE_REFRESH, canvasEventHandler_AlarmRendererChangeRefresh);
////				topoCanvas.addEventListener(CanvasEvent.PREPARE_LOAD_LAYER, canvasEventHandler_PrepareLoadLayer);
////				topoCanvas.addEventListener(CanvasEvent.LAYER_CHANGED, canvasEventHandler_LayerChanged);
////				ui.parentApplication.add(_alarmTimer);
////				FlexGlobals.topLevelApplication.add(_alarmTimer);
//			}
//		}

		/**
		 * 停止自动刷新告警
		 *
		 */
//		private function stopAutoLoadAlarms():void
//		{
//			if (topoCanvas.alarmEnabled)
//			{
//				_alarmRefreshEnable = false;
//				_alarmTimer.stop();
////				topoCanvas.removeEventListener(CanvasEvent.ALARM_RENDERER_CHANGE_REFRESH, canvasEventHandler_AlarmRendererChangeRefresh);
////				topoCanvas.removeEventListener(CanvasEvent.PREPARE_LOAD_LAYER, canvasEventHandler_PrepareLoadLayer);
////				topoCanvas.removeEventListener(CanvasEvent.LAYER_CHANGED, canvasEventHandler_LayerChanged);
////				ui.parentApplication.remove(_alarmTimer);
////				FlexGlobals.topLevelApplication.remove(_alarmTimer);
//			}
//		}

		/**
		 * 时间已到,触发刷新告警事件
		 * @param event
		 *
		 */
		private function onAlarmTimer(event:TimerEvent=null):void
		{
			if (topoCanvas.alarmEnabled)
			{
				loadAlarms();
			}
//			else
//			{
//				_alarmTimer.stop();
//			}
		}

		/**
		 * 刷新告警
		 *
		 */
		private function loadAlarms():void
		{
			loadTopoLayerAlarms(topoCanvas);
			loadHLinkLayersAlarms();
		}

		/**
		 * 加载拓扑层次的告警
		 * @param topoLayer
		 *
		 */
		protected function loadTopoLayerAlarms(topoLayer:TopoLayer):Boolean
		{
			throw new IllegalOperationError("Function loadTopoLayerAlarms() from abstract class AbstractAlarmRefService has not been implemented by subclass.");
			return true;
		}

		/**
		 * 加载全部缩略图的告警
		 *
		 */
		private function loadHLinkLayersAlarms():void
		{

			topoCanvas.eachHLinkLayer(function(id:String, hlinkLayer:IHLinkLayer):void
				{
					loadHLinkLayerAlarm(hlinkLayer);
				});
		}

		/**
		 * 加载具体的单个缩略图的告警
		 * @param hlinkLayer
		 *
		 */
		private function loadHLinkLayerAlarm(hlinkLayer:IHLinkLayer):void
		{
			var flag:Boolean = loadTopoLayerAlarms(hlinkLayer.topoLayer);
			if (!flag)
			{
				setTimeout(function():void
					{
						loadHLinkLayerAlarm(hlinkLayer);
					}, 2000);
			}

		}


	}
}