package com.jzgame.view.windows.commu
{
	import com.jzgame.util.WindowFactory;
	import com.spellife.display.PopUpWindow;
	import com.spellife.feathers.SLLabel;
	import com.spellife.util.HtmlTransCenter;
	import com.starling.theme.StyleProvider;
	
	import flash.text.TextFormatAlign;
	
	public class PopUpLoadingWindow extends PopUpWindow
	{
		/*auther     :jim
		* file       :PopUpCommunicateWindow.as
		* date       :Apr 14, 2015
		* description:加载资源弹窗
		*/
		public var label:SLLabel;
		public function PopUpLoadingWindow()
		{
			super();
			
			_motionEffect = null;
			_modalVisible = true;
			_isModal = true;
			_isSole = false;
			init();
		}
		
		private function init():void
		{
			label = new SLLabel();
			label.setSize(300,50);
			label.setLocation(0,0);
			label.textRendererProperties.textFormat = StyleProvider.getTF(0xffffff,24,HtmlTransCenter.Arial(),TextFormatAlign.CENTER);
			label.text = "加载中...";
			addChild(label);
//			_anim = new Swf(AssetsLoader.getAssetManager().getByteArray(String(50000 + Number(data))),AssetsLoader.getAssetManager(),500);
//			_animMovie = _anim.createMovieClip("mc_anim");
//			addChild(_animMovie);
//			_animMovie.gotoAndPlay(0);
//			var movie:MovieClip = new MovieClip(atlas.getTextures("loading"), 10);
////			movie.loop = false; // default: true
//			addChild(movie);
//			// 控制播放
//			movie.play();
////			movie.pause();
////			movie.stop();
//			
//			// 注意：添加movie到juggler
//			Starling.juggler.add(movie);
		}
		
		override protected function initShow():void
		{
		}
		
		override protected function initHide():void
		{
		}
		
		override public function get name():String
		{
			return WindowFactory.LOAD_RESOURCE;
		}
		
		override public function dispose():void
		{
			
		}
	}
}