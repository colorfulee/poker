package com.jzgame.vo.commu
{
	import com.spellife.vo.ValueObject;
	
	public class ResultVO extends ValueObject
	{
		/***********
		 * name:    ResultVO
		 * data:    Jan 28, 2016
		 * author:  jim
		 * des:
		 ***********/
		
//		{
//			"k" : [CARD1,CARD2....]    #庄家所有牌
//			"s" : [
//				{
//					"id" : 1,    #seat id
//					"w" :  1,    #输赢,  1 => 赢, -1 => 输, 0 => 平
//					"c" : 800,   #筹码, 输的是负数，
//					"w2" :  1,    #输赢,  1 => 赢, -1 => 输, 0 => 平
//					"c2" : 800,   #筹码, 输的是负数，
//					"pc" : 80000,   #玩家现在筹码数
//				}
//				...
//			],
//			"c" : 2000        #庄家筹码变更
//			"dc" : 80000000   #当前剩余筹码
//		}
		public var k:Array;
		public var c:uint;
		public var dc:Number;
		public var idle:Vector.<EachResultVO> = new Vector.<EachResultVO>;
		public function ResultVO(o)
		{
			super();
			
			k = o.k;
			c = o.c;
			dc = o.dc;
			
			
			for(var i:String in o.s)
			{
				idle.push(new EachResultVO(o.s[i]));
			}
		}
	}
}