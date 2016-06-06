package com.jzgame.command.game
{
	import com.jzgame.common.utils.ExternalVars;
	import com.jzgame.signals.SignalJoinSocket;
	
	import robotlegs.bender.bundles.mvcs.Command;
	
	public class JoinTableDirectCommand extends Command
	{
		/***********
		 * name:    JoinTableDirectCommand
		 * data:    Jan 21, 2016
		 * author:  jim
		 * des:
		 ***********/
		[Inject]
		public var signalJoinSocket:SignalJoinSocket;
		public function JoinTableDirectCommand()
		{
			super();
		}
		
		override public function execute():void
		{
			if(ExternalVars.socketURL == "")
			{
				signalJoinSocket.dispatch("192.168.1.52",9688);
			}else
			{
				var url:Array = ExternalVars.socketURL.split(':');
				signalJoinSocket.dispatch(String(url[0]),int(url[1]));
			}
		}
	}
}