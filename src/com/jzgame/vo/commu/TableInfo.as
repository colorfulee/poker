package com.jzgame.vo.commu
{
	import com.spellife.vo.ValueObject;
	
	public class TableInfo extends ValueObject
	{
		/***********
		 * name:    TableInfo
		 * data:    Jan 22, 2016
		 * author:  jim
		 * des:
		 ***********/
//		{
//			"id": 10001,      # table id
//			"bm": 100,        # chips bet min
//			"bx": 10000,      # chips bet max
//			"ts": 2,          # table status, 0 => IDLE 空闲,
//			1 => BETTING 下注阶段,
//			2 => ASKING_INSURANCE 询问是否下保险金阶段,
//			3 => ASKING_HIT 询问是否要牌阶段
//			4 => READY 两局之间的准备阶段（结算已完成，等待Ready请求）
//			"cs": 2,          # current seat id, 当有操作对象时有此字段
//			"csk": 0,         # current sub cards index，Optional，只有当前玩家已分牌时出现，只有0和1两个值
//			"cd": 5,          # current action count down seconds remaining，当前操作剩余倒计时秒数
//		    "a": 12345,       # current action ID, 当前操作ID，用来标注此次操作的唯一标识，只当某玩家正在操作时才会出现
//			"s": [            # seat list，6元数组，必然有6个值，index与SeatID相对应
//				SEAT_INFO,      #庄家位置信息
//				SEAT_INFO,      #1号座位信息
//				SEAT_INFO,      #2号座位信息
//				SEAT_INFO,      #3号座位信息
//				SEAT_INFO,      #4号座位信息
//				SEAT_INFO       #5号座位信息
//			]
//		}

		public var id:uint;
		public var bm:uint;
		public var bx:uint;
		public var ts:uint;
		public var cs:uint = 0;
		public var csk:uint;
		public var a:uint;
		public var cd:uint;
		//凡事取这里的，不需要index - 1 因为有6位
		public var seats:Vector.<SeatInfoVO> = new Vector.<SeatInfoVO>;
		public function TableInfo(o:Object)
		{
			super();
			
			for(var i:String in o)
			{
				if(this.hasOwnProperty(i))
				{
					this[i] = o[i];
				}
			}
			
			for(var j:String in o.s)
			{
				seats.push(new SeatInfoVO(o.s[j]));
			}
		}
		/**
		 * 获取座位上的信息 
		 * @param i
		 * @return 
		 */		
		public function getSeat(i:uint):SeatInfoVO
		{
			return seats[i];
		}
		/**
		 * 根据座位获取玩家信息 
		 * @param seat
		 * @return 
		 * 
		 */		
		public function getPlayerBySeat(seat:uint):PlayerInfoVO
		{
			return seats[seat].player;
		}
		/**
		 * 玩家是否在座位上
		 * @param u
		 * @return 
		 */		
		public function seatByUid(u:uint):int
		{
			for(var i:uint = 0;i<6;i++ )
			{
				if(seats[i].player)
				{
					seats[i].player.u == u;
					
					return i;
				}
			}
			
			return -1;
		}
	}
}