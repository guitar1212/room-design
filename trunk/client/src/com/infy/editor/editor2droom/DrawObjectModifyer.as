package com.infy.editor.editor2droom
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class DrawObjectModifyer extends MovieClip
	{
		private var m_target:DrawBase;
		
		private var m_modifyIndex:String;
		
		private var m_spriteList:Vector.<Sprite> = new Vector.<Sprite>();
		
		public function DrawObjectModifyer()
		{
			super();
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			onInit();
		}
		
		
		private function onInit():void
		{
			for(var i:int = 0; i < 4; i++)
			{
				var s:Sprite = new Sprite();					
				s.name = "scale" + i;			
				s.useHandCursor = true;
				s.buttonMode = true;
				this.addChild(s);
				m_spriteList.push(s);
			}
			
			var rotateController:Sprite = new Sprite();
			rotateController.graphics.beginFill(0x00ff00, 0.9);
			rotateController.graphics.drawCircle(0, 0, 4);
			rotateController.graphics.endFill();
			rotateController.name = "rotate";
			m_spriteList.push(rotateController);
			
			this.addChild(rotateController);
		}
		
		private function drawControlPoint():void
		{
			var s:Sprite;
			var baseWidth:int = 12;
			var width:int = (m_target != null) ? baseWidth/m_target.scaleX : baseWidth;
			for(var i:int = 0; i < 4; i++)
			{
				s = m_spriteList[i];
				s.graphics.clear();
				s.graphics.beginFill(0x0000ff, 0.9);
				s.graphics.drawRect(-width/2, -width/2, width, width);
				s.graphics.endFill();
			}
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			var targetName:String = event.target.name;
			if(targetName.indexOf("scale") > -1)
			{
				m_modifyIndex = targetName.charAt(5);
				trace(m_modifyIndex);
			}
			
			this.addEventListener(Event.ENTER_FRAME, onModifyObject);
			
		}
		
		protected function onModifyObject(event:Event):void
		{
			
		}
		
		protected function onMouseUp(event:MouseEvent):void
		{
			this.removeEventListener(Event.ENTER_FRAME, onModifyObject);
		}
		
		public function set target(obj:DrawBase):void
		{
			if(obj == null)
			{
				if(m_target)
				{
					m_target.removeChildren();
					m_target = null;
					
					for(var i:int = 0; i < m_spriteList.length; i++)
					{
						this.removeChild(m_spriteList[i]);
					}
				}
			}
			else
			{
				m_target = obj;
				m_target.addChild(this);
				drawControlPoint();
				
				trace("target scale : " + m_target.scaleX + ",  oriScale : " + m_target.oriScale);
			}
			refresh();
		}
		
		private function refresh():void
		{
			this.graphics.clear();
			if(m_target)
			{	
				var r:Rectangle = m_target.getBounds(this);	
				this.graphics.lineStyle(4/m_target.scaleX, 0xff0000);
				this.graphics.moveTo(r.x, r.y);
				this.graphics.lineTo(r.x + r.width, r.y);
				this.graphics.lineTo(r.x + r.width, r.y + r.height);
				this.graphics.lineTo(r.x, r.y + r.height);
				this.graphics.lineTo(r.x, r.y);
				
				m_spriteList[0].x = r.x;
				m_spriteList[0].y = r.y;
				m_spriteList[1].x = r.x + r.width;
				m_spriteList[1].y = r.y;
				m_spriteList[2].x = r.x + r.width;
				m_spriteList[2].y = r.y + r.height;
				m_spriteList[3].x = r.x;
				m_spriteList[3].y = r.y + r.height;
				m_spriteList[4].x = r.x + r.width/2;
				m_spriteList[4].y = r.y + r.height/2;
				
				for(var i:int = 0; i < m_spriteList.length; i++)
				{
					this.addChild(m_spriteList[i]);
				}
			}
		}		
		
	}
}