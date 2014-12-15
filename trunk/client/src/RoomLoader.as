package
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.utils.setInterval;
	
	[SWF(backgroundColor="#dfe3e4", frameRate="60", quality="LOW", width="1024", height="768")]
	public class RoomLoader extends Sprite
	{
		private static const MAIN_SWF_NAME:String = "RoomDesign.swf";
		
		private var m_text:TextField = new TextField();
		
		private var m_loading:LoadingUI = new LoadingUI();
		
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
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoadingProgress);
			
			showLoading();
		}
		
		protected function onLoadingProgress(event:ProgressEvent):void
		{
			var persent:Number = event.bytesLoaded/event.bytesTotal*100;
			var msg:String = "請稍等......" + (event.bytesLoaded/1024).toFixed(1) + "KB (" + persent.toFixed() + "%)";
			m_loading.loadObject = msg;
			m_loading.curProgress = persent;
		}	
		
		protected function onLoadMainSwfComplete(event:Event):void
		{
			var loaderInfo:LoaderInfo = event.target as LoaderInfo;
			this.addChild(loaderInfo.content);
			m_loading.loadObject = "下載完成";
			m_loading.curProgress = 100;
			hideLoading();
		}
		
		private function showLoading():void
		{
			this.addChild(m_loading);
			m_loading.loadObject = "下載中...";
			m_loading.curProgress = 0;
			m_loading.x = (this.stage.width + m_loading.width)/2;
			m_loading.y = 300;
		}
		
		public function hideLoading():void
		{
			this.removeChild(m_loading);
			
		}
	}
}