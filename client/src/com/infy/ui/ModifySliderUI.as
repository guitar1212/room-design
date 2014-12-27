package com.infy.ui
{
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	import fl.events.SliderEvent;

	/**
	 * 
	 * @long  Dec 2, 2014
	 * 
	 */	
	public class ModifySliderUI extends ModifySlider
	{
		private var m_currentValue:Number;
		
		private var m_defalutValue:Number
		
		private var m_cb:Function = null;
		
		public function ModifySliderUI(title:String, defaultValue:Number, min:Number, max:Number, cb:Function = null, snapInterval:Number = 1)
		{
			super();
			this.label.text = title;
			this.slider.minimum = min;
			this.slider.maximum = max;
			this.slider.value = defaultValue;
			this.slider.snapInterval = snapInterval;
			
			this.value.text = defaultValue.toString();
			
			this.m_cb = cb;
			
			this.slider.addEventListener(SliderEvent.THUMB_DRAG, onSliderDrag);
			this.slider.addEventListener(SliderEvent.CHANGE, onSliderDrag);
			this.addEventListener(MouseEvent.MOUSE_UP, onSliderDragFinish);
			this.addEventListener(MouseEvent.MOUSE_DOWN, onSliderDragStart);
		}
		
		protected function onSliderDragStart(event:MouseEvent):void
		{
			this.label.filters = [new GlowFilter(0xffff11)];
		}
		
		protected function onSliderDragFinish(event:MouseEvent):void
		{
			this.label.filters = [];
		}
		
		protected function onSliderDrag(event:SliderEvent):void
		{	
			this.value.text = event.value.toString();
			if(m_cb != null)
				m_cb(label.text, event.value);
		}
		
		public function set sliderValue(_value:Number):void
		{
			this.slider.value = _value;
			this.value.text = _value.toString();
		}
		
		public function set title(t:String):void
		{
			this.label.text = t;
		}
		
		public function set maxValue(value:Number):void
		{
			this.slider.maximum = value;
		}
		
		public function set minValue(value:Number):void
		{
			this.slider.minimum = value;
		}
	}
}