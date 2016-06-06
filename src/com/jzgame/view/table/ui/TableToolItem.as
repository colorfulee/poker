package com.jzgame.view.table.ui
{
	import com.jzgame.common.utils.DisplayManager;
	import com.jzgame.common.utils.LangManager;
	import com.jzgame.common.utils.ResManager;
	import com.jzgame.common.utils.SignalCenter;
	import com.starling.theme.StyleProvider;
	
	import flash.geom.Point;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.renderers.DefaultListItemRenderer;
	
	import starling.display.Image;
	import starling.display.Shape;
	import starling.events.Event;
	
	public class TableToolItem extends DefaultListItemRenderer
	{
		/***********
		 * name:    TableToolItem
		 * data:    Nov 23, 2015
		 * author:  jim
		 * des:
		 ***********/
		
		private var _icon:Image;
		private var _label:Label;
		private var _shapeButton:Button;
		public function TableToolItem()
		{
			super();
		}
		
		override protected function initialize():void
		{
			this.styleProvider = null;

			var shape:Shape = new Shape();
			
			shape.graphics.beginFill(0x5e5773,0);
			shape.graphics.drawRect(0,0,127,54);
			shape.graphics.endFill();

			var shape1:Shape = new Shape()
			shape1.graphics.clear();
			shape1.graphics.beginFill(0x5e5773,.5);
			shape1.graphics.drawRect(0,0,127,54);
			shape1.graphics.endFill();
			
			_shapeButton = new Button();
			_shapeButton.styleProvider = null;
			_shapeButton.defaultSkin = shape;
			addChild(_shapeButton);
			
			_label = new Label();
			_label.textRendererProperties.textFormat = StyleProvider.getTF(0xcee4ff,20);
			_label.setSize(60,30);
			_label.x = 0;
			_label.y = 62;
			_shapeButton.addEventListener(Event.TRIGGERED,someEventHandler);
		}
		/**
		 *  点击
		 * @param event
		 * 
		 */		
		private function someEventHandler( event:Event ):void
		{
			SignalCenter.onToolClick.dispatch(this.index);
		}
		
		override protected function commitData():void
		{
			switch(this.index + 1)
			{
				case 1:
					_icon = new Image(ResManager.blackAssets.getTexture("stand"));
					_icon.x = 5;
					addChild(_icon);
					_label.text = LangManager.getText('500234');
					break;
				case 2:
					_icon = new Image(ResManager.blackAssets.getTexture("lobby"));
					_icon.x = 5;
					addChild(_icon);
					_label.text = LangManager.getText('500235');
					break;
			}
			
			DisplayManager.centerByPoint(_icon ,new Point(27, 27 ));
			_icon.touchable = false;
		}
	}
}