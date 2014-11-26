package com.infy.layer
{
	import flash.display.Sprite;
	
	/**
	 * 
	 * @long  Nov 26, 2014
	 * 
	 */	
	public class Layer extends Sprite
	{
		public static const BACKGROUND:int = 0;
		public static const UI:int = 1;
		public static const TOP:int = 2;
		public static const TOTAL_LAYERS:int = 3;
		
		public function Layer()
		{
			super();
		}
	}	
}