package com.infy.stage
{
	/**
	 * 
	 * @long  Dec 1, 2014
	 * 
	 */	
	public class StageManager
	{
		private static var m_instance:StageManager = null;
		
		private var m_stageList:Vector.<StageBase> = new Vector.<StageBase>();
		
		private var m_curStage:StageBase = null;
		
		public function StageManager()
		{
		}
		
		public static function get instance():StageManager
		{
			if(m_instance == null)
				m_instance = new StageManager();
			
			return m_instance;
		}
		
		public function addStage(s:StageBase):void
		{
			m_stageList.push(s);
		}
		
		public function changeStage(stageIdx:int):void
		{
			var newStage:StageBase = m_stageList[stageIdx];
			
			if(m_curStage)
			{
				if(m_curStage == newStage)
					return;
				
				m_curStage.release();
				m_curStage = null;
			}
			
			m_curStage = m_stageList[stageIdx];
			m_curStage.initilaize();
		}
		
		public function onUpdate():void
		{
			if(m_curStage)
			{
				m_curStage.update();
			}
		}
	}
}