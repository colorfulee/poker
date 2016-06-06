package com.jzgame.common.model
{
	import com.jzgame.common.services.MessageType;
	import com.jzgame.common.utils.AssetsCenter;
	import com.jzgame.common.utils.logging.Tracer;
	import com.jzgame.events.communication.NetSendEvent;
	import com.jzgame.vo.commu.SendSingleMessage;

	public class NetSendProxy
	{
		/*auther     :jim
		* file       :NetSendProxy.as
		* date       :Apr 2, 2015
		* description:socket 通讯代理
		*/
		public function NetSendProxy()
		{
		}
		/**
		 * 发送ready消息 
		 * 
		 */		
		public static function iamready():void
		{
			var single:SendSingleMessage = new SendSingleMessage();
			single.m  = MessageType.SEND_READY;
			Tracer.info("i am ready :");
			AssetsCenter.eventDispatcher.dispatchEvent(new NetSendEvent(single))
		}
		/**
		 * 站起来 
		 * @param e
		 * 
		 */	
		public static function standUp():void
		{
			var single:SendSingleMessage = new SendSingleMessage();
			single.m  = MessageType.SEND_STAND_UP;
			AssetsCenter.eventDispatcher.dispatchEvent(new NetSendEvent(single));
		}
		/**
		 * 回大厅 
		 * @param e
		 * 
		 */	
		public static function leaveTable(userId:uint,tableId:uint):void
		{
			var single:SendSingleMessage = new SendSingleMessage();
			single.p = [userId,tableId];
			single.m = MessageType.SEND_LEAVE_GAME;
			AssetsCenter.eventDispatcher.dispatchEvent(new NetSendEvent(single));
		}
		/**
		 * 获取自己用户信息
		 * @param tableId
		 * @param userId
		 * 
		 */		
		public static function getPlayerInfo():void
		{
			var single:SendSingleMessage = new SendSingleMessage();
			single.p = [];
			single.m = MessageType.SEND_GET_PLAYER;
			
			AssetsCenter.eventDispatcher.dispatchEvent(new NetSendEvent(single));
		}
		/**
		 * 加入桌子 
		 * @param tableId
		 * @param userId
		 * 
		 */		
		public static function joinTable(tableId:int,userId:int):void
		{
			var single:SendSingleMessage = new SendSingleMessage();
			single.p = [userId,tableId];
			single.m = MessageType.SEND_LOGIN_TABLE;
			
			AssetsCenter.eventDispatcher.dispatchEvent(new NetSendEvent(single));
		}
		/**
		 * 坐下 
		 * @param seat
		 * 
		 */		
		public static function sitDown(seat:uint):void
		{
			var single:SendSingleMessage = new SendSingleMessage();
			single.p = [seat];
			single.m = MessageType.SEND_SIT_DOWN;
			
			AssetsCenter.eventDispatcher.dispatchEvent(new NetSendEvent(single));
		}
		/**
		 * 下注 
		 * @param seat
		 * 
		 */		
		public static function bet(chips:uint):void
		{
			var single:SendSingleMessage = new SendSingleMessage();
			single.p = [chips];
			single.m = MessageType.SEND_BET;
			
			AssetsCenter.eventDispatcher.dispatchEvent(new NetSendEvent(single));
		}
		/**
		 * 完成下注 
		 * @param seat
		 * 
		 */		
		public static function finishBet():void
		{
			var single:SendSingleMessage = new SendSingleMessage();
			single.p = [];
			single.m = MessageType.SEND_FINISH_BET;
			
			AssetsCenter.eventDispatcher.dispatchEvent(new NetSendEvent(single));
		}
		/**
		 * 行为
		 * @param seat
		 * 
		 */		
		public static function action(action:uint,actionid:uint):void
		{
//			[action, action_id] action 1 => Hit, 2 => Stand, 3 => Double, 4 => Split 
//			
//			action_id 操作ID，用来标注此次操作的唯一标识 
			

			var single:SendSingleMessage = new SendSingleMessage();
			single.p = [action,actionid];
			single.m = MessageType.SEND_ACTION;
			
			AssetsCenter.eventDispatcher.dispatchEvent(new NetSendEvent(single));
		}
	}
}