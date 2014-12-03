package com.infy.event
{
	import flash.events.Event;
	
	public class CameraEvent extends Event
	{
		public static const CHANGE:String = "change";
		
		public var attribute:String;
		
		public var value:Number;
		
		public function CameraEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
		}
	}
}