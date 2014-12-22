package com.infy.room
{
	/**
	 * 
	 * @long  Nov 26, 2014
	 * 
	 */	
	public class RoomInfo
	{
		/**
		 *	房型編號 
		 */		
		public var id:String;
		
		/**
		 *	房間名稱 
		 */		
		public var roomName:String;
		
		/**
		 *	房間描述 
		 */		
		public var describtion:String;
		
		/**
		 *	視角數量 
		 */		
		public var numViewPoints:int;
		
		/**
		 *	視角 
		 */		
		public var viewPoints:Array = [];
		
		/**
		 *	物品種類數量 
		 */		
		public var numItems:int;
		
		/**
		 *	可擺設的物品 
		 * @see RoomItemInfo
		 */		
		public var items:Vector.<RoomItemInfo> = new Vector.<RoomItemInfo>();
		
		public function RoomInfo()
		{
		}
	}
}