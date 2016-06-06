package com.jzgame.view.table
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.jzgame.common.configHelper.Configure;
	import com.jzgame.common.events.SimpleEvent;
	import com.jzgame.common.utils.SignalCenter;
	import com.jzgame.common.utils.logging.Tracer;
	import com.jzgame.enmu.DebugInfoType;
	import com.jzgame.enmu.EventType;
	import com.jzgame.enmu.TableInfoUtil;
	import com.jzgame.events.DebugInfoEvent;
	import com.jzgame.model.GameModel;
	import com.jzgame.model.TableModel;
	import com.jzgame.model.UserModel;
	import com.jzgame.util.WindowFactory;
	import com.jzgame.view.display.WinOrLoseChipView;
	import com.jzgame.vo.commu.AskDoubleVO;
	import com.jzgame.vo.commu.PlayerBetVO;
	import com.jzgame.vo.commu.PlayerBustVO;
	import com.jzgame.vo.commu.ResultVO;
	import com.jzgame.vo.commu.SeatInfoVO;
	import com.jzgame.vo.commu.TableInfo;
	import com.spellife.feathers.SLLabel;
	import com.spellife.util.RealGameTimer;
	import com.starling.theme.StyleProvider;
	
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.setTimeout;
	
	import robotlegs.extensions.starlingViewMap.impl.StarlingMediator;
	
	import starling.display.DisplayObject;
	
	public class ChipViewMediator extends StarlingMediator
	{
		/***********
		 * name:    ChipViewMediator
		 * data:    Nov 19, 2015
		 * author:  jim
		 * des:
		 ***********/
		[Inject]
		public var view:ChipView;
		[Inject]
		public var gameModel:GameModel;
		[Inject]
		public var tableModel:TableModel;
		[Inject]
		public var userModel:UserModel;
		
		private var resultTimer:RealGameTimer;
		private var resetTimer:RealGameTimer;
		public function ChipViewMediator()
		{
			super();
		}
		
		override public function initialize():void
		{
			SignalCenter.onPlayerBetBack.add(playerBetHandler);
			SignalCenter.onDealBustBack.add(bustHandler);
			SignalCenter.onResultBack.add(resultHandler);
			SignalCenter.onAskDoubleBack.add(doubleHandler);
			
			addContextListener(EventType.ACTION, onActionHandler);
			addContextListener(EventType.NET_FORCE_RESET_TABLE, forceRestHandler);
			addContextListener(EventType.NET_INIT_TABLE, receiveTableInfoHandler);
		}
		
		override public function destroy():void
		{
			SignalCenter.onAskDoubleBack.remove(doubleHandler);
			SignalCenter.onResultBack.remove(resultHandler);
			SignalCenter.onDealBustBack.remove(bustHandler);
			SignalCenter.onPlayerBetBack.remove(playerBetHandler);
			
			removeContextListener(EventType.NET_INIT_TABLE, receiveTableInfoHandler);
			removeContextListener(EventType.NET_FORCE_RESET_TABLE, forceRestHandler);
			removeContextListener(EventType.ACTION, onActionHandler);
			
			
			TweenMax.killAll(true);
		}
		/**
		 * @param playerBet
		 */		
		private function playerBetHandler(playerBet:Object):void
		{
			var bet:PlayerBetVO = playerBet as PlayerBetVO;
			//缓存此玩家的下注筹码
			gameModel.clips[bet.seat_id - 1].clip1 = bet.bet_chips;
			
			var allNum:SLLabel = view.tableChipContainer.getChildByName(bet.seat_id+'_all') as SLLabel;
			if(!allNum)
			{
				allNum = new SLLabel;
				allNum.name = bet.seat_id+'_all';
				allNum.setSize(100,30);
				var t:Point = Configure.tableConfig.getChipPoint(bet.seat_id);
				allNum.setLocation(t.x,t.y + 50);
				allNum.textRendererProperties.textFormat = StyleProvider.getTF(0xffffff,16);
				view.tableChipContainer.addChild(allNum);
				
				tableModel.chipNumList[bet.seat_id] = allNum;
			}
			
			allNum.text = bet.bet_chips.toString();
			
			if(bet.chips == 0)
			{
				initMyBet(bet.bet_chips,bet.seat_id);
			}else
			{
				initMyBet(bet.chips,bet.seat_id);
			}
			
			
			
		}
		/**
		 * login 的时候同步桌子信息 
		 * @param e
		 * 
		 */		
		private function receiveTableInfoHandler(e:SimpleEvent):void
		{
			var tableInfo:TableInfo = TableInfo(e.carryData);
			Tracer.info("同步桌子");
			for(var i:String in tableInfo.seats)
			{
				var seat:SeatInfoVO = tableInfo.seats[i];
				//获取对应池子的筹码vo 初始化自己面前池子筹码
//				var item:ChipTableItem = initMyBet(seat.bet.toNumber(),seat.seatid);
//				var clipVO:TableClipVO = new TableClipVO(seat.clip,ClipType.MAIN);
//				gameModel.tempClips.push(clipVO);
			}
			
			//初始化池子信息
//			if(tableInfo.pots.length > 0)
//			{
//				gameModel.pots = new Vector.<Int64>;
//				for(var j:String in tableInfo.pots)
//				{
//					gameModel.pots.push(tableInfo.pots[j]);
//				}
//				updatePosts();
//			}
		}
		
		/**
		 * 初始化玩家身前筹码 
		 * @param chip
		 * 
		 */		
		private function initMyBet(chip:Number,seat:uint):ChipTableItem
		{
			//获取对应池子的筹码vo 初始化自己面前池子筹码
			var clipItem:ChipTableItem = new ChipTableItem;
			var clips:Array;
			var t:Point = Configure.tableConfig.getChipPoint(seat);
			var f:Point = Configure.tableConfig.getSeatPoint(seat);
			clipItem.num = chip;
			clipItem.x = f.x ;
			clipItem.y = f.y ;
			clipItem.name = getOwnClipName(seat);
			view.eachChipContainer.addChild(clipItem);
			TweenMax.to(clipItem,.5,{x:t.x+ Math.random() * 30 - 25,y:t.y+ Math.random() * 30 - 25});
			//缓存筹码
			tableModel.chipList[seat].push(clipItem);

			
//			tableModel.splitClip();
			return clipItem;
		}
		/**
		 * 操作 
		 * @param e
		 */		
		private function onActionHandler(e:SimpleEvent):void
		{
		}
		/**
		 * 双倍要牌返回 
		 * @param o
		 * 
		 */		
		private function doubleHandler(o:AskDoubleVO):void
		{
			initMyBet(o.c,o.s);
		}
		/**
		 * 结算 
		 * @param o
		 */		
		private function resultHandler(o:ResultVO):void
		{
			//其他玩家显示结算要等庄动画播放完毕开始
			var delay:uint = 0;
			//如果有闲家结算，才能轮到和庄家比牌
			//如果闲家全部爆掉，就不需要比牌
			if(o.idle.length != 0)
			{
				delay = o.k.length * 200 + 800;
			}
			
			setTimeout(resultChip,delay,o);
		}
		/**
		 * 结算筹码 
		 * @param o
		 * 
		 */		
		private function resultChip(o:ResultVO):void
		{
			for(var i:String in o.idle)
			{
				if(o.idle[i].c != 0)
				{
					var text:WinOrLoseChipView = new WinOrLoseChipView(o.idle[i].c);
					var t:Point = Configure.tableConfig.getChipPoint(o.idle[i].id);
					var f:Point = Configure.tableConfig.getSeatPoint(o.idle[i].id);
					text.x = t.x;
					text.y = t.y;
					view.stage.addChild(text);
					TweenMax.to(text,1,{x:f.x,y:f.y,ease:Linear.easeIn,onComplete:moveEnd,onCompleteParams:[text]});
				}
				var type:uint = o.idle[i].w;
				var list:Array = tableModel.chipList[o.idle[i].id]
				if(type == 1)
				{
					for(var m:String in list)
					{
						DisplayObject(list[m]).removeFromParent(true);
					}
					
					list.splice(0,list.length);
				}else if(type == 0)
				{
					for(var m:String in list)
					{
						DisplayObject(list[m]).removeFromParent(true);
					}
					
					list.splice(0,list.length);
				}else
				{
					for(var m:String in list)
					{
						DisplayObject(list[m]).removeFromParent(true);
					}
					
					list.splice(0,list.length);
				}
				//如果是我自己，更新我的筹码
				if(o.idle[i].id == tableModel.mySeat)
				{
					userModel.myInfo.uMoney = o.idle[i].pc;
					SignalCenter.onUpdateChips.dispatch(userModel.myInfo.uMoney);
				}
			}
			
			
			for(var inum:String in tableModel.chipNumList)
			{
				tableModel.chipNumList[inum].removeFromParent(true);
			}
		}
		/**
		 * 玩家爆炸结算 
		 * @param o
		 * 
		 */
		private function bustHandler(o:PlayerBustVO):void
		{
			var text:WinOrLoseChipView = new WinOrLoseChipView(o.b);
			var t:Point = Configure.tableConfig.getChipPoint(o.s);
			var f:Point = Configure.tableConfig.getSeatPoint(o.s);
			text.x = t.x;
			text.y = t.y;
			TweenMax.to(text,.5,{x:f.x,y:f.y,onComplete:moveEnd,onCompleteParams:[text]});
			
			//移除筹码
			var list:Array = tableModel.chipList[o.s]
			for(var m:String in list)
			{
				DisplayObject(list[m]).removeFromParent(true);
			}
			
			list.splice(0,list.length);
		}
		/**
		 * 结束 
		 * @param text
		 * 
		 */		
		private function moveEnd(text:WinOrLoseChipView):void
		{
			setTimeout(clearText,1000,text);
		}
		
		private function clearText(text:WinOrLoseChipView):void
		{
			text.removeFromParent(true);
		}
		
		/**
		 * 开始重置 
		 * 
		 */		
		private function startReset():void{
			//如果是all in模式，倒计时开始
			if(gameModel.tableBaseInfoVO.maxRole == TableInfoUtil.VERY_SMALL_ROOM_NUMBER)
			{
				if(gameModel.autoBuy)
				{
				}else
				{
					WindowFactory.addPopUpWindow(WindowFactory.ALL_IN_MODE_COUNTING_WINDOW);
					//显示ready按钮
					dispatch(new Event(EventType.SHOW_ALL_IN_READY_BTN));
				}
			}
		}
		
		/**
		 * 发送重置消息 
		 * 
		 */		
		private function reset():void
		{
			view.reset();
			dispatch(new Event(EventType.RESET));
			Tracer.info("clip reset result end!");
		}
		/**
		 * 牌局已经开始 
		 * @param e
		 * 
		 */		
		private function forceRestHandler(e:Event):void
		{
			dispatch(new DebugInfoEvent("===================== 强制新开牌局 ======================!",DebugInfoType.INFO));
		}
		
		/**
		 * 
		 * @param clipIndex
		 * 
		 */		
		private function showEachResultClip(resultVO:ResultVO):void
		{
		}
		/**
		 * 赢家获得筹码动画
		 * @param clip 筹码值
		 * @param winnerSeatId 胜者座位
		 * @param clipIndex 筹码池id
		 * 
		 */		
		private function findClipView(clip:Number,winnerSeatId:uint,clipIndex:uint):void
		{
			var mc:DealerChipTableItem;
			var clips:Array = tableModel.splitClip(clip);
			var p:Point = Configure.tableConfig.getCollectChipPoint( clipIndex );
			var target:Point = Configure.tableConfig.getSeatPoint( ( winnerSeatId ));
			
			var startX:Number = p.x;
			//如果两落
			if(clips.length > 5)
			{
				startX = p.x - 12;
			}
			
//			for(var i:uint = 0; i<clips.length;i++)
//			{
//				mc = new DealerChipTableItem(clips[i]);
//				if(i>5)
//				{
//					mc.x = p.x + 12;
//				}else
//				{
//					mc.x = startX;
//				}
//				
//				mc.y = p.y;
//				view.addChild(mc);
//				TweenMax.to(mc,0.5,{x:target.x+i*3,y:target.y+(i%5)*3,onComplete:complete,onCompleteParams:[mc],delay:0.1 * ((i+1))});
//			}
//			//当前的彩池隐藏
//			var clipItem:ChipTableItem = view.getChildByName(getClipName(clipIndex)) as ChipTableItem;
//			if(clipItem)
//			{
//				clipItem.hideClip();
//				clipItem.clearAllClips();
//				dispatch(new DebugInfoEvent("findClipView===> 找到这个池子:筹码数量:"+clip+":赢家座位id:"+winnerSeatId+":池子id:"+"clipContainer_"+clipIndex,DebugInfoType.INFO));
//			}else
//			{
//				dispatch(new DebugInfoEvent("findClipView 没有招到这个池子:筹码数量:"+clip+":赢家座位id:"+winnerSeatId+":池子id:"+"clipContainer_"+clipIndex,DebugInfoType.INFO));
//			}
		}
		
		/**
		 * 获取自己池子名字
		 * @param clipIndex
		 * @return 
		 * 
		 */		
		private function getOwnClipName(seatId:uint):String
		{
			var clipname:String = "clipOwnContainer_"+seatId;
			return clipname;
		}
		/**
		 * 池子名字
		 * @param clipIndex
		 * @return 
		 * 
		 */		
		private function getClipName(clipIndex:uint):String
		{
			var clipname:String = "clipContainer_"+clipIndex;
			return clipname;
		}
	}
}