package com.jzgame.common.services
{
	import com.jzgame.common.services.socket.NetPackageUnit;
	import com.jzgame.common.services.socket.SocketServiceEvent;
	import com.jzgame.common.utils.logging.Tracer;
	import com.jzgame.vo.commu.ReadSingleMessage;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.ObjectEncoding;
	import flash.net.Socket;
	import flash.system.Security;
	import flash.utils.ByteArray;
	
	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
	
	public class SocketService
	{
		private var _host:String;  
		private var _port:uint;  
		private var _socket:Socket;
		//自加计数
		public var index:Number = 1;
		private var key:String = "";
		[Inject]
		public var commandMap:IEventCommandMap;
		
		[Inject]
		public var eventDispatcher:IEventDispatcher;
		
//		[Inject]
//		public var netReceivedPackUnitModel:NetReceivedPackUnitModel;
		
		/**
		 * 连接主机端口 
		 * @param host
		 * @param port
		 * 
		 */		
		public function connect(host:String, port:uint = 80):void
		{
			_host = host;  
			_port = port;  
			_socket = new Socket();
			_socket.objectEncoding = ObjectEncoding.AMF3;            
			Security.loadPolicyFile("xmlsocket://" + host + ":" + port);  
			_socket.addEventListener(Event.CONNECT, handler);
			_socket.addEventListener(Event.CLOSE, handler);  
			_socket.addEventListener(IOErrorEvent.IO_ERROR, handler);  
			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handler);  
			_socket.addEventListener(ProgressEvent.SOCKET_DATA, handler);  
			
			_socket.connect(host, port); 
		}
		/**
		 * 主机
		 * @return 
		 * 
		 */
		public function get host():String 
		{  
			return _host;  
		}
		/**
		 * 端口
		 * @return 
		 * 
		 */          
	    public function get port():uint 
		{  
	        return _port;  
	    }  
		/**
		 * 是否连接 
		 * @return 
		 * 
		 */         
        public function get connected():Boolean 
		{  
			if(!_socket)return false;
	        return _socket.connected;  
	    }
		/**
		 * 关闭连接 
		 * 
		 */		
		public function close():void 
		{
			if(_socket.connected)
			{
				_socket.close();
			}
			_socket.removeEventListener(Event.CONNECT, handler);  
			_socket.removeEventListener(Event.CLOSE, handler);  
			_socket.removeEventListener(IOErrorEvent.IO_ERROR, handler);  
			_socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handler);  
			_socket.removeEventListener(ProgressEvent.SOCKET_DATA, handler);  
		}
		/**
		 * 发送消息 
		 * @param params
		 * 
		 */		
		public function send(params:ByteArray):void 
		{  
			if(!connected || params == null) return;
			if(params)
			{
				_socket.writeBytes(params);  
				_socket.flush();
			}else
			{
				throw new Error('send error');
			}
		}
		
		private var bytes:ByteArray = new ByteArray;
		
		private var length:Number = 0;
		/**
		 * 查找头 
		 * 
		 */		
		private function findLength():void
		{
			bytes.position = 0;
			
			// 4 bytes 为长度 32 bits unsigned integer 
			length = bytes.readUnsignedInt();
			
			trace("length:",length,"bytes.bytesAvailable:",bytes.bytesAvailable);
		}
		/**
		 *接收到消息 
		 * 
		 */		
		private function received():void 
		{
			var byte:ByteArray = new ByteArray;
			if (_socket.bytesAvailable > 0) {
				Tracer.info("_socket.bytesAvailable:"+_socket.bytesAvailable);
				//设置指针为初始位置，否则bytesAvailable属性则会不正确
				//为什么不用长度,因为如果读取了字节，长度不会自动减少
				_socket.readBytes(bytes, bytes.length, _socket.bytesAvailable); 
			}
			
			if(length == 0)
			{
				findLength();
			}
			
			if(length < NetPackageUnit.MSG_HEADER_LENGTH) return;
			//避免粘包,长度不包括头
			while(bytes.length >= (length + NetPackageUnit.MSG_HEADER_LENGTH))
			{
				var store:ByteArray = new ByteArray;
				//读取指定长度的一条消息,包括crc和header
				bytes.readBytes(store,0,length);
				var receivemessage:ReadSingleMessage = new ReadSingleMessage(store,length);
				eventDispatcher.dispatchEvent(new SocketServiceEvent(SocketServiceEvent.SOCKET_RECEIVED,receivemessage));
				var temp:ByteArray = new ByteArray;
				//把粘包的保存下来
				bytes.readBytes(temp,0,bytes.bytesAvailable);
				bytes = temp;
				if(bytes.bytesAvailable != 0)
				{
					findLength();
				}else
				{
					length = 0;
					break;
				}
			}
		}
		/**
		 * 处理句柄 
		 * @param event
		 * 
		 */         
		private function handler(event:Event):void 
		{  
			switch(event.type)
			{
				case Event.CLOSE:
					Tracer.error("Socket Connect Close!");
					eventDispatcher.dispatchEvent(new SocketServiceEvent(SocketServiceEvent.SOCKET_CLOSE));
					break;
				case Event.CONNECT:
					eventDispatcher.dispatchEvent(new SocketServiceEvent(SocketServiceEvent.SOCKET_CONNECTED));
					break;
				case IOErrorEvent.IO_ERROR:  
				case SecurityErrorEvent.SECURITY_ERROR:  
					eventDispatcher.dispatchEvent(new SocketServiceEvent(SocketServiceEvent.SOCKET_ERROR));
					Tracer.error("Socket Connect Error!");
					break;  
				case ProgressEvent.SOCKET_DATA:
					received();  
					break;  
			}
		}
	}  
}  
