package com.infy.stage
{
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.events.MouseEvent3D;
	import away3d.lights.LightBase;
	import away3d.loaders.Loader3D;
	
	import com.infy.camera.CameraInfo;
	import com.infy.event.RoomEvent;
	import com.infy.game.RoomGame;
	import com.infy.layer.Layer;
	import com.infy.layer.LayerManager;
	import com.infy.light.LightInfo;
	import com.infy.parser.RoomConfigParser;
	import com.infy.path.GamePath;
	import com.infy.resource.getIcon;
	import com.infy.room.RoomInfo;
	import com.infy.room.RoomItemInfo;
	import com.infy.room.RoomItemType;
	import com.infy.str.StringTable;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	import src.DesignViewItemVO;

	/**
	 * 
	 * @long  Dec 1, 2014
	 * 
	 */	
	public class DesignRoomStage extends StageBase
	{
		private static var STATE_GET_ROOM:int = 0;
		private static var STATE_GET_ROOM_PROCESSING:int = 1;
		
		private var m_state:int = -1;
		
		private var m_selectGoodsId:String;
		private var m_selectGoodsIcon:DisplayObject = null;
		
		private var m_bGoodsMoving:Boolean = false;
		
		private var m_roomParser:RoomConfigParser = null;
		
		private var m_curView:String = "view1";
		
		public function DesignRoomStage(game:RoomGame)
		{
			super(game);
		}
		
		override public function initilaize():void
		{
			super.initilaize();
			game.ui.type = 1;
			game.ui.showSimpleLoading("下載房間資訊...");
			game.ui.loadingProgress = 100;
			game.ui.cbMouseClick = onNextStage;
			game.ui.cbLabelItemClick = onLabelItemClick;
			game.ui.cbGoodsItemDown = onGoodsItemMouseDown;
			game.ui.cbItemClickMenu = onObjMenuClick;
			
			game.addEventListener(RoomEvent.LOAD_COMPLETED, onLoadRoomObjectCompleted);
			game.addEventListener(RoomEvent.CREATE_OBJECT, onRoomObjectCreate);
			game.addEventListener(RoomEvent.CREATE_LIGHT, onLightCreate);
			game.addEventListener(RoomEvent.CREATE_CAMERA, onCameraCreate);
			
			// show 3d view
			game.show3DView();
			
			if(m_roomParser == null)
				m_roomParser = new RoomConfigParser(game);
			
			initRoom();
			init3D();
			
			//test
			test();
		}
		
		override public function release():void
		{
			super.release();
			game.ui.cbMouseClick = null;
			game.ui.cbLabelItemClick = null;
			game.ui.cbGoodsItemDown = null;
			game.ui.cbItemClickMenu = null;
			
			game.ui.hideSimpleLoading();
		}
		
		protected function onCameraCreate(event:RoomEvent):void
		{
			var camInfo:CameraInfo = event.object as CameraInfo;
			//createCameraInfo(camInfo);
			
			if(camInfo.isDefault)
				game.setCamera(camInfo);
		}
		
		private function onRoomObjectCreate(event:RoomEvent):void
		{
			var o:ObjectContainer3D = event.object as ObjectContainer3D;
			
			if(o == null) return;
			
			/*if(o.name == "ground")
				ground = o;*/
			
			game.addObjectToScene(o);
			
			if(o is Mesh)
			{				
				(o as Mesh).material.lightPicker = game.lightPicker;
			}
			else if(o is Loader3D)
			{				
				//addObjectContainerToScene(o);
				game.prepareObjectContainer(o);
			}
			
			o.addEventListener(MouseEvent3D.DOUBLE_CLICK, on3DObjeMouseDown);
			//game.addObjectToScene(event.object as ObjectContainer3D);
		}
		
		private function onLightCreate(event:RoomEvent):void
		{
			var lightInfo:LightInfo = event.object as LightInfo;
			
			var light:LightBase = game.createLight(lightInfo);
			game.addObjectToScene(light);
		}
		
		protected function on3DObjeMouseDown(event:MouseEvent3D):void
		{
			// TODO Auto-generated method stub
			
		}
		
		protected function onLoadRoomObjectCompleted(event:RoomEvent):void
		{
			game.ui.hideSimpleLoading();
		}
		
		
		private function test():void
		{
			game.ui.labelItemArray = RoomItemType.TYPE_NAME_ARRAY;
			game.ui.labelItemCurChoose = 0;
			
			onLabelItemClick(0);
		}
		
		private function initRoom():void
		{
			m_roomParser.loadRoomSetting(game.roomID);
		}	
		
		
		
		private function init3D():void
		{
			
		}
		
		
		private function onLabelItemClick(index:int):void
		{
			var type:String = RoomItemType.TYPE_ARRAY[index];
			setItems(type);
		}
		
		private function onGoodsItemMouseDown(goodsId:String):void
		{
			trace(goodsId);
			m_selectGoodsId = goodsId;
			m_bGoodsMoving = true;
			m_selectGoodsIcon = getIcon(goodsId);
			
			LayerManager.instance.addChildAt(m_selectGoodsIcon, Layer.TOP);
			//game.addEventListener(MouseEvent.MOUSE_MOVE, onGoodsMove);
			//game.addEventListener(MouseEvent.MOUSE_UP, onGoodsMoveStop, false, 10);
			game.root.addEventListener(MouseEvent.MOUSE_UP, onGoodsMoveStop, false, 10);
		}
		
		private function onObjMenuClick(index:int):void
		{
			if(index == 0)
			{
				// move obj
				
			}
			else if(index == 1)
			{
				// rotete obj
				
			}
			else if(index == 2)
			{
				// delete obj
				
			}
		}
		/*protected function onGoodsMove(event:Event):void
		{
			
		}*/
		
		protected function onGoodsMoveStop(event:Event):void
		{
			game.root.removeEventListener(MouseEvent.MOUSE_UP, onGoodsMoveStop);
			
			LayerManager.instance.curLayerIndex = Layer.TOP;
			LayerManager.instance.removeChild(m_selectGoodsIcon);
			m_bGoodsMoving = false;
			if(m_selectGoodsIcon is Bitmap)
				(m_selectGoodsIcon as Bitmap).bitmapData.dispose();
			m_selectGoodsIcon = null;
		}
		
		/**
		 *	 依照類別設定物品攔
		 * @param type RoomItemType
		 * 
		 */		
		private function setItems(type:String):void
		{
			var itemArr:Array = getItemsByType(type);
			
			game.ui.goodsVOArr = itemArr;
		}
		
		private function getItemsByType(type:String):Array
		{
			var roomInfo:RoomInfo = game.roomInfo;
			
			var i:int = 0, len:int = roomInfo.numItems;
			var arr:Array = [];
			var itemInfo:RoomItemInfo;
			for(i = 0; i < len; i++)
			{
				itemInfo = roomInfo.items[i];
				if(itemInfo.type != type)
					continue;
				
				var vo:DesignViewItemVO = new DesignViewItemVO();
				vo.id = itemInfo.id;
				
				vo.itemIcon = getIcon(itemInfo.id);
				vo.itemCount = itemInfo.maxCounts - itemInfo.usedCounts;
				vo.itemEnabled = itemInfo.availale(m_curView);
				arr.push(vo);
			}
			
			return arr;
		}
		
		private function changeView(view:String):void
		{
			m_curView = view;
			
			
		}
		
		override public function update():void
		{
			super.update();
			
			if(m_state == STATE_GET_ROOM)
			{
				// 取得房間相關資訊
				
				
				m_state = STATE_GET_ROOM_PROCESSING;
			}
			
			
			if(m_bGoodsMoving)
			{
				if(m_selectGoodsIcon)
				{
					m_selectGoodsIcon.x = game.ui.stage.mouseX - m_selectGoodsIcon.width/2;
					m_selectGoodsIcon.y = game.ui.stage.mouseY - m_selectGoodsIcon.height/2;
				}
			}
			
		}
		
		private function onNextStage():void
		{
			StageManager.instance.changeStage(3);
		}
	}
}