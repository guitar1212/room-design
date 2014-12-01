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
			game.ui.type = 0;
			game.ui.loadingProgress = 0;
			game.hide3DView();
		}
		
		override public function release():void
		{
			super.release();	
		}
		
		override public function update():void
		{
			super.update();
		}
	}
}