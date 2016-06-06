package com.jzgame.view.table.ui
{
	import com.spellife.feathers.SLLabel;
	import com.spellife.util.HtmlTransCenter;
	import com.starling.theme.StyleProvider;
	
	import flash.text.TextFormatAlign;
	
	import starling.display.Shape;
	import starling.display.Sprite;
	
	public class CardNumView extends Sprite
	{
		/***********
		 * name:    CardNumView
		 * data:    Jan 29, 2016
		 * author:  jim
		 * des:     牌的总点数
		 ***********/
		private var _text:SLLabel;
		private var _back:Shape;
		public function CardNumView()
		{
			super();
			
			
			_back = new Shape();
			_back.graphics.beginFill(0x0,.6);
			_back.graphics.drawRoundRect(0,0,100,30,10);
			addChild(_back);
			
			_text = new SLLabel();
			_text.setSize(100,30);
			_text.y = 3;
			_text.textRendererProperties.textFormat = StyleProvider.getTF(0xffffff,18,HtmlTransCenter.Arial(),TextFormatAlign.CENTER);
			addChild(_text);
		}
		
		public function set chip(value:String):void
		{
			_text.text = value;
		}
	}
}