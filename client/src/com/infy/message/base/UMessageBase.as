package com.infy.message.base
{
	import com.infy.message.MessageManager;

	/**
	 * 
	 * @long  Dec 1, 2014
	 * 
	 */	
	public class UMessageBase
	{		
		private var m_Message:Object = {};
		
		public function UMessageBase()
		{
			m_Message['params'] = [];
		}
		
		public function send():void
		{
			MessageManager.instance.send(this);
		}

		public function get mode():int
		{
			return m_Message["mode"];
		}

		public function set mode(value:int):void
		{
			m_Message["mode"] = value;
		}
		
		/**
		 * 設定int
		 * @param index index從0開始
		 * @param value 要加入的數值
		 */
		protected function addInt(index:int, value:int):void
		{
			m_Message['params'][index] = value;
		}
		
		/**
		 * 設定String
		 * @param index index從0開始
		 * @param value 要加入的數值
		 */
		protected function addString(index:int, value:String):void
		{
			m_Message['params'][index] = value;
		}
		
		/**
		 * 設定Number
		 * @param index index從0開始
		 * @param value 要加入的數值 
		 */
		protected function addNumber(index:int, value:Number):void
		{
			m_Message['params'][index] = value;
		}
		
		protected function addObject(index:int, obj:Object):void
		{
			m_Message['params'][index] = obj;
		}
		
		public function get data():Array
		{
			return m_Message['params'];
		}

	}
}