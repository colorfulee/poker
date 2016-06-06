package com.jzgame.modules.operate
{
	import com.jzgame.common.utils.ResManager;
	import com.jzgame.view.table.ui.BetBar;
	import com.spellife.util.HtmlTransCenter;
	import com.starling.theme.StyleProvider;
	
	import feathers.controls.Button;
	
	import org.osflash.signals.Signal;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class OperateView extends Sprite
	{
		/***********
		 * name:    OperateView
		 * data:    Nov 18, 2015
		 * author:  jim
		 * des:
		 ***********/
		//双倍
		public var doubleButton:Button;
		//分牌
		public var splitButton:Button;
		//停止要牌
		public var standCardButton:Button;
		//要牌
		public var hitButton:Button;
		//下注
		public var betBar:BetBar;
		//加注
		public var raiseSlider:RaiseSlider;
		//下注结束按钮
		public var betBtn:Button;
		public var container:Sprite = new Sprite;
		
		public var trigged:Signal = new Signal(Button);
		public function OperateView()
		{
			super();
			
			init();
		}
		
		private function init():void
		{
			container.x = 300;
			addChild(container);
			
			raiseSlider = new RaiseSlider();
			raiseSlider.x = 466;
			raiseSlider.y = -raiseSlider.height + 70;
			container.addChild(raiseSlider);
			raiseSlider.visible = false;
			
			doubleButton = new Button();
			doubleButton.styleProvider = null;
			doubleButton.defaultSkin = new Image(ResManager.blackAssets.getTexture("double"));
			doubleButton.disabledSkin = new Image(ResManager.blackAssets.getTexture("doubleGray"));
			container.addChild(doubleButton);
			doubleButton.x = 0;
			doubleButton.y = 0;
			
			splitButton = new Button();
			splitButton.styleProvider = null;
			splitButton.defaultSkin = new Image(ResManager.blackAssets.getTexture("split"));
			splitButton.disabledSkin = new Image(ResManager.blackAssets.getTexture("splitGray"));
			container.addChild(splitButton);
			splitButton.x = 100;
			splitButton.y = 0;
			
			splitButton.isEnabled = false;
			
			standCardButton = new Button();
			standCardButton.styleProvider = null;
			standCardButton.defaultSkin = new Image(ResManager.blackAssets.getTexture("standIcon"));
			standCardButton.disabledSkin = new Image(ResManager.blackAssets.getTexture("standGrayIcon"));
			container.addChild(standCardButton);
			standCardButton.x = 100 * 2;
			standCardButton.y = 0;
			
			hitButton = new Button();
			hitButton.styleProvider = null;
			hitButton.defaultSkin = new Image(ResManager.blackAssets.getTexture("hit"));
			hitButton.disabledSkin = new Image(ResManager.blackAssets.getTexture("hitGray"));
			container.addChild(hitButton);
			hitButton.x = 100 * 3;
			hitButton.y = 0;
			
			
			doubleButton.addEventListener(Event.TRIGGERED, operate);
			splitButton.addEventListener(Event.TRIGGERED, operate);
			standCardButton.addEventListener(Event.TRIGGERED, operate);
			hitButton.addEventListener(Event.TRIGGERED, operate);
			
			betBar = new BetBar();
			betBar.x = 330;
			betBar.y = 30;
			addChild(betBar);
			
			betBtn = new Button();
			betBtn.styleProvider = null;
			betBtn.defaultSkin = new Image(ResManager.blackAssets.getTexture('details_btn_recharge1'));
			betBtn.downSkin = new Image(ResManager.blackAssets.getTexture('details_btn_recharge2'));
			betBtn.label = "下注结束";
			betBtn.defaultLabelProperties.textFormat = StyleProvider.getTF(0xffffff,18,HtmlTransCenter.Arial());
			betBtn.x = 175;
			betBtn.y = 30;
			addChild(betBtn);
			
			hideAll();
		}
		/**
		 * 操作事件 
		 * @param ev
		 * 
		 */		
		private function operate(ev:Event):void
		{
			trigged.dispatch(ev.currentTarget);
		}
		/**
		 * 弃牌 
		 * 
		 */	
		public function fold():void
		{
			hideAll();
		}
		/**
		 *站起来 
		 * 
		 */		
		public function standUp():void
		{
			container.visible = false;
		}
		
		/**
		 * 是否是我自己的回合
		 * @param value
		 * 
		 */		
		public function set myTurn(value:Boolean):void
		{
			hideAll();
			
			if(value)
			{
				container.visible = true;
			}else
			{
				container.visible = false;
			}
		}
		
		/**
		 * 自己坐下  
		 * @param showJackPotBet  是否显示
		 * 
		 */			
		public function sitDown(showJackPotBet:Boolean = false):void
		{
			hideAll();
//			
			if(showJackPotBet)
			{
//				_jackPotBetView.visible = true;
			}else
			{
//				waitingContainer.visible = true;
			}
		}
		/**
		 * 等待开局 
		 * 
		 */		
		public function waitStart():void
		{
			hideAll();
		}
		/**
		 * 显示下注 
		 * 
		 */		
		public function showBet(b:Boolean = false):void
		{
			betBar.visible = b;
		}
		/**
		 * 显示操作 
		 * @param b
		 * 
		 */		
		public function showOperate(b:Boolean = false):void
		{
			container.visible = b;
		}
		
		private function hideAll():void
		{
			container.visible = false;
			betBtn.visible = false;
			betBar.visible = false;
		}
		
		override public function dispose():void
		{
			doubleButton.removeEventListener(Event.TRIGGERED, operate);
			splitButton.removeEventListener(Event.TRIGGERED, operate);
			standCardButton.removeEventListener(Event.TRIGGERED, operate);
			hitButton.removeEventListener(Event.TRIGGERED, operate);
			super.dispose();
		}
	}
}