package com.jzgame.vo.commu
{
	import com.hurlant.crypto.prng.ARC4;
	import com.hurlant.util.Hex;
	
	import flash.utils.ByteArray;

	public class ReadSingleMessage
	{
		/***********
		 * name:    ReadSingle_message
		 * data:    Jan 20, 2016
		 * author:  jim
		 * des:
		 ***********/
		//消息index
		public var i:uint = 0;
		//消息id
		public var m:uint = 0;
		//消息主体
		private var _message:Object;
		//携带数据
		public var carryData:Object;
		private var _json:String;
		//error id
		public var eid:uint = 0;
		//error description
		public var estring:String = '';
		//crc 验证
		public var crc:Number;
		public function ReadSingleMessage(data:ByteArray,length:uint)
		{
			var key:String = 'UpToHi\\(^o^)/';
			var keyByte:ByteArray = Hex.toArray(Hex.fromString(key));
			var rc4:ARC4 = new ARC4(keyByte);
			rc4.decrypt(data);
			
			//json 减去最后两位crc
			var string:String = data.readUTFBytes(length-2);
			crc = data.readShort() & 0xffff;
			_json = string;
			_message = JSON.parse(string);
			
			i      = _message.i;
			eid     = _message.e ? _message.e : 0;
			estring = _message.s ? _message.s : '';
			//是否是主动推送的,没有索引就是主动推送
			if(i == 0)
			{
				m    = _message.n;
				carryData = _message.d;
			}else
			{
				carryData = _message.r;
			}
		}
		
		public function toString():String
		{
			return ',json:'+_json;
		}
	}
}