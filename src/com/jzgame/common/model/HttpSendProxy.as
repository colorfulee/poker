package com.jzgame.common.model
{
	import com.jzgame.common.services.MessageType;
	import com.jzgame.common.services.http.HttpRequest;
	import com.jzgame.common.services.http.events.HttpRequestEvent;
	import com.jzgame.common.utils.AssetsCenter;
	

	public class HttpSendProxy
	{
		/*auther     :jim
		* file       :HttpSendProxy.as
		* date       :Jan 16, 2015
		* description:http 通讯代理
		*/
		public function HttpSendProxy()
		{
		}
		
		public static function getPlayerInfo():void
		{
			var requestVo:HttpRequest = new HttpRequest();
			requestVo.name = MessageType.GET_PLAYER_INFO;
			requestVo.data = [];
			var event:HttpRequestEvent = new HttpRequestEvent(requestVo);
			AssetsCenter.eventDispatcher.dispatchEvent(event);
		}
	}
}