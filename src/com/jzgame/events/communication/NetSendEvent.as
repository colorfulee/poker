package com.jzgame.events.communication
{
	/** 
	 * @Content 
	 * @Author jim 
	 * @Version 1.0.0 
	 * @Date：Apr 11, 2013 10:31:27 AM 
	 * @description:
	 */ 
	import com.jzgame.enmu.NetEventType;
	import com.jzgame.vo.commu.SendSingleMessage;
	
	import flash.events.Event;
	
	public class NetSendEvent extends Event
	{
		public var messageType:uint;
		//json 转化的字符串
		public var content:SendSingleMessage;
		
		public function NetSendEvent(content_:SendSingleMessage)
		{
			messageType = content_.m;
			content     = content_;
			super(NetEventType.SEND, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new NetSendEvent(content);
		}
	}
}