package com.infy.task
{
	/**
	 * 
	 * @long  Dec 15, 2014
	 * 
	 */	
	public class Task
	{
		private var m_ckeckFunction:Function = null;
		
		private var m_bEnd:Boolean = false;
		
		public function Task(checkFunction:Function = null)
		{
			m_ckeckFunction = checkFunction; 
		}
		
		public function onStart():void
		{
			m_bEnd = false;
		}
		
		public function onCheck():Boolean
		{
			if(m_ckeckFunction != null)
			{
				return m_ckeckFunction();
			} 
			else
				return false;
		}
		
		public function onUpdate():void			
		{
			if(m_bEnd) return;

		}
		
		public function onEnd():void
		{
			m_bEnd = true;
		}
	}
}