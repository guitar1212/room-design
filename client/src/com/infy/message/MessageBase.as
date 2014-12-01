package com.infy.message
{
	/**
	 * 
	 * @long  Dec 1, 2014
	 * 
	 */	
	public class MessageBase
	{
		private var m_mode:int;
		
		public function MessageBase()
		{
		}
		
		public function send():void
		{
			
		}

		public function get mode():int
		{
			return m_mode;
		}

		public function set mode(value:int):void
		{
			m_mode = value;
		}

	}
}