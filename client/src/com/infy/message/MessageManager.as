package com.infy.message
{
	import com.infy.message.base.UMessageBase;
	
	import org.phprpc.PHPRPC_Client;
	import org.phprpc.PHPRPC_Error;

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
		
		private var m_reciveCallback:Function = null;
		
		private var m_completeCB:Function = null;
		
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
			m_rpc.keyLength = 1024;
			m_rpc.encryptMode = 0;
			m_host = host;
		}
		
		public function send(msg:UMessageBase):void
		{
			var mode:int = msg.mode;
			m_rpc.roomserver(mode, msg.data, phprpcCallback);
		}
		
		private function phprpcCallback(result:*, args:Array, output:String, warring:PHPRPC_Error):void
		{
			if(m_reciveCallback != null)
				m_reciveCallback(result, args, output, warring);
			
			if(result)
			{
				var mode:int = result['mode'];
				var returncode:int = result['params'][0];
				if(returncode != 0)
					throw new Error("mode" + result['mode'] + " return code = " + returncode);
				
				var data:Object = parserResult(result['params'][1]);
				
				
				MessageDispatecher.instance.dispatch(mode, data);
				
				if(m_completeCB != null)
					m_completeCB(data);
				
			}			
		}
		
		private function parserResult(rawData:*):Object
		{
			var data:Object = rawData;
			
			
			
			return data;
		}
	}
}