package com.infy.layer
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	 * 
	 * @long  Nov 26, 2014
	 * 
	 */	
	public class LayerManager extends Sprite
	{
		private static var m_instance:LayerManager = null;
		
		private var m_layerList:Array = [];
		
		private var m_curLayer:int = 0;
		
		
		public function LayerManager()
		{
			super();
			initialize();
		}
		
		public static function get instance():LayerManager
		{
			if(m_instance == null)
				m_instance = new LayerManager();
					
			return m_instance;
		}
		
		private function initialize():void
		{
			for(var i:int = 0; i < Layer.TOTAL_LAYERS; i++)
			{				
				m_layerList.push(super.addChild(new Sprite()));
			}
			
		}
		
		public function getLayer(index:int):Sprite
		{
			return m_layerList[index];
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			var l:Sprite = getLayer(curLayerIndex);
			return l.addChild(child);
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			var l:Sprite = getLayer(index);
			return l.addChild(child);
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			var l:Sprite = getLayer(curLayerIndex);
			return l.removeChild(child);
		}
		
		override public function removeChildAt(index:int):DisplayObject
		{
			var l:Sprite = getLayer(curLayerIndex);
			return l.removeChildAt(index);
		}

		public function get curLayerIndex():int
		{
			return m_curLayer;
		}

		public function set curLayerIndex(value:int):void
		{
			m_curLayer = value;
		}

	}
}