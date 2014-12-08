package com.infy.ui
{
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.loaders.Loader3D;
	import away3d.materials.SinglePassMaterialBase;
	
	import com.infy.event.ObjEvent;
	
	import fl.controls.CheckBox;
	import fl.controls.Label;
	
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * 
	 * @long  Dec 3, 2014
	 * 
	 */	
	public class Modify3DObjectUI extends Sprite
	{
		private var m_dx:int = 5;
		private var m_dy:int = 5;
		
		private var m_title:Label = new Label();
		
		private var m_target:ObjectContainer3D = null;
		
		private var m_castShadow:CheckBox = new CheckBox();
		
		public function Modify3DObjectUI()
		{
			super();
			
			m_title.x = 100;
			m_title.y = m_dy;
			this.addChild(m_title);
			m_dy += 20;			
			
			m_castShadow.label = "cast shadow";
			m_castShadow.x = 100;
			m_castShadow.y = m_dy;
			m_dy += 20;
			this.addChild(m_castShadow);
			m_castShadow.addEventListener(Event.CHANGE, onCheckBoxChange);
			
			
			addSlider(0, "x", 0, -500, 500, 1);
			addSlider(1, "y", 0, -500, 500, 1);			
			addSlider(2, "z", 0, -500, 500, 1);
			addSlider(3, "scale", 1, 0.1, 10, 0.1);
			addSlider(4, "rotX", 0, -180, 180, 1);
			addSlider(5, "rotY", 0, -180, 180, 1);
			addSlider(6, "rotZ", 0, -180, 180, 1);
			addSlider(7, "shadow epsilon", 0.2, 0, 3, 0.1);
		}
		
		protected function onCheckBoxChange(event:Event):void
		{
			var select:Boolean = CheckBox(event.target).selected;
			if(m_target is Mesh)
			{
				(m_target as Mesh).castsShadows = select;
			}
			else if(m_target is Loader3D)
			{
				var l:Loader3D = m_target as Loader3D;
				for(var i:int = 0; i < l.numChildren; i++)
				{
					var m:Mesh = l.getChildAt(i) as Mesh;
					if(m)
						m.castsShadows = select;
				}
			}
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
			if(title == "shadow epsilon") 
			{
				if(m_target is Mesh)
				{
					var m:SinglePassMaterialBase = (m_target as Mesh).material as SinglePassMaterialBase
					if(m && m.shadowMethod)
						m.shadowMethod.epsilon = value;
				}
			}
			
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
				
				var bShadow:Boolean = true;
				if(m_target is Mesh)
				{
					bShadow = (m_target as Mesh).castsShadows;
				}
				m_castShadow.selected = bShadow;
			}
		}

		public function get target():ObjectContainer3D
		{
			return m_target;
		}

		public function set target(value:ObjectContainer3D):void
		{
			m_target = value;
			
			m_title.text = value.name;
			refresh();
		}

	}
}