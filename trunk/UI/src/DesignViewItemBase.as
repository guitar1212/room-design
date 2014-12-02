package src
{
	import flash.display.MovieClip;
	import src.DesignViewItemVO;
	import flash.events.MouseEvent;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class DesignViewItemBase extends MovieClip
	{
		private var m_vo:DesignViewItemVO;
		private var m_id:String = "";
		public var cbItemClick:Function = null;
		
		public function DesignViewItemBase() 
		{
			// constructor code
			this["itemOver"].visible = false;
			this["itemOver"].mouseEnabled = false;
			this.addEventListener(MouseEvent.MOUSE_OVER,onOver);
			this.addEventListener(MouseEvent.MOUSE_OUT,onOut);
			this.addEventListener(MouseEvent.CLICK,onitemClick);
		}
		
		private function onOver(e:MouseEvent):void
		{
			this["itemOver"].visible = true;
		}
		private function onOut(e:MouseEvent):void
		{
			this["itemOver"].visible = false;
		}
		
		public function setViewPic(pic:DisplayObject):void
		{
			this.addSingleChild(this["miniViewAnchor"],pic);
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
		
		private function onitemClick(e:MouseEvent):void
		{
			if (cbItemClick != null)
				cbItemClick(m_id);
		}

	}
	
}
