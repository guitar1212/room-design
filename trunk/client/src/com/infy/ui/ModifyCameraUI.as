package com.infy.ui
{
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.controllers.ControllerBase;
	import away3d.controllers.HoverController;
	
	import fl.controls.CheckBox;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * 
	 * @long  Dec 2, 2014
	 * 
	 */	
	public class ModifyCameraUI extends Sprite
	{
		private var m_dx:int = 5;
		private var m_dy:int = 5;
		
		private var m_targetCameraController:ControllerBase = null;
		
		private var m_checkbox:CheckBox = new CheckBox();
		
		private var m_checkCB:Function = null;
		
		public function ModifyCameraUI()
		{
			super();			
			m_checkbox.x = m_dx;
			m_checkbox.y = m_dy;
			m_dy += 25;
			m_checkbox.label = "Lock camera";			
			this.addChild(m_checkbox);
			m_checkbox.addEventListener(Event.CHANGE, onCheckBoxChange);
			
			addSlider("panAngle", 0, -180, 180, onSlideChange);
			addSlider("tiltAngle", 0, -90, 90, onSlideChange);			
			addSlider("near", 5, 1, 100, onSlideChange);
			addSlider("far", 3000, 1000, 5000, onSlideChange);
			addSlider("distance", 150, 20, 1000, onSlideChange);
			addSlider("fov", 60, 16, 75, onSlideChange);
						
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		protected function onCheckBoxChange(event:Event):void
		{
			// TODO Auto-generated method stub
			var select:Boolean = CheckBox(event.target).selected;
			if(m_checkCB != null)	
				m_checkCB(select);
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			event.stopPropagation();
		}
		
		public function addSlider(title:String, defaultVal:Number, min:Number, max:Number, cb:Function):void
		{
			var s:ModifySliderUI = new ModifySliderUI(title, defaultVal, min, max, cb);
			s.x = m_dx;
			s.y = m_dy;
			this.addChild(s);
			
			m_dy += 25;
		}
		
		public function set target(contoller:ControllerBase):void
		{
			m_targetCameraController = contoller;
		}
		
		private function onSlideChange(title:String, value:Number):void
		{
			if(m_targetCameraController == null) return;
			
			var cam:Camera3D = m_targetCameraController.targetObject as Camera3D;
			
			if(title == "panAngle")  HoverController(m_targetCameraController).panAngle = value;
			if(title == "tiltAngle")  HoverController(m_targetCameraController).tiltAngle = value;
			if(title == "near") cam.lens.near = value;
			if(title == "far") cam.lens.far = value;
			if(title == "fov") PerspectiveLens(cam.lens).fieldOfView = value;
			if(title == "distance") HoverController(m_targetCameraController).distance = value;			
		}
				
		public function set checkCallback(cb:Function):void
		{
			m_checkCB = cb;
		}
		
	}
}