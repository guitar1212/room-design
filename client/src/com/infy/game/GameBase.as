package com.infy.game
{
	import away3d.cameras.Camera3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.controllers.HoverController;
	import away3d.materials.lightpickers.StaticLightPicker;
	
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
	}
}