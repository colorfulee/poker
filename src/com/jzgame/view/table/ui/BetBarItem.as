package com.jzgame.view.table.ui
{
	import com.jzgame.common.model.NetSendProxy;
	import com.jzgame.view.table.ChipTableItem;
	
	import feathers.controls.renderers.DefaultListItemRenderer;
	
	import starling.events.Event;
	
	public class BetBarItem extends DefaultListItemRenderer
	{
		/***********
		 * name:    BetBarItem
		 * data:    Jan 26, 2016
		 * author:  jim
		 * des:
		 ***********/
		private var _icon:ChipTableItem;
		private var _num:Number = 0;
		public function BetBarItem()
		{
			super();
			
			_icon = new ChipTableItem();
			addChild(_icon);
			
			this.addEventListener(Event.TRIGGERED, betHandler);
		}
		
		override public function set data(value:Object):void
		{
			super.data = value;
			if(!value)return;
			_num = Number(value);
			_icon.num = Number(value);
		}
		/**
		 * 下注 
		 * @param e
		 * 
		 */		
		private function betHandler(e:Event):void
		{
			NetSendProxy.bet(_num);
		}
	}
}