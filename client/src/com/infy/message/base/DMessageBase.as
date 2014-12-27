package com.infy.message.base
{
	/**
	 * 
	 * @long  Dec 8, 2014
	 * 
	 */	
	public class DMessageBase
	{
		private var m_data:Object = null;
		
		/**
		 * 數值類型的錯誤回傳值
		 */
		public const ERROR_VALUE:int = -9999;
		
		public function DMessageBase()
		{
		}
		
		/**
		 * 設定接收到的訊息內容 
		 */
		public function set Data(data:Object):void
		{
			m_data = data;
		}
		
		/**
		 * 取得接收到的訊息內容 
		 */
		public function get Data():Object
		{
			return m_data;
		}
		
		/**
		 * 取得int
		 * @param index index從0開始 
		 * @return 如果有錯, 回傳ERROR_VALUE
		 */
		protected function getInt(index:int):int
		{
			if(m_data != null)
			{
				return m_data[index.toString()];
			}
			else
			{ 
				trace("m_data is null");
				return ERROR_VALUE;
			}
		} 
		
		/**
		 * 取得String
		 * @param index index從0開始 
		 * @return 回果有錯, 回傳""
		 */
		protected function getString(key:String):String
		{
			if(m_data != null)
			{
				return m_data[key];
			}
			else
			{ 
				trace("m_data is null");
				return "";
			}
		}
		
		protected function getArray(key:String):Array
		{
			return m_data[key] as Array;
		}
		
		/**
		 * 取得Number
		 * @param index index從0開始 
		 * @return 如果有錯, 回傳ERROR_VALUE
		 */
		protected function getNumber(index:int):Number
		{
			if(m_data != null)
			{
				return m_data[index.toString()];
			}
			else
			{ 
				trace("m_data is null");
				return ERROR_VALUE;
			}
		}
	}
}