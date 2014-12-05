package com.infy.camera
{
	import flash.geom.Vector3D;

	/**
	 * 
	 * @long  Nov 5, 2014
	 * 
	 */	
	public class CameraInfo
	{
		public var name:String;
		public var type:String;
		public var isDefault:Boolean;
		public var near:Number;
		public var far:Number;
		public var fov:Number;
		public var distance:Number;
		public var panAngle:Number;
		public var tiltAngle:Number;
		public var lookAt:Vector3D;
		
		public function CameraInfo()
		{
		}
		
		public function toString():String
		{
			return "";
		}
	}
}