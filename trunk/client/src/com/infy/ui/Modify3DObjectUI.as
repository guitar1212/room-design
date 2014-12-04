package com.infy.ui
{
	import away3d.containers.ObjectContainer3D;
	
	import com.infy.event.ObjEvent;
	
	import flash.display.Sprite;

	/**
	 * 
	 * @long  Dec 3, 2014
	 * 
	 */	
	public class Modify3DObjectUI extends Sprite
	{
		private var m_dx:int = 5;
		private var m_dy:int = 5;
		
		private var m_target:ObjectContainer3D = null;
		
		public function Modify3DObjectUI()
		{
			super();
			
			addSlider(0, "x", 0, -500, 500, 1);
			addSlider(1, "y", 0, -500, 500, 1);			
			addSlider(2, "z", 0, -500, 500, 1);
			addSlider(3, "scale", 1, 0.1, 10, 0.1);
			addSlider(4, "rotX", 0, -180, 180, 1);
			addSlider(5, "rotY", 0, -180, 180, 1);
			addSlider(6, "rotZ", 0, -180, 180, 1);
			
		}
		
		public function addSlider(index:int, title:String, defaultVal:Number, min:Number, max:Number, intervar:Number):void
		{
			var s:ModifySliderUI = new ModifySliderUI(title, defaultVal, min, max, onSlideChange, intervar);
			s.x = m_dx;
			s.y = m_dy;
			this.addChildAt(s, index);
			
			m_dy += 25;
		}
		
		private function onSlideChange(title:String, value:Number):void
		{
			if(m_target == null) return;
			if(title == "x")  m_target.x = value;
			if(title == "y")  m_target.y = value;
			if(title == "z")  m_target.z = value;
			if(title == "scale")  m_target.scaleX = m_target.scaleY = m_target.scaleZ = value;
			if(title == "rotX")  m_target.rotationX = value;
			if(title == "rotY")  m_target.rotationY = value;
			if(title == "rotZ")  m_target.rotationZ = value;
			
			var ent:ObjEvent = new ObjEvent(ObjEvent.CHANGE);
			ent.attribute = title;
			ent.value = value;
			
			this.dispatchEvent(ent);
		}
		
		public function refresh():void
		{
			if(m_target)
			{
				ModifySliderUI(getChildAt(0)).sliderValue = m_target.x;
				ModifySliderUI(getChildAt(1)).sliderValue = m_target.y;
				ModifySliderUI(getChildAt(2)).sliderValue = m_target.z;
				ModifySliderUI(getChildAt(3)).sliderValue = m_target.scaleX;
				ModifySliderUI(getChildAt(4)).sliderValue = m_target.rotationX;
				ModifySliderUI(getChildAt(5)).sliderValue = m_target.rotationY;
				ModifySliderUI(getChildAt(6)).sliderValue = m_target.rotationZ;
			}
		}

		public function get target():ObjectContainer3D
		{
			return m_target;
		}

		public function set target(value:ObjectContainer3D):void
		{
			m_target = value;
			refresh();
		}

	}
}