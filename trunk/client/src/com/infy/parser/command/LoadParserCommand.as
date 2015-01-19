package com.infy.parser.command
{
	import away3d.containers.ObjectContainer3D;
	
	import com.infy.editor.editor2droom.event.Editor2DEvent;
	import com.infy.event.RoomEvent;
	import com.infy.path.GamePath;
	import com.infy.util.primitive.PrimitiveInfo;
	import com.infy.util.tools.ColorUtil;
	
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
				
				var f:Function = excuteMethod;
				target = f(path, type, pos3, rot3, 1, s3);
			}
		}
		
		override public function updateCommand():void
		{
			super.updateCommand();			
		}
		
		override public function toString():String
		{	
			return super.toString();
		}
		
		override public function create2DEvnet():Editor2DEvent
		{	
			if(isDelete) return null;
			
			var e:Editor2DEvent = null;
			
			var sizeX:Number = (target.maxX - target.minX)*target.scaleX;
			var sizeY:Number = (target.maxZ - target.minZ)*target.scaleZ;
			
			
			e = new Editor2DEvent(Editor2DEvent.CREATE);
			e.name = name;
			e.style = "model";
			e.depth = size.y;
			e.position.setTo(position.x, -position.z);
			e.size.setTo(sizeX, sizeY);
			e.rotation = rotation.y;
			e.color = ColorUtil.getHexCode(color[0], color[1], color[2]);
			
			return e;
			
		}
	}
}