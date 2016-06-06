package com.jzgame.view.table.ui
{
	import com.greensock.TweenMax;
	import com.jzgame.common.utils.ResManager;
	import com.spellife.util.HtmlTransCenter;
	import com.starling.theme.StyleProvider;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class TableUIView extends Sprite
	{
		/***********
		 * name:    TableUIView
		 * data:    Nov 18, 2015
		 * author:  jim
		 * des:
		 ***********/
		public var roomLabel:Label;
		public var toolButton:Button;
		public var toolView:TableToolView;
		public var titleBar:TitleBarView;
		
		public var arrow:ArrowView;
		//等待下一轮
		public var wait:WaitingNextRoundView;
		
		public function TableUIView()
		{
			super();
			
			init();
		}
		
		private function init():void
		{
			roomLabel = new Label;
			roomLabel.width = 200;
			roomLabel.x = 80;
			roomLabel.y = 5;
			addChild(roomLabel);
			roomLabel.textRendererProperties.textFormat = StyleProvider.getTF(0x655b76,16,HtmlTransCenter.Arial());
			roomLabel.textRendererProperties.textFormat.bold = true;
			
			toolButton = new Button();
			toolButton.styleProvider = null;
			toolButton.defaultSkin = new Image(ResManager.tableAssets.getTexture('table_btn_menu1'));
			toolButton.downSkin = new Image(ResManager.tableAssets.getTexture('table_btn_menu2'));
			addChild(toolButton);
			
			toolView = new TableToolView;
			toolView.x = 820;
			toolView.y = 50;
			addChild(toolView);

			
			arrow = new ArrowView();
			arrow.x = 475;
			arrow.y = 260;
			arrow.visible = false;
//			arrow.rotation = 10/Math.PI;
			addChild(arrow);
			
			wait = new WaitingNextRoundView();
			wait.x = 475;
			wait.y = 260;
			addChild(wait);
			
			wait.visible = false;
		}
		
		public function start():void
		{
			titleBar = new TitleBarView();
			addChild(titleBar);
		}
		/**
		 * 显示等待 页面
		 * @param b
		 */		
		public function showWait(b:Boolean = false):void
		{
			wait.visible = b;
		}
		/**
		 * 箭头指向座位 
		 * @param seat
		 * 
		 */		
		public function lookAt(seat:uint):void
		{
			arrow.visible = true;
			switch(seat)
			{
				case 1:
					TweenMax.to(arrow,.5,{rotation: Math.PI * 260 / 180})
//					arrow.rotation = Math.PI * 260 / 180;
					break;
				case 2:
					TweenMax.to(arrow,.5,{rotation: Math.PI * 300 / 180})
					arrow.rotation = Math.PI * 300 / 180;
					break;
				case 3:
					arrow.rotation = 0;
//					TweenMax.to(arrow,.5,{rotation: 0})
					break;
				case 4:
					TweenMax.to(arrow,.5,{rotation: Math.PI * 60 / 180})
//					arrow.rotation = Math.PI * 60 / 180;
					break;
				case 5:
					TweenMax.to(arrow,.5,{rotation: Math.PI * 95 / 180})
//					arrow.rotation = Math.PI * 95 / 180;
					break;
			}
		}
	}
}