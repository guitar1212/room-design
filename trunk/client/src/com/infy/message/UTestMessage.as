package com.infy.message
{
	import com.infy.message.base.UMessageBase;
	
	public class UTestMessage extends UMessageBase
	{
		public function UTestMessage()
		{
			super();
		}
		
		public function set userID():void
		{
			this.addString("Long");
		}
	}
}