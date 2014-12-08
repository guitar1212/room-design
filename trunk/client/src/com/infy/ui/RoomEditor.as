package com.infy.ui
{
	import com.infy.ui.comp.MoveIcon;
	
	import fl.controls.Button;
	import fl.controls.TextArea;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * 
	 * @long  Dec 3, 2014
	 * 
	 */	
	public class RoomEditor extends MovieClip
	{	
		private var m_text:TextArea = new TextArea();
		
		private var m_okBtn:Button = new Button();
		
		private var m_cleanBtn:Button = new Button();
		
		private var m_okCB:Function = null;
		
		private var m_cancelCB:Function = null;
		
		private var m_moveBtn:MoveIcon;
		
		public function RoomEditor(w:Number = 650, h:Number = 200, okCB:Function = null, cancelCB:Function = null)
		{
			super();
			
			m_okCB = okCB;
			
			m_cancelCB = cancelCB;
			
			m_text.width = w;
			m_text.height = h;
			m_text.text = "I am Editor";
			m_text.textField.background = true;
			m_text.textField.backgroundColor = 0xc2c2c2;
			
			
			this.addChild(m_text);
			
			if(m_okCB != null)
			{
				m_okBtn.x = 5;
				m_okBtn.y = m_text.height + 3;
				m_okBtn.label = "Load";
				m_okBtn.addEventListener(MouseEvent.CLICK, onOKBtnClick);
				this.addChild(m_okBtn);
			}
			
			if(m_cancelCB != null)
			{
				m_cleanBtn.label = "Clean";
				m_cleanBtn.x = m_text.width - m_cleanBtn.width;
				m_cleanBtn.y = m_text.height + 3;
				m_cleanBtn.addEventListener(MouseEvent.CLICK, onCancelBtnClick);
				this.addChild(m_cleanBtn);
			}
			
			m_moveBtn = new MoveIcon();			
			this.addChild(m_moveBtn);
			m_moveBtn.x = m_text.width - m_moveBtn.width;
			m_moveBtn.y = -m_moveBtn.height;
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			this.alpha = 0.35;
			this.startDrag();
		}
		
		protected function onMouseUp(event:MouseEvent):void
		{
			this.alpha = 1;
			this.stopDrag();
			
		}
		
		protected function onOKBtnClick(event:MouseEvent):void
		{
			if(m_okCB != null)
				m_okCB(data);
		}
		
		protected function onCancelBtnClick(event:MouseEvent):void
		{
			if(m_cancelCB != null)
				m_cancelCB();
		}
		
		public function set data(context:String):void
		{
			context = context.replace(/[\r]/g, "");
			m_text.text = context;			
		}
		
		public function get data():String
		{
			return m_text.text;
		}
	}
}