package com.jzgame.vo.commu
{
	import com.spellife.vo.ValueObject;
	
	public class PlayerInfoVO extends ValueObject
	{
		/***********
		 * name:    PlayerInfoVO
		 * data:    Jan 22, 2016
		 * author:  jim
		 * des:
		 ***********/
//		{
//			"u": 1001,                    # User ID
//			"n": "Daniel",                # User Name
//			"f": "http://xxx/123.jpg",    # 头像图片URL
//			"c": 87654                    # 玩家拥有的筹码（玩家总资产）
//		}

		public var u:uint;
		public var n:String;
		public var f:String;
		public var c:uint;
		public function PlayerInfoVO(o:Object)
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