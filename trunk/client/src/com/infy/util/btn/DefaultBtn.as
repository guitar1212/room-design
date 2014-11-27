package com.infy.util.btn
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * 
	 * @long  Nov 21, 2014
	 * 
	 */	
	public class DefaultBtn extends Sprite
	{
		private var m_text:TextField = new TextField();
		private var m_cb:Function = null;
		
		public function DefaultBtn(text:String, callback:Function, width:int = 70, height:int = 25, color:uint = 0xaaaaaa, alpha:Number = 0.7)
		{
			super();
			
			m_text.text = text;
			m_text.x = 5;
			m_text.y = 5;
			this.addChild(m_text);
			
			this.graphics.beginFill(color, alpha);
			this.graphics.drawRect(0, 0, width, height);
			this.graphics.endFill();
			
			this.buttonMode = true;
			this.useHandCursor = true;
			this.mouseChildren = false;
			
			this.addEventListener(MouseEvent.CLICK, onMouseClick);
			
			m_cb = callback;
		}
		
		protected function onMouseClick(event:MouseEvent):void
		{
			if(m_cb != null)
				m_cb();			
		}
		 
	}
}