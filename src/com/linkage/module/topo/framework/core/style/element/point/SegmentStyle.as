package com.linkage.module.topo.framework.core.style.element.point
{
	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;

	/**
	 * 网段样式
	 * @author duangr
	 *
	 */
	public class SegmentStyle extends NodeStyle
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.core.style.element.point.SegmentStyle");

		public function SegmentStyle(imageContext:String)
		{
			super(imageContext);
		}

	}
}