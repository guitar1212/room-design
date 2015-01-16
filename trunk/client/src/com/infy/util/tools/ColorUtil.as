package com.infy.util.tools
{
	/**
	 * 
	 * @long  Dec 4, 2014
	 * 
	 */	
	public class ColorUtil
	{
		public function ColorUtil()
		{
		}
		
		public static function getHexCode(r:uint, g:uint, b:uint, alpha:uint = 255):uint
		{
			return alpha << 24 | r << 16 | g << 8 | b;
		}
		
		public static function getRGB(color:uint):Array
		{
			var r:uint = ((color&0xFF0000)>>16);
			var g:uint = ((color&0x00FF00)>>8);
			var b:uint = ((color&0x0000FF)>>0);			
			return [r, g, b];
		}
		
		public static function getARGB(color:uint):Array
		{
			var a:uint = (color >> 24)&0xFF;
			var r:uint = (color >> 16)&0xFF;
			var g:uint = (color >> 8)&0xFF;
			var b:uint = color&0xFF;
			return [a, r, g, b];
		}
	}
}