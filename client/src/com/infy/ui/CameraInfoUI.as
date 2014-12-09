package com.infy.ui
{
	import com.infy.camera.CameraInfo;
	import com.infy.ui.comp.MoveIcon;
	
	import fl.controls.Button;
	import fl.controls.List;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * 
	 * @long  Dec 9, 2014
	 * 
	 */	
	public class CameraInfoUI extends MovieClip
	{
		private var m_list:List = new List();
		
		private var m_itemChangeCB:Function = null;
		private var m_clickCB:Function = null;
		
		private var m_createBtn:Button = new Button();
		private var m_deleteBtn:Button = new Button();
		
		private var m_confirmUI:CameraInfoComfirmUI = new CameraInfoComfirmUI();
		
		public function CameraInfoUI()
		{
			super();
			
			m_list.addEventListener(Event.CHANGE, onListChange);
			this.addChild(m_list);
			
			m_createBtn.label = "create";
			this.addChild(m_createBtn);
			m_createBtn.addEventListener(MouseEvent.CLICK, onButtonClick)
			m_deleteBtn.label = "delete";
			m_deleteBtn.addEventListener(MouseEvent.CLICK, onButtonClick)
			this.addChild(m_deleteBtn);
			
			var moveBtn:MoveIcon = new MoveIcon();			
			this.addChild(moveBtn);
			moveBtn.x = m_list.width - moveBtn.width;
			moveBtn.y = -moveBtn.height;
			
			m_confirmUI.buttonCallback = onConfirmUIResponse;
			
			refresh();
		}
		
		protected function onButtonClick(event:MouseEvent):void
		{	
			var b:Button = event.target as Button;
			if(m_clickCB == null)
				return;
						
			if(b.label == "create")
				m_clickCB(0);
			else if(b.label == "delete")
				m_clickCB(1);
		}
		
		public function showConfirmUI(data:String):void
		{
			m_confirmUI.setInfo(data);
			this.addChild(m_confirmUI);
		}
		
		public function hideConfirmUI():void
		{
			this.removeChild(m_confirmUI);	
		}
		
		private function refresh():void
		{
			m_createBtn.y = m_list.y + m_list.height + 3;
			m_deleteBtn.y = m_createBtn.y + m_createBtn.height + 3;
		}
		
		protected function onListChange(event:Event):void
		{
			// TODO Auto-generated method stub
			trace(m_list.selectedIndex);
			
			if(m_itemChangeCB != null)
			{
				var item:Object = m_list.selectedItem;
				m_itemChangeCB(item["label"]);
			}
		}
		
		public function set selectCallback(cb:Function):void
		{
			m_itemChangeCB = cb;
		}
		
		public function set buttonCallback(cb:Function):void
		{
			m_clickCB = cb;
		}
		
		public function addCameraInfo(label:String, camInfo:CameraInfo):void
		{
			m_list.addItem({label:label, data:camInfo})
		}
		
		private function onConfirmUIResponse(index:int):void
		{
			if(index == 0)
			{
				
			}
			else if(index == 1)
			{
				hideConfirmUI();
			}
		}
	}
}