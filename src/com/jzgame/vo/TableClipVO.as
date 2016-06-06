package com.jzgame.vo
{
	import com.spellife.vo.ValueObject;
	
	public class TableClipVO extends ValueObject
	{
		/*auther     :jim
		* file       :TableClipVO.as
		* date       :Aug 28, 2014
		* description:
		*/
		//第一堆
		public var clip1:Number  = 0;
		//第二堆 如果有分牌
		public var clip2:Number  = 0;
		public var seatID:uint = 0;//谁发的筹码
		public function TableClipVO()
		{
			super();
		}
		
		public function clear():void
		{
			clip1 = 0;
			clip2 = 0;
			seatID = 0;
		}
	}
}