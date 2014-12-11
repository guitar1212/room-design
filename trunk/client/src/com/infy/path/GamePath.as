package com.infy.path
{
	/**
	 * 
	 * @long  Dec 11, 2014
	 * 
	 */	
	public class GamePath
	{
		public static var SERVER_PATH:String = "";
		
		public static var GAME_METHOD:String = "gameserver";
		
		public static var ASSET_ROOT_PATH:String = "";
		
		public function GamePath()
		{
		}
		
		public static function get ASSET_MODEL_PATH():String
		{
			return ASSET_ROOT_PATH + "/model/";
		}
		
		public static function get ASSET_IMAGE_PATH():String
		{
			return ASSET_ROOT_PATH + "/img/"
		}
	}
}