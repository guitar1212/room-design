package com.infy.message
{
	import org.phprpc.PHPRPC_Client;

	/**
	 * 
	 * @long  Dec 1, 2014
	 * 
	 */	
	public class MessageManager
	{
		private static var m_instance:MessageManager = null;
		
		private var m_rpc:PHPRPC_Client = null;
		
		private var m_host:String;
		
		public function MessageManager()
		{
		}
		
		public static function get instance():MessageManager
		{
			if(m_instance == null)
				m_instance = new MessageManager();
			
			return m_instance;
		}
		
		public function initialize(host:String, method:String):void
		{
			m_rpc = new PHPRPC_Client(host, [method]);
			m_host = host;
		}
		
		
	}
}