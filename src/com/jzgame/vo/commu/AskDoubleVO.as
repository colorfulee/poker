package com.jzgame.vo.commu
{
	import com.spellife.vo.ValueObject;
	
	public class AskDoubleVO extends ValueObject
	{
		/***********
		 * name:    AskHitVO
		 * data:    Jan 28, 2016
		 * author:  jim
		 * des:
		 ***********/
//		{
//			"s":$seat_id,
//			"k":$card_id,
//			"c":$chips,
//			"b":$bet_chips,
//			"pc":$player_chips
//		}
//		
//		$chips: 本次下注筹码数
//		$bet_chips: 加上本次下注后，玩家所下的筹码数总和（即桌子上的筹码数）
//		$player_chips: 本次下注后，玩家所持有的筹码数
		
		public var s:uint;
		public var k:uint;
		public var c:uint;
		public var pc:uint;
		
		public function AskDoubleVO(o)
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