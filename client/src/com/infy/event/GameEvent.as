package com.infy.event
{
	import flash.display.BitmapData;
	import flash.events.Event;
	
	/**
	 * 
	 * @long  Dec 24, 2014
	 * 
	 */	
	public class GameEvent extends Event
	{
		public static const CAPTURE_SCREEN_COMPLETE:String = "capturescreencomplete";
		
		public var bitmapData:BitmapData;
		
		public function GameEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}