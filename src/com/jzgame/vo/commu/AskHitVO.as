package com.jzgame.vo.commu
{
	import com.spellife.vo.ValueObject;
	
	public class AskHitVO extends ValueObject
	{
		/***********
		 * name:    AskHitVO
		 * data:    Jan 28, 2016
		 * author:  jim
		 * des:
		 ***********/
//		{
//			"s":$seat_id,                   #座位号
//			"a":$action_id,                 #操作ID，用来标注此次操作的唯一标识
//			"cd":$count_down_seconds,       #倒计时秒数
//			"sk":$sub_cards_index           #可选,如果分牌,会有此字段, 0 和 1
//		}
		public var s:uint;
		public var a:uint;
		public var cd:uint;
		public var sk:uint;
		
		public function AskHitVO(o)
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