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

		//private var m_testBG:Bitmap;
		private var m_testView:testView = null;
		
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
		
		public function set type(_type:int):void
		{
			m_ui.curStep = _type;
		}
		
		public function toggleTestBg():void
		{
			if(m_testView)
			{
				m_ui.viewObject = null;
				m_testView = null;				
			}
			else
			{
				m_testView = new testView();
				m_ui.viewObject = m_testView;
			}
			/*if(m_testBG == null)
				m_testBG = new RoomDesign.RoomBackground() as Bitmap;		
			
			if(m_testBG.parent == null)
				this.addChildAt(m_testBG, 0);
			else
				this.removeChild(m_testBG);*/
		}
		
	}
}