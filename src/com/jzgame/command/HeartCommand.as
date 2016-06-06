package com.jzgame.command
{
	import com.jzgame.common.services.SocketService;
	
	import flash.events.IEventDispatcher;
	
	import robotlegs.bender.bundles.mvcs.Command;
	
	public class HeartCommand extends Command
	{
		/***********
		 * name:    HeartCommand
		 * data:    Jun 9, 2015
		 * author:  jim
		 * des:心跳
		 ***********/
		
		[Inject]
		public var socket:SocketService;
		[Inject]
		public var eventDis:IEventDispatcher;
		public function HeartCommand()
		{
			super();
		}
		
		override public function execute():void
		{
			if(socket.connected)
			{
//				SocketSendProxy.sendHeart();
			}else
			{
			}
		}
	}
}