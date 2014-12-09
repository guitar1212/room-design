package com.infy.stage
{
	import com.infy.game.RoomGame;

	/**
	 * 
	 * @long  Dec 1, 2014
	 * 
	 */	
	public class ConfirmRoomStage extends StageBase
	{
		public function ConfirmRoomStage(game:RoomGame)
		{
			super(game);
		}
		
		override public function initilaize():void
		{
			super.initilaize();
			game.ui.type = 2;
			
			game.ui.cbBtnChooseClick = onButtonClick;
			
			setButton();
		}
		
		override public function release():void
		{
			super.release();
			
			game.ui.cbBtnChooseClick = null;
		}
		
		private function setButton():void
		{
			// TODO Auto Generated method stub
			var btnArr:Array = ["重新設計", "設計存檔", "線上訂房"];
			
			game.ui.btnArray = btnArr;
		}
		
		private function onButtonClick(index:int):void
		{
			if(index == 0)
			{
				StageManager.instance.changeStage(1);
			}
			else if(index == 1)
			{
				saveDesignRoom();
			}
			else if(index == 2)
			{
				linkOrderRoom();
			}
		}
		
		private function linkOrderRoom():void
		{
			// TODO Auto Generated method stub
			
		}
		
		private function saveDesignRoom():void
		{
			// TODO Auto Generated method stub
			
		}		
		
		override public function update():void
		{
			super.update();
		}
	}
}