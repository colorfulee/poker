package com.jzgame.view.table.ui
{
	import feathers.controls.List;
	import feathers.data.ListCollection;
	import feathers.layout.HorizontalLayout;
	
	import starling.display.Sprite;
	
	public class BetBar extends Sprite
	{
		/***********
		 * name:    BetBar
		 * data:    Jan 26, 2016
		 * author:  jim
		 * des:
		 ***********/
		public var list:List;
		public function BetBar()
		{
			super();
			
			init();
		}
		
		private function init():void
		{
			list = new List();
			list.setSize(500,100);
			list.itemRendererType = BetBarItem;
			list.dataProvider = new ListCollection([50,100,200,500]);
			
			var layout:HorizontalLayout = new HorizontalLayout();
			layout.gap = 10;
			list.itemRendererProperties.width = 100;
			list.layout = layout;
			addChild(list);
		}
	}
}