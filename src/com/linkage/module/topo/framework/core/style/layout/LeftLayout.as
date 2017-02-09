package com.linkage.module.topo.framework.core.style.layout
{
	import com.linkage.module.topo.framework.core.Feature;
	import com.linkage.system.utils.StringUtils;
	
	import flash.geom.Point;
	
	import mx.core.IVisualElement;

	/**
	 * Label左边布局
	 * @author duangr
	 *
	 */
	public class LeftLayout implements ILayout
	{
		public function LeftLayout()
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
			var lines:Number=Math.ceil(text.length/15);
			// 画在图标的左边
			label.x = -textLength - 3;
			label.y = feature.height / 2.0- fontSize*lines/2;

			return label;
		}
	}
}