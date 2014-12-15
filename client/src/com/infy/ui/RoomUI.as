package com.infy.ui
{
	import com.infy.layer.Layer;
	import com.infy.layer.LayerManager;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	/**
	 * 
	 * @long  Nov 26, 2014
	 * 
	 */	
	public class RoomUI extends WebDesignUI
	{
		private var m_loading:LoadingUI;
		private var m_loadingProgress:int = 0;
		
		public function RoomUI()
		{
			super();
			init();
		}
		
		private function init():void
		{	
			curStep = 0;
			loadingProgress = 0;			
		}
		
		/**
		 *	指定UI目前狀態 
		 * @param _type
		 * 
		 */		
		public function set type(_type:int):void
		{
			curStep = _type;			
		}
		
		
		
		public function showLoading(msg:String = ""):void
		{
			if(m_loading == null)
				m_loading = new LoadingUI();
			
			m_loading.alpha = 0.75;
			m_loading.loadObject = msg;
			loadingProgress = 0;
			//this.addChild(m_loading);
			LayerManager.instance.addChildAt(m_loading, Layer.TOP);
		}
		
		public function hideLoading():void
		{
			if(m_loading.parent)
			{
				/*LayerManager.instance.curLayerIndex = Layer.TOP;
				LayerManager.instance.removeChild(m_loading);*/
				m_loading.parent.removeChild(m_loading);
			}				
		}
		
		public function set loadingProgress(value:int):void
		{
			if(m_loading == null)
				m_loading = new LoadingUI();
			
			m_loadingProgress = value;
			m_loading.curProgress = value;
		}
		
		public function get loadingProgress():int
		{
			return m_loadingProgress;
		}
		
		public function resize():void
		{
			m_loading.x = (stage.stageWidth - 260/*m_loading.width*/)/2;
			m_loading.y = 250;
		}
			
		
		public function show(value:Boolean):void
		{
			this.visible = value;
		}
		
	}
}