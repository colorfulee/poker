package com.jzgame.vo.commu
{
	public class SendSingleMessage
	{
		/***********
		 * name:    SendSingleMessage
		 * data:    Jan 20, 2016
		 * author:  jim
		 * des:
		 ***********/
		//自加
		public var i:uint;
		//参数
		public var p:Array = [];
		//消息id
		public var m:uint;
		public function SendSingleMessage()
		{
		}
		
		public function toString():String
		{
			return 'index:'+i+',method:'+m+',p:'+p;
		}
	}
}