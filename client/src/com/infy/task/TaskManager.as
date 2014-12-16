package com.infy.task
{
	/**
	 * 
	 * @long  Dec 15, 2014
	 * 
	 */	
	public class TaskManager
	{
		private static var m_instance:TaskManager  = null;
		
		private var m_taskList:Vector.<Task> = new Vector.<Task>();
		
		
		public function TaskManager()
		{
		}
		
		public static function get instance():TaskManager
		{
			if(m_instance == null)
				m_instance = new TaskManager();
			
			return m_instance;
		}
		
		public function update():void
		{
			for each(var t:Task in m_taskList)
			{
				t.onUpdate();
				if(t.onCheck())
				{
					this.removeTask(t);
				}
			}
		}
		
		public function addTask(t:Task):void
		{
			m_taskList.push(t);
			t.onStart();
		}
		
		public function removeTask(t:Task):void
		{
			var index:int = m_taskList.indexOf(t); 
			if(index > -1)
			{
				var task:Task = m_taskList.splice(index, 1)[0];
				task.onEnd();
			}
		}
	}
}