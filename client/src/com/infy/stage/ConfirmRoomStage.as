package com.infy.stage
{
	import com.infy.camera.CameraInfo;
	import com.infy.camera.CameraInfoManager;
	import com.infy.game.RoomGame;
	import com.infy.light.LightManager;
	import com.infy.str.StringTable;
	
	import src.DesignViewItemVO;

	/**
	 * 
	 * @long  Dec 1, 2014
	 * 
	 */	
	public class ConfirmRoomStage extends StageBase
	{
		private var m_btnState:String = "";
		
		public function ConfirmRoomStage(game:RoomGame)
		{
			super(game);
		}
		
		override public function initilaize():void
		{
			super.initilaize();
			game.ui.type = 2;
			
			game.ui.cbBtnChooseClick = onButtonClick;
			game.ui.cbItemClick = onViewPointClick;
			game.ui.cbDirectionDown = onDirectionBtnDown;
			game.ui.cbDirectionUp = onDirectionBtnUp
			game.lockCamera = true;
			
			setButton();
		}
		
		override public function release():void
		{
			super.release();
			
			game.ui.cbBtnChooseClick = null;	
			game.ui.cbItemClick = null;
			game.ui.cbDirectionDown = null;
			game.lockCamera = true;
			clean();
		}
		
		private function clean():void
		{
			// clean scene
			game.cleanScene();
			
			LightManager.instance.clean();
			
			CameraInfoManager.instance.clean();
		}
		
		private function setButton():void
		{
			// TODO Auto Generated method stub
			var btnArr:Array = ["重新設計", "設計存檔", "線上訂房"];
			
			game.ui.btnArray = btnArr;
		}
		
		private function onButtonClick(index:int):void
		{
			if(index == 0)
			{
				game.ui.showConfirmUI(StringTable.getString("CONFIRM_UI", "ABORT_DESIGN"), reDesignRoom, onCloseConfirm);
			}
			else if(index == 1)
			{
				saveDesignRoom();
			}
			else if(index == 2)
			{
				linkOrderRoom();
			}
		}
		
		private function onViewPointClick(vo:DesignViewItemVO):void
		{
			trace("onViewPointClick" + vo.id);
			var info:CameraInfo = CameraInfoManager.instance.getCameraInfo(vo.id);
			if(info)
			{
				game.setCamera(info, info.type);
			}
			
		}
		
		private function onDirectionBtnDown(index:String):void
		{
			m_btnState = index;
		}
		
		private function onDirectionBtnUp(index:String):void
		{
			m_btnState = "";
		}
		
		private function reDesignRoom():void
		{
			StageManager.instance.changeStage(1);
			onCloseConfirm();
		}
		
		private function onCloseConfirm():void
		{
			game.ui.hideConfirmUI();
		}
		
		private function linkOrderRoom():void
		{
			// TODO Auto Generated method stub
			
		}
		
		private function saveDesignRoom():void
		{
			// TODO Auto Generated method stub
			
		}		
		
		override public function update():void
		{
			super.update();
			
			if(m_btnState == "up")
			{
				game.cameraController.distance -= 1;
			}
			else if(m_btnState == "down")
			{
				game.cameraController.distance += 1;
			}
			else if(m_btnState == "right")
			{
				game.cameraController.panAngle += 1;
			}
			else if(m_btnState == "left")
			{
				game.cameraController.panAngle -= 1;
			}
		}
	}
}