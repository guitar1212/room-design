package com.infy.message
{
	import com.infy.message.base.UMessageBase;
	
	public class UTestMessage extends UMessageBase
	{
		public function UTestMessage()
		{
			super();
			this.mode = 101;
		}
		
		public function set userID(id:String):void
		{
			this.addString(0, id);
		}
		
		public function set context(msg:Array):void
		{
			this.addObject(1, msg);
		}
		
	}
}