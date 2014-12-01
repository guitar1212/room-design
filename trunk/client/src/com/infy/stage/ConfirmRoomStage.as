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