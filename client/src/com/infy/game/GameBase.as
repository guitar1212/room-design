package com.infy.game
{
	import com.infy.camera.CameraInfo;
	import com.infy.constant.View3DCons;
	import com.infy.event.GameEvent;
	import com.infy.light.LightInfo;
	import com.infy.parser.command.LightParserCommand;
	import com.infy.util.TimerManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.EventDispatcher;
	import flash.net.FileReference;
	
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.OrthographicLens;
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.controllers.HoverController;
	import away3d.entities.Mesh;
	import away3d.lights.DirectionalLight;
	import away3d.lights.LightBase;
	import away3d.lights.PointLight;
	import away3d.materials.TextureMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	
	/**
	 * 
	 * @long  Dec 15, 2014
	 * 
	 */	
	public class GameBase extends EventDispatcher
	{
		private var m_root:Sprite;
		
		public var scene:Scene3D;
		public var view:View3D;
		public var camera:Camera3D;
		
		public var cameraController:HoverController;
		
		public var lightPicker:StaticLightPicker;
		
		public function GameBase(root:Sprite)
		{
			m_root = root;	
			initialize();
		}
		
		public function initialize():void
		{
			root.stage.scaleMode = StageScaleMode.NO_SCALE;
			root.stage.align = StageAlign.TOP_LEFT;
		}
		
		public function update():void
		{
			
		}
		
		public function get root():Sprite
		{
			return m_root;
		}
		
		public function addObjectToScene(obj:ObjectContainer3D):void
		{
			scene.addChild(obj);
		}
		
		public function remvoeObjectFromeScene(obj:ObjectContainer3D):void
		{
			scene.removeChild(obj);
		}
		
		public function prepareObjectContainer(container:ObjectContainer3D):void
		{
			var i:int = 0, len:int = container.numChildren;
			for(i; i < len; i++)
			{
				var o:ObjectContainer3D = container.getChildAt(i);
				if(o is Mesh)
				{
					var mesh:Mesh = o as Mesh;
					mesh.mouseEnabled = true;
					if(mesh.material is TextureMaterial)
					{
						//TextureMaterial(mesh.material).alphaBlending = true;
						TextureMaterial(mesh.material).alphaThreshold = 0.5;
					}
					//mesh.material = m;
					mesh.material.lightPicker = this.lightPicker;
					//md.displayVertexNormals(mesh, 0x66ccff, 15000);
					//mesh.addEventListener(MouseEvent3D.MOUSE_DOWN, on3DObjeMouseDown);
					//drawWireFrame(mesh);
				}
				else
				{
					prepareObjectContainer(o);
				}
				
			}
		}
		
		public function createLight(lightInfo:LightInfo):LightBase
		{
			var type:String = lightInfo.type;
			var light:LightBase;
			if(type == LightParserCommand.TYPE_DIRECTION)
			{
				light = new DirectionalLight();
				(light as DirectionalLight).direction = lightInfo.direction;
				
			}
			else if(type == LightParserCommand.TYPE_POINT)
			{
				light = new PointLight();
				(light as PointLight).radius = lightInfo.radius;
				(light as PointLight).fallOff = lightInfo.fallOff;
			}
			
			light.name = lightInfo.name;
			light.ambient = lightInfo.ambient;
			light.ambientColor = lightInfo.color;
			light.diffuse = lightInfo.diffuse;
			light.specular = lightInfo.specular;
			light.color = lightInfo.color;
			light.castsShadows = lightInfo.castsShadows;
			
			if(lightInfo.addToLightPicker)
			{
				var a:Array = lightPicker.lights;
				a.push(light);
				lightPicker.lights = a;
			}
			
			lightInfo.light = light;
			
			return light;
		}
		
		public function setCamera(info:CameraInfo, type:String = "P"):void
		{
			if(cameraController)
			{
				cameraController.targetObject = null;				
				cameraController = null;
			}
			if(info.type == "P")
			{
				camera.lens = new PerspectiveLens();
				PerspectiveLens(camera.lens).fieldOfView = info.fov;
			}
			else if(info.type == "O")
			{
				camera.lens = new OrthographicLens();
				OrthographicLens(camera.lens).projectionHeight = info.projectionHeight;
			}
			
			cameraController = new HoverController(camera);
			cameraController.steps = 40;
			cameraController.distance = info.distance;
			cameraController.minTiltAngle = -15;
			cameraController.maxTiltAngle = 90;
			cameraController.panAngle = info.panAngle;
			cameraController.tiltAngle = info.tiltAngle;
			
			camera.lens.near = info.near;
			camera.lens.far = info.far;
			
			HoverController(cameraController).lookAtPosition = info.lookAt.clone();
		}
		
		private var m_bitmapdata:BitmapData;
		private var m_bScreenCapture:Boolean = false;
		public function captureScreen():void
		{
			if(!m_bScreenCapture)
			{
				m_bitmapdata = null;
				m_bitmapdata = new BitmapData(View3DCons.WIDTH, View3DCons.HEIGHT);
				
				view.renderer.queueSnapshot(m_bitmapdata);
				m_bScreenCapture = true;
				
				TimerManager.instance.register(onCaptureScreenFinish, 500, 1);
			}
		}
		
		private function onCaptureScreenFinish():void
		{
			m_bScreenCapture = false;
			
			var event:GameEvent = new GameEvent(GameEvent.CAPTURE_SCREEN_COMPLETE);
			event.bitmapData = m_bitmapdata;
			this.dispatchEvent(event);
		}
		
		public function cleanScene():void
		{
			while(scene.numChildren > 0)
			{
				scene.removeChildAt(0);
			}
			
			this.lightPicker.lights = [];
		}
	}
}