package com.jzgame.context
{
	import com.jzgame.bundle.MyBundle;
	import com.jzgame.enmu.ReleaseUtil;
	import com.starling.view.StarlingGame;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	
	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.extensions.signalCommandMap.SignalCommandMapExtension;
	import robotlegs.bender.framework.impl.Context;
	import robotlegs.extensions.starlingViewMap.StarlingViewMapExtension;
	
	import starling.core.Starling;
	
	public class MainContext extends Sprite
	{
		private var _context:Context;
		private var _starling:Starling;
		public function MainContext()
		{
			super();
			this.mouseEnabled = this.mouseChildren = false;
			addEventListener(Event.ADDED_TO_STAGE, start);
		}
		
		private function start(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, start);
			
			var deviceSize:Rectangle = new Rectangle(0, 0,
				Math.max(stage.fullScreenWidth, stage.fullScreenHeight),
				Math.min(stage.fullScreenWidth, stage.fullScreenHeight));

			var dpi:Number = Capabilities.screenDPI;
			var dpWide:Number = stage.fullScreenWidth * 160 / dpi;
			var inchesWide:Number = stage.fullScreenWidth / dpi;
			
			var serverString:String = unescape(Capabilities.serverString);
			var reportedDpi:Number = Number(serverString.split("&DP=", 2)[1]);
			
			var guiSize:Rectangle = new Rectangle(0, 0, 960, 640);
			var appScale:Number = 1;
			var appSize:Rectangle = guiSize.clone();
			var appLeftOffset:Number = 0;
			//这里要寻找sacle大的，即时超框也不要黑边
			// if device is wider than GUI's aspect ratio, height determines scale
			if ((deviceSize.width/deviceSize.height) < (guiSize.width/guiSize.height)) {
				appScale = deviceSize.height / guiSize.height;
				appSize.width = deviceSize.width / appScale;
				appLeftOffset = Math.round((appSize.width - guiSize.width) / 2);
			} 
				// if device is taller than GUI's aspect ratio, width determines scale
			else {
				appScale = deviceSize.width / guiSize.width;
				appSize.height = deviceSize.height / appScale;
				appLeftOffset = 0;
			}
//			// scale the entire interface
//			base.scale = appScale;
//			
//			// map stays at the top left and fills the whole screen
//			base.map.x = 0;
//			
//			// menus are centered horizontally
//			base.menus.x = appLeftOffset;
//			
//			// crop some menus which are designed to run off the sides of the screen
//			base.scrollRect = appSize;
			
//			this.scaleX = this.scaleY = appScale;
			
			ReleaseUtil.SCALEX = ReleaseUtil.SCALEY = appScale;
			
			initStarling();
			
			init();
		}
		
		private function init():void
		{
			_context = new Context().install( MyBundle,SignalCommandMapExtension,StarlingViewMapExtension ).configure(new ContextView(this) ,_starling) as Context;
		}
		
		/**
		 * configure and start Starling
		 */
		private function initStarling():void {
			_starling = new Starling(StarlingGame,stage);
			//屏幕的实际尺寸
			trace(ReleaseUtil.STAGE_WIDTH,ReleaseUtil.STAGE_HEIGHT);
			//窗口要设置成实际尺寸分辨率
			_starling.viewPort = new Rectangle(0,0,ReleaseUtil.STAGE_WIDTH,ReleaseUtil.STAGE_HEIGHT);
			_starling.showStats = false;
			_starling.antiAliasing = 1;
			_starling.start();
			//场景要设置成实际尺寸分辨率
			_starling.stage.stageWidth = ReleaseUtil.STAGE_WIDTH ;
			_starling.stage.stageHeight = ReleaseUtil.STAGE_HEIGHT ;
		}
	}
}