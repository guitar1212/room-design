package com.infy.stage
{
	import com.infy.game.RoomGame;
	
	import flash.display.Loader;
	import flash.net.URLRequest;
	
	import src.DesignViewItemVO;

	/**
	 * 
	 * @long  Dec 1, 2014
	 * 
	 */	
	public class DesignRoomStage extends StageBase
	{
		public function DesignRoomStage(game:RoomGame)
		{
			super(game);
		}
		
		override public function initilaize():void
		{
			super.initilaize();
			game.ui.type = 1;
			game.ui.showLoading(0);
			game.ui.cbMouseClick = onNextStage;
			game.ui.cbLabelItemClick = onLabelItemClick
			
			// show 3d view
			game.show3DView();
			
			init3D();
			
			//test
			test();
		}
		
		
		override public function release():void
		{
			super.release();
			game.ui.cbMouseClick = null;
			game.ui.cbLabelItemClick = null;
		}
		
		private function test():void
		{
			game.ui.labelItemArray = ["空間氣氛", "寢具家飾", "文創小物", "特色點心", "衛浴用品"];
			game.ui.labelItemCurChoose = 0;
			
			onLabelItemClick(0);
		}
		
		
		private function init3D():void
		{
			
		}
		
		
		private function onLabelItemClick(index:int):void
		{
			var type:int = 0;
			setItems(type);
		}
		
		private function setItems(type:int):void
		{
			var itemArr:Array = getItemsByType(type);
			
			var goodsVOArr:Array = [];
			for(var i:int = 0; i < itemArr.length; i++)
			{
				var vo:DesignViewItemVO = new DesignViewItemVO();
				vo.id = itemArr[i];
				var path:String = "..\\assets\\pic\\icon\\" + itemArr[i] + ".jpg";
				var l:Loader = new Loader();
				l.load(new URLRequest(path));			
				
				vo.itemIcon = l;
				goodsVOArr.push(vo);
			}
			
			game.ui.goodsVOArr = goodsVOArr;
		}
		
		private function getItemsByType(type:int):Array
		{
			var arr:Array = [];
			
			// test
			for(var i:int = 1; i < 8; i++)
			{
				var id:String = "item01_00" + i;
				arr.push(id);
			}
			
			return arr;
		}
		
		override public function update():void
		{
			super.update();
		}
		
		private function onNextStage():void
		{
			StageManager.instance.changeStage(3);
		}
	}
}