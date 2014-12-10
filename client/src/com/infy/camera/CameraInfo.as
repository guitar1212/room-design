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
		public var name:String = "defaultCam";
		public var type:String = "P";
		public var isDefault:Boolean = true;
		public var near:Number = 10;
		public var far:Number = 2000;
		public var fov:Number = 60;
		public var distance:Number = 1000;
		public var panAngle:Number = 15;
		public var tiltAngle:Number = 60;
		public var lookAt:Vector3D = new Vector3D(0, 0, 0);
		
		public function CameraInfo()
		{
		}
		
		public function toString():String
		{
			return "name : " + name + "\n" +
				   "type : " + type +"\n" +
				   "isDefault : " + isDefault +"\n" + 
				   "near : " + near + "\n" +
				   "far : " + far + "\n" +
				   "distance : " + distance +"\n" +
				   "panAngle : " + panAngle +"\n" +
				   "tiltAngle : " + tiltAngle +"\n" +
				   "lookAt : " + lookAt.toString()
				    ;
		}
	}
}