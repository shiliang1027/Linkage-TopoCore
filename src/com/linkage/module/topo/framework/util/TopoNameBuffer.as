package com.linkage.module.topo.framework.util
{
	import com.linkage.module.topo.framework.data.IDataSource;
	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;
	import com.linkage.system.structure.map.IMap;
	import com.linkage.system.structure.map.ISet;
	import com.linkage.system.structure.map.Map;
	import com.linkage.system.structure.map.Set;

	import flash.utils.setTimeout;

	/**
	 * TopoName 缓存容器,凡是使用正则表达式获取过的toponame都缓存起来
	 * @author duangr
	 *
	 */
	public class TopoNameBuffer
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.util.TopoNameBuffer");

		// 已经请求到数据的缓存容器 (regex -> [toponame])
		private var _cachedBuffer:IMap = new Map();
		// 正在加载中的缓存容器(若存在正在加载中的数据,再次请求时请先等待,无需再次远程请求)
		private var _loadingBuffer:ISet = new Set();


		// 单件实例
		private static var _instance:TopoNameBuffer = null;

		public function TopoNameBuffer(pvt:_PrivateClass)
		{
			if (pvt == null)
			{
				throw new ArgumentError("TopoNameBuffer构造时,参数[pvt:_PrivateClass]不能为null!");
			}
		}

		/**
		 * 获取单件实例
		 * @return
		 *
		 */
		public static function getInstance():TopoNameBuffer
		{
			if (_instance == null)
			{
				_instance = new TopoNameBuffer(new _PrivateClass());
			}
			return _instance;
		}


		/**
		 * 清理全部缓存
		 *
		 */
		public function clearAllBuffer():void
		{
			_cachedBuffer.clear();
		}

		/**
		 * 清理指定缓存
		 * @param regex
		 *
		 */
		public function clearBuffer(regex:String):void
		{
			_cachedBuffer.remove(regex);
		}

		/**
		 * 根据正则表达式加载符合条件的toponame(返回的是数组)
		 *
		 * @param regex 正则表达式
		 * @param dataSource 数据源
		 * @param success 成功后的回调<br/> 格式为:  function success(topoNames:Array):void{  ... }
		 * @param thisObject  用作函数的 this 的对象
		 *
		 */
		public function loadTopoNames(regex:String, dataSource:IDataSource, success:Function, thisObject:* = null):void
		{
			log.debug("loadTopoNames {0} start ...", regex); 
			log.info(" regex="+ regex);
			if (regex == null)
			{
				log.info("~~~loadTopoNames");
				log.debug("loadTopoNames {0} end return null", regex);
				callback(null, success, thisObject);
			}
			else{
				log.info("loadTopoNames test");
				log.info(regex);
			}
			
			log.info("test loadTopoNames");
			var cachedTopoNames:Array = _cachedBuffer.get(regex);
			log.info("cachedTopoNames");
			log.info(cachedTopoNames);
			if (cachedTopoNames == null)
			{
				log.info("cachedTopoNames regex");
				log.info(regex);
				if (!_loadingBuffer.contains(regex))
				{
					// 首次加载
					_loadingBuffer.add(regex);

					dataSource.findAvailableTopoName(regex, function(data:XML):void
						{
							var searchTopoNames:Array = [];
							var topoNames:XMLList = data.child("toponame");
							if (topoNames)
							{
								for each (var obj:*in topoNames)
								{
									searchTopoNames.push(String(obj.@v));
								}
							}
							_cachedBuffer.put(regex, searchTopoNames);
							log.info(regex + " 符合条件的拓扑搜索TopoName: " + searchTopoNames);
							log.debug("loadTopoNames {0} end return {1}", regex, searchTopoNames);
							// return
							callback(searchTopoNames, success, thisObject);
						}, function():void
						{
							// complete
							_loadingBuffer.remove(regex);
						});
				}
				else
				{
					log.info("cachedTopoNames else ");
					// 正在加载中,请先稍候
					setTimeout(function():void
						{
							loadTopoNames(regex, dataSource, success, thisObject);
						}, 200);
					return;
				}
			}
			else
			{
				log.debug("loadTopoNames {0} end return {1}", regex, cachedTopoNames);
				callback(cachedTopoNames, success, thisObject);
			}
		}

		/**
		 * 已经查询到结果,执行回调
		 * @param topoNames
		 * @param success
		 * @param thisObject
		 *
		 */
		private function callback(topoNames:Array, success:Function, thisObject:* = null):void
		{
			try
			{
				// return
				success.call(thisObject, topoNames);
			}
			catch (e:Error)
			{
				log.error("TopoNameBuffer.loadTopoNames Success Callback Error:{0},\n StackTrace:{1}", e.name, e.getStackTrace());
				throw e;
			}
		}
	}
}

class _PrivateClass
{
	public function _PrivateClass()
	{

	}
}