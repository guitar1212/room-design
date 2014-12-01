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
			this["barfilter"].x = -153 + 175*(curProgress / 100);
			this["percentTf"].text = String(curProgress) + "%";
		}
		
		
		
		private function initUI():void
		{
			this["percentTf"].mouseEnabled = false;
			
		}
		
		

	}
	
}
