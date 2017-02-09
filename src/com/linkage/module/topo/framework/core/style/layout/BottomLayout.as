package com.linkage.module.topo.framework.core.style.layout
{
	import com.linkage.module.topo.framework.core.Feature;
	import com.linkage.system.logging.ILogger;
	import com.linkage.system.logging.Log;
	import com.linkage.system.utils.StringUtils;
	
	import flash.geom.Point;
	
	import mx.core.IVisualElement;
	
	import spark.layouts.VerticalLayout;

	/**
	 * Label底部布局
	 * @author duangr
	 *
	 */
	public class BottomLayout implements ILayout
	{
		// log
		private var log:ILogger = Log.getLogger("com.linkage.module.topo.framework.core.style.layout.BottomLayout");

		public function BottomLayout()
		{
		}

		public function layoutPointLabel(text:String, label:IVisualElement, feature:Feature,fromPoint:Point,toPoint:Point):IVisualElement
		{
			return null;
		}
		
		public function layoutLabel(text:String, label:IVisualElement, feature:Feature):IVisualElement
		{
			var fontSize:Number = feature.getStyle("fontSize");
			//添加换行处理
			var maxLineLength:Number=15;
			var length:Number=StringUtils.getStrLen(text);
			var textLength:Number;
			if(length>maxLineLength){
				textLength= (maxLineLength+2) * fontSize / 2;//换行符\r\n算2个字符
			}else{
				textLength=length*fontSize/2;
			}
			// 考虑到已经设置了文本的最大宽度
			var maxWidth:Number = feature.element.labelMaxWidth;
			if (maxWidth > 0 && maxWidth < textLength)
			{
				textLength = maxWidth;
				label.width = maxWidth;
			}
			// 画在图标的正下方
			label.x = feature.width / 2.0 - textLength / 2.0;
			label.y = feature.height + 2;
			
//			var layout:VerticalLayout = new VerticalLayout();
//			layout.horizontalAlign="center";
//			layout.gap=2;
//			feature.layout = layout;
			return label;
		}
	}
}