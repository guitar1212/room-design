package src
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.display.DisplayObject;
	import flash.display.Sprite;	
	import flash.events.MouseEvent;

	public class MCAsButtonBase extends MovieClip
	{
		private var m_id:String = "";
		public var cbChooseBtnClick:Function = null;
		
		public function MCAsButtonBase() 
		{
			// constructor code
			this["overMC"].visible = false;
			this["btnTf"].mouseEnabled = false;
			this.buttonMode = true;
			this.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			this.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			this.addEventListener(MouseEvent.CLICK,onMouseClick);
		}
		public function set btnId(id:String):void
		{
			m_id = id;
		}
		
		public function set btnText(nameInfo:String):void
		{
			this["btnTf"].text = nameInfo;
		}
		private function onMouseClick(e:MouseEvent):void
		{
			if (cbChooseBtnClick != null)
				cbChooseBtnClick(m_id);
		}
		private function onMouseDown(e:MouseEvent):void
		{
			this["overMC"].y += 1;
		}
		private function onMouseUp(e:MouseEvent):void
		{
			this["overMC"].y -= 1;
		}
		
		private function onMouseOver(e:MouseEvent):void
		{
			this["overMC"].visible = true;
		}
		private function onMouseOut(e:MouseEvent):void
		{
			this["overMC"].visible = false;
		}

	}
	
}
