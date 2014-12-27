package com.infy.message
{
	import com.infy.message.base.DMessageBase;
	
	public class DTestMessage extends DMessageBase
	{
		public function DTestMessage()
		{
			super();
		}
		
		public function get New():Array
		{
			return this.getArray("new");
		}
		
		public function get Time():String
		{
			return this.getString("time");
		}
	}
}