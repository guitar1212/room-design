package com.infy.parser.command
{
	import com.infy.event.RoomEvent;
	
	import flash.events.EventDispatcher;
	
	/**
	 * 
	 * @long  Dec 19, 2014
	 * 
	 */	
	public class LightParserCommand extends ParserCommandBase implements IParserCommand
	{
		public var name:String;
		
		public var type:String;
		
		public function LightParserCommand(dispatcher:EventDispatcher, args:Array=null)
		{
			super(dispatcher, args);
		}
		
		override public function excute():void
		{
			var event:RoomEvent = new RoomEvent(RoomEvent.CREATE_LIGHT);
			this.dispatchEvent(event);
		}
		
		override public function toString():String
		{
			return "";
		}
	}
}