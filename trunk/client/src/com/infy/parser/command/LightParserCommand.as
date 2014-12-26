package com.infy.parser.command
{
	import com.infy.event.RoomEvent;
	import com.infy.light.LightInfo;
	import com.infy.light.LightManager;
	import com.infy.util.tools.ColorUtil;
	
	import flash.events.EventDispatcher;
	import flash.geom.Vector3D;
	
	/**
	 * 
	 * @long  Dec 19, 2014
	 * 
	 */	
	public class LightParserCommand extends ParserCommandBase implements IParserCommand
	{
		public static const TYPE_DIRECTION:String = "dir";
		public static const TYPE_POINT:String = "point";
		
		
		public var name:String;		
		public var type:String;
		private var color:Vector3D;
		private var ambient:Number;
		private var ambientColor:Vector3D;
		private var diffuse:Number;
		private var castShadows:Boolean;
		private var specular:Number;
		private var direction:Vector3D;
		private var falloff:Number;
		private var radius:Number;
		private var addToLightPicker:Boolean;
		
		
		public function LightParserCommand(dispatcher:EventDispatcher, args:Array=null)
		{
			super(dispatcher, args);
		}
		
		override public function parser(args:Array):void
		{
			var keyword:String = args.shift() as String;
			name = args.shift() as String;
			type = args.shift() as String;
			color = toVector3D(args.shift());
			ambient = args.shift();
			ambientColor = toVector3D(args.shift());
			diffuse = args.shift();
			specular = args.shift();
			castShadows = toBoolean(args.shift());
			direction = toVector3D(args.shift());
			falloff = args.shift();
			radius = args.shift();
			addToLightPicker = toBoolean(args.shift());
		}
		
		override public function excute():void
		{
			var info:LightInfo = new LightInfo();
			info.name = name;
			info.type = type;
			info.color = ColorUtil.getHexCode(color.x, color.y, color.z);
			info.ambient = ambient;
			info.ambientColor = ColorUtil.getHexCode(ambientColor.x, ambientColor.y, ambientColor.z);
			info.diffuse = diffuse;
			info.specular = specular;
			info.castsShadows = castShadows;
			info.direction = direction;
			info.fallOff = falloff;
			info.radius = radius;
			info.addToLightPicker = addToLightPicker;
			
			LightManager.instance.addLight(info);
			
			var event:RoomEvent = new RoomEvent(RoomEvent.CREATE_LIGHT);
			event.objType = "light";
			event.object = info;
			this.dispatchEvent(event);
		}
		
		override public function toString():String
		{
			var str:String = "";
			str += addString(ParserCommandType.LIGHT);
			str += addString(name);
			str += addString(type);
			str += addVector3D(color);
			str += addNumber(ambient);
			str += addVector3D(ambientColor);
			str += addNumber(diffuse);
			str += addNumber(specular);
			str += addBoolean(castShadows);
			str += addVector3D(direction);
			str += addNumber(falloff);
			str += addNumber(radius);
			str += addBoolean(addToLightPicker);
			return str;
		}
	}
}