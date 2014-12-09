package com.infy.stage
{
	import com.infy.game.RoomGame;
	import com.infy.hotel.HotelInfo;
	
	import src.DesignViewItemVO;

	/**
	 * 
	 * @long  Dec 1, 2014
	 * 
	 */	
	public class SelectRoomStage extends StageBase
	{
		public function SelectRoomStage(game:RoomGame)
		{
			super(game);
		}
		
		override public function initilaize():void
		{
			super.initilaize();
			game.ui.show(true);
			game.ui.type = 0;
			game.ui.loadingProgress = 0;
			game.hide3DView();
						
			game.ui.cbMouseClick = onNextStage;
			game.ui.cbItemClick = onViewPointClick;
			game.ui.cbLabelClick = onRoomSelect;
			
			
			//test
			setRoomData(null);
			game.ui.labelCurChoose = 0;
		}
		
		
		override public function release():void
		{
			super.release();
			game.ui.cbMouseClick = null;
			game.ui.cbItemClick = null;
			game.ui.cbLabelClick = null;
			
			game.ui.labelArray = [];
		}
		
		override public function update():void
		{
			super.update();
		}
		
		
		private function setRoomData(hotelInfo:HotelInfo):void
		{
			var numRooms:int = 2;
			game.ui.labelArray = ["二人房", "四人房"];
			
			
			onRoomSelect(0);
		}
		
		private function onRoomSelect(index:int):void
		{
			game.ui.roomIntroDesc = "這就是房間 " + index + " 的介紹";
		}
		
		private function onViewPointClick(index:int):void
		{
			// TODO Auto Generated method stub
			
		}
		
		private function onNextStage():void
		{
			StageManager.instance.changeStage(2);
		}
	}
}