package com.jzgame.vo.commu
{
	import com.spellife.vo.ValueObject;
	
	public class GameStartVO extends ValueObject
	{
		/***********
		 * name:    GameStartVO
		 * data:    Jan 27, 2016
		 * author:  jim
		 * des:
		 ***********/
		
//		"s":[$seat_id,...],         #参加牌局的座位号，int数组
//		"cd":$count_down_seconds    #倒计时的秒数, 数值型

		
		public var cd:uint;
		public function GameStartVO(o:Object)
		{
			super();
			
			for(var i:String in o)
			{
				if(this.hasOwnProperty(i))
				{
					this[i] = o[i];
				}
			}
		}
	}
}