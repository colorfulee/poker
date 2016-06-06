package com.jzgame.model
{
	import com.jzgame.vo.PreRoundInfoVO;
	import com.jzgame.vo.TableClipVO;
	import com.jzgame.vo.UserBaseVO;
	import com.jzgame.vo.game.MessageAlertVO;
	import com.jzgame.vo.room.RoomBaseInfoVO;
	
	import flash.display.BitmapData;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	public class GameModel
	{
		/*auther     :jim
		* file       :GameModel.as
		* date       :Sep 2, 2014
		* description:
		*/
		
		//是否为新手引导
		public var guide:Boolean = false;
		
		//是否在桌子中
		private var _inTable:Boolean = false;
		//是否自动坐下,如果外部play now
		public var autoSit:Boolean = false;
		//此轮call的值
		public var callClip:Number = 0;
		//最小下注
		private var _raiseMinClip:Number = 0;
		//当前下注
		public var raiseClip:Number = 0;
		//最大下注
		private var _raiseMaxClip:Number = 0;
		//此轮我下的筹码数
		public var myRoundClip:Number = 0;
		//庄id
		public var dealSeatId:uint = 1;
		//进入的桌子VO
		public var tableBaseInfoVO:RoomBaseInfoVO = new RoomBaseInfoVO;
		private var handPoker:Dictionary = new Dictionary;
		private var _guideStep:uint = 0;
		private var _facePosition:Vector.<Point> = new Vector.<Point>;
		private var _tipsRect:Vector.<Rectangle> = new Vector.<Rectangle>;
		private var _tipsHoleRect:Vector.<Rectangle> = new Vector.<Rectangle>;
		//桌牌
		public var tableCardList:Vector.<uint> = new Vector.<uint>;
		//引导的大步骤
		private var _guideShowStep:uint = 1;
		//玩家上一次行为记录
		public var playerActionHoney:Dictionary = new Dictionary;
		//收集筹码动画时间
		public var collectClipTime:Number = 800;
		//个人操作时间
		public var playerCD:Number = 10;
		//错误弹窗列表
		public var errorCodeList:Vector.<String> = new Vector.<String>;
		
		private var _tipUserId:uint = 0;
		//是否自动补足筹码,不管是什么游戏模式
		public var autoBuy:Boolean = false;
		//筹码池
		public var clips:Vector.<TableClipVO> = new Vector.<TableClipVO>;
		public var tempClips:Vector.<TableClipVO> = new Vector.<TableClipVO>;
		//消息弹窗列表
		public var messageList:Vector.<MessageAlertVO> = new Vector.<MessageAlertVO>;
		//
		public var so:Object;
		//新手引导vo
		public var guideRoomVO:RoomBaseInfoVO;
		//比牌锁，避免比牌的时候手牌站起来手牌没有
		public var cardCompareLock:Boolean = false;
		//缓存玩家行为，只缓存正常玩牌信息，断线重连不记录
		public var tempRoundInfo:PreRoundInfoVO;
		//当前是否为断线重连
		public var offLine:Boolean;
		[Inject]
		public var userModel:UserModel;
		
		[Inject]
		public var eventDis:IEventDispatcher;
		
		public var screenShot:BitmapData;
		
		//大乐透总奖励
		public var jack_pot:Number=0;
		//大乐透压注
		public var jack_betLevel:uint = 0;
		
		
		//服务端发过来的匹配id
		public var action_id:uint;
		
		public function GameModel()
		{
			init();
		}
		
		public function get guideShowStep():uint
		{
			return _guideShowStep;
		}

		public function set guideShowStep(value:uint):void
		{
			trace(value,new Error().getStackTrace());
			_guideShowStep = value;
		}

		public function get inTable():Boolean
		{
			return _inTable;
		}

		public function set inTable(value:Boolean):void
		{
			trace("inTable",value,new Error().getStackTrace());
			_inTable = value;
		}

		public function get tipUserId():uint
		{
			if(_tipUserId == 0) _tipUserId = userModel.myInfo.userId;
			return _tipUserId;
		}

		public function set tipUserId(value:uint):void
		{
			_tipUserId = value;
		}

		public function get raiseMaxClip():Number
		{
			return _raiseMaxClip;
		}
		/**
		 * 设置最大下注 
		 * @param value
		 * 
		 */
		public function set raiseMaxClip(value:Number):void
		{
			_raiseMaxClip = Math.min( value , userModel.myInfo.uClip);
		}

		public function get raiseMinClip():Number
		{
			return _raiseMinClip;
		}
		/**
		 * 设置最小下注 
		 * @param value
		 * 
		 */
		public function set raiseMinClip(value:Number):void
		{
			_raiseMinClip = Math.min( value , userModel.myInfo.uClip);
		}

		private function init():void
		{
			_facePosition.push(new Point(658,176 - 80));
			_facePosition.push(new Point(846,248 - 90));
			_facePosition.push(new Point(867,451 - 60));
			_facePosition.push(new Point(690,537 - 90));
			_facePosition.push(new Point(470,537 - 60));
			_facePosition.push(new Point(281,537 - 90));
			_facePosition.push(new Point(105,451 - 60));
			_facePosition.push(new Point(127,248 - 90));
			_facePosition.push(new Point(317,176 - 80));
			
			clips.push(new TableClipVO());
			clips.push(new TableClipVO());
			clips.push(new TableClipVO());
			clips.push(new TableClipVO());
			clips.push(new TableClipVO());
			
			guideRoomVO = new RoomBaseInfoVO;
			guideRoomVO.blinds = 100;
			guideRoomVO.maxBuy = 200;
			guideRoomVO.minBuy = 100;
			guideRoomVO.maxRole = 5;
			guideRoomVO.online = 5;
			guideRoomVO.id = 1000001;
		}

		public function get guideStep():uint
		{
			return _guideStep;
		}

		public function set guideStep(value:uint):void
		{
			_guideStep = value;
			trace("guideStep:",_guideStep);
		}
		/**
		 * 缓存某人手牌
		 * @param seat
		 * @param hand
		 * 
		 */		
//		public function addHandPoker(userId:uint,hand:Array):void
//		{
//			handPoker[userId] = hand;
//		}
		/**
		 * 获取某人的手牌
		 * @param seat
		 * @return 
		 * 
		 */		
//		public function getHandPokerBySeat(userId:uint):Array
//		{
//			return handPoker[userId];
//		}
		
		/**
		 * 获取引导的位置
		 * @param step
		 * @return 
		 * 
		 */		
//		public function getTipsPositionByStep(step:uint):Rectangle
//		{
//			var rect:Rectangle = _tipsRect[step - 1];
//			return rect;
//		}
		/**
		 * 获取头像的位置
		 * @param seatId
		 * @return 
		 * 
		 */		
		public function getFacePosition(seatId:uint):Point
		{
			var p:Point = _facePosition[seatId - 1];
			
			return p;
		}
		/**
		 * 清空筹码缓存值 
		 * 
		 */
		public function clipClear():void
		{
			myRoundClip = 0;
			callClip    = 0;
			raiseClip   = 0;
			for(var i:String in playerActionHoney)
			{
				delete playerActionHoney[i];
			}
		}
		/**
		 * 清空 
		 * 
		 */		
		public function reset():void
		{
			tableCardList.splice(0,tableCardList.length);
			clipClear();
		}
		/**
		 * 销毁房间的时候操作 
		 * 
		 */		
		public function clear():void
		{
			reset();
			jack_betLevel = 0;
		}
	}
}