package com.jzgame.configs
{
	import com.jzgame.command.AppStartCommand;
	import com.jzgame.command.AssetsLoadCommand;
	import com.jzgame.command.HeartCommand;
	import com.jzgame.command.communication.ConnectCommand;
	import com.jzgame.command.communication.HttpReceivedCommand;
	import com.jzgame.command.communication.NetReceivedCommand;
	import com.jzgame.command.communication.NetSendCommand;
	import com.jzgame.command.game.JoinTableDirectCommand;
	import com.jzgame.common.controller.HttpRequestCommand;
	import com.jzgame.common.model.connect.ConnectStartupCommand;
	import com.jzgame.common.services.HttpService;
	import com.jzgame.common.services.SocketService;
	import com.jzgame.common.services.http.events.HttpRequestEvent;
	import com.jzgame.common.services.http.events.HttpResponseEvent;
	import com.jzgame.common.services.socket.SocketServiceEvent;
	import com.jzgame.common.utils.ResManager;
	import com.jzgame.enmu.EventType;
	import com.jzgame.enmu.NetEventType;
	import com.jzgame.events.communication.NetSendEvent;
	import com.jzgame.mediator.commu.PopUpLoadingWindowMediator;
	import com.jzgame.mediator.table.TitleBarViewMediator;
	import com.jzgame.mediator.windows.ringGame.RingGameRoomWindowMediator;
	import com.jzgame.model.ActivitiesModel;
	import com.jzgame.model.BuffModel;
	import com.jzgame.model.GameModel;
	import com.jzgame.model.MessageLogModel;
	import com.jzgame.model.NoteModel;
	import com.jzgame.model.OnLineModel;
	import com.jzgame.model.PackageModel;
	import com.jzgame.model.PlayerRecordsModel;
	import com.jzgame.model.PreRoundInfoModel;
	import com.jzgame.model.RankModel;
	import com.jzgame.model.RoomModel;
	import com.jzgame.model.TableModel;
	import com.jzgame.model.UserModel;
	import com.jzgame.model.WindowModel;
	import com.jzgame.modules.lobby.RoomView;
	import com.jzgame.modules.lobby.RoomViewMediator;
	import com.jzgame.modules.operate.OperateView;
	import com.jzgame.modules.operate.OperateViewMediator;
	import com.jzgame.modules.userInfo.UserInfoView;
	import com.jzgame.modules.userInfo.UserInfoViewMediator;
	import com.jzgame.signals.SignalJoinSocket;
	import com.jzgame.signals.SignalJoinTable;
	import com.jzgame.util.WindowFactory;
	import com.jzgame.view.table.ChipView;
	import com.jzgame.view.table.ChipViewMediator;
	import com.jzgame.view.table.PlayersView;
	import com.jzgame.view.table.PlayersViewMediator;
	import com.jzgame.view.table.TableView;
	import com.jzgame.view.table.TableViewMediator;
	import com.jzgame.view.table.ui.TableUIView;
	import com.jzgame.view.table.ui.TableUIViewMediator;
	import com.jzgame.view.table.ui.TitleBarView;
	import com.jzgame.view.windows.commu.PopUpCommunicateWindow;
	import com.jzgame.view.windows.commu.PopUpLoadingWindow;
	import com.jzgame.view.windows.ringGame.RingGameRoomWindow;
	import com.starling.mediator.StarlingViewMediator;
	import com.starling.view.StarlingGame;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
	import robotlegs.bender.extensions.signalCommandMap.api.ISignalCommandMap;
	import robotlegs.bender.framework.api.IConfig;
	import robotlegs.bender.framework.api.IInjector;
	import robotlegs.bender.framework.api.ILogger;
	import robotlegs.bender.framework.api.LifecycleEvent;
	
	
	public class MyMobileConfig implements IConfig
	{
		[Inject]
		public var injector:IInjector;
		
		[Inject]
		public var mediatorMap:IMediatorMap;
		
		[Inject]
		public var commandMap:IEventCommandMap;
		[Inject]
		public var signalCommandMap:ISignalCommandMap;
		
		[Inject]
		public var contextView:ContextView;
		
		[Inject]
		public var logger:ILogger;

		[Inject]
		public var eventDis:IEventDispatcher;
		
		public function MyMobileConfig()
		{
		}
		
		public function configure():void
		{
			initModels();
			initMediators();
			initCommands();
			initServer();
			initWindows();
			
		}
		
		private function onLoadComplete():void
		{
			ResManager.start();
		}
		
		private function initModels():void
		{
			//作为唯一实例
			injector.map(UserModel).asSingleton();
			injector.map(RoomModel).asSingleton();
			injector.map(GameModel).asSingleton();
			injector.map(BuffModel).asSingleton();
			injector.map(TableModel).asSingleton();
			injector.map(MessageLogModel).asSingleton();
			injector.map(PackageModel).asSingleton();
			injector.map(PreRoundInfoModel).asSingleton();
			
			//作为唯一实例
			
			injector.map(WindowModel).asSingleton();
			injector.map(PlayerRecordsModel).asSingleton();
			injector.map(RankModel).asSingleton();
			injector.map(OnLineModel).asSingleton();
			injector.map(NoteModel).asSingleton();
			injector.map(ActivitiesModel).asSingleton();
			
//			injector.map( RegisterModule ).asSingleton();
//			injector.map(GameModel).asSingleton();
//			injector.map(WindowModel).asSingleton();
		}
		
		private function initMediators():void
		{
			mediatorMap.map(StarlingGame).toMediator(StarlingViewMediator);
			mediatorMap.map(RoomView).toMediator(RoomViewMediator);
			mediatorMap.map(RingGameRoomWindow).toMediator(RingGameRoomWindowMediator);
			mediatorMap.map(TableView).toMediator(TableViewMediator);
			mediatorMap.map(OperateView).toMediator(OperateViewMediator);
			mediatorMap.map(PlayersView).toMediator(PlayersViewMediator);
			mediatorMap.map(TableUIView).toMediator(TableUIViewMediator);
			mediatorMap.map(TitleBarView).toMediator(TitleBarViewMediator);
			mediatorMap.map(ChipView).toMediator(ChipViewMediator);
			mediatorMap.map(UserInfoView).toMediator(UserInfoViewMediator);
			mediatorMap.map(PopUpLoadingWindow).toMediator(PopUpLoadingWindowMediator);
		}
		
		private function initCommands():void
		{
//			signals
//			fuckCommand.map( RegisterSignal ).toCommand( GetInTableCommand );
			
			//events
//			commandMap.map( EventType.GAME_START ).toCommand( GameStartCommand );
			commandMap.map(LifecycleEvent.POST_INITIALIZE).toCommand(AppStartCommand);
			commandMap.map(LifecycleEvent.POST_INITIALIZE).toCommand(ConnectStartupCommand);
			commandMap.map( EventType.ASSETS_START ).toCommand( AssetsLoadCommand );
			
			commandMap.map( EventType.HEART_TO_SERVER ).toCommand( HeartCommand );
			commandMap.map( NetEventType.SEND , NetSendEvent).toCommand( NetSendCommand );
			commandMap.map( SocketServiceEvent.SOCKET_RECEIVED , SocketServiceEvent).toCommand( NetReceivedCommand );
			commandMap.map( HttpRequestEvent.HTTP_REQUEST , HttpRequestEvent).toCommand( HttpRequestCommand );
			commandMap.map( HttpResponseEvent.HTTP_RESPONSE_RECEIVE, HttpResponseEvent).toCommand(HttpReceivedCommand);
//			commandMap.map(EventType.CHANGE_TABLE_COLOR, Event).toCommand(ChangeColorCommand);
			
			//需要传参数的时候用信号,否则要新建信号类- -麻烦
			signalCommandMap.map( SignalJoinTable ).toCommand(JoinTableDirectCommand);
			signalCommandMap.map( SignalJoinSocket ).toCommand(ConnectCommand);
		}
		
		private function initServer():void
		{
			injector.map( SocketService ).asSingleton();
			injector.map( HttpService ).asSingleton();
		}
		
		private function initWindows():void
		{
			WindowFactory.register(WindowFactory.RING_ROOM_WINDOW, RingGameRoomWindow);
			WindowFactory.register(WindowFactory.COMMUNICATE_WINDOW, PopUpCommunicateWindow);
			WindowFactory.register(WindowFactory.LOAD_RESOURCE, PopUpLoadingWindow);
//			WindowFactory.register(WindowFactory.MESSAGE_WINDOW, PopUpMessageCenterWindow);
//			WindowFactory.register(WindowFactory.MISSION_WINDOW, PopUpTaskWindow);
//			WindowFactory.register(WindowFactory.STORE_WINDOW, PopUpStoreWindow);
//			WindowFactory.register(WindowFactory.STORE_BUY_WINDOW, StoreBuyWindow);
//			WindowFactory.register(WindowFactory.LESS_CHIP_WINDOW, LessChipWindow);
//			WindowFactory.register(WindowFactory.PLAYER_INFO_WINDOW, PopUpUserDetailWindow);
//			WindowFactory.register(WindowFactory.RANK_WINDOW, PopUpRankWindow);
//			WindowFactory.register(WindowFactory.FRIENDS_WINDOW, PopUpFriendsWindow);
//			WindowFactory.register(WindowFactory.PACK_WINDOW, PopUpPackWindow);
//			WindowFactory.register(WindowFactory.NOTE_WINDOW, PopUpNoteWindow);
//			WindowFactory.register(WindowFactory.PACK_DETAIL_WINDOW, PackDetailWindow);
//			WindowFactory.register(WindowFactory.GAME_SET_WINDOW, PopUpGameSettingWindow);
//			WindowFactory.register(WindowFactory.ACHIEVE_WINDOW, PopUpAchieWindow);
//			WindowFactory.register(WindowFactory.ROUND_WINDOW, PopUpRoundWindow);
//			WindowFactory.register(WindowFactory.OTHER_USER_INFO_WINDOW, PlayerInfoInGameView);
//			WindowFactory.register(WindowFactory.MY_INFO_WINDOW, PlayerMyInfoInGameView);
//			WindowFactory.register(WindowFactory.SEVEN_LOGIN_BONUS_WINDOW, PopUpSignInWindow);
//			WindowFactory.register(WindowFactory.SEVEN_LOGIN_REWARD_WINDOW, PopUpSevenRewardWindow);
//			WindowFactory.register(WindowFactory.ACHIE_DETAIL_WINDOW, PopUpAchieDescriptionWindow);
//			WindowFactory.register(WindowFactory.SAFE_BOX_WINDOW, PopUpSafeBoxWindow);
//			WindowFactory.register(WindowFactory.SAFE_BOX_LOGIN_WINDOW, PopUpSafeBoxLoginWindow);
//			WindowFactory.register(WindowFactory.FADE_TIP_WINDOW, PopUpFadeOutWindow);
//			WindowFactory.register(WindowFactory.SAFE_BOX_PASS_WINDOW, PopUpSafeBoxSetPwdWindow);
//			WindowFactory.register(WindowFactory.CHAT_DETAIL_WINDOW, ChatDetailView);
		}
	}
}