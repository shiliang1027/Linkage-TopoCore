package com.linkage.module.topo.framework.core.model.element.plane
{
	import com.linkage.module.topo.framework.Constants;
	import com.linkage.module.topo.framework.core.parser.ElementProperties;
	import com.linkage.system.utils.StringUtils;

	/**
	 * 拓扑视图对象
	 * @author duangr
	 *
	 */
	public class TPView extends TPComplex implements ITPView
	{
		// 视图的前缀
		private static const VIEW_PREFIX:String = "view.";
		// 视图的模板id
		private static const VIEW_MODELID:String = "view.modelId";

		public function TPView()
		{
			super();
			this.type = ElementProperties.PROPERTYVALUE_OBJECT_TYPE_VIEW;
		}

		override public function get alarmEnabled():Boolean
		{
			return true;
		}

		override public function get weight():uint
		{
			return Constants.WEIGHT_ELEMENT_VIEW;
		}

		override public function get itemName():String
		{
			return Constants.ITEM_NAME_TPVIEW;
		}

		override public function getProperty(key:String):String
		{
			var returnValue:String = super.getProperty(key);

			if (returnValue != null)
			{
				return returnValue;
			}

			switch (key)
			{
				case "view_params":
					returnValue = getViewParams();
					break;
				default:
					break;
			}
			return returnValue;
		}

		override public function eachProperty(callback:Function, thisObject:* = null):void
		{
			if (callback == null)
			{
				return;
			}
			callback.call(thisObject, "view_params", getViewParams());
			super.eachProperty(callback, thisObject);
		}

		/**
		 * 获取视图的参数
		 * @return
		 *
		 */
		private function getViewParams():String
		{
			var params:Array = [];
			// 先将自身的id放入参数中
			params.push("id:" + id);
			eachExtendProperty(function(key:String, value:String):void
				{
					if (key == VIEW_MODELID)
					{
						return;
					}
					if (StringUtils.startsWith(key, VIEW_PREFIX))
					{
						params.push(key + ":" + value);
					}
				});
			return params.join("#");
		}

		override public function toString():String
		{
			return "TPView(" + id + ": " + name + " : " + shapeType + ")(" + x + ", " + y + ") w:" + width + " h:" + height;
		}
	}
}