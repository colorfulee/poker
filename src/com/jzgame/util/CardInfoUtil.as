package com.jzgame.util
{
	import com.jzgame.common.utils.AssetsCenter;
	import com.jzgame.common.utils.LangManager;
	import com.jzgame.common.utils.logging.Tracer;
	import com.jzgame.enmu.Card;
	import com.jzgame.enmu.PlayerStatus;
	import com.jzgame.vo.CardInfoVO;

	public class CardInfoUtil
	{
		/*auther     :jim
		* file       :CardInfoUtil.as
		* date       :Oct 10, 2014
		* description:
		*/
		public function CardInfoUtil()
		{
		}
		/**
		 * 
		 * @param card
		 * @return 
		 * 
		 */
		public static function praseCardInfo(card:Number):CardInfoVO
		{
			var num:uint = Math.floor(card / Card.EACH_MAX);
			var type:uint = card % Card.EACH_MAX;
			
			switch(type)
			{
				case 0:
					type = Card.SUIT_BLACK_HEART;
					break;
				case 1:
					type = Card.SUIT_RED_HEART;
					break;
				case 2:
					type = Card.SUIT_DIAMONDS;
					break;
				case 3:
					type = Card.SUIT_CLUBS;
					break;
			}
			return new CardInfoVO(type,num , card);
		}
		/**
		 * 最大手牌 
		 * @param cards
		 * @return 
		 * 
		 */		
		public static function praseMaxCards(cards:String):String
		{
			//最好手牌
			var max:String=" ";
			if(cards != "")
			{
				var temp:Array = cards.split(AssetsCenter.COMMA);
				for(var i:String in temp)
				{
					max += Card.praseCardString(temp[i]) +" ";
				}
			}else
			{
				max = "--";
			}
			
			return max
		}
		
		/**
		 * 获取玩家状态描述
		 * @param state
		 * @return 
		 * 
		 */
		public static function getStateNameByState(state:uint):String
		{
			var str:String = LangManager.getText("402026");
			switch(state)
			{
				case PlayerStatus.PLAYING_ALLIN:
					str = "全押";
					str = LangManager.getText("300903");
					break;
				case PlayerStatus.PLAYING_CALL:
					str = "跟注";
					str = LangManager.getText("300917");
					break;
				case PlayerStatus.PLAYING_FOLD:
					str = "弃牌";
					str = LangManager.getText("300915");
					break;
				case PlayerStatus.PLAYING_BLIND_LITTLE:
					str = "小盲";
					str = LangManager.getText("300927");
					break;
				case PlayerStatus.PLAYING_BLIND_BIGGER:
					str = "大盲";
					str = LangManager.getText("300926");
					break;
				case PlayerStatus.PLAYING_IDLE:
					str = "等待";
					str = LangManager.getText("300925");
					break;
				case PlayerStatus.PLAYING_CHECK:
					str = "过牌";
					str = LangManager.getText("300916");
					break;
				case PlayerStatus.PLAYING_RAISE:
					str = "加注";
					str = LangManager.getText("300918");
					break;
				case PlayerStatus.PLAYING_ANTE:
					str = "前注";
					str = LangManager.getText("300918");
					break;
				case PlayerStatus.PLAYING_READY:
					str = "等待";
					str = LangManager.getText("300925");
					break;
				default:
					Tracer.error("为什么是空闲状态:"+state);
					break;
			}
			return str;
		}
		
		/**
		 * 
		 * @param type
		 * @return 
		 * 
		 */		
		public static function getCardType(type:uint):String
		{
			var name:String = "";
			switch(type)
			{
				case Card.SUIT_BLACK_HEART:
					name = LangManager.getText("301531");
					name = Card.BLACK_HEART_STR;
					break;
				case Card.SUIT_CLUBS:
					name = LangManager.getText("301532");
					name = Card.SUIT_CLUBS_STR;
					break;
				case Card.SUIT_DIAMONDS:
					name = LangManager.getText("301533");
					name = Card.SUIT_DIAMONDS_STR;
					break;
				case Card.SUIT_RED_HEART:
					name = LangManager.getText("301534");
					name = Card.HEART_STR;
					break;
			}
			
			return name;
		}
		/**
		 * 算点数 
		 * @param cards
		 * @return 
		 * 
		 */		
		public static function count(cards:Array):uint
		{
			var v:uint = 0;
			var c:uint = 0;
			for(var i:String in cards)
			{
				v = praseCardInfo(cards[i]).value;
				//如果大于10 都是10点
				if(v>10)v=10;
				
				c += v;
			}
			return c;
		}
		/**
		 *  算点数  如果有A的话 只算其中一个A
		 * @param cards
		 * @return 
		 * 
		 */		
		public static function countWithA(cards:Array):uint
		{
			var v:uint = 0;
			var c:uint = 0;
			var b:Boolean = false;
			for(var i:String in cards)
			{
				v = praseCardInfo(cards[i]).value;
				//如果大于10 都是10点
				if(v>10)v=10;
				c += v;
				if(v == 1 && b==false)
				{
					c+=10;
					b = true;
				}
			}
			
			return c;
		}
		/**
		 * 是否是五龙 
		 * @param cards
		 * @return 
		 * 
		 */		
		public static function isFiveDragon(cards:Array):Boolean
		{
			if(cards.length==5 && count(cards)<21)
			{
				return true;
			}else
			{
				return false;
			}
		}
		/**
		 *  
		 * @param cards
		 * @return 
		 * 
		 */		
		public static function isBlackJack(cards:Array):Boolean
		{
			if(cards.length==2)
			{
				//点数加起来为11点
				if(count(cards) == 11)
				{
					//其中一张牌为A
					if( (praseCardInfo(cards[0]).value == 1 || praseCardInfo(cards[0]).value == 1))
					{
						return true;
					}
				}
				
				return false;
			}else
			{
				return false;
			}
		}
		
		
		/**
		 * 分割筹码,返回的是从大到小
		 * @param value
		 * @return 
		 */		
		public static function splitClip(value:Number):Array
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
		private static function splitUnit(value:Number,len:uint):Array
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
	}
}