package com.starling.mediator
{
	import com.jzgame.common.model.HttpSendProxy;
	import com.jzgame.common.model.NetSendProxy;
	import com.jzgame.common.services.MessageType;
	import com.jzgame.common.services.SocketService;
	import com.jzgame.common.services.http.events.HttpResponseEvent;
	import com.jzgame.common.utils.AssetsCenter;
	import com.jzgame.common.utils.DisplayManager;
	import com.jzgame.common.utils.ResManager;
	import com.jzgame.common.utils.SignalCenter;
	import com.jzgame.common.utils.logging.Tracer;
	import com.jzgame.enmu.EventType;
	import com.jzgame.enmu.ReleaseUtil;
	import com.jzgame.enmu.TableInfoUtil;
	import com.jzgame.events.SoundEffectEvent;
	import com.jzgame.model.GameModel;
	import com.jzgame.model.UserModel;
	import com.jzgame.modules.lobby.RoomView;
	import com.jzgame.signals.SignalJoinSocket;
	import com.jzgame.util.WindowFactory;
	import com.jzgame.view.table.TableView;
	import com.spellife.display.PopUpWindowManager;
	import com.spellife.ui.ToolTipManager;
	import com.spellife.util.RealGameTimer;
	import com.spellife.util.TimerManager;
	import com.starling.view.StarlingGame;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	public class StarlingViewMediator extends Mediator
	{
		/*auther     :jim
		* file       :StarlingViewMediator.as
		* date       :Sep 15, 2014
		* description:
		*/
		[Inject]
		public var view:StarlingGame;
		[Inject]
		public var userModel:UserModel;
		[Inject]
		public var gameModel:GameModel;
		[Inject]
		public var myServer:SocketService;
		[Inject]
		public var signalJoinSocket:SignalJoinSocket;
		private var _heart:RealGameTimer;
		public function StarlingViewMediator()
		{
			super();
		}
		
		override public function destroy():void
		{
			removeContextListener(EventType.RETURN_LOBBY, returnLobbyHandler);
		}
		
		override public function initialize():void
		{
			AssetsCenter.eventDispatcher = eventDispatcher;
			PopUpWindowManager.container = view.pop;
			ToolTipManager.init(view.tips);
			addContextListener(EventType.RETURN_LOBBY, returnLobbyHandler);
			addContextListener(MessageType.GET_PLAYER_INFO, httpReceiveHandler);
			
			SignalCenter.onInitialLoadComplete.add(onLoadComplete);
			SignalCenter.onConnectComplete.add(onConnected);
			
			//开始加载素材
			AssetsCenter.eventDispatcher.dispatchEvent(new Event(EventType.ASSETS_START));

//			stateManager = new StateManager(eventDispatcher,commandMap);
//			//			StateManager.register(new AIAddUserState(),StateType.PARENT_STATE_AI_STATE);
//			//			StateManager.register(new FirstRoundState(),StateType.PARENT_STATE_AI_STATE);
//			dispatch(new ChangeStateEvent(StateType.PARENT_STATE_AI_STATE,ChangeStateEvent.CHANGE_PARENT_STATE));
//			dispatch(new ChangeStateEvent(StateType.WAITING));
		}
		
		private function httpReceiveHandler(e:HttpResponseEvent):void
		{
			if(e.request.name == MessageType.GET_PLAYER_INFO)
			{
				userModel.myInfo.uNickName = Object(e.data).n;
				userModel.myInfo.uFace = Object(e.data).f;
				userModel.myInfo.uMoney = Object(e.data).c;
				
				SignalCenter.onUpdateUserInfo.dispatch();
			}
		}
		
		/**
		 * 素材加载完毕 
		 * 
		 */		
		private function onLoadComplete():void
		{
			ResManager.start();
			
//			view.onAdded(null);
			
			if(ReleaseUtil.runningOnAndroid() || ReleaseUtil.runningOnIphone())
			{
			}else
			{
			}
			
			initLobby();
			
			initHeart();
//			//直接链接socket
//			if(ExternalVars.socketURL == "")
//			{
//				signalJoinSocket.dispatch("192.168.1.52",9688);
//			}else
//			{
//				var url:Array = ExternalVars.socketURL.split(':');
//				signalJoinSocket.dispatch(String(url[0]),int(url[1]));
//			}
//			myServer.connect("192.168.1.52",9688);
		}

		/**
		 * 握手成功 
		 * 
		 */		
		private function onConnected():void
		{
			WindowFactory.hideCommuWindow();
			
			initTable();
			
			if((gameModel.tableBaseInfoVO.type == TableInfoUtil.SPE_MTT || gameModel.tableBaseInfoVO.type == TableInfoUtil.MTT) && !gameModel.offLine)
			{
			}else
			{
				/**
				 * 
				 * 登陆桌子
				 */
				NetSendProxy.joinTable(10001,userModel.myInfo.userId);
			}
		}
		
		
		/**
		 * 初始化大厅 
		 */		
		private function initLobby():void
		{
			DisplayManager.clearItemStage(view.container);
			
			var roomView:RoomView = new RoomView();
			view.container.addChild(roomView);
			
			//获取个人信息
			HttpSendProxy.getPlayerInfo();
		}
		/**
		 * 初始化桌子 
		 */		
		private function initTable():void
		{
			DisplayManager.clearItemStage(view.container);
			
			var table:TableView = new TableView;
			view.container.addChild(table);
		}
		
		/**
		 *初始化心跳  
		 * 
		 */
		private function initHeart():void
		{
			_heart = new RealGameTimer(3000);
			_heart.addEventListener(TimerEvent.TIMER,heartSend);
			_heart.start();
			_start = getTimer();
		}
		
		private var _start:Number = 0;
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function heartSend(e:TimerEvent):void
		{
			_start = getTimer();
			eventDispatcher.dispatchEvent(new Event(EventType.HEART_TO_SERVER));
		}
		/**
		 * 停止游戏 
		 * @param e
		 * 
		 */		
		private function gameStopHandler(e:Event):void
		{
			Tracer.error("stop game!");
			if(_heart)
			{
				_heart.removeEventListener(TimerEvent.TIMER,heartSend);
				_heart.stop();
			}
			TimerManager.getInstance().animTimer.stop();
		}
		/**
		 * 回到大厅
		 * @param e
		 * 
		 */		
		private function returnLobbyHandler(e:Event):void
		{
			if(!gameModel.guide)
			{
//				NetSendProxy.leaveTable(userModel.myInfo.userId);
				//清空
				userModel.clearMuteList();
				dispatch(new SoundEffectEvent(AssetsCenter.getSoundPath("lobby")));
			}else
			{
				WindowFactory.removeAll();
				gameModel.guideStep = 0;
			}
			gameModel.tableBaseInfoVO.id = 0;
			gameModel.guide = false;
			//FIXME 在Mediator中更改Proxy
			userModel.removeAllUser();
			initLobby();
			gameModel.inTable = false;
		}
	}
}