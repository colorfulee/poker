package com.jzgame.view.table
{
	import com.jzgame.common.utils.LangManager;
	import com.jzgame.common.utils.ResManager;
	import com.jzgame.common.utils.SignalCenter;
	import com.spellife.feathers.SLLabel;
	import com.spellife.util.HtmlTransCenter;
	import com.starling.theme.StyleProvider;
	
	import flash.text.TextFormatAlign;
	
	import feathers.display.Scale9Image;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class SitDownButton extends Sprite
	{
		/***********
		 * name:    SitDownButton
		 * data:    Nov 18, 2015
		 * author:  jim
		 * des:
		 ***********/
		private var _back:Scale9Image;
		private var _arrow:Image;
		private var _text:SLLabel;
		private var _seat:uint;
		public function SitDownButton(seat:uint)
		{
			super();
			
			_seat = seat;
			
			init();
		}
		
		private function init():void
		{
			this.touchable = true;
			this.touchGroup = true;
			
			var texture:Texture = ResManager.blackAssets.getTexture("sit"+_seat);
			_arrow = new Image(texture);
			_arrow.pivotX = texture.width * 0.5;
			_arrow.pivotY = texture.height * 0.5;
			addChild(_arrow);
			
			_text = new SLLabel();
			_text.text = LangManager.getText('900001');
			_text.setSize(100,30);
			_text.x = -50;
			switch(_seat)
			{
				case 1:
					_text.x -= 7;
					_text.y -= 18;
					_arrow.rotation += Math.PI * (270 / 180);
					break;
				case 2:
					_arrow.rotation += Math.PI * (310 / 180);
					_text.x -= 10;
					_text.y -= 13;
					break;
				case 3:
					_text.y -= 13;
					break;
				case 4:
					_arrow.rotation += Math.PI * (50 / 180);
					_text.x += 6;
					_text.y -= 13;
					break;
				case 5:
					_arrow.rotation += Math.PI * (85 / 180);
					_text.x += 6;
					_text.y -= 13;
					break;
			}
			_text.textRendererProperties.textFormat = StyleProvider.getTF(0xffffff,18,HtmlTransCenter.Arial(),TextFormatAlign.CENTER);
			addChild(_text);
			
			this.addEventListener(TouchEvent.TOUCH,touch);
		}
		/**
		 * 点击 
		 * @param e
		 * 
		 */		
		private function touch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this,TouchPhase.ENDED);
			if(touch)
			{
				SignalCenter.onSitDownArrowTriggered.dispatch(this.name);
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			this.removeEventListener(TouchEvent.TOUCH,touch);
		}
	}
}