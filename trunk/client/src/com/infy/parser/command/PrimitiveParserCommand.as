package com.infy.parser.command
{
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	
	import com.infy.event.RoomEvent;
	import com.infy.path.GamePath;
	import com.infy.util.primitive.PrimitiveCreator;
	import com.infy.util.primitive.PrimitiveInfo;
	
	import flash.events.EventDispatcher;
	import flash.geom.Vector3D;
	
	/**
	 * 
	 * @long  Dec 18, 2014
	 * 
	 */	
	public class PrimitiveParserCommand extends ParserCommandBase implements IParserCommand
	{
		public var cmd:String;
		
		public var name:String;
		
		public var type:String;
		
		public var position:Vector3D;
		
		public var rotation:Vector3D;
		
		public var size:Vector3D;
		
		public var color:Array;
		
		public var alpha:Number;
		
		public var castShadow:Boolean;
		
		public var reciveShadow:Boolean;
		
		public function PrimitiveParserCommand(dispatcher:EventDispatcher, args:Array=null)
		{
			super(dispatcher, args);
		}
		
		override public function parser(args:Array):void
		{
			cmd = args.shift();
			var info:PrimitiveInfo = new PrimitiveInfo();
			info.parser(args);
			
			name = info.name;
			type = info.type;
			position = info.pos;
			rotation = info.rotation;
			size = info.size;
			color = info.colorRGB;
			alpha = info.alpha;
			castShadow = info.castShadow;
			reciveShadow = info.reciveShadow;
		}
		
		override public function excute():void
		{	
			var mesh:Mesh;
			var data:Array = rawData.concat();
			data.shift();
			if(cmd == ParserCommandType.BOX)
				mesh = PrimitiveCreator.createCube(data);
			else if(cmd == ParserCommandType.PLANE)
				mesh = PrimitiveCreator.createPlane(data);
			else if(cmd == ParserCommandType.SPHERE)
				mesh = PrimitiveCreator.createSphere(data);
			
			target = mesh;			
			
			var event:RoomEvent = new RoomEvent(RoomEvent.CREATE_OBJECT);
			event.object = mesh;
			event.objType = cmd;
			dispatchEvent(event);
		}
		
		override public function toString():String
		{
			if(target)
			{
				position = target.position;
				rotation.x = target.rotationX;
				rotation.y = target.rotationY;
				rotation.z = target.rotationZ;
			}
			
			var str:String = cmd;
			
			str += addString(name);			
			str += addString(type);
			str += addVector3D(position);
			str += addVector3D(rotation);
			str += addVector3D(size);
			str += addArray(color);			
			str += addNumber(alpha);
			str += addBoolean(castShadow);
			str += addBoolean(reciveShadow);
			
			return str;
		}
	}
}