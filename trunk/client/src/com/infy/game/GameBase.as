package com.infy.game
{
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.controllers.HoverController;
	import away3d.entities.Mesh;
	import away3d.materials.TextureMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	
	import com.infy.camera.CameraInfo;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.EventDispatcher;
	
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
		
		
		public function setCamera(info:CameraInfo, type:String = "P"):void
		{
			cameraController = null;
			cameraController = new HoverController(camera);
			cameraController.distance = info.distance;
			cameraController.minTiltAngle = -15;
			cameraController.maxTiltAngle = 90;
			cameraController.panAngle = info.panAngle;
			cameraController.tiltAngle = info.tiltAngle;
			camera.lens.near = info.near;
			camera.lens.far = info.far;
			PerspectiveLens(camera.lens).fieldOfView = info.fov;
			HoverController(cameraController).lookAtPosition = info.lookAt.clone();
		}
	}
}