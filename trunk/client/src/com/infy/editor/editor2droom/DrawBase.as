package com.infy.editor.editor2droom
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
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
		
		private var m_text:TextField = new TextField();
		
		public function DrawBase()
		{
			super();
			
			/*m_text.autoSize = TextFieldAutoSize.LEFT;
			m_text.textColor = 0x0000ff;
			this.addChild(m_text);*/
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
				text = this.name; 
				
			}
			else
			{
				//this.filters = [];
				m_modifier.target = null;
				text = "";
			}
		}
		
		public function get select():Boolean
		{
			return m_bSelect;
		}
		
		public function set text(str:String):void
		{
			m_text.text = str;
		}
		
		public function move(_x:Number, _y:Number):void
		{
			this.x += _x;
			this.y += _y;
			
			// calculate offset 
			_x = _x/this.oriScale*this.scaleX;/*
			_y = _y/this.oriScale*this.scaleX;
			this.offset.x += _x;
			this.offset.y += _y;*/
			
		}
	}
}