package com.infy.editor.editor2droom
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	
	public class DrawBase extends Sprite
	{
		public var startPoint:Point = new Point();
		
		public var endPoint:Point = new Point();
		
		public var drawColor:uint = 0x11ff11;
		
		public var drawAlpha:Number = 0.7;
		
		public var offset:Point = new Point();
		
		public var oriScale:Number = 1;
		
		public var oriPosition:Point = new Point();
		
		public var oriWidth:Number;
		
		public var oriHeight:Number;
		
		public var oriRotation:Number = 0;
		
		public var depth:Number = 1;
		
		public var refrenceObject:DisplayObject = null;
		
		private var m_bSelect:Boolean = false;
		
		private var m_modifier:DrawObjectModifyer = new DrawObjectModifyer();
		
		public function DrawBase()
		{
			super();
		}
		
		public function startDraw(startX:Number, startY:Number):void
		{
			this.x = startX;
			this.y = startY;
			startPoint.x = 0;
			startPoint.y = 0;
			
			this.addEventListener(Event.ENTER_FRAME, onDrawing);
		}
		
		public function endDraw(endX:Number, endY:Number):void
		{
			endPoint.x = endX;
			endPoint.y = endY;
			this.removeEventListener(Event.ENTER_FRAME, onDrawing);
		}
		
		protected function onDrawing(event:Event):void
		{
			draw();
		}		
		
		protected function draw():void
		{
			var p:Point;
			if(refrenceObject)
			{				
				//p = new Point(refrenceObject.x - this.x - parent.x, refrenceObject.y - this.y - parent.y);
				var s:Point = refrenceObject.parent.localToGlobal(new Point(refrenceObject.x, refrenceObject.y));
				//p = globalToLocal(new Point(stage.mouseX, stage.mouseY));
				p = globalToLocal(s);
			}
			else
				p = globalToLocal(new Point(stage.mouseX, stage.mouseY));
			
			this.endPoint.setTo(p.x, p.y);
			
			graphics.clear();
			
			
		}
		
		public function set select(value:Boolean):void
		{
			m_bSelect = value;
			if(value)
			{
				//this.filters = [new GlowFilter(0xffff00, 0.8, 3, 3)];
				m_modifier.target = this;
				
			}
			else
			{
				//this.filters = [];
				m_modifier.target = null;
			}
		}
		
		public function get select():Boolean
		{
			return m_bSelect;
		}
	}
}