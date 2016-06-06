package com.jzgame.common.controller
{
	import com.jzgame.common.services.HttpService;
	import com.jzgame.common.services.http.HttpRequest;
	import com.jzgame.common.services.http.events.HttpRequestEvent;
	import com.jzgame.common.utils.ExternalVars;
	
	import flash.events.IEventDispatcher;
	
	import robotlegs.bender.bundles.mvcs.Command;
	
	/**
	 * 通过http发送请求
	 * @author Rakuten
	 * 
	 */
	public class HttpRequestCommand extends Command
	{
		public function HttpRequestCommand()
		{
			super();
		}
		
		[Inject]
		public var event:HttpRequestEvent;
		
		[Inject]
		public var httpService:HttpService;
		
		[Inject]
		public var eventDispatcher:IEventDispatcher;
		
		override public function execute():void
		{
			httpService.gateway = ExternalVars.gateway+'?uid='+ExternalVars.userID;
			//			http://192.168.1.52:8080/j21web/players/{uid}
			httpService.send(event.data as HttpRequest);
		}
	}
}

