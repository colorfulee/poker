package com.jzgame.vo.commu
{
	import com.spellife.vo.ValueObject;
	
	public class DealAskCardVO extends ValueObject
	{
		/***********
		 * name:    DealAskCardVO
		 * data:    Jan 27, 2016
		 * author:  jim
		 * des:
		 ***********/
		
//		{
//			"s":$seat_id,
//			"k":$card_id,
//			"sk":$sub_cards_index           #可选,如果分牌,会有此字段, 0 和 1
//		}

		public var s:uint;
		public var k:uint;
		public var sk:uint;
		public function DealAskCardVO(o:Object)
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