package com.infy.stage
{
	import com.infy.game.RoomGame;

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
			
			// show 3d view
			game.show3DView();
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