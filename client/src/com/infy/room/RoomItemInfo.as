package com.infy.room
{
	/**
	 * 
	 * @long  Dec 22, 2014
	 * 
	 */	
	public class RoomItemInfo
	{
		/**
		 *	類別 
		 */		
		public var type:String;
		
		/**
		 *	ID 
		 */		
		public var id:String;
		
		/**
		 *	最大數量 
		 */		
		public var maxCounts:int;
		
		/**
		 *	使用數量 
		 */		
		public var usedCounts:int;
		
		
		/**
		 *	可使用的視角 
		 */		
		public var canUseView:Array = [];
		
		public function RoomItemInfo()
		{
		}
		
		/**
		 *	是否可使用 
		 * @return 
		 * 
		 */
		public function availale(view:String):Boolean
		{
			// 檢查數量
			if(usedCounts >= maxCounts)
			{
				return false;
			}
			// 檢查視角
			else
			{
				if(canUseView.indexOf(view) > -1)
					return true;
				else
					return false;
			}			 
		}

	}
}