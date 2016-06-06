package com.jzgame.vo.commu
{
	import com.spellife.vo.ValueObject;
	
	import flash.geom.Point;
	
	public class SeatInfoVO extends ValueObject
	{
		//座位号码
		public var id:uint;
		public var b:uint;
		//手牌
		public var k:Array = [];
		public var k2:Array = [];
		//玩家信息，可选，存在时说明有玩家坐在该位子上
		public var player:PlayerInfoVO;
		
		public var position:Point;
//		{
//			"id": 1                 # Seat ID
//			"b":  1000,             # Bet Chips 已下注的筹码数
//			"k":  [11,22],          # 已拿到的牌
//			"k2": [23,11],         # Sub Cards List，分牌信息，Optional，只有该玩家分牌时才出现
//			"p":  PLAYER_INFO，     # 玩家信息，可选，存在时说明有玩家坐在该位子上
//			"di": DEALER_INFO,      # 庄家信息，预留，为将来可能出现的庄家信息预留字段
//		}

		public function SeatInfoVO(o:Object)
		{
			super();
			
			for(var i:String in o)
			{
				if(this.hasOwnProperty(i))
				{
					this[i] = o[i];
				}
			}
			
			if(o.hasOwnProperty('p') && o.p)
			{
				player = new PlayerInfoVO(o.p);
			}
		}
		
		public function reset():void
		{
		}
	}
}