package com.jzgame.command.communication
{
	/** 
	 * @Content 
	 * @Author jim 
	 * @Version 1.0.0 
	 * @Date：Apr 10, 2013 11:00:07 AM 
	 * @description:消息处理分派中心
	 */ 
	
	import com.jzgame.common.events.SimpleEvent;
	import com.jzgame.common.model.NetSendProxy;
	import com.jzgame.common.services.MessageType;
	import com.jzgame.common.services.socket.SocketServiceEvent;
	import com.jzgame.common.utils.ExternalVars;
	import com.jzgame.common.utils.LangManager;
	import com.jzgame.common.utils.SignalCenter;
	import com.jzgame.common.utils.logging.Tracer;
	import com.jzgame.enmu.EventType;
	import com.jzgame.model.GameModel;
	import com.jzgame.model.MessageLogModel;
	import com.jzgame.model.PackageModel;
	import com.jzgame.model.TableModel;
	import com.jzgame.model.UserModel;
	import com.jzgame.util.ExternalCenter;
	import com.jzgame.vo.commu.AskDoubleVO;
	import com.jzgame.vo.commu.AskHitVO;
	import com.jzgame.vo.commu.AskStandVO;
	import com.jzgame.vo.commu.DealAskCardVO;
	import com.jzgame.vo.commu.DealHandCardVO;
	import com.jzgame.vo.commu.GameStartVO;
	import com.jzgame.vo.commu.PlayerBetVO;
	import com.jzgame.vo.commu.PlayerBustVO;
	import com.jzgame.vo.commu.PlayerInfoVO;
	import com.jzgame.vo.commu.ReadSingleMessage;
	import com.jzgame.vo.commu.ResultVO;
	import com.jzgame.vo.commu.SeatInfoVO;
	import com.jzgame.vo.commu.SendSingleMessage;
	import com.jzgame.vo.commu.TableInfo;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import feathers.controls.Alert;
	import feathers.data.ListCollection;
	
	import robotlegs.bender.bundles.mvcs.Command;
	
	public class NetReceivedCommand extends Command
	{
		[Inject]
		public var event:SocketServiceEvent;
		[Inject]
		public var userModel:UserModel;
		[Inject]
		public var messageModel:MessageLogModel;
		[Inject]
		public var packModel:PackageModel;
		[Inject]
		public var gameModel:GameModel;
		[Inject]
		public var tableModel:TableModel;
		
		[Inject]
		public var eventDispatcher:IEventDispatcher;
		
		private var boo:Boolean = false;
		
		override public function execute():void
		{
			var model:ReadSingleMessage = ReadSingleMessage(event.data);
			var send:SendSingleMessage = messageModel.getMessageByIndex(model.i);
			Tracer.debug("收到网络消息:"+model.m+"错误码:"+model.eid+",json:"+model.toString());
			if(!send)
			{
				Tracer.debug("收到网络消息:无此索引消息发出:"+model.i);
			}else
			{
				model.m = send.m;
				messageModel.removeMessage(model.i);
			}
			//如果有错误 10301
			if(model.eid > 0)
			{
				if(model.eid == 10301)
				{
					Alert.show(LangManager.getText("402203"),LangManager.getText("500003"),new ListCollection([{label:"ok",trigged:function ():void{ExternalCenter.refresh()}}]));
					eventDispatcher.dispatchEvent(new Event(EventType.STOP_GAME));
				}else
				{
					eventDispatcher.dispatchEvent(new SimpleEvent(EventType.ERROR_CODE_WINDOW,model.eid));
				}
				return;
			}
			var debug:String = "";
			var playerSeatInfo:SeatInfoVO ;
			switch(model.m)
			{
				//心跳
				case MessageType.HEART:
					Tracer.debug("收到网络消息无错误:心跳");
					break;
				//登陆
				case MessageType.SEND_LOGIN_TABLE:
					Tracer.debug("收到网络消息无错误:加入桌子");
					//log
					tableModel.tableInfo = new TableInfo(model.carryData);
					tableModel.mySeat = tableModel.tableInfo.seatByUid(ExternalVars.userID);
					Tracer.debug(userModel.myInfo.uNickName+"本人进来了桌子:"+model.toString());
					SignalCenter.onLoginTableInfo.dispatch();
					NetSendProxy.getPlayerInfo();
					break;
				//坐下
				case MessageType.R_SIT_DOWN:
					Tracer.debug("收到网络消息无错误:坐下");
					//log
					Tracer.debug(userModel.myInfo.uNickName+"坐下:"+model.toString());
					var seatInfo:SeatInfoVO = new SeatInfoVO(model.carryData);
					tableModel.tableInfo.seats[seatInfo.id] = seatInfo;
					//如果是本人，则存储本人座位信息
					if(seatInfo.player.u == ExternalVars.userID)
					{
						tableModel.mySeat = seatInfo.id;
					}
					SignalCenter.onSitDownBack.dispatch(seatInfo.id);
					break;
				//站起
				case MessageType.R_STAND_UP:
					Tracer.debug("收到网络消息无错误:站起");
					//log
					Tracer.debug(userModel.myInfo.uNickName+"站起:"+model.toString());
					var standSeat:uint = uint(model.carryData);
					var standPlayer:PlayerInfoVO = tableModel.tableInfo.getPlayerBySeat(standSeat);
					//如果是本人，则清空座位信息
					if(standPlayer.u == ExternalVars.userID)
					{
						tableModel.mySeat = -1;
					}
					//清楚座位上的信息
					tableModel.tableInfo.seats[standSeat].player = null;
					
					SignalCenter.onStandBack.dispatch(model.carryData,standPlayer.u);
					break;
				case MessageType.R_GAME_START:
					Tracer.debug("收到网络消息无错误:游戏开始");
					//log
					var gamestart:GameStartVO = new GameStartVO(model.carryData);
					SignalCenter.onGameStartBack.dispatch(gamestart.cd);
					tableModel.tableInfo.ts = 1;
					break;
				case MessageType.R_PLAYER_BET:
					Tracer.debug("收到网络消息无错误:下注");
					//log
					var playerbet:PlayerBetVO = new PlayerBetVO(model.carryData);
					SignalCenter.onPlayerBetBack.dispatch(playerbet);
					//判断是否为自己
					if(userModel.isMine(tableModel.tableInfo.getPlayerBySeat(playerbet.seat_id).u));
					{
						userModel.myInfo.uMoney = playerbet.player_chips;
						SignalCenter.onUpdateChips.dispatch(playerbet.player_chips);
					}
					//更新所有玩家筹码
					SignalCenter.onUpdateUserChipBack.dispatch(tableModel.tableInfo.getPlayerBySeat(playerbet.seat_id).u,playerbet.player_chips);
					break;
				case MessageType.R_DEAL_CARDS:
					Tracer.debug("收到网络消息无错误:收到基础牌");
					//log
					var dealCards:DealHandCardVO = new DealHandCardVO(model.carryData);
					
					for(var i:String in dealCards.array)
					{
						playerSeatInfo = tableModel.tableInfo.seats[dealCards.array[i][0]];
						playerSeatInfo.k.push(dealCards.array[i][1]);
						playerSeatInfo.k.push(dealCards.array[i][2]);
					}
					SignalCenter.onDealHandBack.dispatch(dealCards);
					tableModel.tableInfo.ts = 3;
					break;
				case MessageType.R_ASK_CARD:
					Tracer.debug("收到网络消息无错误:收到玩家要牌");
					//log
					var dealAskCard:DealAskCardVO = new DealAskCardVO(model.carryData);
					
					playerSeatInfo = tableModel.tableInfo.seats[dealAskCard.s];
					if(dealAskCard.sk == 1)
					{
						playerSeatInfo.k2.push(dealAskCard.k);
					}else
					{
						playerSeatInfo.k.push(dealAskCard.k);
					}
					
					SignalCenter.onDealAskHandBack.dispatch(dealAskCard);
					break;
				case MessageType.R_PLAYER_BUST:
					Tracer.debug("收到网络消息无错误:收到玩家爆炸");
					//log
					var bustCard:PlayerBustVO = new PlayerBustVO(model.carryData);
					SignalCenter.onDealBustBack.dispatch(bustCard);
					
//					//判断是否为自己
//					if(userModel.isMine(tableModel.tableInfo.getPlayerBySeat(bustCard.s).u));
//					{
//						userModel.myInfo.uMoney = bustCard.dc;
//						SignalCenter.onUpdateChips.dispatch(userModel.myInfo.uMoney);
//					}
					break;
				case MessageType.R_STOP_CARD:
					Tracer.debug("收到网络消息无错误:停止要牌");
					//log
					var askStand:AskStandVO = new AskStandVO(model.carryData);
					SignalCenter.onAskStandBack.dispatch(askStand);
					break;
				case MessageType.R_PLAYER_DOUBLE:
					Tracer.debug("收到网络消息无错误:双倍要牌");
					//log
					var askDouble:AskDoubleVO = new AskDoubleVO(model.carryData);
					playerSeatInfo = tableModel.tableInfo.seats[askDouble.s];
					//缓存又要的一张牌
					playerSeatInfo.k.push(askDouble.k);
					SignalCenter.onAskDoubleBack.dispatch(askDouble);
					//判断是否为自己
					if(userModel.isMine(tableModel.tableInfo.getPlayerBySeat(askDouble.s).u));
					{
						userModel.myInfo.uMoney = askDouble.pc;
						SignalCenter.onUpdateChips.dispatch(userModel.myInfo.uMoney);
					}
					break;
				case MessageType.R_ASK_HIT:
					Tracer.debug("收到网络消息无错误:轮到下一个人");
					//log
					var turn:AskHitVO = new AskHitVO(model.carryData);
					gameModel.action_id = turn.a;
					SignalCenter.onNextTurnBack.dispatch(turn);
					break;
				case MessageType.R_RESULT:
					Tracer.debug("收到网络消息无错误:结算");
					//log
					var result:ResultVO = new ResultVO(model.carryData);
					if(result.idle.length!=0)
					{
						//同步庄家的牌
						playerSeatInfo = tableModel.tableInfo.seats[0];
						playerSeatInfo.k = result.k;
					}
					tableModel.resultVO = result;
					SignalCenter.onResultBack.dispatch(result);
					tableModel.tableInfo.ts = 4;
					break;
				//收到response
				//获得个人信息
				case MessageType.SEND_GET_PLAYER:
					var playerinfo:PlayerInfoVO = new PlayerInfoVO(model.carryData);
					userModel.myInfo.uMoney = playerinfo.c;
					userModel.myInfo.uFace = playerinfo.f;
					userModel.myInfo.uNickName = playerinfo.n;
					SignalCenter.onUpdateUserInfo.dispatch();
					break;
			}
			
		}
	}
}