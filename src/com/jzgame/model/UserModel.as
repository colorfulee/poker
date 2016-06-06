package com.jzgame.model
{
	import com.jzgame.common.configHelper.Configure;
	import com.jzgame.common.events.SimpleEvent;
	import com.jzgame.common.services.http.CRC32;
	import com.jzgame.common.utils.ExternalVars;
	import com.jzgame.common.utils.logging.Tracer;
	import com.jzgame.enmu.EventType;
	import com.jzgame.enmu.PlayerStatus;
	import com.jzgame.util.CardInfoUtil;
	import com.jzgame.util.ItemStringUtil;
	import com.jzgame.vo.CardInfoVO;
	import com.jzgame.vo.PlayerDetailVO;
	import com.jzgame.vo.UserBaseVO;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;

	/** 
	 * @Content 
	 * @Author jim 
	 * @Version 1.0.0 
	 * @Date：Apr 10, 2013 1:39:48 PM 
	 * @description:
	 */ 
	public class UserModel
	{
		//是否新手
		public var newer:Boolean = false;

		private var _myInfo:UserBaseVO = new UserBaseVO;
		//个人信息vo
		public var playerDetail:PlayerDetailVO = new PlayerDetailVO;
		
		public var userList:Vector.<UserBaseVO> = new Vector.<UserBaseVO>;
		//结算时候临时镜像的玩家列表
		public var copyTempUserList:Vector.<UserBaseVO> = new Vector.<UserBaseVO>;
		//禁言玩家列表
		public var mutePlayerList:Vector.<String> = new Vector.<String>;
		//获得奖励列表提示
		public var rewardsTips:Vector.<String> = new Vector.<String>;
		[Inject]
		public var eventDis:IEventDispatcher;
		//倒计时剩余时间
		public var onlineTime:int=0;
		//保险箱密码
		public var safePassward:String = "";
		
		public var openOnlineTime:Boolean=false;
		
		public var crc32:CRC32 = new CRC32;
		
		public function UserModel()
		{
			super();
		}

		public function get myInfo():UserBaseVO
		{
			return _myInfo;
		}
		/**
		 * 是否是本人 
		 * @param u
		 * @return 
		 * 
		 */		
		public function isMine(u:uint):Boolean
		{
			if(u == ExternalVars.userID)return true;
			return false;
		}

		/**
		 * 查找最多筹码的人，除了自己 
		 * @return 
		 * 
		 */		
		public function findWithoutMeMaxChip():Number
		{
			var chip:Number = 0;
			for each(var item:UserBaseVO in userList)
			{
				if(item.userId == myInfo.userId) continue;
				chip = Math.max(item.uMoney,chip);
			}
			return chip;
		}

		/**
		 * 根据玩家id 
		 * @param uid
		 * @return 
		 * 
		 */		
		public function getUserByID(uid:uint):UserBaseVO
		{
			var userBaseVO:UserBaseVO;
			for(var i:String in userList)
			{
				userBaseVO = userList[i] as UserBaseVO;
				if(userBaseVO.userId == uid)
				{
					return userBaseVO;
				}
			}
			trace("get user by id :",uid,null);
			return null;
		}
		
		/**
		 * 根据玩家id 
		 * @param uid
		 * @return 
		 * 
		 */		
		public function getCopyUserByID(uid:uint):UserBaseVO
		{
			var userBaseVO:UserBaseVO;
			for(var i:String in copyTempUserList)
			{
				userBaseVO = copyTempUserList[i] as UserBaseVO;
				if(userBaseVO.userId == uid)
				{
					return userBaseVO;
				}
			}
			trace("get copy user by id :",uid,null);
			return null;
		}
		/**
		 *  
		 * @param userBaseVO
		 * 
		 */		
		public function addUser(newUserBaseVO:UserBaseVO):void
		{
			var userBaseVO:UserBaseVO = newUserBaseVO;
			var contains:Boolean = false;
			for(var i:String in userList)
			{
				userBaseVO = userList[i] as UserBaseVO;
				if(userBaseVO.userId == newUserBaseVO.userId)
				{
					userList[i] = newUserBaseVO;
					contains = true;
					break;
				}
			}
			
			if(!contains)
			{
				userList.push(newUserBaseVO);
				//如果是我本人登陆
				if(newUserBaseVO.userId == myInfo.userId)
				{
					//同步座位信息
					myInfo.uSeatIndex = newUserBaseVO.uSeatIndex;
					myInfo.uNickName = newUserBaseVO.uNickName;
					myInfo.uClip = newUserBaseVO.uClip;
					myInfo.uFB_ID = newUserBaseVO.uFB_ID;
					myInfo.uStatus = newUserBaseVO.uStatus;
					myInfo.cards = newUserBaseVO.cards;
					myInfo.uEquipId = newUserBaseVO.uEquipId;
					myInfo.uVipLevel = newUserBaseVO.uVipLevel;
					if(newUserBaseVO.cards.length > 0)
					{
						var coverCard:CardInfoVO = CardInfoUtil.praseCardInfo(newUserBaseVO.cards[0]);
						var coverCard2:CardInfoVO = CardInfoUtil.praseCardInfo(newUserBaseVO.cards[1]);
						//						gameModel.addHandPoker(myInfo.userId,player.card);
						Tracer.debug("短线重连同步手牌:"+coverCard.toString() +coverCard2.toString());
						eventDis.dispatchEvent(new SimpleEvent(EventType.NET_HAND_POKER,myInfo.userId));
					}
					eventDis.dispatchEvent(new Event(EventType.I_AM_IN_SEAT));
				}else
				{
					eventDis.dispatchEvent(new SimpleEvent(EventType.PLAYER_IN_SEAT,newUserBaseVO));
				}
			}
		}
		/**
		 * 开局同步玩家信息 
		 * @param list
		 * 
		 */		
		public function updateUserListInfo(list:Array):void
		{
			var userBaseVO:UserBaseVO;
			var contains:Boolean = false;
			
			for(var i:String in userList)
			{
				userBaseVO = userList[i] as UserBaseVO;
				var length:uint = list.length;
				for(var j:uint = 0; j<length; j++)
				{
					var newVo:UserBaseVO = new UserBaseVO();
					if(userBaseVO.userId == newVo.userId)
					{
						userBaseVO.uClip = newVo.uClip;
						userBaseVO.uLevel = newVo.uLevel;
						userBaseVO.uMoney = newVo.uMoney;
						userBaseVO.uStatus = newVo.uStatus;
						userBaseVO.cards = newVo.cards;
						userBaseVO.uEquipId = newVo.uEquipId;
						//如果我在局里，更新我的数据拷贝,否则筹码数量不对
						if(userBaseVO.userId == _myInfo.userId)
						{
							_myInfo.uEquipId = _myInfo.uEquipId;
							_myInfo.uClip = newVo.uClip;
							_myInfo.uLevel = newVo.uLevel;
							_myInfo.uMoney = newVo.uMoney;
							_myInfo.uStatus = newVo.uStatus;
							_myInfo.cards = newVo.cards;
						}
						list.splice(j,1);
						break;
					}
				}
			}
		}
		/**
		 * 更新自己信息 
		 * @param vo
		 * 
		 */		
		public function updateInfo(vo:Object,interfaceName:String):void
		{
			var tips:Array = [];
			if(vo.hasOwnProperty("chip"))
			{
				if(vo.chip > _myInfo.uMoney)
				{
					tips.push(ItemStringUtil.getItemDes(ItemStringUtil.CHIP,String(vo.chip - _myInfo.uMoney)));
				}
//				_myInfo.uMoney = new Int64(vo.chip);
			}
			if(vo.hasOwnProperty("coin"))
			{
				_myInfo.uGold = (vo.coin);
			}
			if(vo.hasOwnProperty("dealer"))
			{
				_myInfo.uDealer = (vo.dealer);
			}
			if(vo.hasOwnProperty("background"))
			{
				_myInfo.uTableBack = (vo.background);
			}
			
			if(vo.hasOwnProperty("score"))
			{
				_myInfo.uScore = vo.score;
			}
			
			if(vo.hasOwnProperty("score_get"))
			{
				_myInfo.uEverMaxScore = vo.score_get;
			}
			if(vo.hasOwnProperty("user_nickname"))
			{
				_myInfo.userRealName = vo.user_nickname;
			}
			if(vo.hasOwnProperty("user_phone"))
			{
				_myInfo.userPhone = vo.user_phone;
			}
			if(vo.hasOwnProperty("user_email"))
			{
				_myInfo.userEmail = vo.user_email;
			}
			
			if(vo.hasOwnProperty("exp"))
			{
				if(vo.exp > _myInfo.uPendingExp)
				{
					tips.push(ItemStringUtil.getItemDes(ItemStringUtil.EXP,String(vo.exp - _myInfo.uPendingExp)));
				}
				_myInfo.uPendingExp = vo.exp;
				_myInfo.uLevelExp = vo.exp;
				_myInfo.uLevel = Configure.playerLevel.getLevelByExp(vo.exp);
			}
			if(vo.hasOwnProperty("guide_status"))
			{
				_myInfo.guideStatus = vo.guide_status;
			}
			
			if(vo.hasOwnProperty("equip_gift_id"))
			{
				_myInfo.uEquipId = vo.equip_gift_id;
			}
			
			if(vo.hasOwnProperty("equip_end_time"))
			{
				_myInfo.uEquipEndTime = vo.equip_end_time;
			}
			
			if(vo.hasOwnProperty("isset_box_pwd"))
			{
				_myInfo.isset_box_pwd = vo.isset_box_pwd;
			}
			
			if(vo.hasOwnProperty("chip_box"))
			{
				_myInfo.chip_box = vo.chip_box;
			}
			
			switch(interfaceName)
			{
			}
//			eventDis.dispatchEvent(new Event(EventType.INFO_INIT));
			eventDis.dispatchEvent(new Event(EventType.UPDATE_USER_INFO));
		}
		/**
		 * 移除 
		 * @param userId
		 * 
		 */		
		public function removeUser(userId:uint):void
		{
			var userBaseVO:UserBaseVO;
			for(var i:String in userList)
			{
				userBaseVO = userList[i] as UserBaseVO;
				if(userBaseVO.userId == userId)
				{
					//移除玩家
					userList.splice(uint(i),1);
					//移除禁言玩家
					removeMuteUser(userId);
					if(userId == _myInfo.userId)
					{
						_myInfo.uStatus = PlayerStatus.PLAYING_IDLE;
						//清空座位信息
						_myInfo.uSeatIndex = 0;
					}
					userBaseVO.uStatus = PlayerStatus.PLAYING_IDLE;
					eventDis.dispatchEvent(new SimpleEvent(EventType.STAND_UP,userBaseVO.clone()));
					userBaseVO.uSeatIndex = 0;
					return;
				}
			}
			
			trace("removeUser:do not exist id:",userId);
		}
		/**
		 * 移除禁言玩家 
		 * @param userId
		 * 
		 */		
		public function removeMuteUser(userId:uint):void
		{
			for(var i:String in mutePlayerList)
			{
				if(mutePlayerList[i] == userId)
				{
					//移除玩家
					mutePlayerList.splice(uint(i),1);
					return;
				}
			}
		}
		/**
		 * 
		 * 清空禁言列表
		 */		
		public function clearMuteList():void
		{
			mutePlayerList.splice(0,mutePlayerList.length);
		}
		/**
		 * 移除所有玩家 
		 * 
		 */		
		public function removeAllUser():void
		{
			//移除我手牌缓存
			_myInfo.cards = [];
			_myInfo.uSeatIndex = 0;
			_myInfo.uStatus = PlayerStatus.PLAYING_IDLE;
			userList.splice(0,userList.length);
			copyTempUserList.splice(0,copyTempUserList.length);
		}
		/**
		 * 镜像 
		 * 
		 */		
		public function copyUserList():void
		{
			copyTempUserList = userList.concat();
		}
	}
}