package com.jzgame.view.table.ui
{
	import com.jzgame.common.events.SimpleEvent;
	import com.jzgame.common.model.NetSendProxy;
	import com.jzgame.common.utils.AssetsCenter;
	import com.jzgame.common.utils.ConfigSO;
	import com.jzgame.common.utils.LangManager;
	import com.jzgame.common.utils.SignalCenter;
	import com.jzgame.enmu.EventType;
	import com.jzgame.enmu.PlayerStatus;
	import com.jzgame.enmu.TableInfoUtil;
	import com.jzgame.model.GameModel;
	import com.jzgame.model.TableModel;
	import com.jzgame.model.UserModel;
	import com.jzgame.model.UserProxy;
	import com.jzgame.util.WindowFactory;
	import com.jzgame.vo.UserBaseVO;
	import com.jzgame.vo.commu.AskHitVO;
	
	import flash.events.Event;
	
	import feathers.controls.Alert;
	import feathers.data.ListCollection;
	
	import robotlegs.extensions.starlingViewMap.impl.StarlingMediator;
	
	import starling.events.Event;
	
	public class TableUIViewMediator extends StarlingMediator
	{
		/***********
		 * name:    TableUIViewMediator
		 * data:    Nov 18, 2015
		 * author:  jim
		 * des:
		 ***********/
		[Inject]
		public var view:TableUIView;
		[Inject]
		public var gameModel:GameModel;
		[Inject]
		public var userModel:UserModel;
		[Inject]
		public var tableModel:TableModel;
		public function TableUIViewMediator()
		{
			super();
		}
		
		override public function initialize():void
		{
			SignalCenter.onLoginTableInfo.add(loginTableHandler);
			SignalCenter.onGameStartBack.add(gameStartHandler);
			SignalCenter.onNextTurnBack.add(turnHandler);
			SignalCenter.onSitDownBack.add(sitDownHandler);
			SignalCenter.onToolClick.add(toolHandler);
			
			view.toolButton.addEventListener(starling.events.Event.TRIGGERED,toolButtonHandler);
			if(userModel.getUserByID(userModel.myInfo.userId))
			{
			}else
			{
				if(userModel.userList.length >= gameModel.tableBaseInfoVO.maxRole)
				{
				}else
				{
				}
				
				loginHandler(null);
			}
			
			view.roomLabel.text = LangManager.getText("500004",gameModel.tableBaseInfoVO.id);
			
			view.toolView.toolList.dataProvider = new ListCollection([{label:'站起'},{label:'返回'}]);
			view.toolView.toolList.selectedIndex = -1;
			
			view.start();
		}
		
		override public function destroy():void
		{
			SignalCenter.onLoginTableInfo.remove(loginTableHandler);
			SignalCenter.onSitDownBack.remove(sitDownHandler);
			SignalCenter.onToolClick.remove(toolHandler);
			SignalCenter.onNextTurnBack.remove(turnHandler);
			SignalCenter.onGameStartBack.remove(gameStartHandler);
			view.toolButton.removeEventListener(starling.events.Event.TRIGGERED,toolButtonHandler);
			view.dispose();
		}
		
		/**
		 *  点击工具列表
		 * @param e
		 * 
		 */		
		private function toolHandler(index:uint):void
		{
			switch(index)
			{
				case 0:
					standUpHandler();
					break;
				case 1:
					returnLobby();
					break;
			}
		}
		/**
		 * 
		 * @param turn
		 * 
		 */		
		private function turnHandler(turn:AskHitVO):void
		{
			view.lookAt(turn.s);
		}
		/**
		 * 坐下 
		 * @param seat
		 * 
		 */		
		private function sitDownHandler(seat:uint):void
		{
			//如果是我坐下，需要判断是否要等待
			if(seat == tableModel.mySeat)
			{
				checkWaiting();
			}
		}
		/**
		 * 游戏开始下注阶段
		 * @param cd
		 * 
		 */		
		private function gameStartHandler(cd:uint):void
		{
			view.arrow.visible = false;
			view.showWait(false);
		}
		/**
		 * 登录桌子 
		 * 
		 */		
		private function loginTableHandler():void
		{
			//如果我断线重连,已经在桌子上了
			if(tableModel.mySeat>-1)
			{
				checkWaiting();
			}
		}
		/**
		 * 检测是否需要等待 
		 * 
		 */		
		private function checkWaiting():void
		{
			//显示等待下一排拒
			switch(tableModel.tableInfo.ts)
			{
				case 1:
					view.showWait(false);
					break;
				case 2:
				case 3:
					view.showWait(true);
					break;
				case 4:
					view.showWait(false);
					break;
			}
		}
		/**
		 *  
		 * @param e
		 * 
		 */		
		private function toolButtonHandler(e:starling.events.Event):void
		{
			e.stopImmediatePropagation();
			e.stopPropagation();
		}
		/**
		 * 触发起身
		 * @param e
		 * 
		 */		
		private function standUpHandler(e:* = null):void
		{
			if(ConfigSO.getInstance().muteStandUp || userModel.myInfo.uStatus == PlayerStatus.PLAYING_IDLE || userModel.myInfo.uStatus == PlayerStatus.OBSERVING|| userModel.myInfo.uStatus == PlayerStatus.PLAYING_FOLD)
			{
				standUp();
			}else
			{
				var tips:String = LangManager.getText("202023");
				Alert.show(tips,"message",new ListCollection([{label:"ok",triggered:standUp},{label:"cancel"}]));
			}
		}
		/**
		 * 起身
		 * 
		 */
		private function standUp():void
		{
			NetSendProxy.standUp();
		}
		/**
		 * 玩家站起来 
		 * @param e
		 * 
		 */		
		private function receiveStandUpHandler(e:SimpleEvent):void
		{
			var userBaseVO:UserBaseVO = UserBaseVO(e.carryData);
			if(userBaseVO.userId == userModel.myInfo.userId)
			{
			}
			
			loginHandler(null);
		}
		/**
		 * 回大厅 
		 * @param e
		 */		
		private function clickLobby():void
		{
			if(ConfigSO.getInstance().muteStandUp || userModel.myInfo.uStatus == PlayerStatus.PLAYING_IDLE || userModel.myInfo.uStatus == PlayerStatus.OBSERVING)
			{
				returnLobby();
			}else
			{
				var tips:String = LangManager.getText("202023");
				Alert.show(tips,"message",new ListCollection([{label:"ok",triggered:confirmLobby},{label:"cancel"}]));
			}
		}
		/**
		 * 确认回大厅 
		 */		
		private function confirmLobby():void
		{
			returnLobby();
		}
		/**
		 * 返回大厅
		 * 
		 */		
		private function returnLobby():void
		{
			WindowFactory.removeAll();
			AssetsCenter.eventDispatcher.dispatchEvent(new flash.events.Event(EventType.RETURN_LOBBY));
		}
		/**
		 * 登录成功 
		 * @param e
		 * 
		 */		
		private function loginHandler(e:flash.events.Event):void
		{
			var length:uint = userModel.userList.length;
			
			switch(gameModel.tableBaseInfoVO.type)
			{
				case TableInfoUtil.SIT_AND_GO:
//					view.imageButtonChangeTable.visible = false;
					break;
				case TableInfoUtil.MTT:
				case TableInfoUtil.SPE_MTT:
//					view.imageButtonChangeTable.visible = false;
					break;
				default:
					if(userModel.myInfo.uSeatIndex == 0)
					{
						if(length >= gameModel.tableBaseInfoVO.maxRole)
						{
//							view.imageButtonChangeTable.visible = true;
						}else
						{
//							view.imageButtonChangeTable.visible = false;
						}
					}
					break;
			}
		}
		private function playNow():void
		{
			if(!UserProxy.checkChip(gameModel.tableBaseInfoVO.limit)) return ;
			//检查是否足够最小筹码
			if(!UserProxy.checkValid(gameModel.tableBaseInfoVO.minBuy,UserProxy.CHIP)) return ;
			
			var binds:Number = gameModel.tableBaseInfoVO.blinds * 200;
			var chips:Number = Math.min(binds,userModel.myInfo.uMoney);
			var seat:uint = 1;
			var i:uint = 0;
			//如果是满员就围观
			if(gameModel.tableBaseInfoVO.maxRole == TableInfoUtil.BIG_ROOM_NUMBER)
			{
				for(i=1; i<=gameModel.tableBaseInfoVO.maxRole;i++)
				{
					if(tableModel.getUserBySeat(i))continue;
					
					seat = i;
					return;
				}
			}else
			{
				for(i=1; i<=gameModel.tableBaseInfoVO.maxRole;i++)
				{
					seat = 1 + (i - 1) * 2;
					if(tableModel.getUserBySeat(seat))continue;
					return;
				}
			}
		}
	}
}