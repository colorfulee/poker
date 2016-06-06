package com.jzgame.mediator.commu
{
	import com.jzgame.common.utils.SignalCenter;
	import com.jzgame.view.windows.commu.PopUpLoadingWindow;
	
	import robotlegs.extensions.starlingViewMap.impl.StarlingMediator;
	
	public class PopUpLoadingWindowMediator extends StarlingMediator
	{
		/***********
		 * name:    PopUpLoadingWindowMediator
		 * data:    Mar 3, 2016
		 * author:  jim
		 * des:
		 ***********/
		[Inject]
		public var view:PopUpLoadingWindow;
		public function PopUpLoadingWindowMediator()
		{
			super();
		}
		
		override public function initialize():void
		{
			SignalCenter.onShowProgress.add(progressHandler);
		}
		
		override public function destroy():void
		{
			SignalCenter.onShowProgress.remove(progressHandler);
		}
		
		private function progressHandler(value:String):void
		{
			view.label.text = value;
		}
	}
}