package com.infy.stage
{
	import com.infy.game.RoomGame;

	/**
	 * 
	 * @long  Dec 1, 2014
	 * 
	 */	
	public class StageBase implements IStage
	{
		private var m_game:RoomGame;
		
		public function StageBase(g:RoomGame)
		{
			m_game = g;
		}
		
		public function initilaize():void
		{
			
		}
		
		public function update():void
		{
			
		}
		
		public function release():void
		{
			
		}
		
		public function get game():RoomGame
		{
			return m_game;
		}
	}
}