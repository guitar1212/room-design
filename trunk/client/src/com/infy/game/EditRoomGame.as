package com.infy.game
{
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.controllers.HoverController;
	import away3d.core.pick.PickingType;
	import away3d.debug.AwayStats;
	import away3d.lights.DirectionalLight;
	import away3d.lights.LightBase;
	import away3d.loaders.Loader3D;
	import away3d.loaders.parsers.DAEParser;
	import away3d.loaders.parsers.Max3DSParser;
	import away3d.loaders.parsers.OBJParser;
	import away3d.loaders.parsers.Parsers;
	import away3d.materials.lightpickers.StaticLightPicker;
	
	import com.infy.constant.View3DCons;
	import com.infy.event.RoomEvent;
	import com.infy.light.LightInfo;
	import com.infy.light.LightManager;
	
	import flash.display.Sprite;
	import flash.geom.Vector3D;
	
	/**
	 * 
	 * @long  Dec 15, 2014
	 * 
	 */	
	public class EditRoomGame extends GameBase
	{
		public var noShadowLightPicker:StaticLightPicker;
		
		//private var camLight:PointLight;
		
		public function EditRoomGame(root:Sprite)
		{
			super(root);
		}
		
		override public function initialize():void
		{
			super.initialize();
			initEngine();
			initLights();
		}
		
		private function initEngine():void
		{			
			var lens:PerspectiveLens = new PerspectiveLens();
			lens.near = 5;
			camera.lens = lens;
			camera.name = "mainCamera";
			
			view.name = "gameView";
			view.antiAlias = 4;
			view.scene = scene;
			view.camera = camera;
			view.backgroundColor = View3DCons.BACKGROUND_COLOR;
			view.width = View3DCons.WIDTH;
			view.height = View3DCons.HEIGHT;
			view.mousePicker = PickingType.RAYCAST_BEST_HIT
			
			//setup controller to be used on the camera
			cameraController = new HoverController(camera);
			cameraController.distance = 150;
			cameraController.minTiltAngle = -15;
			cameraController.maxTiltAngle = 90;
			cameraController.panAngle = 45;
			cameraController.tiltAngle = 20;
			
			view.addSourceURL("srcview/index.html");
			root.addChild(view);
			
			root.addChild(new AwayStats(view));
			
			Parsers.enableAllBundled();
			
			Loader3D.enableParser(OBJParser);
			Loader3D.enableParser(DAEParser);
			Loader3D.enableParser(Max3DSParser);
		}
		
		private function initLights():void
		{
			/*var light1:DirectionalLight = new DirectionalLight();
			light1.direction = new Vector3D(0, -1, 0);
			light1.ambient = 1.0;
			light1.diffuse = 1.0;
			light1.name = LightInfo.MAIN_LIGHT;
			light1.castsShadows
			//light1.castsShadows = true;
			//light1.shadowMapper.depthMapSize = 2048;			
			addLight(light1)*/;
			
			var light2:DirectionalLight = new DirectionalLight();
			light2.direction = new Vector3D(0, -1, 0);
			light2.color = 0xFFFFFF;
			light2.ambient = 0.1;
			light2.diffuse = 0.7;
			light2.name = "no_shadow_light";			
			//addLight(light2);
			
			lightPicker = new StaticLightPicker([]);
			noShadowLightPicker = new StaticLightPicker([light2]);
		}
		
		
		public function addLight(light:LightBase):void
		{
			var info:LightInfo = new LightInfo();
			info.name = light.name;
			
			LightManager.instance.addLight(info);
			
			//scene.addChild(light);
			
			var e:RoomEvent = new RoomEvent(RoomEvent.CREATE_LIGHT);
			e.object = info;
			e.objType = "light";
			this.dispatchEvent(e);
		}
		
		override public function addObjectToScene(obj:ObjectContainer3D):void
		{
			super.addObjectToScene(obj);
		}
		
		override public function remvoeObjectFromeScene(obj:ObjectContainer3D):void
		{
			super.remvoeObjectFromeScene(obj);
		}
		
		override public function update():void
		{			
			//camLight.position = camera.position;
			super.update();
		}
	}
}