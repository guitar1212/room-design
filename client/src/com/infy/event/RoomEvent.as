package com.infy.event
{
	import away3d.containers.ObjectContainer3D;
	
	import flash.events.Event;
	
	/**
	 * 
	 * @long  Dec 15, 2014
	 * 
	 */	
	public class RoomEvent extends Event
	{
		public static const CREATE_OBJECT:String = "create_object";
		
		public static const CREATE_CAMERA:String = "create_camera";
		
		public var object:Object = null;
		
		public var objType:String = "";
		
		public var extra:Object = null;
		
		public function RoomEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);			
		}
		
		
	}
}