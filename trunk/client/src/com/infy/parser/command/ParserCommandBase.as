package com.infy.parser.command
{
	import away3d.containers.ObjectContainer3D;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Vector3D;

	/**
	 * 
	 * @long  Dec 18, 2014
	 * 
	 */	
	public class ParserCommandBase implements IParserCommand
	{
		private var m_dispatcher:EventDispatcher;
		
		private var m_excuteMethod:Function = null;
		
		private var m_rawData:Array = null;
		
		private var m_target:ObjectContainer3D = null;
		
		public function ParserCommandBase(dispatcher:EventDispatcher, args:Array = null)
		{
			m_dispatcher = dispatcher;
			
			if(args)
			{
				m_rawData = args.concat();			
				parser(args);
			}
		}
		
		public function parser(args:Array):void
		{
		}
		
		public function excute():void
		{
			if(m_excuteMethod != null)
				m_excuteMethod();
		}
		
		public function toString():String
		{
			return null;
		}
		
		public function set excuteMethod(f:Function):void
		{
			m_excuteMethod = f;
		}
		
		
		public function get excuteMethod():Function
		{
			return m_excuteMethod;
		}
		
		protected function get rawData():Array
		{
			return m_rawData;
		}
		
		protected function addString(str:String):String
		{			
			return "\t" + str;
		}
		
		protected function addInt(value:int):String
		{
			return "\t" + value;
		}
		
		protected function addNumber(value:Number):String
		{
			return "\t" + value.toFixed(2);
		}
		
		protected function addBoolean(b:Boolean):String
		{
			if(b) return "\tY";
			else return "\tN";
		}
		
		protected function addVector3D(v:Vector3D):String
		{
			return "\t" + v.x + "," + v.y + "," + v.z;
		}
		
		protected function addArray(a:Array):String
		{
			var s:String = "\t";
			for(var i:int = 0; i < a.length; i++)
				s += (a[i] + ",");
			return s;
		}
		
		protected function dispatchEvent(event:Event):Boolean
		{
			return m_dispatcher.dispatchEvent(event);
		}

		public function get target():ObjectContainer3D
		{
			return m_target;
		}

		public function set target(value:ObjectContainer3D):void
		{
			m_target = value;
		}
		
		public function toVector3D(args:String):Vector3D
		{
			var a:Array = toArray(args);
			return new Vector3D(a[0], a[1], a[2]);
		}
		
		public function toArray(args:String):Array
		{
			return args.split(",");
		}
		
		public function toBoolean(args:String):Boolean
		{
			return args == "Y";
		}

	}
}