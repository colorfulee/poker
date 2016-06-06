package com.jzgame.vo.commu
{
	import com.spellife.vo.ValueObject;
	
	public class PlayerBetVO extends ValueObject
	{
		/***********
		 * name:    PlayerBetVO
		 * data:    Jan 27, 2016
		 * author:  jim
		 * des:
		 ***********/
//		$chips: 玩家本次下注筹码数
//		$bet_chips: 玩家下注的总筹码数（即桌子上的筹码数）
//		$player_chips: 玩家下完赌注后所剩下的筹码数（即玩家总资产）

//		[$seat_id,$chips,$bet_chips,$player_chips]
        public var seat_id:uint;
        public var chips:uint;
        public var bet_chips:uint;
        public var player_chips:uint;
		public function PlayerBetVO(o:Object)
		{
			super();
			
			seat_id = o[0];
			chips = o[1];
			bet_chips = o[2];
			player_chips = o[3];
		}
	}
}