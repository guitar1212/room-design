package com.infy.stage
{
	import com.infy.game.RoomGame;
	import com.infy.message.MessageManager;
	import com.infy.str.StringTable;
	
	/**
	 * 
	 * @long  Dec 1, 2014
	 * 
	 */	
	public class InitialStage extends StageBase
	{
		private static const STEP_1_NET:int = 1;
		private static const STEP_2:int = 2;
		private static const STEP_3:int = 3;
		private static const STEP_4:int = 4;
		private static const STEP_5_FINISH:int = 5;
		
		private static const HOST:String = "";
		private static const METHOD:String = "";
		
		private var m_step:int = 0;
		
		public function InitialStage(g:RoomGame)
		{
			super(g);
		}
		
		override public function initilaize():void
		{
			super.initilaize();
			
			StringTable.initialize();
			
			game.ui.setStepInfo(0, StringTable.getString("UI_STEP", "STEP1"));
			game.ui.setStepInfo(1, StringTable.getString("UI_STEP", "STEP2"));
			game.ui.setStepInfo(2, StringTable.getString("UI_STEP", "STEP3"));
			
			game.ui.show(false);
			
			MessageManager.instance.initialize(HOST, METHOD);			
			
		}
		
		override public function release():void
		{
			super.release();	
		}
		
		override public function update():void
		{
			super.update();
			
			if(m_step == STEP_1_NET)
			{
				
			}
			else if(m_step == STEP_2)
			{
				
			}
			else if(m_step == STEP_3)
			{
				
			}
			else if(m_step == STEP_4)
			{
				
			}
			else if(m_step == STEP_5_FINISH)
			{
				m_step = 0;
				StageManager.instance.changeStage(1);
			}
		}
	}
}