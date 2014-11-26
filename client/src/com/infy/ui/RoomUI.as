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
		private var m_testBG:Bitmap;
		
		public function RoomUI()
		{
			super();
			init();
		}
		
		private function init():void
		{			 
			toggleTestBg()
		}
		
		public function toggleTestBg():void
		{
			if(m_testBG == null)
				m_testBG = new RoomDesign.RoomBackground() as Bitmap;		
			
			if(m_testBG.parent == null)
				this.addChildAt(m_testBG, 0);
			else
				this.removeChild(m_testBG);
		}
		
	}
}