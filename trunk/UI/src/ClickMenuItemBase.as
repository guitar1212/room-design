package src
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;

	public class ClickMenuItemBase extends MovieClip
	{
		private var m_id:String = "";
		public var cbMenuClick:Function = null;
		
		public function ClickMenuItemBase() 
		{
			// constructor code
			this["itemOver"].visible = false;
			this["itemOver"].mouseEnabled = false;
			this["infoTf"].mouseEnabled = false;
			this.buttonMode = true;
			this.addEventListener(MouseEvent.MOUSE_OVER,onOver);
			this.addEventListener(MouseEvent.MOUSE_OUT,onOut);
			this.addEventListener(MouseEvent.CLICK,onMenuClick);
		}
		
		private function onOver(e:MouseEvent):void
		{
			this["itemOver"].visible = true;
		}
		private function onOut(e:MouseEvent):void
		{
			this["itemOver"].visible = false;
		}
		
		public function set menuInfo(str:String):void
		{
			(this["infoTf"] as TextField).text = str;
		}
		public function set menuId(id:String):void
		{
			m_id = id;
		}
		
		private function onMenuClick(e:MouseEvent):void
		{
			if (cbMenuClick != null)
				cbMenuClick(m_id);
		}

	}
	
}
