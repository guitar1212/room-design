package com.infy.event
{
	import flash.events.Event;
	
	/**
	 * 
	 * @long  Dec 15, 2014
	 * 
	 */	
	public class RoomEvent extends Event
	{
		public static const CREATE_OBJECT:String = "create_object";
		
		public var objType:String = "";
		
		public function RoomEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}