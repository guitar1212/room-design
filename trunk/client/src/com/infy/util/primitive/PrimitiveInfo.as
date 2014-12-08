package com.infy.util.primitive
{
	import flash.geom.Vector3D;

	public class PrimitiveInfo
	{
		public var name:String = "";
		public var pos:Vector3D = new Vector3D();
		public var rotation:Vector3D = new Vector3D();
		public var size:Vector3D = new Vector3D(1, 1, 1);
		public var colorRGB:Array = [255, 255, 255];
		public var alpha:Number = 1.0;
		public var castShadow:Boolean = false;
		public var reciveShadow:Boolean = false;
		
		
		public function PrimitiveInfo()
		{
		}
		
		public function parser(args:Array):void
		{
			var name:String = args.shift();
			var posArr:Array = String(args.shift()).split(",");
			pos.x = posArr[0]; pos.y = posArr[1]; pos.z = posArr[2];
			var rotationArr:Array = String(args.shift()).split(",");
			rotation.x = rotationArr[0];rotation.y = rotationArr[1];rotation.z = rotationArr[2];
			var sizeArr:Array = String(args.shift()).split(",");
			size.x = sizeArr[0];size.y = sizeArr[1];size.z = sizeArr[2];
			colorRGB = String(args.shift()).split(",");
			
			alpha = args.shift();
			castShadow = args.shift() == "Y" ? true : false;
			reciveShadow = args.shift() == "Y" ? true : false;
		}
		
		public function get color():uint
		{
			var r:uint = colorRGB[0];
			var g:uint = colorRGB[1];
			var b:uint = colorRGB[2];
			return r << 16 | g << 8 | b;
		}
	}
}