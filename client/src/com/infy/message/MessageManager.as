package com.infy.message
{
	/**
	 * 
	 * @long  Dec 1, 2014
	 * 
	 */	
	public class MessageManager
	{
		private static var m_instance:MessageManager = null;
		
		private var m_host:String;
		private var m_port:String;
		
		public function MessageManager()
		{
		}
		
		public static function get instance():MessageManager
		{
			if(m_instance == null)
				m_instance = new MessageManager();
			
			return m_instance;
		}
		
		public function set host(value:String):void
		{
			m_host = value;
		}
		
		public function set port(value:String):void
		{
			m_port = value;
		}
	}
}