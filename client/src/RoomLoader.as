package
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.text.TextField;
	
	public class RoomLoader extends Sprite
	{
		private static const MAIN_SWF_NAME:String = "RoomDesign.swf";
		
		private var m_text:TextField = new TextField();
		
		public function RoomLoader()
		{
			super();
			
			this.addEventListener(Event.ADDED_TO_STAGE, onInit);
		}
		
		protected function onInit(event:Event):void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			this.removeEventListener(Event.ADDED_TO_STAGE, onInit);
			
			var path:String = MAIN_SWF_NAME + "?";
			var param:Object = this.loaderInfo.parameters;
			
			for(var key:String in param)
			{
				path += (key + "=" + param[key] + "&")
			}
			
			var loader:Loader = new Loader();
			loader.load(new URLRequest(path));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadMainSwfComplete);
			
			showLoading();
		}
	
		
		protected function onLoadMainSwfComplete(event:Event):void
		{
			var loaderInfo:LoaderInfo = event.target as LoaderInfo;
			this.addChild(loaderInfo.content);
			
			hideLoading();
		}
		
		private function showLoading():void
		{
			// TODO Auto Generated method stub
			
		}
		
		private function hideLoading():void
		{
			// TODO Auto Generated method stub
			
		}
	}
}