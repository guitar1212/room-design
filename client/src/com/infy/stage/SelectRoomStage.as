package com.infy.stage
{
	import com.infy.game.RoomGame;
	import com.infy.hotel.HotelInfo;
	import com.infy.path.GamePath;
	import com.infy.resource.getIcon;
	import com.infy.room.RoomInfo;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import src.DesignViewItemVO;

	/**
	 * 
	 * @long  Dec 1, 2014
	 * 
	 */	
	public class SelectRoomStage extends StageBase
	{
		private var m_curSelectRoomInfo:RoomInfo;
		
		public function SelectRoomStage(game:RoomGame)
		{
			super(game);
		}
		
		override public function initilaize():void
		{
			super.initilaize();
			game.ui.show(true);
			game.ui.type = 0;
			game.ui.hideLoading();
			game.hide3DView();
						
			game.ui.cbMouseClick = onNextStage;
			game.ui.cbItemClick = onViewPointClick;
			game.ui.cbLabelClick = onRoomSelect;
			
			game.ui.viewItemVO = [];
			
			//test
			setHotelData(game.hotelInfo);
			game.ui.labelCurChoose = 0;
		}
		
		
		override public function release():void
		{
			super.release();
			game.ui.cbMouseClick = null;
			game.ui.cbItemClick = null;
			game.ui.cbLabelClick = null;
			
			game.ui.labelArray = [];
			
			game.ui.viewObject = null;
		}
		
		override public function update():void
		{
			super.update();
		}
		
		
		private function setHotelData(hotelInfo:HotelInfo):void
		{
			var labelArr:Array = [];
			var roomInfo:RoomInfo;
			for(var i:int = 0; i < hotelInfo.roomCounts; i++)
			{
				roomInfo = hotelInfo.roomData[i] as RoomInfo;
				labelArr.push(roomInfo.roomName);
			}
			
			game.ui.labelArray = labelArr;
			
			
			onRoomSelect(0);
		}
		
		private function onRoomSelect(index:int):void
		{
			var roomInfo:RoomInfo = game.hotelInfo.roomData[index] as RoomInfo;
			game.ui.roomIntroDesc = roomInfo.describtion;
			
			game.roomID = roomInfo.id;
			
			// set viewpoint
			var viweArr:Array = [];
			for(var i:int = 0; i < roomInfo.numViewPoints; i++)
			{
				var vo:DesignViewItemVO = new DesignViewItemVO();
				vo.id = roomInfo.viewPoints[i];
				vo.itemIcon = getIcon(vo.id);		
				viweArr.push(vo);
			}
			
			game.ui.viewItemVO = viweArr;
			
			m_curSelectRoomInfo = roomInfo;
			
			// default view point
			onViewPointClick(viweArr[0]);
		}
		
		private function onViewPointClick(vo:DesignViewItemVO):void
		{
			trace("view point " + vo.id);
			
			game.ui.showLoading("下載房間示意圖...");
			var filename:String = vo.id;
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadViewPointComplete, false, 0, true);
			var path:String = GamePath.ASSET_IMAGE_PATH + "view/" + filename + ".png";
			loader.load(new URLRequest(path));
			//game.ui.viewObject = getIcon("");
			game.ui.viewObject = null;
		}
		
		protected function onLoadViewPointComplete(event:Event):void
		{
			game.ui.hideLoading();
			game.ui.viewObject = ((event.target) as LoaderInfo).content;
		}
		
		private function onNextStage():void
		{
			StageManager.instance.changeStage(2);
		}
	}
}