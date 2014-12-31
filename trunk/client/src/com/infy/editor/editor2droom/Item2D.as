package com.infy.editor.editor2droom
{
	import away3d.tools.utils.Bounds;
	
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;

	/**
	 * 
	 * @long  Dec 31, 2014
	 * 
	 */	
	public class Item2D
	{
		public var name:String = "";
		
		public var position:Vector3D = new Vector3D();
		
		public var rotation:Vector3D = new Vector3D();
		
		public var color:uint = 0xffffff;
		
		public var icon:DisplayObject = null;
		
		public var bound:Rectangle = new Rectangle();
		
		public var height:Number = 0;
	
		public function Item2D()
		{
		}
	}
}