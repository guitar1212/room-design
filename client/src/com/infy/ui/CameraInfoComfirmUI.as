package com.infy.ui
{
	import fl.controls.Button;
	import fl.controls.Label;
	import fl.controls.TextArea;
	import fl.controls.TextInput;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * 
	 * @long  Dec 9, 2014
	 * 
	 */	
	public class CameraInfoComfirmUI extends Sprite
	{
		private var m_nameLable:Label = new Label();
		private var m_nameInput:TextInput = new TextInput();
		
		private var m_textArea:TextArea = new TextArea();
		
		private var m_enterBtn:Button = new Button();		
		private var m_cancelBtn:Button = new Button();
		
		private var m_btnCB:Function = null;
		
		public function CameraInfoComfirmUI()
		{
			super();
			
			m_nameLable.text = "Name : ";			
			this.addChild(m_nameLable);
			
			this.addChild(m_nameInput);
			
			
			m_textArea.width = 200;
			m_textArea.height = 250;
			this.addChild(m_textArea);
			
			m_enterBtn.label = "Create";
			this.addChild(m_enterBtn);
			m_enterBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			
			m_cancelBtn.label = "Cancel";
			this.addChild(m_cancelBtn);
			m_cancelBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			
			refresh();
		}
		
		protected function onButtonClick(event:MouseEvent):void
		{
			if(m_btnCB == null) return;
				
			var b:Button = event.target as Button;
			if(b.label == "Create")
				m_btnCB(0);
			else
				m_btnCB(1);
			
		}
		
		public function setInfo(info:String):void
		{
			m_textArea.text = info;
			refresh();
		}
		
		private function refresh():void
		{
			m_nameLable.x = 0;
			m_nameLable.y = 0;
			
			m_nameInput.x = m_nameLable.x + m_nameLable.width;
			m_nameInput.y = m_nameLable.y;
			
			m_textArea.x = 0;
			m_textArea.y = m_nameInput.y + m_nameInput.height;
			
			m_enterBtn.x = 0;
			m_enterBtn.y = m_textArea.y + m_textArea.height + 3;
			
			m_cancelBtn.x = m_enterBtn.x + m_enterBtn.width + 3;
			m_cancelBtn.y = m_enterBtn.y 
		}
		
		public function set buttonCallback(cb:Function):void
		{
			m_btnCB = cb;
		}
	}
}