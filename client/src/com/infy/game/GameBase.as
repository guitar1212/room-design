package com.infy.game
{
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
	
	import com.infy.camera.CameraInfo;
	import com.infy.constant.View3DCons;
	import com.infy.event.GameEvent;
	import com.infy.light.LightInfo;
	import com.infy.parser.command.LightParserCommand;
	import com.infy.util.TimerManager;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
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
		
		private var m_bLockCamera:Boolean = true;
		
		public function GameBase(root:Sprite)
		{
			m_root = root;	
			initialize();
		}
		
		public function initialize():void
		{
			root.stage.scaleMode = StageScaleMode.NO_SCALE;
			root.stage.align = StageAlign.TOP_LEFT;
			
			scene = new Scene3D();
			
			camera = new Camera3D();
			
			view = new View3D();
			
			view.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			view.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			root.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			root.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		protected function onKeyUp(event:KeyboardEvent):void
		{
			m_shiftKeyDown = event.shiftKey;
		}
		
		protected function onKeyDown(event:KeyboardEvent):void
		{
			m_shiftKeyDown = event.shiftKey;
			
			keyDown(event.keyCode, event.ctrlKey, event.shiftKey, event.altKey);
		}
		
		protected function keyDown(keycode:uint, ctrl:Boolean, shift:Boolean, alt:Boolean):void
		{
		}	
		
		protected function onMouseUp(event:MouseEvent):void
		{
			m_moveCamera = false;
			root.stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			if(cameraController)
			{
				lastPanAngle = cameraController.panAngle;
				lastTiltAngle = cameraController.tiltAngle;
				lastMouseX = root.stage.mouseX;
				lastMouseY = root.stage.mouseY;
				m_moveCamera = true;
				root.stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
				if(event.shiftKey)
				{
					lastPanX = root.stage.mouseX;
					lastPanY = root.stage.mouseY;
				}
			}
		}
		
		protected function onStageMouseLeave(event:Event):void
		{
			onMouseUp(null);
		}
		
		public function update():void
		{
			if(!lockCamera)
			{
				if(m_moveCamera)
				{
					if(m_shiftKeyDown)
					{
						var dx:Number = 0.3*(root.stage.mouseX - lastPanX);
						var dy:Number = 0.3*(root.stage.mouseY - lastPanY);
						
						cameraController.lookAtPosition.x -= dx;
						
						if(camera.lens is OrthographicLens)						
							cameraController.lookAtPosition.z += dy;
						else
							cameraController.lookAtPosition.y += dy;
						
						cameraController.update();
						lastPanX = root.stage.mouseX;
						lastPanY = root.stage.mouseY;
						lastMouseX = root.stage.mouseX;
						lastMouseY = root.stage.mouseY;
					}
					else
					{
						cameraController.panAngle = 0.3*(root.stage.mouseX - lastMouseX) + lastPanAngle;
						cameraController.tiltAngle = 0.3*(root.stage.mouseY - lastMouseY) + lastTiltAngle;
					}
				}
			}
		}
		
		public function get root():Sprite
		{
			return m_root;
		}
		
		public function get lockCamera():Boolean
		{
			return m_bLockCamera;
		}
		
		public function set lockCamera(value:Boolean):void
		{
			m_bLockCamera = value;
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
			if(info.type == "P")
				cameraController.steps = 25;
			else if(info.type == "O")
				cameraController.steps = 2;
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
		private var m_moveCamera:Boolean;
		private var lastPanAngle:Number;
		private var lastTiltAngle:Number;
		private var lastMouseX:Number;
		private var lastMouseY:Number;
		private var lastPanX:Number;
		private var lastPanY:Number;
		
		// key state
		private var m_shiftKeyDown:Boolean = false;
		
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