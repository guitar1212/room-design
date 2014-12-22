package com.infy.resource
{
	import com.infy.path.GamePath;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.net.URLRequest;

	/**
	 * 
	 * @long  Dec 10, 2014
	 * 
	 */	
	public function getIcon(id:String):DisplayObject
	{
		var b:DisplayObject = null
		
		if(id == "default")
			b = new EmbedResource.DefaultGoosIcon() as Bitmap;
		else
		{
			b = new Loader();
			var path:String = GamePath.ASSET_ICON_PATH + id + ".jpg";
			Loader(b).load(new URLRequest(path));
			trace("getIcon path = " + path);
		}
		
		return b;
	}
}