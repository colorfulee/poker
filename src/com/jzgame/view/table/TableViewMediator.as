package com.jzgame.view.table
{
	import com.greensock.TweenMax;
	import com.jzgame.common.configHelper.Configure;
	import com.jzgame.common.events.SimpleEvent;
	import com.jzgame.common.model.NetSendProxy;
	import com.jzgame.common.utils.AssetsCenter;
	import com.jzgame.common.utils.SignalCenter;
	import com.jzgame.enmu.AssetsName;
	import com.jzgame.enmu.EventType;
	import com.jzgame.enmu.TableInfoUtil;
	import com.jzgame.events.SoundEffectEvent;
	import com.jzgame.loader.AssetsLoader;
	import com.jzgame.model.GameModel;
	import com.jzgame.model.TableModel;
	import com.jzgame.model.UserModel;
	import com.jzgame.model.UserProxy;
	import com.jzgame.util.CardInfoUtil;
	import com.jzgame.view.table.ui.CardNumView;
	import com.jzgame.vo.CardInfoVO;
	import com.jzgame.vo.FlopCardInfoVO;
	import com.jzgame.vo.UserBaseVO;
	import com.jzgame.vo.commu.AskDoubleVO;
	import com.jzgame.vo.commu.AskHitVO;
	import com.jzgame.vo.commu.AskStandVO;
	import com.jzgame.vo.commu.DealAskCardVO;
	import com.jzgame.vo.commu.DealHandCardVO;
	import com.jzgame.vo.commu.EachResultVO;
	import com.jzgame.vo.commu.PlayerBustVO;
	import com.jzgame.vo.commu.PlayerInfoVO;
	import com.jzgame.vo.commu.ResultVO;
	import com.jzgame.vo.commu.SeatInfoVO;
	
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.setTimeout;
	
	import lzm.starling.swf.Swf;
	import lzm.starling.swf.display.SwfMovieClip;
	
	import robotlegs.extensions.starlingViewMap.impl.StarlingMediator;
	
	public class TableViewMediator extends StarlingMediator
	{
		/***********
		 * name:    TableViewMediator
		 * data:    Nov 17, 2015
		 * author:  jim
		 * des:
		 ***********/
		[Inject]
		public var view:TableView;
		[Inject]
		public var userModel:UserModel;
		[Inject]
		public var gameModel:GameModel;
		[Inject]
		public var tableModel:TableModel;
		public function TableViewMediator()
		{
			super();
		}
		
		override public function initialize():void
		{
			view.start();
			
			SignalCenter.onLoginTableInfo.add(receiveTableInfoHandler);
			SignalCenter.onSitDownBack.add(sitDownBackHandler);
			SignalCenter.onStandBack.add(standBackHandler);
			SignalCenter.onDealHandBack.add(dealHandCardHandler);
			SignalCenter.onDealAskHandBack.add(dealAskHandCardHandler);
			SignalCenter.onDealBustBack.add(bustHandCardHandler);
			SignalCenter.onAskDoubleBack.add(dealDoubleHandler);
			SignalCenter.onResultBack.add(resultHandler);
			SignalCenter.onGameStartBack.add(gameStartHandler);
			
			addContextListener(EventType.FLOP_CARD, onFlopHandler);
			addContextListener(EventType.NET_HAND_POKER, receiveHandPokerHandler);
			addContextListener(EventType.RESET, resetTableHandler);
			addContextListener(EventType.NET_FORCE_RESET_TABLE, forceReset);
			addContextListener(EventType.SHOW_BUTTON, showButtonHandler);
			SignalCenter.onSitDownArrowTriggered.add(seatSelect);
		}
		
		override public function destroy():void
		{
			SignalCenter.onAskDoubleBack.remove(dealDoubleHandler);
			SignalCenter.onGameStartBack.remove(gameStartHandler);
			SignalCenter.onResultBack.remove(resultHandler);
			SignalCenter.onDealBustBack.remove(bustHandCardHandler);
			SignalCenter.onStandBack.remove(standBackHandler);
			SignalCenter.onDealAskHandBack.remove(dealAskHandCardHandler);
			SignalCenter.onDealHandBack.remove(dealHandCardHandler);
			SignalCenter.onSitDownBack.remove(sitDownBackHandler);
			SignalCenter.onLoginTableInfo.remove(receiveTableInfoHandler);
			
			removeContextListener(EventType.SHOW_BUTTON, showButtonHandler);
			removeContextListener(EventType.NET_HAND_POKER, receiveHandPokerHandler);
			removeContextListener(EventType.FLOP_CARD, onFlopHandler);
			removeContextListener(EventType.RESET, resetTableHandler);
			removeContextListener(EventType.NET_FORCE_RESET_TABLE, forceReset);
			
			SignalCenter.onSitDownArrowTriggered.remove(seatSelect);
			
			view.dispose();
			clearTable();
			tableModel.reset();
			gameModel.clear();
			TweenMax.killAll(true);
		}
		/**
		 *初始化桌子信息  
		 * 
		 */	
		private function receiveTableInfoHandler():void
		{
			//初始空闲椅子
			initIdleChair();
			
			//同步桌子状态
			switch(tableModel.tableInfo.ts)
			{
				case 1:
					view.betCounting.showCounting(tableModel.tableInfo.cd);
					break;
			}
			//初始化桌子牌
			for (var card:String in tableModel.tableInfo.seats)
			{
				if(tableModel.tableInfo.seats[card].k.length > 0)
				{
					initCards(tableModel.tableInfo.seats[card].id,tableModel.tableInfo.seats[card].k);
				}
//				var coverCard:CardInfoVO  = CardInfoUtil.praseCardInfo(card);
//				var flop:FlopCardInfoVO = new FlopCardInfoVO(gameModel.tableCardList.length + 1,coverCard);
//				dispatch(new SimpleEvent(EventType.FLOP_CARD,flop));
//				gameModel.tableCardList.push(card);
			}
			//如果当前有人操作
			if(tableModel.tableInfo.cs!=0)
			{
				SignalCenter.onNextTurnBack.dispatch(new AskHitVO(
					{s:tableModel.tableInfo.cs,a:tableModel.tableInfo.a,sk:tableModel.tableInfo.csk,cd:tableModel.tableInfo.cd}));
			}
			
//			var seat:uint = 0;
//			blackJaceHandler(3);
//			bustHandCardHandler(new PlayerBustVO({'s':2}));
//			fiveDragHandler(4);
			
//			setTimeout(flipHandPoker,200 * 1,seat,CardInfoUtil.praseCardInfo(20),1);
//			setTimeout(flipHandPoker,200 * 2,seat,CardInfoUtil.praseCardInfo(20),2);
//			setTimeout(flipHandPoker,200 * 3,seat,CardInfoUtil.praseCardInfo(20),3);
//			setTimeout(flipHandPoker,200 * 4,seat,CardInfoUtil.praseCardInfo(20),4);
//			setTimeout(flipHandPoker,200 * 5,seat,CardInfoUtil.praseCardInfo(20),5);
		}
		
		/**
		 * 游戏开始 
		 * @param u
		 * 
		 */		
		private function gameStartHandler(u:uint):void
		{
			clearTable();
			
			view.betCounting.showCounting(15);
		}
		
		private function initCards(seat:uint,card:Array):void
		{
			var i:uint = 1;
			if(card)
			{
				//庄家第0张为暗牌，现在要第一张为暗牌
				if(seat==0)
				{
					setTimeout(flipHandPoker,200 * i,seat,CardInfoUtil.praseCardInfo(card[1]),1);
					setTimeout(flipHandPoker,200 * length + 200 * i,seat,CardInfoUtil.praseCardInfo(card[0]),2);
				}else
				{
					setTimeout(flipHandPoker,200 * i,seat,CardInfoUtil.praseCardInfo(card[0]),1);
					setTimeout(flipHandPoker,200 * length + 200 * i,seat,CardInfoUtil.praseCardInfo(card[1]),2);
				}
			}
			//				//如果是庄家，不显示点数
			//				if(seat==0)continue;
			var pokerPoint:Point = Configure.tableConfig.getPokerBackPoint(seat+1);
			var cardnumView:CardNumView = new CardNumView();
			cardnumView.name = tableModel.getHandPokerCardNumName(seat);
			cardnumView.x = pokerPoint.x;
			cardnumView.y = pokerPoint.y - 30;
			cardnumView.chip = '0';
			view.cardContainer.addChild(cardnumView);
		}
		/**
		 * 初始化空闲的椅子 
		 * 
		 */		
		private function initIdleChair():void
		{
			//清空邀请按钮
			removeSingleInviteChair();
			//初始桌子上的玩家
			var point:Point;
			var seat:uint = 1;
			var i:uint = 1;
			var my:Point;
			var player:PlayerInfoVO;
			for(i=1; i<=TableInfoUtil.SMALL_ROOM_NUMBER;i++)
			{
				seat = i;
				player = tableModel.getUserBySeat(seat);
				if(player)
				{
					//如果是本人，则存储本人座位信息
					if(userModel.isMine(player.u))
					{
						tableModel.mySeat = seat;
					}
					continue;
				}
				initSingleIdleChair(seat);
			}
		}
		/**
		 * 收到基础手牌 
		 * @param o
		 */		
		private function dealHandCardHandler(o:Object):void
		{
			view.betCounting.hideCounting();
			
			var deal:DealHandCardVO = o as DealHandCardVO;
			var i:uint;
			var seat:uint;
			var card:Array;
			var length:uint = deal.array.length;
			
			for(i = 0; i<length; i++)
			{
				seat = deal.array[i][0];
				card = deal.getCardsBySeat(seat);
				if(card)
				{
					//庄家第0张为暗牌，现在要第一张为暗牌
					if(seat==0)
					{
						setTimeout(flipHandPoker,200 * i,seat,CardInfoUtil.praseCardInfo(card[2]),1);
						setTimeout(flipHandPoker,200 * length + 200 * i,seat,CardInfoUtil.praseCardInfo(card[1]),2);
					}else
					{
						
						setTimeout(flipHandPoker,200 * i,seat,CardInfoUtil.praseCardInfo(card[1]),1);
						setTimeout(flipHandPoker,200 * length + 200 * i,seat,CardInfoUtil.praseCardInfo(card[2]),2);
					}
				}
//				//如果是庄家，不显示点数
//				if(seat==0)continue;
				var pokerPoint:Point = Configure.tableConfig.getPokerBackPoint(seat+1);
				var cardnumView:CardNumView = new CardNumView();
				cardnumView.name = tableModel.getHandPokerCardNumName(seat);
				cardnumView.x = pokerPoint.x;
				cardnumView.y = pokerPoint.y - 30;
				cardnumView.chip = '0';
				view.cardContainer.addChild(cardnumView);
				
				//如果只有两张牌并且是21点
				if(CardInfoUtil.countWithA(card) == 21)
				{
					//等发牌动作结束再播放
					setTimeout(blackJaceHandler,200 * 3 + 2 * 500,seat);
				}
			}
		}
		/**
		 * 玩家爆炸 
		 * @param o
		 * 
		 */		
		private function bustHandCardHandler(o:PlayerBustVO):void
		{
			var pokerPoint:Point = Configure.tableConfig.getPokerBackPoint(o.s+1);
			var bustSwf:Swf;
			var bustMovie:SwfMovieClip;
			bustSwf = new Swf(AssetsLoader.getAssetManager().getByteArray(AssetsName.EFFECT_WIN),AssetsLoader.getAssetManager(),500);
			bustMovie = bustSwf.createMovieClip("mc_BustCard");
			view.addChild(bustMovie);
			bustMovie.x = pokerPoint.x;
			bustMovie.y = pokerPoint.y;
			bustMovie.completeFunction = bustEnd;
			bustMovie.play();
		}
		
		private function bustEnd(target:SwfMovieClip):void
		{
			target.stop();
			target.completeFunction = null;
			target.removeFromParent(true);
		}
		/**
		 * 玩家21点 
		 * 
		 */		
		private function blackJaceHandler(seat:uint):void
		{
			var pokerPoint:Point = Configure.tableConfig.getPokerBackPoint(seat + 1);
			var bustSwf:Swf;
			var bustMovie:SwfMovieClip;
			bustSwf = new Swf(AssetsLoader.getAssetManager().getByteArray(AssetsName.EFFECT_WIN),AssetsLoader.getAssetManager(),500);
			bustMovie = bustSwf.createMovieClip("mc_BlackjackCard");
			view.addChild(bustMovie);
			bustMovie.x = pokerPoint.x;
			bustMovie.y = pokerPoint.y;
			bustMovie.completeFunction = bustEnd;
			bustMovie.play();
		}
		/**
		 * 玩家五龙 
		 */		
		private function fiveDragHandler(seat:uint):void
		{
			var pokerPoint:Point = Configure.tableConfig.getPokerBackPoint(seat + 1);
			var bustSwf:Swf;
			var bustMovie:SwfMovieClip;
			bustSwf = new Swf(AssetsLoader.getAssetManager().getByteArray(AssetsName.EFFECT_WIN),AssetsLoader.getAssetManager(),500);
			bustMovie = bustSwf.createMovieClip("mc_WuLong");
			view.addChild(bustMovie);
			bustMovie.x = pokerPoint.x;
			bustMovie.y = pokerPoint.y;
			bustMovie.completeFunction = bustEnd;
			bustMovie.play();
		}
		/**
		 * 移除某个座位上的手牌 
		 * @param seat
		 * 
		 */		
		private function removeHandPoker(seat:uint):void
		{
			var seatInfo:SeatInfoVO = tableModel.tableInfo.seats[seat];
			var name:String;
			var length:uint = seatInfo.k.length;
			for(var i:uint = 0; i<length; i++)
			{
				name = tableModel.getHandPokerName(seat,i+1);
				var myPoker:PokerItemView = view.handCardContainer.getChildByName(name) as PokerItemView;
				myPoker.removeFromParent(true);
			}
			//清空牌型缓存
			seatInfo.k = [];
			var card:CardNumView = view.cardContainer.getChildByName(tableModel.getHandPokerCardNumName(seat)) as CardNumView;
			
			if(card)
			{
				card.removeFromParent(true);
			}
		}
		/**
		 * 收到要牌返回 
		 * @param o
		 */		
		private function dealAskHandCardHandler(o:DealAskCardVO):void
		{
			var seatInfo:SeatInfoVO = tableModel.tableInfo.seats[o.s];
			//第几张牌
			var index:uint = 0;
			if(seatInfo)
			{
				if(o.sk == 1)
				{
					index = seatInfo.k2.length;
				}else
				{
					index = seatInfo.k.length;
				}
				flipHandPoker(o.s,CardInfoUtil.praseCardInfo(o.k),index,true,0);
				
				var name:String = tableModel.getHandPokerCardNumName(o.s);
				var cardnum:CardNumView = view.cardContainer.getChildByName(name) as CardNumView;
				var cardnumber:uint = CardInfoUtil.count(seatInfo.k);
				cardnum.chip = cardnumber.toString();
				
				if(cardnumber == 21)
				{
					SignalCenter.onAskStandBack.dispatch(new AskStandVO({s:seatInfo.id,sk:0}));
				}
			}
		}
		/**
		 * 收到双倍返回 
		 * @param o
		 * 
		 */		
		private function dealDoubleHandler(o:AskDoubleVO):void
		{
			var seatInfo:SeatInfoVO = tableModel.tableInfo.seats[o.s];
			flipHandPoker(o.s,CardInfoUtil.praseCardInfo(o.k),seatInfo.k.length,true,0);
		}
		/**
		 * 
		 * 移除邀请按钮 
		 * 
		 */
		private function removeSingleInviteChair():void
		{
			var length:uint = view.inviteContainer.numChildren;
			while(view.inviteContainer.numChildren > 0)
			{
				var invite:TableInviteButton = view.inviteContainer.getChildAt(0) as TableInviteButton;
				if(invite)
				{
					invite.removeFromParent(true);
				}
			}
		}
		/**
		* 初始化一个椅子
		* @param seat
		* 
		*/		
		private function initSingleIdleChair(seat:uint):void
		{
			var icon:SitDownButton;
			var point:Point;
			var my:Point;
			//如果存在
			if(view.arrowContainer.getChildByName("seat_"+(seat))) return;
			
			//如果不是一般游戏模式,则不显示,新手引导也要显示
			{
				icon = new SitDownButton(seat);
				my = Configure.tableConfig.getSeatPoint(seat);
				icon.x = my.x;
				icon.y = my.y;
				icon.name = "seat_"+(seat);
				trace("idle seat in small room:",seat);
				view.arrowContainer.addChild(icon);
			}
		}
		
		/**
		 * 结算 
		 * @param o
		 * 
		 */
		private function resultHandler(o:ResultVO):void
		{
			//其他玩家显示结算要等庄动画播放完毕开始
			var delay:uint = 0;
			//如果有闲家结算，才能轮到和庄家比牌
			//如果闲家全部爆掉，就不需要比牌
			if(o.idle.length != 0)
			{
				seatDealerResult(o.k,o.dc,o.c);
				
				delay = o.k.length * 200 + 800;
			}
			
			for(var i:String in o.idle)
			{
				setTimeout(seatResult,delay,o.idle[i]);
//				seatResult(o.idle[i]);
			}
			
			setTimeout(ready,3000+delay);
		}
		
		private function ready():void
		{
			NetSendProxy.iamready();
		}
		/**
		 * 庄家结果
		 * @param vo
		 * 
		 */		
		private function seatDealerResult(cards:Array,dc:Number,c:Number):void
		{
			//第几张牌
			var index:uint = 0;
			showFlop(CardInfoUtil.praseCardInfo(cards[0]));
			
//			for(var i:uint = 2; i<cards.length;i++)
//			{
//				flipHandPoker(0,CardInfoUtil.praseCardInfo(cards[i]),i+1,true,(i-2) * 500);
//				
//				var name:String = tableModel.getHandPokerCardNumName(0);
//				var cardnum:CardNumView = view.cardContainer.getChildByName(name) as CardNumView;
//				if(cardnum)
//				{
//					var cardnumber:uint = CardInfoUtil.count(cards);
//					cardnum.chip = cardnumber.toString();
//				}
//			}
		}
		/**
		 * 每个座位上的结算
		 * @param vo
		 * 
		 */		
		private function seatResult(vo:EachResultVO):void
		{
			var pokerPoint:Point = Configure.tableConfig.getPokerBackPoint(vo.id+1);
			var bustSwf:Swf;
			var bustMovie:SwfMovieClip;
			bustSwf = new Swf(AssetsLoader.getAssetManager().getByteArray(AssetsName.EFFECT_WIN),AssetsLoader.getAssetManager(),500);
			if(vo.w == 1)
			{
				bustMovie = bustSwf.createMovieClip("mc_WinAnimation");
			}else if(vo.w == -1)
			{
				bustMovie = bustSwf.createMovieClip("mc_LoseAnimation");
			}else
			{
				bustMovie = bustSwf.createMovieClip("mc_TieCard");
			}
			view.addChild(bustMovie);
			bustMovie.x = pokerPoint.x;
			bustMovie.y = pokerPoint.y;
			bustMovie.completeFunction = bustEnd;
			bustMovie.play();
			
			var uplayer:PlayerInfoVO = tableModel.tableInfo.getSeat(vo.id).player;
			
			if(uplayer)
			{
				trace('同步玩家筹码:'+vo.pc);
				SignalCenter.onUpdateUserChipBack.dispatch(uplayer.u,vo.pc);
			}
		}
		/**
		 * 初始化单个邀请 
		 * @param seat
		 * 
		 */		
		private function initSingleIdleInviteChair(seat:uint):void
		{
			var icon:TableInviteButton;
			var point:Point;
			var my:Point;
			//如果存在
			if(view.inviteContainer.getChildByName("invite_seat_"+(seat))) return;
			
			//如果不是一般游戏模式,则不显示,新手引导也要显示
			if(gameModel.tableBaseInfoVO.type == TableInfoUtil.NEW_BI || gameModel.tableBaseInfoVO.type == TableInfoUtil.NORMAL_RING_GAME)
			{
				icon = new TableInviteButton();
				my = Configure.tableConfig.getSeatPoint(seat);
				icon.x = my.x;
				icon.y = my.y;
				icon.name = "invite_seat_"+(seat);
				view.inviteContainer.addChild(icon);
			}
		}
		/**
		 * 玩家入座成功 
		 * @param e
		 */		
		private function playerSeatHandler(e:SimpleEvent):void
		{
			var playerInfo:UserBaseVO = UserBaseVO(e.carryData);
			var seatInfo:PlayerInfoVO = tableModel.getUserBySeat(playerInfo.uSeatIndex);
			
			var icon:SitDownButton = view.arrowContainer.getChildByName("seat_"+playerInfo.uSeatIndex) as SitDownButton;
			if(icon)
			{
				icon.removeFromParent(true);
			}
			
		}
		/**
		 * 选择座位 
		 * @param e
		 */
		private function seatSelect(seatName:String):void
		{
			var indexC:String = seatName;
			var index:uint = uint(indexC.replace("seat_",""));
			//如果自己额筹码不足最低买入
			if(userModel.myInfo.uMoney < gameModel.tableBaseInfoVO.minBuy)
			{
				UserProxy.checkValid(gameModel.tableBaseInfoVO.minBuy,UserProxy.CHIP);
				return;
			}
			
			if(!UserProxy.checkChip(gameModel.tableBaseInfoVO.limit)) return ;
			
			//检查是否足够最小筹码
			if(!UserProxy.checkValid(gameModel.tableBaseInfoVO.minBuy,UserProxy.CHIP)) return ;
			
			var binds:Number = gameModel.tableBaseInfoVO.blinds * 200;
			var chips:Number = Math.min(binds,userModel.myInfo.uMoney);
			NetSendProxy.sitDown(index);
		}
		/**
		 * 入座成功 
		 * @param e
		 */		
		private function sitDownBackHandler(seat:uint):void
		{
			var seatInfo:PlayerInfoVO = tableModel.getUserBySeat(seat);
			
			var icon:SitDownButton = view.arrowContainer.getChildByName("seat_"+seat) as SitDownButton;
			if(icon)
			{
				icon.removeFromParent(true);
			}
//			var icon:SitDownButton;
//			var point:Point;
//			
//			while(view.arrowContainer.numChildren > 0)
//			{
//				icon = view.arrowContainer.getChildAt(0) as SitDownButton;
//				icon.removeFromParent(true);
//			}
		}
		/**
		 * 某人站起 
		 * @param e
		 * 
		 */		
		private function standBackHandler(seat:uint,uid:uint):void
		{
			initSingleIdleChair(seat);
		}
		/**
		 * 选庄成功 
		 * @param e
		 * 
		 */		
		private function showButtonHandler(e:Event):void
		{
			view.roleButton.x = tableModel.hePosition.x;
			view.roleButton.y = tableModel.hePosition.y;	
			
			tableModel.dealerSeat = gameModel.dealSeatId;
			var dealer:Point = Configure.tableConfig.getDealerPoint(tableModel.dealerSeat);
			TweenMax.to(view.roleButton,1,{x:dealer.x,y:dealer.y});
		}
		/**
		 * 后端发来收到手牌 
		 * @param e
		 * 
		 */
		private function receiveHandPokerHandler(e:SimpleEvent):void
		{
			/**
			 * 在发手牌的时候，检测下下一局压注 
			 * @param e
			 * 
			 */		
			//如果玩家只是在座位上等待,而没有参与牌局。怎么办
			//播放其他玩家收到手牌动画
			var userBaseVO:UserBaseVO;
			//排序
			var temp:Vector.<UserBaseVO> = userModel.userList.sort(compare);
			var cardList:Array = [];
			var i:String;
		}
		/**
		 * 排序vector 递增
		 * @param x
		 * @param y
		 * @return 
		 * 
		 */		
		private function compare(x:UserBaseVO, y:UserBaseVO):Number
		{
			if(x.uSeatIndex > y.uSeatIndex)
			{
				return 1;
			}else
			{
				return -1;
			}
		}
		/**
		 * 每一张的牌的动画 
		 * @param seat
		 * @param index 第几张牌 从1开始
		 * @param animation
		 */		
		private function flipHandPoker(seat:uint,d:CardInfoVO,index:uint = 1,animation:Boolean = true,delay:Number = -1):void
		{
			trace('发牌.......:',seat,tableModel.getHandPokerName(seat,index));
			var pokerPoint:Point = Configure.tableConfig.getPokerBackPoint(seat+1);
			var dealp:Point = new Point(653,154);
//			var speed:Number = 500;
//			var distance:Number = Point.distance(pokerPoint,dealp);
//			var time:Number = distance/speed;
			var time:Number = .3;
			
			var myPoker:PokerItemView = new PokerItemView;
			myPoker.name = tableModel.getHandPokerName(seat,index);
			myPoker.setData(d);
			myPoker.x = dealp.x ;
			myPoker.y = dealp.y;
			myPoker.alpha = .3;
			myPoker.scale = .1;
			var dt:Number = 0;
			if(delay<0)
			{
				dt = .5 * index;
			}else
			{
				dt = delay; 
			}
			TweenMax.to(myPoker,Math.abs(time),{delay:dt,alpha:1,scale:1,x:pokerPoint.x+ index * 22,y:pokerPoint.y,onComplete:updatePokerNum,onCompleteParams:[seat,index]});
			view.handCardContainer.addChild(myPoker);
			dispatch(new SoundEffectEvent(AssetsCenter.getSoundPath("fapai")));
		}
		/**
		 * 庄家翻牌逻辑 
		 * @param card
		 * 
		 */		
		private function showFlop(card:CardInfoVO):void
		{
			var poker:PokerItemView = view.handCardContainer.getChildByName(tableModel.getHandPokerName(0,2)) as PokerItemView;
			poker.setData(card);
			poker.start(.2,dealNextHandler);
			trace('showFlopshowFlopshowFlop');
			//			poker.start(0,0.1);
		}
		/**
		 * 继续庄家结算是否要牌 
		 * 
		 */		
		private function dealNextHandler():void
		{
			//更新庄家翻出的牌的点数
			updatePokerNum(0,2);
			var cards:Array = tableModel.resultVO.k;
			for(var i:uint = 2; i<cards.length;i++)
			{
				//发牌动画结束后会更新点数
				flipHandPoker(0,CardInfoUtil.praseCardInfo(cards[i]),i+1,true,(i-1) * .5);
				
//				var name:String = tableModel.getHandPokerCardNumName(0);
//				var cardnum:CardNumView = view.cardContainer.getChildByName(name) as CardNumView;
//				if(cardnum)
//				{
//					var cardnumber:uint = CardInfoUtil.count(cards);
//					cardnum.chip = cardnumber.toString();
//				}
			}
		}
		/**
		 * 更新扑克点数 
		 * @param a
		 * 
		 */		
		private function updatePokerNum(seat:uint,index:uint):void
		{
			var temp:Array = [];
			for(var i:uint = 0; i<index;i++)
			{
				temp.push(tableModel.tableInfo.seats[seat].k[i]);
			}
			var cardnum:Number = CardInfoUtil.count(temp);
			var cardwithA:Number = CardInfoUtil.countWithA(temp);
			
			//有五张牌并且没有爆炸,五龙
			if(temp.length == 5 && cardnum <=21)
			{
				fiveDragHandler(seat);
			}
			
			//庄家爆炸
			if(cardnum>21 && seat==0)
			{
				bustHandCardHandler(new PlayerBustVO({s:0}));
			}
			var cardnumName:String = tableModel.getHandPokerCardNumName(seat);
			var cardnumView:CardNumView = view.cardContainer.getChildByName(cardnumName) as CardNumView;

			if(cardnumView)
			{
				if(cardnum == cardwithA)
				{
					cardnumView.chip = cardnum.toString();
				}else
				{
					if(cardwithA > 21)
					{
						cardnumView.chip = cardnum.toString();
					}else
					{
						cardnumView.chip = cardnum.toString() +'/'+cardwithA.toString();
					}
				}
			}
		}
		/**
		 * 翻桌牌 
		 * @param e
		 */
		private function onFlopHandler(e:SimpleEvent):void
		{
			var card:FlopCardInfoVO = FlopCardInfoVO(e.carryData);
			//如果普通游戏记录
			if(gameModel.tableBaseInfoVO.type == TableInfoUtil.NORMAL_RING_GAME)
			{
				//记录log
				if(gameModel.tempRoundInfo)
				{
					if(card.index <= 3)
					{
						gameModel.tempRoundInfo.flopCards.push(card.card.number);
					}else if(card.index == 4)
					{
						gameModel.tempRoundInfo.turnCard = card.card.number;
					}else if(card.index == 5)
					{
						gameModel.tempRoundInfo.riverCard = card.card.number;
					}
				}
			}
			dispatch(new SoundEffectEvent(AssetsCenter.getSoundPath("fapai")));
			var interval:Number = 300 * card.index;
			interval = 0;
			setTimeout(showFlop,interval,card);
		}
		
		
		
		/**
		 * 清空桌子，准备下一轮
		 * @param e
		 * 
		 */		
		private function resetTableHandler(e:Event):void
		{
			clearTable();
			
			if(gameModel.tableBaseInfoVO.maxRole == TableInfoUtil.VERY_SMALL_ROOM_NUMBER)
			{
			}else
			{
			}
		}
		/**
		 * 强制清牌 
		 * @param e
		 * 
		 */		
		private function forceReset(e:Event):void
		{
			clearTable();
		}
		
		/**
		 * 清空牌桌 
		 * 
		 */		
		private function clearTable():void
		{
			if(!tableModel.tableInfo)return;
			for(var i:String in tableModel.tableInfo.seats)
			{
				removeHandPoker(tableModel.tableInfo.seats[i].id);
			}
		}
	}
}