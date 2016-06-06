package com.jzgame.view.table
{
	import com.jzgame.common.utils.DisplayManager;
	import com.jzgame.common.utils.ResManager;
	import com.jzgame.enmu.ReleaseUtil;
	import com.jzgame.modules.operate.OperateView;
	import com.jzgame.view.table.ui.TableUIView;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class TableView extends Sprite
	{
		/***********
		 * name:    TableView
		 * data:    Nov 17, 2015
		 * author:  jim
		 * des:
		 ***********/
		private var _back:Image;
		private var _table:Image;
		private var _tableShade:Image;
		//下注倒计时
		public var betCounting:DealerBetCounting;
		public var handCardContainer:Sprite = new Sprite;
		public var cardContainer:Sprite = new Sprite;
		public var arrowContainer:Sprite = new Sprite;
		//邀请层
		public var inviteContainer:Sprite = new Sprite;
		//庄icon
		public var roleButton:Image;
		//====
		private var dealContainer:Sprite = new Sprite;
		private var _tableUI:TableUIView;
		private var _operate:OperateView;
		private var _players:PlayersView;
		private var _chips:ChipView;
		public function TableView()
		{
			super();
			
			init();
		}
		
		private function init():void
		{
			_back = new Image(ResManager.getTexture("tableBack"));
			addChild(_back);
			
			_table = new Image(ResManager.getTexture("tableImg"));
			_table.scale = .83;
			DisplayManager.centerByStage(_table);
//			_table.y -= 50;
			addChild(_table);
			
			_tableShade = new Image(ResManager.getTexture("tableShadeBack"));
//			_tableShade.x = 33;
//			_tableShade.y = 130;
			addChild(_tableShade);
			betCounting = new DealerBetCounting();
			betCounting.x = 260 - 110;
			betCounting.y = 120;
			betCounting.hideCounting();
			addChild(betCounting);
			
			addChild(cardContainer);
			addChild(arrowContainer);
			addChild(inviteContainer);
		}
		
		public function start():void
		{
			_operate = new OperateView;
			_operate.x = 5;
			_operate.y = ReleaseUtil.STAGE_HEIGHT - 80;
			addChild(_operate);
			
			_players = new PlayersView;
			addChild(_players);
			
			_chips = new ChipView();
			addChild(_chips);
			addChild(handCardContainer);
			addChild(dealContainer);
			_tableUI = new TableUIView;
			addChild(_tableUI);
			
			roleButton = new Image(ResManager.tableAssets.getTexture("table_icon_dealer"));
			dealContainer.addChild(roleButton);
			
			
//			var poker:PokerItemView = new PokerItemView();
//			poker.setData(CardInfoUtil.praseCardInfo(13));
//			addChild(poker);
//			var poker1:PokerItemView = new PokerItemView();
//			poker1.setData(CardInfoUtil.praseCardInfo(14));
//			poker1.x = 100;
//			addChild(poker1);
		}
	}
}