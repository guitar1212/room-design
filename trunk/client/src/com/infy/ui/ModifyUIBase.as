package com.infy.ui
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import away3d.cameras.Camera3D;
	import away3d.controllers.ControllerBase;
	import away3d.core.base.Object3D;
	import away3d.entities.Entity;
	
	public class ModifyUIBase extends Sprite
	{
		private var m_dx:int = 5;
		private var m_dy:int = 5;
		
		private var m_target:*;
		
		public function ModifyUIBase()
		{
			super();
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			event.stopPropagation();
		}
		
		public function addSlider(index:int, title:String, defaultVal:Number, min:Number, max:Number, cb:Function):void
		{
			var s:ModifySliderUI = new ModifySliderUI(title, defaultVal, min, max, cb);
			s.x = m_dx;
			s.y = m_dy;
			this.addChildAt(s, index);
			
			m_dy += 25;
		}
		
		public function set target(_val:*):void
		{
			m_target = _val;
			refresh();
		}
		
		public function refresh():void
		{
			// TODO Auto Generated method stub
			
		}
	}
}