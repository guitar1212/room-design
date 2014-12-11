package com.infy.stage
{
	import com.infy.game.RoomGame;
	import com.infy.layer.Layer;
	import com.infy.layer.LayerManager;
	import com.infy.path.GamePath;
	import com.infy.resource.getIcon;
	import com.infy.str.StringTable;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
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
		private var m_selectGoodsIcon:Bitmap = null;
		
		private var m_bGoodsMoving:Boolean = false;
		
		public function DesignRoomStage(game:RoomGame)
		{
			super(game);
		}
		
		override public function initilaize():void
		{
			super.initilaize();
			game.ui.type = 1;
			game.ui.showLoading("下載房間資訊...");
			game.ui.cbMouseClick = onNextStage;
			game.ui.cbLabelItemClick = onLabelItemClick;
			game.ui.cbGoodsItemDown = onGoodsItemMouseDown;
			
			// show 3d view
			game.show3DView();
			
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
		}
		
		private function test():void
		{
			game.ui.labelItemArray = [StringTable.getString("LABEL_TYPE", "TYPE_1"),
									  StringTable.getString("LABEL_TYPE", "TYPE_2"),
									  StringTable.getString("LABEL_TYPE", "TYPE_3"),
									  StringTable.getString("LABEL_TYPE", "TYPE_4"),
									  StringTable.getString("LABEL_TYPE", "TYPE_5")];
			game.ui.labelItemCurChoose = 0;
			
			onLabelItemClick(0);
		}
		
		private function initRoom():void
		{
			// get room config
			
		}	
		
		
		private function init3D():void
		{
			
		}
		
		
		private function onLabelItemClick(index:int):void
		{
			var type:int = 0;
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
		
		/*protected function onGoodsMove(event:Event):void
		{
			
		}*/
		
		protected function onGoodsMoveStop(event:Event):void
		{
			game.root.removeEventListener(MouseEvent.MOUSE_UP, onGoodsMoveStop);
			
			LayerManager.instance.curLayerIndex = Layer.TOP;
			LayerManager.instance.removeChild(m_selectGoodsIcon);
			m_bGoodsMoving = false;
			m_selectGoodsIcon.bitmapData.dispose();
			m_selectGoodsIcon = null;
		}
		
		private function setItems(type:int):void
		{
			var itemArr:Array = getItemsByType(type);
			
			var goodsVOArr:Array = [];
			for(var i:int = 0; i < itemArr.length; i++)
			{
				var vo:DesignViewItemVO = new DesignViewItemVO();
				vo.id = itemArr[i];
				var path:String = GamePath.ASSET_IMAGE_PATH + "icon/" + itemArr[i] + ".jpg";
				var l:Loader = new Loader();
				l.load(new URLRequest(path));
				
				vo.itemIcon = l;
				goodsVOArr.push(vo);
			}
			
			game.ui.goodsVOArr = goodsVOArr;
		}
		
		private function getItemsByType(type:int):Array
		{
			var arr:Array = [];
			
			// test
			for(var i:int = 1; i < 8; i++)
			{
				var id:String = "item01_00" + i;
				arr.push(id);
			}
			
			return arr;
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