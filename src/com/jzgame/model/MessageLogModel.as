package com.jzgame.model
{
	import com.jzgame.vo.commu.SendSingleMessage;
	
	import flash.utils.Dictionary;

	public class MessageLogModel
	{
		/***********
		 * name:    MessageLogModel
		 * data:    Jan 22, 2016
		 * author:  jim
		 * des:     消息模块记录匹配
		 ***********/
		private var _lib:Dictionary = new Dictionary();
		
		public function MessageLogModel()
		{
		}
		
		public function addMessage(v:SendSingleMessage):void
		{
			_lib[v.i] = v;
		}
		
		public function getMessageByIndex(i:int):SendSingleMessage
		{
			return _lib[i];
		}
		
		public function removeMessage(i:int):void
		{
			delete _lib[i];
		}
	}
}