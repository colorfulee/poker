package com.jzgame.vo.commu
{
	import com.spellife.vo.ValueObject;
	
	public class AskStandVO extends ValueObject
	{
		/***********
		 * name:    AskHitVO
		 * data:    Jan 28, 2016
		 * author:  jim
		 * des:
		 ***********/
//		{
//		"s":$seat_id,
//		"sk":$sub_cards_index     
//		}
		public var s:uint;
		public var sk:uint;
		
		public function AskStandVO(o)
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