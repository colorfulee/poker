package com.jzgame.mediator.table
{
	import com.jzgame.common.utils.SignalCenter;
	import com.jzgame.model.UserModel;
	import com.jzgame.view.table.ui.TitleBarView;
	
	import robotlegs.extensions.starlingViewMap.impl.StarlingMediator;
	
	public class TitleBarViewMediator extends StarlingMediator
	{
		/***********
		 * name:    TitleBarViewMediator
		 * data:    Jan 26, 2016
		 * author:  jim
		 * des:
		 ***********/
		[Inject]
		public var view:TitleBarView;
		[Inject]
		public var userModel:UserModel;
		public function TitleBarViewMediator()
		{
			super();
		}
		
		override public function initialize():void
		{
			SignalCenter.onUpdateUserInfo.add(updateInfo);
			SignalCenter.onUpdateChips.add(updateChips);
			view.chip = userModel.myInfo.uMoney;
		}
		
		override public function destroy():void
		{
			SignalCenter.onUpdateUserInfo.remove(updateInfo);
			SignalCenter.onUpdateChips.remove(updateChips);
		}
		/**
		 * 更新筹码 
		 * @param chips
		 * 
		 */		
		private function updateChips(chips:uint):void
		{
			view.chip = chips;
		}
		private function updateInfo():void
		{
			updateChips(userModel.myInfo.uMoney);	
		}
	}
}