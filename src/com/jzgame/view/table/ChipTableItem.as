package com.jzgame.view.table
{
	import com.jzgame.common.utils.ResManager;
	import com.jzgame.enmu.Card;
	import com.jzgame.enmu.TableInfoUtil;
	import com.jzgame.model.TableModel;
	import com.jzgame.util.CardInfoUtil;
	import com.jzgame.util.NumUtil;
	
	import feathers.controls.Label;
	import feathers.display.Scale3Image;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class ChipTableItem extends Sprite
	{
		/***********
		 * name:    ChipTableItem
		 * data:    Nov 19, 2015
		 * author:  jim
		 * des:
		 ***********/
		private var _back:Scale3Image;
		private var _icon:Image;
		private var _text:Label;
		public function ChipTableItem()
		{
			super();
			
			init();
		}
		
		private function init():void
		{
//			var s3:Scale3Textures = new Scale3Textures(ResManager.tableAssets.getTexture("s9_table_bg_mychips"),20,5);
//			_back = new Scale3Image(s3);
//			_back.width = 100;
//			addChild(_back);
//			
//			_icon = new Image(ResManager.tableAssets.getTexture("table_icon_chips"));
//			addChild(_icon);
//			
//			_text = new Label();
//			_text.width = 100;
//			_text.textRendererProperties.textFormat = new TextFormat(HtmlTransCenter.Arial(),18,0xffbf4f);
//			_text.textRendererProperties.textFormat.align = TextFieldAutoSize.CENTER;
//			addChild(_text);
		}
		/**
		 * 设置筹码数 
		 * @param v
		 * 
		 */		
		public function set num(v:Number):void
		{
			var list:Array = NumUtil.splitClip(v);
			for(var i:String in list)
			{
				_icon = new Image(ResManager.blackAssets.getTexture("zhuozi_icon_"+list[i]));
				addChild(_icon);
			}
//			_text.text = v.toString();
		}
		
		public function get num():Number
		{
			return 0;
			return Number(_text.text);
		}
	}
}