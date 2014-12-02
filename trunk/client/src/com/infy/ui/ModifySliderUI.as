package com.infy.ui
{
	import fl.events.SliderEvent;

	/**
	 * 
	 * @long  Dec 2, 2014
	 * 
	 */	
	public class ModifySliderUI extends ModifySlider
	{
		private var m_maxValue:Number;
		private var m_minValue:Number;
		private var m_currentValue:Number;
		
		private var m_defalutValue:Number
		
		private var m_cb:Function = null;
		
		public function ModifySliderUI(title:String, defaultValue:Number, min:Number, max:Number, cb:Function = null)
		{
			super();
			this.label.text = title;
			this.slider.minimum = min;
			this.slider.maximum = max;
			this.slider.value = defaultValue;
			
			this.value.text = defaultValue.toString();
			
			this.m_cb = cb;
			
			this.slider.addEventListener(SliderEvent.THUMB_DRAG, onSliderDrag);
		}
		
		protected function onSliderDrag(event:SliderEvent):void
		{	
			this.value.text = event.value.toString();
			if(m_cb != null)
				m_cb(label.text, event.value);
		}
		
		public function set sliderValue(_value:int):void
		{
			this.slider.value = _value;
			this.value.text = _value.toString();;
		}
	}
}