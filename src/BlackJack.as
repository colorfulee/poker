package
{
	import com.hurlant.crypto.prng.ARC4;
	import com.hurlant.util.Base64;
	import com.hurlant.util.Hex;
	import com.jzgame.common.utils.AssetsCenter;
	import com.jzgame.common.utils.ExternalVars;
	import com.jzgame.context.MainContext;
	import com.jzgame.enmu.ReleaseUtil;
	
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuBuiltInItems;
	import flash.ui.ContextMenuItem;
	import flash.utils.ByteArray;
	
	import starling.core.Starling;
	
	[SWF(width="960", height="640", frameRate="50", backgroundColor="#0")]
	public class BlackJack extends Sprite
	{
		/***********
		 * name:    BlackJack
		 * data:    Jan 19, 2016
		 * author:  jim
		 * des:
		 ***********/
		private var starling:Starling;
		private var _mainContext:MainContext;
		
		
		public function BlackJack()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			var info:LoaderInfo = this.stage.loaderInfo;
			
			ExternalVars.initialize(info);
			
			new AssetsCenter(info.parameters.res ? info.parameters.res : "",ExternalVars.language);
			
			_mainContext = new MainContext();
			addChild(_mainContext);
			
			initMenu();
			return;
			var d:URLLoader = new URLLoader();
			d.dataFormat = URLLoaderDataFormat.BINARY;
			d.addEventListener(Event.COMPLETE, decodeHandler);
			d.load(new URLRequest('test.data'));
		}
		
		private function decodeHandler(e:Event):void
		{
			var d:URLLoader = e.currentTarget as URLLoader;
			var byte:ByteArray = d.data as ByteArray;
//			trace(byte.length);
			var key:ByteArray = Hex.toArray(Hex.fromString('0123456789abcdef'));
			var rc4:ARC4 = new ARC4(key);
			rc4.decrypt(byte);
//			trace(byte.readUTFBytes(byte.bytesAvailable));
			var out:String = Hex.fromArray(byte);
////			Hex.toString(out);
			trace(Hex.toString(out));
			trace(Base64.decode(out));
			return;
		}
		
		private var myContextMenu:ContextMenu;
		/**
		 * 初始化版本号 
		 * 
		 */	
		public function initMenu():void {
			myContextMenu = new ContextMenu();
			removeDefaultItems();
			addCustomMenuItems();
			this.contextMenu = myContextMenu;
		}
		
		private function removeDefaultItems():void {
			myContextMenu.hideBuiltInItems();
			
			var defaultItems:ContextMenuBuiltInItems = myContextMenu.builtInItems;
			defaultItems.print = true;
		}
		
		private function addCustomMenuItems():void {
			var item:ContextMenuItem = new ContextMenuItem(ReleaseUtil.VERSION);
			myContextMenu.customItems.push(item);
		}
		
	}
}