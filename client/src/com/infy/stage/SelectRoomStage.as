package com.infy.stage
{
	import com.infy.game.RoomGame;

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
		}
		
		override public function release():void
		{
			super.release();
			game.ui.cbMouseClick = null;
		}
		
		override public function update():void
		{
			super.update();
		}
		
		
		private function setRoomData(room:*):void
		{
				
		}
		
		private function onNextStage():void
		{
			StageManager.instance.changeStage(2);
		}
	}
}