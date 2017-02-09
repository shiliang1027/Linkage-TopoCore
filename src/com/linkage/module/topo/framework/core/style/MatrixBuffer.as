package com.linkage.module.topo.framework.core.style
{
	import com.linkage.module.topo.framework.util.MathUtil;
	import com.linkage.system.structure.map.IMap;
	import com.linkage.system.structure.map.Map;

	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	import spark.effects.Rotate3D;

	/**
	 * 转换矩阵容器
	 * @author duangr
	 *
	 */
	public class MatrixBuffer
	{
		// 矩形转换对象
		private var _rectangleMatrix:Matrix = new Matrix();
		// 平行四边形转换对象(向右偏移15度)
		private var _parallelogramMatrix:Matrix = new Matrix(1, 0, Math.tan(MathUtil.angle2radian(-15)), 1);
		// 梯形转换
		private var _trapeziumMatrix:Matrix3D = new Matrix3D();
		// 单件实例
		private static var _instance:MatrixBuffer = null;

		public function MatrixBuffer(pvt:_PrivateClass)
		{
			if (pvt == null)
			{
				throw new ArgumentError("MatrixBuffer构造时,参数[pvt:_PrivateClass]不能为null!");
			}
			_trapeziumMatrix.appendRotation(-45, Vector3D.X_AXIS);
		}

		/**
		 * 获取单件实例
		 * @return
		 *
		 */
		public static function getInstance():MatrixBuffer
		{
			if (_instance == null)
			{
				_instance = new MatrixBuffer(new _PrivateClass());
			}
			return _instance;
		}

		/**
		 * 矩形转换对象
		 *
		 */
		public function get rectangleMatrix():Matrix
		{
			return _rectangleMatrix.clone();
		}

		/**
		 * 平行四边形转换对象(向右偏移15度)
		 *
		 */
		public function get parallelogramMatrix():Matrix
		{
			return _parallelogramMatrix.clone();
		}

		/**
		 * 梯形转换对象
		 *
		 */
		public function get trapeziumMatrix():Matrix3D
		{
			return _trapeziumMatrix.clone();
		}


		/**
		 * 构造平行四边形的转换矩阵
		 * @param angle
		 * @return
		 *
		 */
		public function buildParallelogramMatrix(angle:Number):Matrix
		{
			return new Matrix(1, 0, Math.tan(MathUtil.angle2radian(-angle)), 1);
		}
	}
}

class _PrivateClass
{
	public function _PrivateClass()
	{

	}
}