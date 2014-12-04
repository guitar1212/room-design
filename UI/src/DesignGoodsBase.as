package src
{
	import flash.display.MovieClip;
	import src.DesignViewItemVO;
	import flash.events.MouseEvent;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class DesignGoodsBase extends MovieClip
	{
		private var m_vo:DesignViewItemVO;
		private var m_id:String = "";
		public var cbItemDown:Function = null;
		public var cbItemUp:Function = null;
		
		public function DesignGoodsBase() 
		{
			// constructor code
			this["itemOver"].visible = false;
			this["itemOver"].mouseEnabled = false;
			this.addEventListener(MouseEvent.MOUSE_OVER,onOver);
			this.addEventListener(MouseEvent.MOUSE_OUT,onOut);
			this.addEventListener(MouseEvent.MOUSE_DOWN,onitemDown);
			this.addEventListener(MouseEvent.MOUSE_UP,onitemUp);
			
		}
		
		private function onOver(e:MouseEvent):void
		{
			this["itemOver"].visible = true;
		}
		private function onOut(e:MouseEvent):void
		{
			this["itemOver"].visible = false;
		}
		
		public function setPic(pic:DisplayObject):void
		{
			this.addSingleChild(this["goodsAnchor"],pic);
		}
		public function setId(id:String):void
		{
			m_id = id;
		}
		
		private function addSingleChild(mc:DisplayObjectContainer, child:DisplayObject = null):void
		{
			while(mc.numChildren > 0)
			{
				mc.removeChildAt(0);
			}			
			
			if(child != null)
			{
				mc.addChild(child);
			}							
		}
		
		private function onitemDown(e:MouseEvent):void
		{
			if (cbItemDown != null)
				cbItemDown(m_id);
		}
		
		private function onitemUp(e:MouseEvent):void
		{
			if (cbItemUp != null)
				cbItemUp(m_id);
		}

	}
	
}
