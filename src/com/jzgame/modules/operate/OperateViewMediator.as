package com.jzgame.modules.operate
{
	import com.jzgame.common.configHelper.Configure;
	import com.jzgame.common.events.SimpleEvent;
	import com.jzgame.common.model.NetSendProxy;
	import com.jzgame.common.utils.ExternalVars;
	import com.jzgame.common.utils.SignalCenter;
	import com.jzgame.enmu.EventType;
	import com.jzgame.enmu.OperateType;
	import com.jzgame.enmu.TableInfoUtil;
	import com.jzgame.model.GameModel;
	import com.jzgame.model.TableModel;
	import com.jzgame.model.UserModel;
	import com.jzgame.model.UserProxy;
	import com.jzgame.util.WindowFactory;
	import com.jzgame.vo.commu.AskHitVO;
	import com.jzgame.vo.commu.PlayerBetVO;
	import com.jzgame.vo.commu.PlayerInfoVO;
	import com.jzgame.vo.commu.SeatInfoVO;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import feathers.controls.Button;
	
	import robotlegs.extensions.starlingViewMap.impl.StarlingMediator;
	
	import starling.events.Event;
	
	
	public class OperateViewMediator extends StarlingMediator
	{
		/***********
		 * name:    OperateViewMediator
		 * data:    Nov 18, 2015
		 * author:  jim
		 * des:
		 ***********/
		[Inject]
		public var view:OperateView;
		[Inject]
		public var userModel:UserModel;
		[Inject]
		public var gameModel:GameModel;
		[Inject]
		public var tableModel:TableModel;
		public function OperateViewMediator()
		{
			super();
		}
		
		override public function initialize():void
		{
			addContextListener(EventType.I_AM_IN_SEAT, iSeatHandler);
			addContextListener(EventType.NET_LOGIN_TABLE, loginHandler);
			addContextListener(EventType.SHOW_ALL_IN_READY_BTN, showReadyHandler);
			addContextListener(EventType.RESET, resetHandler);
			addContextListener(EventType.NET_FORCE_RESET_TABLE, resetHandler);
			addContextListener(EventType.COLLECT_CLIP, resetConsoleHandler);
			addContextListener(EventType.NET_LOGIN_TABLE, receiveLoginTableHandler);

			view.trigged.add(operate);
			
			view.betBtn.addEventListener(starling.events.Event.TRIGGERED, betOKHandler);
			
			SignalCenter.onGameStartBack.add(gameStartHandler);
			SignalCenter.onDealHandBack.add(dealHandler);
			SignalCenter.onNextTurnBack.add(turnHandler);
			SignalCenter.onStandBack.add(standHandler);
			SignalCenter.onPlayerBetBack.add(playerBetBackHandler);
		}
		
		override public function destroy():void
		{
			view.trigged.remove(operate);
			removeContextListener(EventType.I_AM_IN_SEAT, iSeatHandler);
			removeContextListener(EventType.NET_LOGIN_TABLE, loginHandler);
			removeContextListener(EventType.NET_LOGIN_TABLE, receiveLoginTableHandler);
			removeContextListener(EventType.SHOW_ALL_IN_READY_BTN, showReadyHandler);
			removeContextListener(EventType.RESET, resetHandler);
			removeContextListener(EventType.NET_FORCE_RESET_TABLE, resetHandler);
			removeContextListener(EventType.COLLECT_CLIP, resetConsoleHandler);
			removeContextListener(EventType.ACTION, actionHandler);
			SignalCenter.onDealHandBack.remove(dealHandler);
			SignalCenter.onPlayerBetBack.remove(playerBetBackHandler);
			SignalCenter.onStandBack.remove(standHandler);
			SignalCenter.onGameStartBack.remove(gameStartHandler);
			SignalCenter.onNextTurnBack.add(turnHandler);
			view.betBtn.removeEventListener(starling.events.Event.TRIGGERED, betOKHandler);
		}
		/**
		 * 登录成功 
		 * @param e
		 * 
		 */		
		private function loginHandler(e:flash.events.Event):void
		{
			var length:uint = userModel.userList.length;
			trace(gameModel.tableBaseInfoVO.type);
			switch(gameModel.tableBaseInfoVO.type)
			{
				case TableInfoUtil.SIT_AND_GO:
					break;
				case TableInfoUtil.MTT:
				case TableInfoUtil.SPE_MTT:
					break;
				default:
					if(length >= gameModel.tableBaseInfoVO.maxRole)
					{
					}
					break;
			}
		}
		/**
		 *初始化桌子信息  
		 * 
		 */	
		private function receiveLoginTableHandler(e:flash.events.Event):void
		{
			if(gameModel.autoSit)
			{
				gameModel.autoSit = false;
				playNowHandler(null);
			}
		}
		/**
		 * 确认下注 
		 * @param e
		 * 
		 */
		private function betOKHandler(e:starling.events.Event):void
		{
			NetSendProxy.finishBet();
			view.betBtn.visible = false;
		}
		
		/**
		 * 显示ready按钮 
		 * @param e
		 */		
		private function showReadyHandler(e:flash.events.Event):void
		{
//			view.ready();
		}
		/**
		 * 玩家下注 
		 * @param o
		 * 
		 */		
		private function playerBetBackHandler(o:PlayerBetVO):void
		{
			//判断是否为自己
			var player:uint = tableModel.tableInfo.getPlayerBySeat(o.seat_id).u;
			var isMine:Boolean = userModel.isMine(player);
			if(isMine)
			{
				trace('bet back is mine!',player,ExternalVars.userID);
				view.betBtn.visible = true;
			}
		}
		/**
		 * 收到发牌 
		 * @param e
		 * 
		 */		
		private function resetConsoleHandler(e:flash.events.Event):void
		{
			gameModel.clipClear();
			
			updateState();
			//			clearPreSelect();
		}
		/**
		 * 游戏开始 
		 * @param u
		 */		
		private function gameStartHandler(u:uint):void
		{
			//如果我在座位上
			if(tableModel.mySeat>-1)
			{
				view.showBet(true);
				view.showOperate(false);
			}else
			{
				view.showBet(false);
				view.showOperate(false);
			}
		}
		/**
		 * 开始发牌 
		 * @param u
		 * 
		 */		
		private function dealHandler(u:uint):void
		{
			//如果我在座位上
			if(tableModel.mySeat>-1)
			{
				view.showBet(false);
				view.showOperate(true);
			}else{
				view.showBet(false);
				view.showOperate(false);
			}
		}
		
		/**
		 * 重置
		 * @param e
		 * 
		 */		
		public function resetHandler(e:flash.events.Event):void
		{
//			view.call.isSelected = false;
//			view.checkFold.isSelected = false;
//			view.autoCall.isSelected = false;
//			view.autoCheck.isSelected = false;
//			view.autoFold.isSelected = false;
//			
//			updateConsoleState();
		}
		/**
		 * 立即开始牌局，坐下 
		 * @param e
		 * 
		 */		
		private function playNowHandler(e:MouseEvent):void
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
					NetSendProxy.sitDown(seat);
					return;
				}
			}else
			{
				for(i=1; i<=gameModel.tableBaseInfoVO.maxRole;i++)
				{
					seat = 1 + (i - 1) * 2;
					if(tableModel.getUserBySeat(seat))continue;
					NetSendProxy.sitDown(seat);
					return;
				}
			}
		}
		
		private function operate(btn:Button):void
		{
			switch(btn)
			{
				case view.doubleButton:
					doubleHandler();
					break;
				case view.splitButton:
					splitHandler();
					break;
				case view.hitButton:
					hitHandler();
					break;
				case view.standCardButton:
					standCardHandler();
					break;
			}
		}
		/**
		 * 双倍
		 * @param e
		 * 
		 */		
		private function doubleHandler():void
		{
			//如果牌信息大于2张
			var seatinfo:SeatInfoVO = tableModel.tableInfo.seats[tableModel.mySeat];
			if(seatinfo && seatinfo.k.length >2)
			{
				return;
			}
			NetSendProxy.action(OperateType.DOUBLE,gameModel.action_id);
		}
		/**
		 * 分牌 
		 * @param e
		 * 
		 */		
		private function splitHandler():void
		{
			NetSendProxy.action(OperateType.SPLIT,gameModel.action_id);
		}
		/**
		 * 停止要牌
		 * @param e
		 * 
		 */		
		private function standCardHandler():void
		{
			NetSendProxy.action(OperateType.STAND,gameModel.action_id);
		}
		/**
		 * 要牌 
		 * @param e
		 * 
		 */		
		private function hitHandler():void
		{
			NetSendProxy.action(OperateType.HIT,gameModel.action_id);
		}
		/**
		 * 跟牌 
		 * @param e
		 */		
		private function followHandler():void
		{
		}
		/**
		 * 加注 
		 * @param e
		 * 
		 */		
		private function raiseHandler():void
		{
			if(view.raiseSlider.visible == false)
			{
				view.raiseSlider.visible = true;
			}else
			{
				view.raiseSlider.visible = false;
				myRaiseHandler(view.raiseSlider.num);
			}
		}
		/**
		 * 自己点击加注
		 * @param e
		 * 
		 */
		private function myRaiseHandler(chip:Number):void
		{
			if(gameModel.guide)
			{
//				var actionVo:ActionVO = new ActionVO(userModel.myInfo.uSeatIndex,PlayerStatus.PLAYING_CALL,200);
//				dispatch(new SimpleEvent(EventType.ACTION,actionVo));
//				tableModel.currentSeat = userModel.myInfo.uSeatIndex;
//				dispatch(new Event(EventType.NEXT_TURN));
//				dispatch(new Event(EventType.GUIDE_MY_CALL));
			}else
			{
				operateEnd();
			}
		}
		
		/**
		 * 我坐下事件 
		 * @param e
		 */		
		private function iSeatHandler(e:flash.events.Event):void
		{
			//如果我坐下以后就有手牌，说明是断线重连,可以游戏,login的时候已经同步了当前玩家状态
			if(userModel.myInfo.cards.length > 0)
			{
			}else
			{
				var bet:Boolean = false;
				if(gameModel.tableBaseInfoVO.blinds>=Configure.jackpotConfig.getMinblind())
				{
					switch(gameModel.tableBaseInfoVO.type)
					{
						case TableInfoUtil.MTT:
						case TableInfoUtil.SPE_MTT:
						case TableInfoUtil.SIT_AND_GO:
							bet = true;
							break;
					}
				}
				//否则等待下一轮
				view.sitDown(bet);
			}
		}
		
		/**
		 * 回合处理 
		 * @param e
		 * 
		 */		
		private function turnHandler(o:AskHitVO):void
		{
			var playerInfo:PlayerInfoVO = tableModel.tableInfo.getPlayerBySeat(o.s);
			//如果是本人
			if(userModel.isMine(playerInfo.u))
			{
				view.showOperate(true);
			}else
			{
				view.showOperate(false);
			}
		}
		/**
		 * 从座位站起 
		 * @param e
		 * 
		 */		
		private function standHandler(seat:uint,u:uint):void
		{
			view.showOperate(false);
			view.showBet(false);
		}
		
		/**
		 * 行为 响应
		 * @param e
		 * 
		 */
		private function actionHandler(e:SimpleEvent):void
		{
		}
		
		/**
		 * 检查是否有需要强制关闭的打开窗口
		 */		
		private function checkOpenWindow():void
		{
			var list:Array = WindowFactory.CHECK_WINDOWS;
			for(var i:String in list)
			{
//				var temp:PopUpWindow = PopUpWindowManager.getWindow(list[i]) as PopUpWindow;
//				if(temp)
//				{
//					WindowFactory.addPopUpWindow(WindowFactory.FADE_TIP_WINDOW,null,LangManager.getText("402201"));
//					return;
//				}
			}
		}
		
		/**
		 * 设置游标上的数字 
		 * @param slider
		 * 
		 */		
		private function setSliderNum(slider:Number):void
		{
			view.raiseSlider.setNum(slider);
		}
		
		/**
		 * 更新下注筹码 
		 * 避免因为除法运算，导致有差值
		 */
		private function updateRaiseClipWithoutEvent():void
		{
			gameModel.raiseClip = Math.min(gameModel.raiseClip,userModel.myInfo.uClip);
			gameModel.raiseClip = Math.min(gameModel.raiseMaxClip,gameModel.raiseClip);
			gameModel.raiseMinClip = Math.min(gameModel.raiseMaxClip,gameModel.raiseMinClip);
			//设置最大值
			view.raiseSlider.setRange(gameModel.raiseClip,gameModel.raiseMaxClip);
			//如果最大跟最小一样，则到顶
			if(gameModel.raiseMaxClip == gameModel.raiseMinClip)
			{
				view.raiseSlider.value = 1;
//				enabledSliderArrow(false);
			}else
			{
//				enabledSliderArrow(true);
				view.raiseSlider.value = ( (gameModel.raiseClip - gameModel.raiseMinClip)/ (gameModel.raiseMaxClip - gameModel.raiseMinClip));
			}
			
			setSliderNum(gameModel.raiseClip);
		}
		/**
		 * 检测按钮 
		 * 
		 */		
		private function checkEnable():void
		{
//			var slider:Number= Math.floor(gameModel.tableBaseInfoVO.blinds) * 2;
//			var nValue:Number = view.slider.numValue - slider;
//			if(gameModel.raiseMinClip >= nValue)
//			{
//				nValue = gameModel.raiseMinClip;
//				view.slider.downBtn.enabled = false;
//			}else
//			{
//				view.slider.downBtn.enabled = true;
//			}
//			
//			nValue = view.slider.numValue + slider;
//			if(gameModel.raiseMaxClip <= view.slider.numValue)
//			{
//				view.slider.upBtn.enabled = false;
//			}else
//			{
//				view.slider.upBtn.enabled = true;
//			}
		}
		/**
		 *自己手动操作结束 
		 * 
		 */		
		private function operateEnd():void
		{
			//自己手动操作结束，将需要下的筹码重置
			gameModel.callClip = 0;
			updateState();
			view.myTurn = false;
			view.raiseSlider.visible = false;
//			view.slider.mouseEnabled = true;
//			view.slider.mouseChildren = true;
		}
		/**
		 * 更新操作台状态 
		 * 
		 */		
		private function updateState():void
		{
			//根据下注筹码,显示
//			if(gameModel.callClip == 0)
//			{
//				view.call.setText(HtmlTransCenter.getHtmlStr(LangManager.getText("300917"),SystemColor.STR_WHITE,16));
//				view.myCall.setText(HtmlTransCenter.getHtmlStr(LangManager.getText("300917"),SystemColor.STR_WHITE,16));
//				view.myRaise.setText(HtmlTransCenter.getHtmlStr(LangManager.getText("300938"),SystemColor.STR_WHITE,16));
//				view.showCheck(true);
//				view.showPreCheck(true);
//			}else
//			{
//				view.myRaise.setText(HtmlTransCenter.getHtmlStr(LangManager.getText("300918"),SystemColor.STR_WHITE,16));
//				view.showPreCheck(false);
//				view.showCheck(false);
//				view.call.setText(HtmlTransCenter.getHtmlStr(LangManager.getText("300917")+" "+gameModel.callClip,SystemColor.STR_WHITE,16));
//				view.myCall.setText(HtmlTransCenter.getHtmlStr(LangManager.getText("300917")+" "+gameModel.callClip,SystemColor.STR_WHITE,16));
//			}
		}
		
		/**
		 * 更新预操作状态  ,如果筹码有改变,则去掉预选
		 * @param change 是否需要改变
		 * 
		 */			
		private function updatePreOperateState(change:Boolean):void
		{
		}
	}
}