package com.infy.ui
{
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.controllers.ControllerBase;
	import away3d.controllers.HoverController;
	
	import com.infy.event.CameraEvent;
	
	import fl.controls.CheckBox;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import flashx.textLayout.formats.Direction;

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
			
			addSlider(0, "panAngle", 0, -180, 180, 1);
			addSlider(1, "tiltAngle", 0, -90, 90, 1);			
			addSlider(2, "near", 5, 1, 100, 1);
			addSlider(3, "far", 3000, 1000, 5000, 1);
			addSlider(4, "distance", 150, 20, 1000, 1);
			addSlider(5, "fov", 60, 16, 75, 0.5);
						
			
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
		
		public function addSlider(index:int, title:String, defaultVal:Number, min:Number, max:Number, interval:Number):void
		{
			var s:ModifySliderUI = new ModifySliderUI(title, defaultVal, min, max, onSlideChange);
			s.x = m_dx;
			s.y = m_dy;
			this.addChildAt(s, index);
			
			m_dy += 25;
		}
		
		public function set target(contoller:ControllerBase):void
		{
			m_targetCameraController = contoller;
			
			setAtributMapping();
			
			refresh();
		}
		
		private function setAtributMapping():void
		{	
		}
		
		public function refresh():void
		{
			var cam:Camera3D = m_targetCameraController.targetObject as Camera3D;
			
			//ModifySliderUI(getChildAt(0)).sliderValue = HoverController(m_targetCameraController).panAngle;
			ModifySliderUI(getChildAt(0)).sliderValue = m_targetCameraController["panAngle"];
			ModifySliderUI(getChildAt(1)).sliderValue = HoverController(m_targetCameraController).tiltAngle;
			ModifySliderUI(getChildAt(2)).sliderValue = cam.lens.near;
			ModifySliderUI(getChildAt(3)).sliderValue = cam.lens.far;
			ModifySliderUI(getChildAt(4)).sliderValue = HoverController(m_targetCameraController).distance;
			ModifySliderUI(getChildAt(5)).sliderValue = PerspectiveLens(cam.lens).fieldOfView;			
		}
		
		private function onSlideChange(title:String, value:Number):void
		{
			if(m_targetCameraController == null) return;
			
			var cam:Camera3D = m_targetCameraController.targetObject as Camera3D;
			
			if(title == "panAngle")  HoverController(m_targetCameraController).panAngle = value;
			if(title == "tiltAngle")  HoverController(m_targetCameraController).tiltAngle = value;
			if(title == "near") cam.lens.near = value;
			if(title == "far") cam.lens.far = value;			
			if(title == "distance") HoverController(m_targetCameraController).distance = value;
			if(title == "fov") PerspectiveLens(cam.lens).fieldOfView = value;
			
			var event:CameraEvent = new CameraEvent(CameraEvent.CHANGE);
			event.attribute = title;
			event.value = value;
			this.dispatchEvent(event);
		}
				
		public function set checkCallback(cb:Function):void
		{			
			m_checkCB = cb;
		}
		
	}
}