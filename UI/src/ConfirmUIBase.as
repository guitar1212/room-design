package src
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class ConfirmUIBase extends MovieClip
	{	
		public var cbCloseClick:Function = null;
		public var cbOKClick:Function = null;
		public var cbCancelClick:Function = null;
		
		public function ConfirmUIBase()
		{
			// constructor code
			initUI();
		}
		
		
		
		
		
		
		private function initUI():void
		{
			this["confirmInfoTf"].mouseEnabled = false;
			this["okBtn"].mouseChildren = false;
			this["cancelBtn"].mouseChildren = false;
			this["closeBtn"].addEventListener(MouseEvent.CLICK,onCloseClick);
			this["okBtn"].addEventListener(MouseEvent.CLICK,onOkClick);
			this["cancelBtn"].addEventListener(MouseEvent.CLICK,onCancelClick);
			
		}

		public function set confirmInfo(str:String):void
		{
			(this["confirmInfoTf"] as TextField).text = str;
		}
		
		private function onCloseClick(e:MouseEvent):void
		{
			if(cbCloseClick != null)
				cbCloseClick()
		}
		private function onOkClick(e:MouseEvent):void
		{
			if(cbOKClick != null)
				cbOKClick()
		}
		private function onCancelClick(e:MouseEvent):void
		{
			if(cbCancelClick != null)
				cbCancelClick()
		}

	}
	
}
