package com.jzgame.common.services
{
	/** 
	 * @Content 
	 * @Author jim 
	 * @Version 1.0.0 
	 * @Date：Apr 9, 2013 5:30:05 PM
	 * @description:
	 */ 
	public class MessageType
	{
		//心跳
		public static var HEART:uint = 0;
		//登陆桌子
		public static var SEND_LOGIN_TABLE:uint = 1;
		//离开桌子
		public static var SEND_LEAVE_GAME:uint = 2;
		//坐下
		public static var SEND_SIT_DOWN:uint = 3;
		//站起来
		public static var SEND_STAND_UP:uint = 4;
		//准备完毕
		public static var SEND_READY:uint = 5;
		//玩家下注
		public static var SEND_BET:uint = 6;
		//玩家结束下注
		public static var SEND_FINISH_BET:uint = 7;
		//发送行为
		public static var SEND_ACTION:uint = 9;
		//获取个人信息
		public static var SEND_GET_PLAYER:uint = 10;
		//test
		public static var SEND_TEST:uint = 999;
		
		//登陆桌子
		public static var R_LOGIN_TABLE:uint = 1;
		//坐下
		public static var R_SIT_DOWN:uint = 101;
		//站起
		public static var R_STAND_UP:uint = 102;
		//游戏开始
		public static var R_GAME_START:uint = 104;
		//玩家下注
		public static var R_PLAYER_BET:uint = 105;
		//发牌两张基础牌
		public static var R_DEAL_CARDS:uint = 106;
		//轮到下一个人
		public static var R_ASK_HIT:uint = 109;
		//继续要牌
		public static var R_ASK_CARD:uint = 110;
		//停止要牌
		public static var R_STOP_CARD:uint = 111;
		//双倍
		public static var R_PLAYER_DOUBLE:uint = 112;
		//玩家分派
		public static var R_PLAYER_SPLIT:uint = 113;
		//玩家爆牌
		public static var R_PLAYER_BUST:uint = 114;
		//game finish
		public static var R_RESULT:uint = 115;
		
		
		public static var GET_PLAYER_INFO:String = '11111';
		
//		101 => Player Sit Down
//		102 => Player Stand Up
//		103 => Player Ready
//		104 => Game Start（即可以开始下注了）
//		105 => Player Bet
//		106 => Deal Base Cards（每人两张基本牌）
//		107 => Ask Insurance（庄家明牌是A，询问闲家是否买保险）
//		108 => Player Pay Insurance（闲家支付保险金）
//		109 => Ask Hit（庄家询问某闲家是否要牌，即轮到该闲家操作）
//		110 => Player Hit（闲家要牌，发一张牌给该闲家）
//		111 => Player Stand
//		112 => Player Double（闲家投注加倍，下一倍筹码并发一张牌）
//		113 => Player Split（闲家分牌）
//		114 => Player Bust（闲家爆牌）
//		115 => Game Outcome（牌局结果，即结算结果）
//		116 => Dealer Get Insurance（庄家获得保险金）
		
		//协议头长度
//		public static const MSG_HEADER_LENGTH:int = 4;
		public static const MSG_HEADER_INFO_LENGTH:int = 4;//协议总长度
		//协议最大长度
//		public static const MSG_MAX_LENGTH:int = 10240;
		
		public static const MAX_LOGINPRIZE_DAYS:int = 7;
	}
}