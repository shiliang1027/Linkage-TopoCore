package com.linkage.module.topo.framework.core
{
	import com.linkage.module.topo.framework.core.model.element.IElement;
	import com.linkage.module.topo.framework.core.model.element.line.ILink;
	import com.linkage.module.topo.framework.core.model.element.line.ITPLine;
	import com.linkage.module.topo.framework.core.model.element.plane.ITPGroup;
	import com.linkage.module.topo.framework.core.model.element.plane.ITPPlane;
	import com.linkage.module.topo.framework.core.model.element.point.ITPPoint;
	import com.linkage.module.topo.framework.view.component.TopoLayer;
	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;
	import com.linkage.system.structure.map.IMap;
	import com.linkage.system.structure.map.Map;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import spark.components.Group;
	
	/**
	 * 画布中元素的层次管理器<br/>
	 * 1.根据元素的zindex属性,修正元素添加到画布的顺序
	 *
	 * @author duangr
	 *
	 */
	public class LayerManager
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.core.LayerManager");
		// 要绘制的元素 (id -> feature)
		private var _featureMap:IMap = new Map();
		// 在group中的元素 (id -> element)
		private var _elementInGroupMap:IMap = new Map();
		// 链路的数组(线要最后画)
		private var _links:Array = [];
		
		private var _curTimeoutNo:uint = 0;
		
		
		// 数据边界的最大最小值
		private var _minX:Number = Number.MAX_VALUE;
		private var _minY:Number = Number.MAX_VALUE;
		private var _maxX:Number = -Number.MAX_VALUE;
		private var _maxY:Number = -Number.MAX_VALUE;
		
		public function LayerManager()
		{
		}
		
		/**
		 * 清除缓存,重新计数
		 */
		public function clear():void
		{
			clearTimeout(_curTimeoutNo);
			resetCache();
			resetXY();
		}
		
		/**
		 * 重置统计边界的X,Y
		 *
		 */
		private function resetXY():void
		{
			_minX = Number.MAX_VALUE;
			_minY = Number.MAX_VALUE;
			_maxX = -Number.MAX_VALUE;
			_maxY = -Number.MAX_VALUE;
		}
		
		/**
		 * 开始添加对象,先把之前的缓存清空
		 *
		 */
		private function resetCache():void
		{
			_featureMap.clear();
			_elementInGroupMap.clear();
			_links.length = 0;
		}
		
		/**
		 * 添加拓扑要素对象
		 * @param feature
		 */
		public function addFeature(feature:Feature):void
		{
			if (feature == null)
			{
				return;
			}
			// 统计数据边界
			statBounds(feature.element);
			if (feature.element is ILink)
			{
				_links.push(feature);
			}
			else
			{
				_featureMap.put(feature.element.id, feature);
				
				// 如果是group的话
				if (feature.element is ITPGroup)
				{
					var group:ITPGroup = feature.element as ITPGroup;
					// group中的元素,不用再画布中绘制
					group.eachChild(function(id:String, element:IElement):void
					{
						_featureMap.remove(id);
						_elementInGroupMap.put(id, element);
					});
				}
			}
		}
		
		/**
		 * 将元素画到画布中
		 * @param canvas
		 * @param restatBound 是否重新统计边界
		 */
		public function drawOnCanvas(canvas:TopoLayer, restatBound:Boolean = false):void
		{
			if (restatBound)
			{
				restatBounds();
			}
			commitBounds(canvas);
			
			drawFeatures(canvas);
			
			this.resetCache();
		}
		
		/**
		 * 将增量添加的对象画在画布上
		 * @param canvas
		 * @param restatBound 是否重新统计边界
		 */
		public function appendOnCanvas(canvas:TopoLayer, restatBound:Boolean = false):void
		{
			if (restatBound)
			{
				restatBounds();
			}
			commitAppendBounds(canvas);
			
			drawFeatures(canvas);
			
			this.resetCache();
		}
		
		/**
		 * 画缓存的元素
		 * @param canvas
		 *
		 */
		private function drawFeatures(canvas:TopoLayer):void
		{
			if (true)
			{
				// [1] 分步加载
				canvas.rendering = true;
				var features:Array = [];
				_featureMap.forEach(function(id:String, feature:Feature):void
				{
					features.push(feature);
				});
				features = features.concat(_links);
				
				log.debug("【渲染对象】共计: {0}  其中链路: {1}", features.length, _links.length);
				stepDrawFeatures(canvas, features, new Date().getTime());
			}
			else
			{
				// [2] 一次性加载
				// 画除链路之外的对象
				_featureMap.forEach(function(id:String, feature:Feature):void
				{
					// 添加对象
					canvas.addElement(feature);
					feature.drawWithStyle();
				});
				
				// 画链路
				_links.forEach(function(feature:Feature, index:int, arr:Array):void
				{
					// 添加链路
					canvas.addElement(feature);
					feature.drawWithStyle();
				});
			}
			
			
		}
		
		
		/**
		 * 分批渲染对象
		 * @param canvas 画布
		 * @param features 对象数组
		 * @param startTime 开始时间
		 *
		 */
		private function stepDrawFeatures(canvas:TopoLayer, features:Array, startTime:Number):void
		{
			var size:int = Math.min(canvas.stepRenderMaxSize, features.length);
			var arr:Array = features.splice(0, size);
			arr.forEach(function(feature:Feature, index:int, array:Array):void
			{
				canvas.addElement(feature);
				feature.drawWithStyle();
			});
			if (features.length > 0)
			{
				_curTimeoutNo = setTimeout(function():void
				{
					stepDrawFeatures(canvas, features, startTime);
				}, canvas.stepRenderSleepMS);
			}
			else
			{
				canvas.rendering = false;
				
				//				var group:Group = new Group();
				//				canvas.addElement(group);
				////				group.graphics.beginFill(0xff0000,0.2);
				//				group.graphics.lineStyle(1,0x00ff00);
				//				group.graphics.drawRect(0,0,canvas.width,canvas.height);
				//				group.graphics.endFill(); 
				//				log.debug("画线");
				//				log.debug("【渲染对象】结束,共计耗时: {0}s", (new Date().getTime() - startTime) / 1000.0);
				//				var rect:Group = new Group();
				//				canvas.addElement(rect);
				//				rect.graphics.beginFill(0xff0000,0.2);
				//				rect.graphics.lineStyle(5,0x00ff00);
				//				rect.graphics.drawRect(0,0,canvas.width,canvas.height);
				//				rect.graphics.endFill();
				//				log.debug("【渲染对象】{0},{1}",canvas.width,canvas.height);
			}
			
			
		}
		
		/**
		 * 重新统计数据边界
		 *
		 */
		private function restatBounds():void
		{
			resetXY();
			_featureMap.forEach(function(id:String, feature:Feature):void
			{
				// 统计数据边界
				statBounds(feature.element);
			});
			_elementInGroupMap.forEach(function(id:String, element:IElement):void
			{
				// 统计数据边界
				statBounds(element);
			});
		}
		
		/**
		 * 统计数据的边界
		 * @param element
		 *
		 */
		private function statBounds(element:IElement):void
		{
			// 面对象
			if (element is ITPPlane)
			{
				// 数据中的点 作为图形的中心点
				var plane:ITPPlane = element as ITPPlane;
				_minX = Math.min(_minX, plane.x - plane.width / 2);
				_minY = Math.min(_minY, plane.y - plane.height / 2);
				_maxX = Math.max(_maxX, plane.x + plane.width / 2);
				_maxY = Math.max(_maxY, plane.y + plane.height / 2);
			}
				// 点对象
			else if (element is ITPPoint)
			{
				var point:ITPPoint = element as ITPPoint;
				_minX = Math.min(_minX, point.x);
				_minY = Math.min(_minY, point.y);
				_maxX = Math.max(_maxX, point.x);
				_maxY = Math.max(_maxY, point.y);
			}
				// 线对象
			else if (element is ITPLine)
			{
				// 线的坐标点是 左上角的点
				var line:ITPLine = element as ITPLine;
				_minX = Math.min(_minX, line.x);
				_minY = Math.min(_minY, line.y);
				_maxX = Math.max(_maxX, line.x + line.width);
				_maxY = Math.max(_maxY, line.y + line.height);
			}
		}
		
		/**
		 * 边界统计结束,提交边界数据
		 * @param canvas
		 *
		 */
		private function commitBounds(canvas:TopoLayer):void
		{
			log.debug("数据范围 ({0}, {1}) -> ({2}, {3})", _minX, _minY, _maxX, _maxY);
			canvas.dataBounds.updateByMinMaxPoint(_minX, _minY, _maxX, _maxY);
			canvas.viewBounds.updateByDataBoundsCenter(canvas.dataBounds);
			log.debug("dataBounds:{0}  viewBounds:{1}", canvas.dataBounds.rectangle, canvas.viewBounds.rectangle);
		}
		
		/**
		 * 增量添加元素后,提交边界数据
		 * @param canvas
		 *
		 */
		private function commitAppendBounds(canvas:TopoLayer):void
		{
			log.debug("增量添加后数据范围 ({0}, {1}) -> ({2}, {3})", _minX, _minY, _maxX, _maxY);
			canvas.dataBounds.updateByAppendMinMaxPoint(_minX, _minY, _maxX, _maxY);
			log.debug("增量添加后 dataBounds:{0}  viewBounds:{1}", canvas.dataBounds.rectangle, canvas.viewBounds.rectangle);
		}
	}
}