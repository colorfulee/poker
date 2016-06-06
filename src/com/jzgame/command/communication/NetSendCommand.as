package com.jzgame.command.communication
{
	import com.hurlant.crypto.prng.ARC4;
	import com.hurlant.util.Hex;
	import com.jzgame.common.services.SocketService;
	import com.jzgame.common.services.socket.NetPackageUnit;
	import com.jzgame.common.utils.logging.Tracer;
	import com.jzgame.events.communication.NetSendEvent;
	import com.jzgame.model.GameModel;
	import com.jzgame.model.MessageLogModel;
	import com.jzgame.model.UserModel;
	
	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;
	
	import robotlegs.bender.bundles.mvcs.Command;

	/** 
	 * @Content 
	 * @Author jim 
	 * @Version 1.0.0 
	 * @Date：Apr 11, 2013 10:30:07 AM 
	 * @description:
	 */ 
	public class NetSendCommand extends Command
	{
		[Inject]
		public var server:SocketService;
		[Inject]
		public var event:NetSendEvent;
		[Inject]
		public var message:MessageLogModel;
		
		[Inject]
		public var userModel:UserModel;
		
		[Inject]
		public var gameModel:GameModel;
		
		[Inject]
		public var eventDispatcher:IEventDispatcher;
		public function NetSendCommand()
		{
			super();
		}
		
		override public function execute():void
		{
			if(gameModel.guide) return;
			
			var packetUnit:NetPackageUnit = new NetPackageUnit();
			
			switch(event.messageType)
			{
				default:
					packetUnit.msgCmd = event.messageType;
					event.content.i = server.index;
					//转成json字符串
					var string:String = JSON.stringify(event.content);

					//计算crc32
					var byte:ByteArray = new ByteArray;
					byte.writeUTFBytes(string);
					
					//加密rc4
					var key:String = 'UpToHi\\(^o^)/';
					var keyByte:ByteArray = Hex.toArray(Hex.fromString(key));
					
					var rc4:ARC4 = new ARC4(keyByte);
					rc4.encrypt(byte);
					
					server.index ++;
					userModel.crc32.reset();
					userModel.crc32.update(byte);
					trace(userModel.crc32.getValue(),0xffff & userModel.crc32.getValue());
					//写入加密后
					packetUnit.writeBytes(byte);
					
					packetUnit.writeShort(0xffff & userModel.crc32.getValue());
					packetUnit.getReady();
					var debugStr:String = userModel.myInfo.uNickName+"向服务器发送数据:"+packetUnit.msgCmd + ':' + string;
					Tracer.debug(debugStr);
					//记录消息内容
					message.addMessage(event.content);
					server.send(packetUnit);
					break;
			}
		}
	}
}