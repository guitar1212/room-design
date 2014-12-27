package com.infy.stage
{
	import com.infy.game.RoomGame;
	import com.infy.message.base.DMessageBase;
	import com.infy.message.base.IMessageController;

	/**
	 * 
	 * @long  Dec 1, 2014
	 * 
	 */	
	public class StageBase implements IStage, IMessageController
	{
		private var m_game:RoomGame;
		
		public function StageBase(g:RoomGame)
		{
			m_game = g;
		}
		
		public function initilaize():void
		{
			registerMessage();
		}
		
		public function update():void
		{
			
		}
		
		public function release():void
		{
			
		}
		
		public function registerMessage():void
		{
			
		}
		
		public function reciveMessage(msg:DMessageBase):void
		{
		
		}
		
		public function get game():RoomGame
		{
			return m_game;
		}
	}
}