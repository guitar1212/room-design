package src
{
	import flash.display.MovieClip;
	
	public class LoadingUIBase extends MovieClip
	{
		
		public function LoadingUIBase()
		{
			// constructor code
			initUI();
		}
		
		
		public function set curProgress(curProgress:int):void
		{
			this["barMask"].width = 250 * (curProgress / 100);
			this["percentTf"].text = curProgress + "%";
			
		}
		
		
		
		private function initUI():void
		{
			this["percentTf"].mouseEnabled = false;
			(this["barMask"] as MovieClip).cacheAsBitmap = true;
			this["barfilter"].cacheAsBitmap = true;
			this["barfilter"].mask = this["barMask"];
			
		}
		
		public function set loadObject(info:String):void
		{
			this["objectTf"].text = info;
		}
		
		

	}
	
}
