package com.jzgame.model
{
	import com.jzgame.enmu.TableInfoUtil;
	import com.jzgame.vo.commu.PlayerInfoVO;
	import com.jzgame.vo.commu.ResultVO;
	import com.jzgame.vo.commu.SeatInfoVO;
	import com.jzgame.vo.commu.TableInfo;
	
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	public class TableModel
	{
		public var tableInfo:TableInfo;
		//存筹码view seat id 为索引
		public var chipList:Dictionary=new Dictionary;
		//存筹码数值view seat id 为索引
		public var chipNumList:Dictionary = new Dictionary;
		
		//座位坐标
		public var position:Vector.<Point> = new Vector.<Point>;
		//座位坐标
		private var seatPoint:Vector.<Point> = new Vector.<Point>;
		
		//荷官位置
		public var hePosition:Point = new Point(540,215);
		//当前庄家位置
		private var _dealerPosition:Point;
		
		private var seatList:Dictionary = new Dictionary;
		
		//庄座位
		public var dealerSeat:uint = 0;
		
		public var currentSeat:int = 0;
		//本人座位信息 -1为没有座位
		public var mySeat:int = -1;
		//大盲
		public var bigBlinds:uint = 0;
		//小盲
		public var smallBlinds:uint = 0;
		//桌牌回合
		public var cardRound:uint = 0;
		
		//结算结果
		public var resultVO:ResultVO;
		public var iamSmallBlinds:Boolean  = false;
		public var round:Number = 1;
		//快捷下注筹码池子
		public var clipArray:Array = [];
		
		[Inject]
		public var eventDis:IEventDispatcher;
		
		public function TableModel()
		{
			position.push(new Point(64,61));
			position.push(new Point(84,56));
			position.push(new Point(85,45));
			position.push(new Point(85,54));
			position.push(new Point(51,45));
			position.push(new Point(56,54));
			position.push(new Point(58,45));
			position.push(new Point(63,54));
			position.push(new Point(56,61));
			
			seatPoint.push(new Point(679,150));
			seatPoint.push(new Point(860,213));
			seatPoint.push(new Point(886,407));
			seatPoint.push(new Point(707,491));
			seatPoint.push(new Point(504,491));
			seatPoint.push(new Point(304,491));
			seatPoint.push(new Point(131,412));
			seatPoint.push(new Point(164,211));
			seatPoint.push(new Point(336,150));
			
			
			chipList[0] = [];
			chipList[1] = [];
			chipList[2] = [];
			chipList[3] = [];
			chipList[4] = [];
			chipList[5] = [];
		}
		
		/**
		 * 循环查找下一个玩家,第一个返回的是庄座位
		 * @return 返回0则无
		 * 
		 */		
		public function next():uint
		{
			var nextTempSeat:uint = 0;
			var nextSeat:uint = 0;
			var i:uint = 0;
			var seatInfo:SeatInfoVO;
			
			for(i = 0; i< TableInfoUtil.BIG_ROOM_NUMBER; i++)
			{
				nextTempSeat = (currentSeat + i ) %TableInfoUtil.BIG_ROOM_NUMBER+ 1;
				seatInfo = seatList[nextTempSeat];
			}
			trace("nextseat:",nextSeat);
			return nextSeat;
		}
		/**
		 *
		 * 寻找庄家下一位 
		 * @param seatID 当前座位
		 * @return 
		 * 
		 */			
		public function findNextSeat(seatID:uint):uint
		{
			var nextTempSeat:uint = 0;
			var preSeat:uint = 0;
			var i:uint = 0;
			var seatInfo:SeatInfoVO;
			
			for(i = 1; i<= TableInfoUtil.BIG_ROOM_NUMBER; i++)
			{
				nextTempSeat = (seatID + i ) % TableInfoUtil.BIG_ROOM_NUMBER ;
				if(nextTempSeat==0)
				{
					nextTempSeat+=TableInfoUtil.BIG_ROOM_NUMBER;
				}
				seatInfo = seatList[nextTempSeat];
			}
			trace("next seat:",preSeat);
			return preSeat;
		}
		/**
		 * 
		 * @param seatID
		 * @return 
		 * 
		 */		
		public function findPreSeat(seatID:uint):uint
		{
			var preTempSeat:uint = 0;
			var preSeat:uint = 0;
			var i:uint = 0;
			var seatInfo:SeatInfoVO;
			
			for(i = 1; i<= TableInfoUtil.BIG_ROOM_NUMBER; i++)
			{
				preTempSeat = (seatID - i ) % TableInfoUtil.BIG_ROOM_NUMBER ;
				if(preTempSeat==0)
				{
					preTempSeat+=TableInfoUtil.BIG_ROOM_NUMBER;
				}
				seatInfo = seatList[preTempSeat];
			}
			trace("pre seat:",preSeat);
			return preSeat;
		}
		
		/**
		 * 查找座位上的用户信息
		 * @param seat
		 * @return 
		 * 
		 */		
		public function getUserBySeat(seat:uint):PlayerInfoVO
		{
			return tableInfo.seats[seat].player;
		}
		
		/**
		 * 根据类型获取预操作类型 的名字
		 * @param type
		 * @return 
		 * 
		 */		
		public function getOperateName(type:uint):String
		{
			return "operate_"+type;
		}
		/**
		 * 根据名字获取预操作类型 
		 * @param str
		 * @return 
		 * 
		 */		
		public function getOperateType( str:String ):uint
		{
			var type:uint = str.split("_")[1];
			return type;
		}

		/**
		 * 
		 * @param seatID
		 * @return 
		 * 
		 */		
		public function getOtherPokerBackName(seatID:uint,index:uint):String
		{
			return "otherPokerBack_seat_"+seatID+"_"+index;
		}
		/**
		 * 
		 * @param seatID
		 * @param index
		 * @return 
		 * 
		 */		
		public function getHandPokerName(seatID:uint,index:uint):String
		{
			return "handPoker_seat_"+seatID+"_"+index;
		}
		/**
		 * 牌点数 
		 * @param seatID
		 * @return 
		 * 
		 */		
		public function getHandPokerCardNumName(seatID:uint):String
		{
			return "handPokerCard_seat_"+seatID;
		}
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */		
		private function getNextClipNum(value:Number):Number
		{
			var temp:Number = value;
			if(value>5)
			{
				temp = 10;
			}else if(value>2)
			{
				temp = 5;
			}else  if(value>1)
			{
				temp = 2;
			}else
			{
				temp = 1;
			}
			
			return temp;
		}
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */		
		public function getNextClip(value:Number):Number
		{
			var leng:Number = value.toString().length-1;
			var temp:Number = Number(value.toString().substr(0,1));
			return getNextClipNum(temp) * Math.pow(10,leng)
		}
		
		/**
		 * 分割筹码,返回的是从大到小
		 * @param value
		 * @return 
		 * 
		 */		
		public function splitClip(value:Number):Array
		{
			var ve:Array=[];
			
			var leng:uint = value.toString().length;
			
			var item:uint = 0;
			for(var i:uint = 0; i<leng; i++)
			{
				item = uint(value.toString().substr(i,1));
				ve = ve.concat(splitUnit(item,leng-i));
			}
			//按照数字排序,从小到大
			ve.sort(Array.NUMERIC);
////			//降序
//			ve = ve.reverse();
			return ve;
		}
		/**
		 * 分割单位数 
		 * @param value
		 * @param len
		 * @return 
		 * 
		 */		
		private function splitUnit(value:Number,len:uint):Array
		{
			var temp:Array = [];
			var big:uint = uint(value / 5);
			var i:uint = 0;
			for(i=0; i<big; i++)
			{
				temp.push(5 * Math.pow(10,len-1));
			}
			var left:uint = (value % 5);
			var center:uint = uint(left / 2);
			for(i=0; i<center; i++)
			{
				temp.push(2 * Math.pow(10,len-1));
			}
			var end:uint = (left % 2);
			for(i=0; i<end; i++)
			{
				temp.push(1 * Math.pow(10,len-1));
			}
			return temp;
		}
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */		
		public function splitIconIndex(value:Number):uint
		{
			var index:uint = uint(value.toString().substr(0,1));
			switch(index)
			{
				case 1:
					if(value.toString().length%2 == 0)
					{
						return 4;
					}else
					{
						return 1;
					}
					break;
				case 2:
					if(value.toString().length%2 == 0)
					{
						return 5;
					}else
					{
						return 2;
					}
					break;
				case 5:
					if(value.toString().length%2 == 0)
					{
						return 6;
					}else
					{
						return 3;
					}
					break;
			}
			return index;
		}
		/**
		 * 重置
		 * 
		 */		
		public function reset():void
		{
			var seatInfo:SeatInfoVO;
			for (var i:String in seatList)
			{
				seatInfo = seatList[i];
				seatInfo.reset();
				delete seatList[i];
			}
			clipArray.splice(0,clipArray.length);
		}
	}
}