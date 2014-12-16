package src
{
	import flash.display.MovieClip;
	
	public class LoadingSimpleUIBase extends MovieClip
	{
		
		public function LoadingSimpleUIBase()
		{
			// constructor code
			initUI();
		}
				
		
		private function initUI():void
		{
			this["loadTf"].mouseEnabled = false;
			
		}
		
		public function set loadObject(info:String):void
		{
			this["loadTf"].text = info;
		}
		
		

	}
	
}
