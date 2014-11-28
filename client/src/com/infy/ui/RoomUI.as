package com.infy.ui
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	/**
	 * 
	 * @long  Nov 26, 2014
	 * 
	 */	
	public class RoomUI extends Sprite
	{
		private var m_ui:WebDesignUI;
		
		public function RoomUI()
		{
			super();
			init();
		}
		
		private function init():void
		{			 
			m_ui = new WebDesignUI();
			this.addChild(m_ui);
			
			m_ui.curStep = 0;
			toggleTestBg()
		}
		
		/**
		 *	指定UI目前狀態 
		 * @param _type
		 * 
		 */		
		public function set type(_type:int):void
		{
			m_ui.curStep = _type;
		}
		
		public function toggleTestBg():void
		{	
			
		}
		
	}
}