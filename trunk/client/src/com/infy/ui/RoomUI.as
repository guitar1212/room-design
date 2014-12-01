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
		
		private var m_loading:LoadingUI;
		
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
			loadingProgress = 0;
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
		
		
		
		public function showLoading(progress:int = -1):void
		{
			if(m_loading == null)
				m_loading = new LoadingUI();
			
			m_loading.alpha = 0.75;
			this.addChild(m_loading);
			
			if(progress > -1)
				loadingProgress = progress;
		}
		
		public function hideLoading():void
		{
			if(m_loading.parent)
				this.removeChild(m_loading);
		}
		
		public function set loadingProgress(value:int):void
		{
			if(m_loading == null)
				m_loading = new LoadingUI();
			
			m_loading.curProgress = value;
		}
		
		public function resize():void
		{
			m_loading.x = (stage.stageWidth - 260/*m_loading.width*/)/2;
			m_loading.y = 250;
		}
			
		
	}
}