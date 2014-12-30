package com.infy.hotel
{
	import com.infy.room.RoomInfo;

	/**
	 * 
	 * @long  Dec 9, 2014
	 * 
	 */	
	public class HotelInfo
	{
		public var id:String = "";
		
		public var roomCounts:int = 0;
		
		/**
		 *	房間資訊
		 * @see RoomInfo 
		 */		
		public var roomData:Array = [];
		
		public function HotelInfo()
		{
		}
		
		public function getRoomInfo(roomId:String):RoomInfo
		{
			var roomInfo:RoomInfo;
			for(var i:int = 0; i < roomData.length; i++)
			{
				var info:RoomInfo = roomData[i] as RoomInfo;
				if(info.id == roomId)
				{
					roomInfo = info;
					break;
				}
			}
			return roomInfo;
		}
	}
}