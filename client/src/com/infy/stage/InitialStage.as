package com.infy.stage
{
	import com.infy.game.RoomGame;
	import com.infy.hotel.HotelInfo;
	import com.infy.message.MessageManager;
	import com.infy.message.UTestMessage;
	import com.infy.path.GamePath;
	import com.infy.room.RoomInfo;
	import com.infy.room.RoomItemInfo;
	import com.infy.room.RoomItemType;
	import com.infy.str.StringTable;
	import com.infy.task.Task;
	import com.infy.task.TaskManager;
	
	import flash.text.engine.Kerning;
	import flash.utils.getTimer;
	
	/**
	 * 
	 * @long  Dec 1, 2014
	 * 
	 */	
	public class InitialStage extends StageBase
	{
		private static const STEP_1_NET:int = 1;
		private static const STEP_2:int = 2;
		private static const STEP_3:int = 3;
		private static const STEP_4:int = 4;
		private static const STEP_5_FINISH:int = 5;
		
		private var m_step:int = STEP_1_NET;
		
		private var m_tempCont:int = 0;
		
		private var m_bSuspend:Boolean = false;
		
		public function InitialStage(g:RoomGame)
		{
			super(g);
		}
		
		override public function initilaize():void
		{
			super.initilaize();
			
			// initial stringTable
			StringTable.initialize();
			
			// set step bar
			game.ui.setStepInfo(0, StringTable.getString("UI_STEP", "STEP1"));
			game.ui.setStepInfo(1, StringTable.getString("UI_STEP", "STEP2"));
			game.ui.setStepInfo(2, StringTable.getString("UI_STEP", "STEP3"));
			
			// hide ui
			game.ui.show(false);
			
			// create link
			MessageManager.instance.initialize(GamePath.SERVER_PATH, GamePath.GAME_METHOD);
			
			for(var i:int = 0; i < RoomItemType.TYPE_ARRAY.length; i++)
			{
				RoomItemType.TYPE_NAME_ARRAY.push(StringTable.getString("LABEL_TYPE", RoomItemType.TYPE_ARRAY[i]));
			}
				
			//test
			setHotelInfo();			
			
			game.ui.showLoading("初始中...");
			game.ui.loadingProgress = 100;
			
			// for test
			m_tempCont = getTimer();
		}
		
		override public function release():void
		{
			super.release();	
		}
		
		override public function update():void
		{
			super.update();
			
			// for test
			var dT:int = getTimer() - m_tempCont;
			game.ui.loadingMessage = "初始中..." + (dT/1000).toFixed(2);
			if(dT > 3000)			
				m_step = STEP_5_FINISH;
			
			if(m_bSuspend) return;
			
			if(m_step == STEP_1_NET)
			{
				var mes:UTestMessage = new UTestMessage();
				mes.userID = "long";
				mes.context = "cchaha";
				mes.send();
				m_bSuspend = true;
			}
			else if(m_step == STEP_2)
			{
				
			}
			else if(m_step == STEP_3)
			{
				
			}
			else if(m_step == STEP_4)
			{
				
			}
			else if(m_step == STEP_5_FINISH)
			{
				m_step = 0;
				StageManager.instance.changeStage(1);
			}
		}
		
		
		private function setHotelInfo():void
		{
			
			// test data
			var hotelInfo:HotelInfo = new HotelInfo();
			hotelInfo.id = "hotel_001";
			hotelInfo.roomCounts = 2;
			
			var roomArr:Array = [];			
			for(var i:int = 0; i < hotelInfo.roomCounts; i++)
			{
				var room:RoomInfo = new RoomInfo();
				room.id = "room0" + (i+1);
				room.roomName = "room" + i;
				room.describtion = "這是第 " + i + " 個房間!";
				room.numViewPoints = 2;			
				room.viewPoints = [];
				var j:int = 0
				for(j; j < room.numViewPoints; j++)
				{
					room.viewPoints.push("view" + j);
				}
				
				room.numItems = 8;
				for(j = 0; j < room.numItems; j++)
				{
					var itemInfo:RoomItemInfo = new RoomItemInfo();
					itemInfo.id = "item01_00" + (j+1);
					itemInfo.maxCounts = j;
					itemInfo.usedCounts = 0;
					if(j%2 == 0)
						itemInfo.canUseView = ["view1"];
					else
						itemInfo.canUseView = ["view2"];
					if(j%2 == 0)
						itemInfo.type = RoomItemType.TYPE_1;
					else
						itemInfo.type = RoomItemType.TYPE_2;
					room.items.push(itemInfo);	
				}
				
				roomArr.push(room);
			}
			hotelInfo.roomData = roomArr;
			
			game.hotelInfo = hotelInfo;
		}
		
		
		private function isNetConnect():Boolean
		{
			return true;
		}
		
		
	}
}