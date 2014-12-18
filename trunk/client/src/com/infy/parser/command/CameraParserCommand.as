package com.infy.parser.command
{
	import com.infy.camera.CameraInfo;
	import com.infy.camera.CameraInfoManager;
	import com.infy.event.RoomEvent;
	
	import flash.events.EventDispatcher;
	import flash.geom.Vector3D;

	/**
	 * 
	 * @long  Dec 18, 2014
	 * 
	 */	
	public class CameraParserCommand extends ParserCommandBase implements IParserCommand
	{
		public var name:String;
		
		public var isDefault:Boolean;
		
		public var type:String;

		public var near:int;
		
		public var far:int;
		
		public var fov:Number;
		
		public var distance:int;
		
		public var panAngle:Number;
		
		public var tiltAngle:Number;
		
		public var lookAt:Vector3D;
		
		public function CameraParserCommand(dispatcher:EventDispatcher, args:Array = null)
		{
			super(dispatcher, args);			
		}
		
		override public function parser(args:Array):void
		{
			var keyword:String = args.shift() as String;
			name = args.shift() as String;
			isDefault = String(args.shift()) == "Y" ? true : false;
			type = args.shift();
			near = args.shift();
			far = args.shift();
			fov = args.shift();
			distance = args.shift();
			panAngle = args.shift();
			tiltAngle = args.shift();
			var lookAtArr:Array = String(args.shift()).split(",");
			lookAt = new Vector3D(lookAtArr[0], lookAtArr[1], lookAtArr[2]);
		}
		
		override public function excute():void
		{	
			super.excute();
			var camInfo:CameraInfo = new CameraInfo();
			camInfo.name = name;
			camInfo.isDefault = isDefault;
			camInfo.near = near;
			camInfo.far = far;
			camInfo.fov = fov;
			camInfo.distance = distance;
			camInfo.panAngle = panAngle;
			camInfo.tiltAngle = tiltAngle;
			camInfo.lookAt = lookAt;
			
			CameraInfoManager.instance.addCameraInfo(camInfo.name, camInfo);			
			
			var event:RoomEvent = new RoomEvent(RoomEvent.CREATE_CAMERA);
			event.objType = "camera";
			event.object = camInfo;
			dispatchEvent(event);	
		}
		
		override public function toString():String
		{
			var str:String = ParserCommandType.CAMERA;
			
			str += addString(name);
			str += addBoolean(isDefault);
			str += addString(type);
			str += addInt(near);
			str += addInt(far);
			str += addNumber(fov);
			str += addInt(distance);
			str += addNumber(panAngle);
			str += addNumber(tiltAngle);
			str += addVector3D(lookAt);
			
			return str;
		}
	}
}