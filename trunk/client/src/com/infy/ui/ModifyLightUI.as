package com.infy.ui
{
	import away3d.entities.Mesh;
	import away3d.lights.DirectionalLight;
	import away3d.lights.LightBase;
	import away3d.loaders.Loader3D;
	import away3d.materials.SinglePassMaterialBase;
	
	import com.infy.util.tools.ColorUtil;
	
	import fl.controls.Label;
	import fl.events.InteractionInputType;
	import fl.events.SliderEvent;
	
	import flash.display.Sprite;
	
	/**
	 * 
	 * @long  Dec 4, 2014
	 * 
	 */	
	public class ModifyLightUI extends Sprite
	{
		private var m_dx:int = 5;
		private var m_dy:int = 20;
		
		private var m_target:LightBase;
		
		private var m_title:Label = new Label();
		
		public function ModifyLightUI(title:String)
		{
			super();
			
			m_title.text = title;
			this.addChild(m_title);
			
			addSlider(0, "ambient", 1, 0, 2, 0.1);
			addSlider(1, "diffuse", 1, 0, 2, 0.1);
			addSlider(2, "specular", 0, 0, 2, 0.1);
			addSlider(3, "color R", 0, 0, 255, 1);
			addSlider(4, "color G", 0, 0, 255, 1);
			addSlider(5, "color B", 0, 0, 255, 1);
			addSlider(6, "dir X", 0, -1, 1, 0.1);
			addSlider(7, "dir Y", -1, -1, 1, 0.1);
			addSlider(8, "dir Z", 0, -1, 1, 0.1);
		}
		
		private function refresh():void
		{
			if(m_target)
			{
				var rbg:Array = ColorUtil.getRGB(m_target.color);
				ModifySliderUI(getChildAt(0)).sliderValue = m_target.ambient;
				ModifySliderUI(getChildAt(1)).sliderValue = m_target.diffuse;
				ModifySliderUI(getChildAt(2)).sliderValue = m_target.specular;
				ModifySliderUI(getChildAt(3)).sliderValue = rbg[0];
				ModifySliderUI(getChildAt(4)).sliderValue = rbg[1];
				ModifySliderUI(getChildAt(5)).sliderValue = rbg[2];
				ModifySliderUI(getChildAt(6)).sliderValue = DirectionalLight(m_target).direction.x;
				ModifySliderUI(getChildAt(7)).sliderValue = DirectionalLight(m_target).direction.y;
				ModifySliderUI(getChildAt(8)).sliderValue = DirectionalLight(m_target).direction.z;
			}
		}
				
		public function addSlider(index:int, title:String, defaultVal:Number, min:Number, max:Number, interva:Number):void
		{
			var s:ModifySliderUI = new ModifySliderUI(title, defaultVal, min, max, onSlideChange, interva);
			s.x = m_dx;
			s.y = m_dy;
			this.addChildAt(s, index);
			
			m_dy += 25;
		}
		
		private function onSlideChange(title:String, value:Number):void
		{
			if(m_target == null) return;
			
			var rgb:Array = ColorUtil.getRGB(m_target.color);
			
			if(title == "ambient") m_target.ambient = value;
			if(title == "diffuse") m_target.diffuse = value;
			if(title == "specular") m_target.specular = value;
			if(title == "color R") m_target.color = ColorUtil.getHexCode(value, rgb[1], rgb[2]);
			if(title == "color G") m_target.color = ColorUtil.getHexCode(rgb[0], value, rgb[2]);
			if(title == "color B") m_target.color = ColorUtil.getHexCode(rgb[0], rgb[1], value);
			if(title == "dir X") DirectionalLight(m_target).direction.x = value;
			if(title == "dir Y") DirectionalLight(m_target).direction.y = value;
			if(title == "dir Z") DirectionalLight(m_target).direction.z = value;
			
			var event:SliderEvent = new SliderEvent(SliderEvent.CHANGE, value, title, InteractionInputType.MOUSE);
			this.dispatchEvent(event);
		}

		public function get target():LightBase
		{
			return m_target;
		}

		public function set target(value:LightBase):void
		{
			m_target = value;
			refresh();
		}
			
	}
}