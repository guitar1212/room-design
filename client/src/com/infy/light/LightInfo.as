package com.infy.light
{
	import away3d.lights.LightBase;
	
	import flash.geom.Vector3D;

	/**
	 * 
	 * @long  Dec 8, 2014
	 * 
	 */	
	public class LightInfo
	{
		public static const MAIN:int = 0;
		public static const MAIN_LIGHT:String = "main_light";
		
		public var name:String = "new_light";
		
		public var type:String = "dir";
		
		public var ambient:Number = 1;
		
		public var ambientColor:uint = 0xffffff;
		
		public var diffuse:Number = 1;
		
		public var specular:Number = 0.5;
		
		public var castsShadows:Boolean = false;
		
		public var color:uint = 0xffffff;
		
		public var addToLightPicker:Boolean = true;
		
		/**
		 *	The minimum distance of the light's reach. (for PointLight) 
		 */		
		public var radius:int = 1;
		
		/**
		 *	The maximum distance of the light's reach (for PointLight) 
		 */		
		public var fallOff:Number = 50;
		
		/**
		 *	 The direction of the light (for DirectionalLight)
		 */		
		public var direction:Vector3D = new Vector3D(0, -1, 0);
		
		public var light:LightBase;
		
		public function LightInfo()
		{		
		}
	}
}