package com.linkage.module.topo.framework.core.style.element.point
{
	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	/**
	 * 拓扑内置简单对象样式
	 * @author duangr
	 *
	 */
	public class TPObjectStyle extends NodeStyle
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.core.style.element.point.TPObjectStyle");

		public function TPObjectStyle(imageContext:String)
		{
			super(imageContext);
		}
	}
}