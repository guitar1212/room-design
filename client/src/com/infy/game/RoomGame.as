package com.infy.game
{
	import com.infy.constant.View3DCons;
	import com.infy.hotel.HotelInfo;
	import com.infy.layer.Layer;
	import com.infy.layer.LayerManager;
	import com.infy.room.RoomInfo;
	import com.infy.stage.ConfirmRoomStage;
	import com.infy.stage.DesignRoomStage;
	import com.infy.stage.InitialStage;
	import com.infy.stage.SelectRoomStage;
	import com.infy.stage.StageManager;
	import com.infy.task.TaskManager;
	import com.infy.ui.RoomUI;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.ui.Keyboard;
	
	import away3d.cameras.Camera3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.controllers.HoverController;
	import away3d.debug.AwayStats;
	import away3d.loaders.Loader3D;
	import away3d.loaders.parsers.DAEParser;
	import away3d.loaders.parsers.Max3DSParser;
	import away3d.loaders.parsers.OBJParser;
	import away3d.loaders.parsers.Parsers;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.utils.Cast;

	/**
	 * 
	 * @long  Nov 26, 2014
	 * 
	 */	
	public class RoomGame extends GameBase
	{	
		private var m_ui:RoomUI;		
		
		private var m_curRoomID:String;
		
		private var m_hotelInfo:HotelInfo;
		
		
		public function RoomGame(root:Sprite)
		{
			super(root);
			//m_root = root;
			
			//initialize();
		}
		
		

		override public function initialize():void
		{			
			super.initialize();
			
			initStage();
			initUI();
			initEngine();
			initLight();
			
			// InitialStage
			StageManager.instance.changeStage(0);
		}
				
		private function initStage():void
		{
			StageManager.instance.addStage(new InitialStage(this));		//0
			StageManager.instance.addStage(new SelectRoomStage(this));	//1
			StageManager.instance.addStage(new DesignRoomStage(this));	//2
			StageManager.instance.addStage(new ConfirmRoomStage(this));	//3			
		}
		
		private function initUI():void
		{
			m_ui = new RoomUI();
			
			LayerManager.instance.addChildAt(m_ui, Layer.UI);
			
			//test
			m_ui.showLoading();
			m_ui.loadingProgress = 50;			
		}
		
		private function initEngine():void
		{
			scene = new Scene3D();
			
			camera = new Camera3D();
			
			view = new View3D();
			view.antiAlias = 4;
			view.scene = scene;
			view.camera = camera;
			view.width = View3DCons.WIDTH;
			view.height = View3DCons.HEIGHT;
			//view.backgroundColor = View3DCons.BACKGROUND_COLOR;
			view.background = Cast.bitmapTexture(RoomDesign.RoomBackground);
			
			//setup controller to be used on the camera
			cameraController = new HoverController(camera);
			cameraController.distance = 150;
			cameraController.minTiltAngle = -15;
			cameraController.maxTiltAngle = 90;
			cameraController.panAngle = 45;
			cameraController.tiltAngle = 20;
			
			//root.addChild(view);
			var awayState:AwayStats = new AwayStats(view);
			awayState.x = 924;
			awayState.y = 35;
			root.addChild(awayState);
			
			Parsers.enableAllBundled();
			
			Loader3D.enableParser(OBJParser);
			Loader3D.enableParser(DAEParser);
			Loader3D.enableParser(Max3DSParser);
		}
		
		private function initLight():void
		{
			// add main light (default light)
			/*var light:DirectionalLight = new DirectionalLight();
			light.ambient = 1;
			light.diffuse = 1;
			light.direction = new Vector3D(0, -1, 0);
			light.name = LightInfo.MAIN_LIGHT;			
			//light.castsShadows = true;
			//light.shadowMapper.depthMapSize = 2048;
						
			this.addObjectToScene(light)			
			
			var lightInfo:LightInfo = new LightInfo();
			lightInfo.name = LightInfo.MAIN_LIGHT;
			lightInfo.light = light;
			LightManager.instance.addLight(lightInfo);
			
			lightPicker = new StaticLightPicker([light]);*/
			lightPicker = new StaticLightPicker([])
			
		}
		
		public function show3DView():void
		{			
			LayerManager.instance.addChildAt(view, Layer.VIEW_3D);
			view.visible = true;
		}
		
		public function hide3DView():void
		{			
			if(view.parent)
			{
				view.visible = false;
				view.parent.removeChild(view);
			}
				
		}
		
		
		public function get ui():RoomUI
		{
			return m_ui;
		}
		
		
		public function get roomID():String
		{
			return m_curRoomID;
		}
		
		public function set roomID(id:String):void
		{
			m_curRoomID = id;
		}
		
		public function get roomInfo():RoomInfo
		{
			var info:RoomInfo = null;
			for(var i:int = 0; i < hotelInfo.roomData.length; i++)
			{
				info = hotelInfo.roomData[i]; 
				if(info.id == roomID)
					break;
			}
			return info;
		}
		
		override public function update():void
		{
			super.update();
			StageManager.instance.onUpdate();
			TaskManager.instance.update();
			
			if(!lockCamera)
			{
				
			}
		}
		
		public function render():void
		{
			if(view.parent)
				view.render();
		}
		
		public function resize(stage:Stage):void
		{
			trace("game resize : width" + stage.width + ".  stageHeight : " +stage.stageHeight);
			if(stage.width < View3DCons.WIDTH)
			{
				view.width = stage.width;
				view.x = 0;
			}
			else
			{
				view.width = View3DCons.WIDTH;
				view.x = (stage.width - View3DCons.WIDTH)/2
			}
			
			if(stage.width > View3DCons.HEIGHT + View3DCons.GAP_TOP)
			{
				view.y = View3DCons.GAP_TOP;
				view.height = View3DCons.HEIGHT;
				
			}
			else if(stage.stageHeight < View3DCons.HEIGHT)
			{
				view.y = 0;
				view.height = stage.stageHeight;
			}
			else
			{
				view.y = (stage.stageHeight - View3DCons.HEIGHT)/2;
				view.height = View3DCons.HEIGHT;
			}
			
			ui.resize();
		}
		
		public function onKeyDown(keycode:uint, ctrl:Boolean, shift:Boolean, alt:Boolean):void
		{
			// debug
			switch(keycode)
			{
				case Keyboard.NUMBER_1:
					StageManager.instance.changeStage(1);
					break;
				case Keyboard.NUMBER_2:
					StageManager.instance.changeStage(2);
					break;
				case Keyboard.NUMBER_3:
					StageManager.instance.changeStage(3);
					break;
				
				case Keyboard.NUMPAD_ADD:
					ui.loadingProgress += 10;
					break;
				case Keyboard.NUMPAD_SUBTRACT:
					ui.loadingProgress -= 10;
					break;
			}
		}

		public function get hotelInfo():HotelInfo
		{
			return m_hotelInfo;
		}

		public function set hotelInfo(value:HotelInfo):void
		{
			m_hotelInfo = value;
		}
		
		public function hidePreLoading():void
		{
			if(root)
			{
				if(root.parent)
				{
					var obj:Object = root.parent;
					obj.hideLoading();
				}
			}
		}		
	}
}