package com.jzgame.view.table
{
	import com.jzgame.common.configHelper.Configure;
	import com.jzgame.common.events.SimpleEvent;
	import com.jzgame.common.utils.AssetsCenter;
	import com.jzgame.common.utils.SignalCenter;
	import com.jzgame.common.utils.logging.Tracer;
	import com.jzgame.enmu.EventType;
	import com.jzgame.enmu.TableInfoUtil;
	import com.jzgame.events.SoundEffectEvent;
	import com.jzgame.model.GameModel;
	import com.jzgame.model.TableModel;
	import com.jzgame.model.UserModel;
	import com.jzgame.vo.UserBaseVO;
	import com.jzgame.vo.commu.AskDoubleVO;
	import com.jzgame.vo.commu.AskHitVO;
	import com.jzgame.vo.commu.AskStandVO;
	import com.jzgame.vo.commu.DealAskCardVO;
	import com.jzgame.vo.commu.PlayerBustVO;
	import com.jzgame.vo.commu.PlayerInfoVO;
	
	import flash.events.Event;
	import flash.geom.Point;
	
	import robotlegs.extensions.starlingViewMap.impl.StarlingMediator;
	
	public class PlayersViewMediator extends StarlingMediator
	{
		/***********
		 * name:    PlayersViewMediator
		 * data:    Nov 17, 2015
		 * author:  jim
		 * des:
		 ***********/
		[Inject]
		public var view:PlayersView;
		[Inject]
		public var userModel:UserModel;
		[Inject]
		public var tableModel:TableModel;
		[Inject]
		public var gameModel:GameModel;
		public function PlayersViewMediator()
		{
			super();
		}
		
		override public function initialize():void
		{
			SignalCenter.onSitDownBack.add(sitDownBackHandler);
			SignalCenter.onLoginTableInfo.add(receiveTableInfoHandler);
			SignalCenter.onStandBack.add(standUpHandler);
			SignalCenter.onNextTurnBack.add(turnHandler);
			SignalCenter.onAskDoubleBack.add(doubleHandler);
			SignalCenter.onDealBustBack.add(playerBustHandler);
			SignalCenter.onAskStandBack.add(playerStandBackHandler);
			SignalCenter.onUpdateUserChipBack.add(updateUserChipHandler);
			SignalCenter.onDealAskHandBack.add(dealAskCard);
			
			addContextListener(EventType.NET_FORCE_RESET_TABLE, startHandler);
		}
		
		override public function destroy():void
		{
			SignalCenter.onAskDoubleBack.remove(doubleHandler);
			SignalCenter.onDealAskHandBack.remove(dealAskCard);
			SignalCenter.onUpdateUserChipBack.remove(updateUserChipHandler);
			SignalCenter.onAskStandBack.remove(playerStandBackHandler);
			SignalCenter.onDealBustBack.remove(playerBustHandler);
			SignalCenter.onNextTurnBack.remove(turnHandler);
			SignalCenter.onStandBack.remove(standUpHandler);
			SignalCenter.onLoginTableInfo.remove(receiveTableInfoHandler);
			SignalCenter.onSitDownBack.remove(sitDownBackHandler);
			
			removeContextListener(EventType.NET_FORCE_RESET_TABLE, startHandler);
		}
		
		private function receiveTableInfoHandler():void
		{
			var i:uint;
			var seat:uint;
			for(i=1; i<=TableInfoUtil.SMALL_ROOM_NUMBER;i++)
			{
				seat = i;
				if(tableModel.getUserBySeat(seat))
				{
					sitDownBackHandler(seat);
				}
			}
		}
		/**
		 * 从座位站起 
		 * @param seat
		 * 
		 */		
		private function standUpHandler(seat:uint,uid:uint):void
		{
			removeSomeBoy(seat,uid);
		}
		/**
		 * 入座成功 
		 * @param e
		 */		
		private function sitDownBackHandler(seat:uint):void
		{
			var face:PlayerItemView = new PlayerItemView;
			var my:Point = Configure.tableConfig.getSeatPoint(seat);
			face.x = my.x;
			face.y = my.y;
			face.seat = seat;
			view.playerContainer.addChild(face);
			
			var playerInfo:PlayerInfoVO = tableModel.getUserBySeat(seat);
			face.name = playerInfo.u.toString();
			face.userId = playerInfo.u;
			face.isMine(playerInfo.u == userModel.myInfo.userId);
			face.setName(playerInfo.n);
			face.setChip(playerInfo.c);
			//如果是机器人
//			if(playerInfo.u < UserProxy.ROBOT_ID_RANGE)
//			{
//				face.setFace(AssetsCenter.getFBFace(""));
//			}else
//			{
//				face.setFace(AssetsCenter.getFBFace(playerInfo.u.toString(),AssetsCenter.FB_FACE_SMALL));
//			}
			face.setFace(playerInfo.f);
			dispatch(new SoundEffectEvent(AssetsCenter.getSoundPath("sit")));
		}
		/**
		 * 开局同步筹码 跟状态
		 * @param e
		 * 
		 */		
		private function startHandler(e:Event):void
		{
			var seatInfo:PlayerInfoVO;
			
			for each(var info:UserBaseVO in userModel.userList)
			{
				seatInfo = tableModel.getUserBySeat(info.uSeatIndex);
				if(seatInfo)
				{
				}
			}
		}
		/**
		 * 收到给玩家发牌 
		 * @param o
		 * 
		 */		
		private function dealAskCard(o:DealAskCardVO):void
		{
			hideCount(o.s);
		}
		/**
		 * 更新玩家筹码数量 
		 * @param user
		 * @param chip
		 * 
		 */		
		private function updateUserChipHandler(uid:uint,chip:uint):void
		{
			var face:PlayerItemView = view.playerContainer.getChildByName(uid.toString()) as PlayerItemView;
			if(face)
			{
				trace('同步玩家筹码player:'+chip);
				face.setChip(chip);
			}
		}
		/**
		 * 双倍要牌返回  关闭倒数
		 * @param o
		 * 
		 */		
		private function doubleHandler(o:AskDoubleVO):void
		{
			hideCount(o.s);
		}
		/**
		 * 玩家爆炸  关闭倒数
		 * @param o
		 * 
		 */		
		private function playerBustHandler(o:PlayerBustVO):void
		{
			hideCount(o.s);
		}
		/**
		 * 停止要牌返回 
		 * @param o
		 * 
		 */		
		private function playerStandBackHandler(o:AskStandVO):void
		{
			hideCount(o.s);
		}
		/**
		 * 轮到下一个人 
		 * @param v
		 * 
		 */		
		private function turnHandler(v:AskHitVO):void
		{
			var uid:uint = tableModel.tableInfo.seats[v.s].player.u;
			var face:PlayerItemView = view.playerContainer.getChildByName(uid.toString()) as PlayerItemView;
			if(face)
			{
				face.showCounting(v.cd);
			}
		}
		/**
		 * 隐藏倒计时
		 * @param seat
		 * 
		 */		
		private function hideCount(seat:uint):void
		{
			var  player:PlayerInfoVO = tableModel.tableInfo.getPlayerBySeat(seat);
			var face:PlayerItemView = view.playerContainer.getChildByName(player.u.toString()) as PlayerItemView;
			if(face)
			{
				face.hideCounting()
			}
		}
		/**
		 * 玩家操作 
		 * @param e
		 * 
		 */		
		private function actionHandler(e:SimpleEvent):void
		{
		}
		/**
		 * 移除某人
		 * @param userBaseVO
		 * 
		 */
		private function removeSomeBoy(seat:uint,uid:uint):void
		{
			view.playerContainer.getChildByName(uid.toString()).removeFromParent(true);
			dispatch(new SoundEffectEvent(AssetsCenter.getSoundPath("lobby")));
			Tracer.info(seat+"离开桌子");
		}
	}
}