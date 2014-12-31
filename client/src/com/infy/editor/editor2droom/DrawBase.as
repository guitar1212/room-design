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
		
		public var drawAlpha:Number = 0.45;
		
		public var offset:Point = new Point();
		
		public var oriScale:Number = 1;
		
		public var refrenceObject:DisplayObject = null;
		
		private var m_bSelect:Boolean = false;
		
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
				p = new Point(refrenceObject.x - this.x, refrenceObject.y - this.y);
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
				this.filters = [new GlowFilter(0xffff00, 0.8, 3, 3)];
			else
				this.filters = [];
		}
		
		public function get select():Boolean
		{
			return m_bSelect;
		}
	}
}