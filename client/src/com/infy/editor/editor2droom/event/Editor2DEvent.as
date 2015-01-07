package com.infy.editor.editor2droom.event
{
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * 
	 * @long  Jan 7, 2015
	 * 
	 */	
	public class Editor2DEvent extends Event
	{
		public static const CREATE:String = "create2DObject";
		
		public var name:String = "";
		
		public var style:String = "";
		
		public var position:Point = new Point();
		
		public var size:Point = new Point(10, 10);
		
		public var depth:Number = 1;
		
		public var rotation:Number = 0;
		
		public var color:uint = 0xffffff;
		
		/**
		 *	for drawCircle 
		 */		
		public var radius:Number = 1;
		
		public function Editor2DEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}