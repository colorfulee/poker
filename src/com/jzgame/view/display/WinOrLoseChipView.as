package com.jzgame.view.display
{
	import com.spellife.feathers.SLLabel;
	import com.spellife.util.HtmlTransCenter;
	import com.starling.theme.StyleProvider;
	
	import starling.display.Sprite;
	
	public class WinOrLoseChipView extends Sprite
	{
		/***********
		 * name:    WinOrLoseChipView
		 * data:    Jan 29, 2016
		 * author:  jim
		 * des:
		 ***********/
		public function WinOrLoseChipView(chip:Number)
		{
			super();
			
			var text:SLLabel = new SLLabel();
			text.textRendererProperties.textFormat = StyleProvider.getTF(0xffffff,40,HtmlTransCenter.Arial());
			addChild(text);
			
			text.text = chip.toString();
		}
	}
}