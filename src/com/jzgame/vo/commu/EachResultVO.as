package com.jzgame.vo.commu
{
	import com.spellife.vo.ValueObject;
	
	public class EachResultVO extends ValueObject
	{
		/***********
		 * name:    EachResultVO
		 * data:    Jan 28, 2016
		 * author:  jim
		 * des:
		 ***********/
		
//		"id" : 1,    #seat id
//		"w" :  1,    #输赢,  1 => 赢, -1 => 输, 0 => 平
//		"c" : 800,   #筹码, 输的是负数，
//		"w2" :  1,    #输赢,  1 => 赢, -1 => 输, 0 => 平
//		"c2" : 800,   #筹码, 输的是负数，
//		"pc" : 80000,   #玩家现在筹码数

		
		public var id:int;
		public var w:int;
		public var c:int;
		public var w2:int;
		public var c2:int;
		public var pc:int;
		public function EachResultVO(o:Object)
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