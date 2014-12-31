package com.infy.editor.editor2droom
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	/**
	 * 
	 * @long  Dec 31, 2014
	 * 
	 */	
	public class ButtonGroup extends MovieClip
	{
		private var m_btnDic:Dictionary = new Dictionary();
		
		public function ButtonGroup()
		{
			super();
			
			this.addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		public function addButton(btn:DisplayObject, cb:Function):void
		{
			if(!m_btnDic.hasOwnProperty(btn))
			{
				m_btnDic[btn] = cb;
			}
		}
		
		protected function onMouseClick(event:MouseEvent):void
		{
			var b:DisplayObject = event.target;
			
			for each(var btn:DisplayObject in m_btnDic)
			{
				if(btn == b)
				{
					m_btnDic[btn]();
					break;
				}
			}
		}
	}
}