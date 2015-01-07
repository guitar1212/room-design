package com.infy.editor.editor2droom
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	/**
	 * 
	 * @long  Dec 31, 2014
	 * 
	 */	
	public class ButtonGroup extends MovieClip
	{
		private var m_btnList:Array = [];
		
		private var m_direction:int = 0;
		
		private var m_btnContainer:Sprite;
		
		private var m_bMultiSelect:Boolean = false;
		
		
		public function ButtonGroup()
		{
			super();
			
			m_btnContainer = new Sprite();
			m_btnContainer.x = 5;
			this.addChild(m_btnContainer);
			
			m_btnContainer.addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		protected function onMouseClick(event:MouseEvent):void
		{
			var btn:DisplayObject = event.target as DisplayObject;
			if(btn)
			{
				var i:int = 0, len:int = m_btnList.length;
				for(i; i < len; i++)
				{
					var data:Object = m_btnList[i] as Object;
					if(data.btn == btn)
					{
						
					}
				}
			}
		}
		
		public function addButton(btn:DisplayObject, cb:Function):void
		{
			var data:Object = {"btn":btn, "callback":cb};
			//m_btnList.push();
		}
		
		public function sort():void
		{
			var i:int = 0, len:int = m_btnList.length;
			var dx:Number = 0, dy:Number = 0;
			var data:Object;
			
			if(direction == 0)
			{
				for(i; i < len; i++)
				{
					data = m_btnList[i] as Object;
					data.btn.x = dx;
					data.btn.y = dy;
					
					dx += (data.btn.width + 2);
				}
			}
			else
			{
				for(i; i < len; i++)
				{
					data = m_btnList[i] as Object;
					data.btn.x = dx;
					data.btn.y = dy;
					
					dy += (data.btn.height + 2);
				}
			}
		}

		public function get direction():int
		{
			return m_direction;
		}

		public function set direction(value:int):void
		{
			m_direction = value;
		}

		public function get multiSelect():Boolean
		{
			return m_bMultiSelect;
		}

		public function set multiSelect(value:Boolean):void
		{
			m_bMultiSelect = value;
		}
		
		
	}
}