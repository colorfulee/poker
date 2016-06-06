package com.jzgame.view.table.ui
{
	import com.jzgame.common.utils.ResManager;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class ArrowView extends Sprite
	{
		/***********
		 * name:    ArrowView
		 * data:    Jan 27, 2016
		 * author:  jim
		 * des:
		 ***********/
		private var _img:Image;
		public function ArrowView()
		{
			super();
			
			init();
		}
		
		private function init():void
		{
			var t:Texture = ResManager.blackAssets.getTexture('arrow');
			_img = new Image(t);
			addChild(_img);
			
			
			this.pivotX = t.width * 0.5;
		}
	}
}