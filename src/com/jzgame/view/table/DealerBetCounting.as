package com.jzgame.view.table
{
	import com.jzgame.common.utils.ResManager;
	import com.spellife.util.MathUtil;
	import com.spellife.util.RealGameTimer;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	
	import extend.PixelMaskDisplayObject;
	
	import starling.display.Image;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class DealerBetCounting extends Sprite
	{
		/***********
		 * name:    DealerBetCounting
		 * data:    Jan 25, 2016
		 * author:  jim
		 * des:     下注倒計時
		 ***********/
		private var _screen:Image;
		private var _back:Image;
		private var _itemMask:Shape;
		private var maskedDisplayObject:PixelMaskDisplayObject;
		private var _cd:Number = 0;
		private var _speed:Number = 1;
		private var _upadateTimer:RealGameTimer;
		public function DealerBetCounting()
		{
			super();
			
			this.touchable = false;
			
			init();
		}
		//半徑
		private var _randus:Number = 400;
		private function init():void
		{
			_screen = new Image(ResManager.blackAssets.getTexture('GameScen00007'));
			addChild(_screen);
			var tx:Texture = ResManager.blackAssets.getTexture('GameSceneAtlas-#00007');
			_back = new Image(tx);
//			_back.pivotX = tx.width * 0.5;
//			_back.pivotY = tx.height * 0.5;
			_back.scale = 2;
			_back.x = -10;
			_back.y = -12;
//			addChild(_back);
			_itemMask = new Shape;
			_itemMask.graphics.beginFill(0);
			_itemMask.graphics.drawCircle(0,0,_randus);
			_itemMask.graphics.endFill();
			_itemMask.x = _randus - 100;
			_itemMask.y = 0;
//			addChild(_itemMask);
			// for masks with animation:
			maskedDisplayObject = new PixelMaskDisplayObject();
			maskedDisplayObject.addChild(_back);
			maskedDisplayObject.mask = _itemMask;
			addChild(maskedDisplayObject);
			
			_upadateTimer = new RealGameTimer(20);
		}
		private var pass:Number = 0;
		private var ag:Number = 2;
		private var type:Boolean = false;
		/**
		 * 设置倒计时 
		 * @param time
		 * 
		 */		
		public function showCounting(time:Number):void
		{
			maskedDisplayObject.visible = true;
			_cd = time;
			
			_speed = -1 / (1000 * _cd / (1000 / 50));
			
			pass = 0;
			ag   = 2.0;//2为满圆
			_upadateTimer.addEventListener(TimerEvent.TIMER,drawAll);
			_upadateTimer.start();
			
			drawAll(null);
		}
		
		/**
		 * 画扇形 
		 * @param e
		 * 
		 */		
		private function drawAll(e:TimerEvent):void
		{
			pass += 20;
			if(pass>= _cd * .6 * 1000)
			{
				//				dispatchEvent(new SimpleEvent(EventType.SHAKE_HAND_POKER,seat));
			}else if(pass >= _cd * .3 * 1000)
			{
			}
			
			if((pass-_cd*1000) >= 0)
			{
				stopTimer();
			}
			
			ag += _speed;
			if(ag<=0){
				_upadateTimer.removeEventListener(Event.ENTER_FRAME,drawAll);
				_upadateTimer.stop();
			}
			_itemMask.graphics.clear();
			_itemMask.graphics.beginFill(0xffaa00,.8);
			MathUtil.drawSector(_itemMask.graphics,0 ,0,_randus,Math.PI*(2 -ag),Math.PI * ag);

//			MathUtil.drawSingleSector(_itemMask.graphics,0 ,0,60-_speed,250);
//			MathUtil.drawSector(_itemMask.graphics,0 ,0,_randus,Math.PI * 2 + Math.PI * (2-ag)-Math.PI / 26 ,Math.PI * ag / 2 + 0.3);
			_itemMask.graphics.endFill();
		}
		/**
		 * 停止倒计时 
		 * 
		 */		
		public function hideCounting():void
		{
			_upadateTimer.stop();
			
			maskedDisplayObject.visible = false;
		}
		
		/**
		 * 关闭时间 
		 * 
		 */		
		private function stopTimer():void
		{
			trace('stopTimer');
			_upadateTimer.removeEventListener(TimerEvent.TIMER,drawAll);
			_upadateTimer.stop();
		}
		
	}
}