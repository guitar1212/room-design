package com.infy.ui
{
	import com.infy.constant.View3DCons;
	import com.infy.layer.Layer;
	import com.infy.layer.LayerManager;
	
	/**
	 * 
	 * @long  Nov 26, 2014
	 * 
	 */	
	public class RoomUI extends WebDesignUI
	{
		private var m_loading:LoadingUI;
		private var m_simpleLoading:LoadingSimpleUI;
		private var m_confirm:ConfirmUI;
		private var m_objMenuUI:ClickMenuUI;
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
			
			m_objMenuUI = new ClickMenuUI();		
			m_objMenuUI.menuArray = ['移動', '旋轉', '刪除'];	
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
		
		public function showSimpleLoading(msg:String = ""):void
		{
			if(m_simpleLoading == null)
				m_simpleLoading = new LoadingSimpleUI();
			
			m_simpleLoading.loadObject = msg;
			LayerManager.instance.addChildAt(m_simpleLoading, Layer.TOP);
		}
		
		public function hideSimpleLoading():void
		{
			if(m_simpleLoading.parent)
			{
				m_simpleLoading.parent.removeChild(m_simpleLoading);
			}	
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
		
		public function set loadingMessage(msg:String):void
		{
			m_loading.loadObject = msg;
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
			m_loading.y = 280;
			
			if(m_confirm)
			{
				m_confirm.x = (stage.width - m_confirm.width)/2;
				m_confirm.y = View3DCons.GAP_TOP + View3DCons.HEIGHT/2;
			}
		}
			
		
		public function show(value:Boolean):void
		{
			this.visible = value;
		}
		
		public function showConfirmUI(title:String, okCB:Function, cancelCB:Function):void
		{
			if(m_confirm == null) m_confirm = new ConfirmUI();
			
			m_confirm.confirmInfo = title;
			m_confirm.cbOKClick = okCB;
			m_confirm.cbCloseClick = cancelCB;
			m_confirm.cbCancelClick = cancelCB;			
			
			LayerManager.instance.addChildAt(m_confirm, Layer.TOP);
			resize();
			
			LayerManager.instance.layerMouseEnable(Layer.UI, false);
		}
		
		public function hideConfirmUI():void
		{
			LayerManager.instance.curLayerIndex = Layer.TOP;
			LayerManager.instance.removeChild(m_confirm);
			
			LayerManager.instance.layerMouseEnable(Layer.UI, true);
		}
		
		public function set cbItemClickMenu(cb:Function):void
		{
			m_objMenuUI.cbMenuClick = cb;
		}
		
		public function showObjMenu(_x:int, _y:int):void
		{
			m_objMenuUI.x = _x;
			m_objMenuUI.y = _y;
			LayerManager.instance.addChildAt(m_objMenuUI, Layer.TOP);
		}
		
		public function hideObjMenu():void
		{
			LayerManager.instance.curLayerIndex = Layer.TOP;
			LayerManager.instance.removeChild(m_objMenuUI);
		}
		
	}
}