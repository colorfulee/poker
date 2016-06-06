package com.jzgame.view.table.ui
{
	import com.jzgame.common.utils.ResManager;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class WaitingNextRoundView extends Sprite
	{
		/***********
		 * name:    WaitingNextRoundView
		 * data:    Feb 2, 2016
		 * author:  jim
		 * des:
		 ***********/
		private var _back:Image;
		public function WaitingNextRoundView()
		{
			super();
			
			init();
		}
		
		private function init():void
		{
			var texture:Texture = ResManager.blackAssets.getTexture('zhuozi_txt_nextround');
			_back = new Image(texture);
			addChild(_back);
			
			this.pivotX = texture.width *0.5;
			this.pivotY = texture.height * 0.5;
		}
	}
}