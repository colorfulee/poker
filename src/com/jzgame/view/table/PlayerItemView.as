package com.jzgame.view.table
{
	import com.jzgame.common.utils.ResManager;
	import com.jzgame.enmu.SystemColor;
	import com.jzgame.util.WindowFactory;
	import com.spellife.display.PopUpWindowManager;
	import com.spellife.feathers.SLImageLoader;
	import com.spellife.feathers.SLLabel;
	import com.spellife.util.HtmlTransCenter;
	import com.spellife.util.MathUtil;
	import com.spellife.util.RealGameTimer;
	import com.starling.theme.StyleProvider;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import extend.PixelMaskDisplayObject;
	
	import feathers.controls.Label;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class PlayerItemView extends Sprite
	{
		/***********
		 * name:    PlayerItemView
		 * data:    Nov 17, 2015
		 * author:  jim
		 * des:
		 ***********/
		public var userId:uint;
		private var _isMine:Boolean = false;
		private var _back:Image;
		private var _countMask:Image;
		private var count:Scale9Image;
		private var itemMask:Shape;
		private var speed:Number=-0.02;;
		private var _upadateTimer:RealGameTimer;
		//座位信息
		public var seat:uint;
		private var _chip:Label;
		private var _face:SLImageLoader;
		private var _name:SLLabel;
		private var _countLabel:Label;
		//牌型
//		public var cardType:CardTypeView;
		
		public function PlayerItemView()
		{
			super();
			
			init();
		}
		
		private function init():void
		{
			var tx:Texture = ResManager.blackAssets.getTexture("GameSceneAtlas-#000097");
			this.pivotX = Math.floor(tx.width * 0.5);
			this.pivotY = Math.floor(tx.height * 0.5);
			_back = new Image(tx);
			addChild(_back);
			
			_face = new SLImageLoader(new Rectangle(48,44,50,50));
			addChild(_face);
			
			_chip = new Label();
			_chip.text = "1999";
			_chip.x = 70;
			_chip.y = 50;
			_chip.width = 100;
			
			_chip.textRendererProperties.textFormat = StyleProvider.getTF(SystemColor.WHITE,16,HtmlTransCenter.Arial(),TextFormatAlign.CENTER);
			addChild(_chip);
			
			_name = new SLLabel();
			_name.text = "1999";
			_name.setLocation(70,15);
			_name.width = 100;
			_name.textRendererProperties.textFormat = StyleProvider.getTF(SystemColor.WHITE,16,HtmlTransCenter.Arial(),TextFormatAlign.CENTER);
			addChild(_name);
			
			_countLabel = new Label();
			_countLabel.text = "0";
			_countLabel.width = 100;
			_countLabel.y = 50;
			_countLabel.textRendererProperties.textFormat = StyleProvider.getTF(SystemColor.WHITE,16,HtmlTransCenter.Arial(),TextFormatAlign.CENTER);
			addChild(_countLabel);
			_countLabel.visible = false;
			
			bindCounting();
			
//			cardType = new CardTypeView();
//			cardType.y = 150 - 8;
//			cardType.x = -4;
//			addChild(cardType);
			
			_upadateTimer = new RealGameTimer(20);
		}
		/**
		 * 设置头像 
		 * @param url
		 * 
		 */		
		public function setFace(url:String):void
		{
			_face.source = url;
		}
		/**
		 * 
		 * @param chip
		 * 
		 */		
		public function setChip(chip:uint):void
		{
			_chip.text = chip.toString();
		}
		/**
		 * 
		 * @param value
		 * 
		 */		
		public function setName(value:String):void
		{
			_name.text = value
		}
		/**
		 * 停止倒计时 
		 * 
		 */		
		public function hideCounting():void
		{
			count.visible = false;
			_countLabel.visible = false;
			_upadateTimer.stop();
		}
		/**
		 * 是否为本人 
		 * @param b
		 * 
		 */		
		public function isMine(b:Boolean):void
		{
			_isMine = b;
			if(!_isMine)
			{
//				cardType.visible = false;
			}else
			{
				
			}
//			this.addEventListener(TouchEvent.TOUCH, showOtherDetail);
		}
		
		private function showOtherDetail(e:TouchEvent):void
		{
			if(e.getTouch(this,TouchPhase.ENDED))
			{
				if(_isMine)
				{
					PopUpWindowManager.centerPopUpWindow(
						WindowFactory.addPopUpWindow(WindowFactory.MY_INFO_WINDOW) as DisplayObject);
				}else
				{
					PopUpWindowManager.centerPopUpWindow(
						WindowFactory.addPopUpWindow(WindowFactory.OTHER_USER_INFO_WINDOW,null,userId,seat) as DisplayObject);
				}
			}
		}
		/**
		 * 结算 
		 * 
		 */		
		public function result():void
		{
			hideCounting();
			returnNormal();
		}
		/**
		 * 重置恢复 
		 * 
		 */		
		public function reset():void
		{
			hideCounting();
			returnNormal();
		}
		/**
		 * 重置 
		 * 
		 */		
		private function returnNormal():void
		{
//			cardType.reset();
		}
		/**
		 * 
		 * @param count
		 * 
		 */		
		public function setCount(count:Number):void
		{
			_countLabel.text = count.toString();
		}
		/**
		 * 设置倒计时 
		 * @param time
		 * 
		 */		
		public function showCounting(time:Number):void
		{
			_countLabel.visible = true;
			count.visible = true;
			_cd = time;
			
			speed = -2 / (1000 * _cd / (1000 / 50));
			
			setCount(_cd);
//			showCountintLabel(_cd);
			//			_countLabel.text = cd.toString();
			//			set_stateText( cd.toString() );
//			_countBg.visible = true;
//			count.visible = true;
			pass = 0;
			ag   = 2;//2为满圆
			_upadateTimer.addEventListener(TimerEvent.TIMER,drawAll);
			_upadateTimer.start();
//			
//			drawAll(null);
//			itemMask.graphics.clear();
//			itemMask.graphics.beginFill(0xffaa00,.8);
//			MathUtil.drawSector(itemMask.graphics,count.width * 0.5 ,count.height * 0.5,Math.min(stage.stageWidth,stage.stageHeight)*.15,type ?  2 * Math.PI * 3 / 4 : Math.PI*(2 * 3 / 4-ag),Math.PI * ag);
//			itemMask.graphics.endFill();
		}
		
		private function bindCounting():void
		{
			var s9:Scale9Textures = new Scale9Textures(ResManager.tableAssets.getTexture("s9_table_bg_countdown"),new Rectangle(10,10,1,1));
			count = new Scale9Image(s9);
			count.width = 190;
			count.height = 88;
			count.visible = false;
			count.y = -4;
			count.x = 8;
			itemMask = new Shape;
			itemMask.graphics.beginFill(0);
			itemMask.graphics.drawCircle(0,0,100);
			itemMask.graphics.endFill();
//			addChild(itemMask);
//			count.visible = false;
//			addChild(count);
			
			// for masks with animation:
			var maskedDisplayObject:PixelMaskDisplayObject = new PixelMaskDisplayObject();
			maskedDisplayObject.addChild(count);
			maskedDisplayObject.mask = itemMask;
			addChild(maskedDisplayObject);
			
			return;
//			speed = -2 / (10000 / (1000 / 50));
		}
		
		private var pass:uint = 0;
		private var _cd:Number = 0;
		private var ag:Number = 0;
		private var type:Boolean = false;
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
			setCount(Math.ceil(_cd - (pass / 1000)));
//			showCountintLabel(Math.ceil(_cd - (pass / 1000)));
			//			_countLabel.text = Math.ceil(_cd - (pass / 1000)).toString() + "″";
			
			if((pass-_cd*1000) >= 0)
			{
				stopTimer();
			}
			
			ag += speed;
			if(ag<=0){
				//				type = !type;
				//				speed = -speed;
				_upadateTimer.removeEventListener(Event.ENTER_FRAME,drawAll);
				_upadateTimer.stop();
			}
			//			else if(ag<=0){
			//				type = !type;
			//				speed = -speed;
			//			}
			itemMask.graphics.clear();
			itemMask.graphics.beginFill(0xffaa00,.8);
			MathUtil.drawSector(itemMask.graphics,count.width * 0.5 ,count.height * 0.5,110,type ?  2 * Math.PI * 3 / 4 : Math.PI*(2 * 3 / 4-ag),Math.PI * ag);
			
			itemMask.graphics.endFill();
		}
		
		/**
		 * 关闭时间 
		 * 
		 */		
		private function stopTimer():void
		{
			_upadateTimer.removeEventListener(TimerEvent.TIMER,drawAll);
			_upadateTimer.stop();
			//			_timer.removeEventListener(TimerEvent.TIMER,update);
			//			_timer.stop();
		}
		
		override public function dispose():void
		{
			super.dispose();
			this.removeEventListener(TouchEvent.TOUCH, showOtherDetail);
		}
	}
}