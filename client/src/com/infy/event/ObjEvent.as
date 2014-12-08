package com.infy.event
{
	import flash.events.Event;
	
	/**
	 * 
	 * @long  Dec 3, 2014
	 * 
	 */	
	public class ObjEvent extends Event
	{
		public static const CHANGE:String = "obj_change";
		
		public var attribute:String;
		
		public var value:Number;
		
		public function ObjEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}