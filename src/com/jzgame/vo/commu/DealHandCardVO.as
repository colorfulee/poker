package com.jzgame.vo.commu
{
	import com.spellife.vo.ValueObject;
	
	public class DealHandCardVO extends ValueObject
	{
		/***********
		 * name:    PlayerBetVO
		 * data:    Jan 27, 2016
		 * author:  jim
		 * des:
		 ***********/
//		[
//			[1,CARD1,CARD2]...,[5,CARD1,CARD2],
//		]
		public var array:Array = [];
		public function DealHandCardVO(o:Object)
		{
			super();
			
			for(var i:String in o)
			{
				array.push(o[i]);
			}
		}
		/**
		 * 获取座位上的牌信息 
		 * @param seat
		 * @return 
		 * 
		 */		
		public function getCardsBySeat(seat:uint):Array
		{
			for(var i:String in array)
			{
				if(array[i][0] == seat)
				{
					return array[i];
				}
			}
			return null;
		}
	}
}