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
		private var m_createCameraCB:Function = null;
		
		private var m_createBtn:Button = new Button();
		private var m_deleteBtn:Button = new Button();
		
		private var m_confirmUI:CameraInfoComfirmUI = new CameraInfoComfirmUI();
		private var m_cameraInfo:CameraInfo;
		
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
		
		public function showConfirmUI(info:CameraInfo):void
		{
			m_confirmUI.clean();
			
			m_cameraInfo = info;
			
			m_confirmUI.setInfo(info.toString());
			this.addChild(m_confirmUI);
			
			m_list.visible = false;
		}
		
		public function hideConfirmUI():void
		{
			this.removeChild(m_confirmUI);	
			m_list.visible = true;
		}
		
		private function refresh():void
		{
			m_createBtn.y = m_list.y + m_list.height + 3;
			m_deleteBtn.y = m_createBtn.y + m_createBtn.height + 3;
		}
		
		protected function onListChange(event:Event):void
		{
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
		
		public function set createCameraCallback(cb:Function):void
		{
			m_createCameraCB = cb;
		}
		
		public function addCameraInfo(label:String, camInfo:CameraInfo):void
		{
			m_list.addItem({label:label, data:camInfo})
		}
		
		public function removeSelectCameraInfo():void
		{
			m_list.removeItemAt(m_list.selectedIndex);
		}
		
		public function getSelectCameraInfo():CameraInfo
		{
			if(m_list.selectedItem)
				return m_list.selectedItem.data as CameraInfo;
			else
				return null;
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
		
		private function onConfirmUIResponse(index:int):void
		{
			if(index == 0)
			{
				if(m_createCameraCB != null)
				{
					var n:String = m_confirmUI.getCameraInfoName();
					if(n != "")
						m_cameraInfo.name = n;
					m_createCameraCB(m_cameraInfo)
				}
			}
			else if(index == 1)
			{				
			}
			
			hideConfirmUI();
		}
	}
}