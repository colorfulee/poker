package com.jzgame.vo.commu
{
	import com.spellife.vo.ValueObject;
	
	public class PlayerBustVO extends ValueObject
	{
		/***********
		 * name:    PlayerBustVO
		 * data:    Jan 28, 2016
		 * author:  jim
		 * des:
		 ***********/
		
//		{
//			"s":$seat_id,
//			"sk":$sub_cards_index           #可选，如果分牌，会有此字段, 0 和 1
//			"b":$bet_chips,                 #输掉的筹码数
//			"dc":$dealer_chips              #可选，变更后庄家所持有的筹码数
//		}

		public var s:uint;
		public var sk:uint;
		public var b:uint;
		public var dc:uint;
		public function PlayerBustVO(o:Object)
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