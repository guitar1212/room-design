package com.infy.parser.command
{
	import com.infy.event.RoomEvent;
	import com.infy.path.GamePath;
	import com.infy.util.primitive.PrimitiveInfo;
	
	import flash.events.EventDispatcher;
	import flash.geom.Vector3D;
	
	/**
	 * 
	 * @long  Dec 18, 2014
	 * 
	 */	
	public class LoadParserCommand extends PrimitiveParserCommand implements IParserCommand
	{	
		
		public function LoadParserCommand(dispatcher:EventDispatcher, args:Array=null)
		{
			super(dispatcher, args);
		}
		
		override public function parser(args:Array):void
		{
			super.parser(args);
		}
		
		override public function excute():void
		{	
			if(excuteMethod != null)
			{
				var path:String = GamePath.ASSET_MODEL_PATH + type + "/" + name  +"/" + name + "." + type;
				
				var pos3:Array = [position.x, position.y, position.z];
				var rot3:Array = [rotation.x, rotation.y, rotation.z];
				var s3:Array = [size.x, size.y, size.z];
				
				target = excuteMethod(path, type, pos3, rot3, 1, s3);
			}
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
			return super.toString();
		}
	}
}