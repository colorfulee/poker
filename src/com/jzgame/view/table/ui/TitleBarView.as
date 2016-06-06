package com.jzgame.view.table.ui
{
	import com.jzgame.common.utils.ResManager;
	import com.spellife.feathers.SLLabel;
	import com.spellife.util.HtmlTransCenter;
	import com.starling.theme.StyleProvider;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class TitleBarView extends Sprite
	{
		/***********
		 * name:    TitleBarView
		 * data:    Jan 26, 2016
		 * author:  jim
		 * des:
		 ***********/
		private var _back:Image;
		private var _chip:SLLabel;
		private var _lv:SLLabel;
		public function TitleBarView()
		{
			super();
			
			init();
		}
		
		private function init():void
		{
			_back = new Image(ResManager.blackAssets.getTexture('title'));
			addChild(_back);
			
			_chip = new SLLabel();
			_chip.setLocation(60,10);
			_chip.setSize(100,30);
			_chip.textRendererProperties.textFormat = StyleProvider.getTF(0xffffff,15,HtmlTransCenter.Arial());
			addChild(_chip);
			
			_lv = new SLLabel();
			_lv.setSize(100,30);
			_lv.setLocation(330,10);
			_lv.textRendererProperties.textFormat = StyleProvider.getTF(0xffffff,15,HtmlTransCenter.Arial());
			addChild(_lv);
		}
		
		public function set chip(v:Number):void
		{
			_chip.text = v.toString();
			_lv.text = 'lv.10';
		}
	}
}