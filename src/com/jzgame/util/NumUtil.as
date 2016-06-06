package com.jzgame.util
{
	import com.jzgame.enmu.ReleaseUtil;
	
	import flash.geom.Matrix;
	import flash.geom.Point;

	public class NumUtil
	{
		/*auther     :jim
		* file       :NumUtil.as
		* date       :Apr 14, 2015
		* description:
		*/
		public function NumUtil()
		{
		}
		/**
		 * 其他超過一萬(五位數)一律用K顯示, 超過一百萬就用M.
		 * @param num
		 * @return 
		 * 
		 */		
		public static function n2kb(num:Number):String
		{
			var numStr:String = String(num);
			var result:String = "";
//			1000000
			if(numStr.length > 6)
			{
				result = numStr.substr(0,numStr.length - 6) + "M";
			}else if(numStr.length > 3)
			{
				result = numStr.substr(0,numStr.length - 3) + "K";
			}else
			{
				result = numStr;
			}
			return result;
		}
		
		/**
		 * 數字(每三位數)需要加上逗號
		 * @param num
		 * @return 
		 * 
		 */	
		public static function n2c(num:Number):String
		{
			var numStr:String = String(num);
			var result:String = "";
			if(numStr.length > 3)
			{
				var temp:Array = [];
				numStr.substr();
				var dot:uint = Math.floor( numStr.length / 3 );
				var first:uint = numStr.length % 3;
				if(first > 0)
				{
					temp.push(numStr.substr(0,first));
				}
				for(var index:uint = 0; index<dot;index++)
				{
					temp.push(numStr.substr(first + index * 3,3));
				}
				result = temp.join(",");
			}else
			{
				result = numStr;
			}
			return result;
		}
		/**
		 * 數字(每三位數)需要加上逗號 超过8位数
		 * @param num
		 * @return 
		 * 
		 */
		public static function n2ck(num:Number):String
		{
			var numStr:String = String(num);
			var result:String = "";
			if(numStr.length > 8)
			{
				result = n2c(Number(numStr.substr(0,numStr.length - 3)))+ "K";
				return result;
			}else
			{
				return n2c(num);
			}
		}
		/**
		 * 数字显示百万级别 
		 * @param num
		 * @return 
		 * 
		 */		
		public static function n2M(num:Number):String
		{
			var numStr:String = String(num);
			var temp:String = numStr.substr(0,numStr.length - 6) + "M";
			
			return temp;
		}
		/**
		 * 根据缩放平移坐标 
		 * @param p
		 * @return 
		 * 
		 */		
		public static function transPoint(p:Point):Point
		{
			var mouseXY:Point = p;
			var ma:Matrix = new Matrix;
			ma.scale(1/ReleaseUtil.SCALEX,1/ReleaseUtil.SCALEY);
			mouseXY = ma.transformPoint(mouseXY);
			
			return mouseXY;
		}
		
		
		/**
		 * 分割筹码,返回的是从大到小
		 * @param value
		 * @return 
		 * 
		 */		
		public static function splitClip(value:Number):Array
		{
			var ve:Array=[];
			
			var leng:uint = value.toString().length;
			
			var item:uint = 0;
			for(var i:uint = 0; i<leng; i++)
			{
				item = uint(value.toString().substr(i,1));
				ve = ve.concat(splitUnit(item,leng-i));
			}
			//按照数字排序,从小到大
			ve.sort(Array.NUMERIC);
			////			//降序
			//			ve = ve.reverse();
			return ve;
		}
		/**
		 * 分割单位数 
		 * @param value
		 * @param len
		 * @return 
		 * 
		 */		
		private static function splitUnit(value:Number,len:uint):Array
		{
			var temp:Array = [];
			var big:uint = uint(value / 5);
			var i:uint = 0;
			for(i=0; i<big; i++)
			{
				temp.push(5 * Math.pow(10,len-1));
			}
			var left:uint = (value % 5);
			var center:uint = uint(left / 2);
			for(i=0; i<center; i++)
			{
				temp.push(2 * Math.pow(10,len-1));
			}
			var end:uint = (left % 2);
			for(i=0; i<end; i++)
			{
				temp.push(1 * Math.pow(10,len-1));
			}
			return temp;
		}
		
	}
}