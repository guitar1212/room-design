package com.infy.editor.ui
{
	import com.adobe.images.JPGEncoder;
	import com.adobe.images.PNGEncoder;
	import com.infy.constant.View3DCons;
	
	import fl.controls.Button;
	import fl.controls.Label;
	import fl.controls.RadioButton;
	import fl.controls.RadioButtonGroup;
	import fl.controls.Slider;
	import fl.events.SliderEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.net.FileReference;
	
	/**
	 * 
	 * @long  Dec 24, 2014
	 * 
	 */	
	public class ImageSavePanel extends MovieClip
	{
		private var m_bitmapData:BitmapData;
		
		private var m_qualityLabel:Label;
		
		private var m_curQuality:int = 70;
		
		private var m_curFormat:String = "jpg";
		
		private var m_curSize:String = "view";
		
		private var m_bitmapSprite:Sprite;
		
		public function ImageSavePanel()
		{
			super();
			
			initialize();
		}
		
		private function initialize():void
		{	
			m_bitmapSprite = new Sprite();
			m_bitmapSprite.x = 100;
			m_bitmapSprite.y = 5;
			this.addChild(m_bitmapSprite);
			
			var rbGroup:RadioButtonGroup = new RadioButtonGroup("Image Format");
			rbGroup.addEventListener(MouseEvent.CLICK, onImageFormatSelect);
			
			var jpegRB:RadioButton = new RadioButton();
			jpegRB.label = "JPEG";
			jpegRB.value = "jpg";
			jpegRB.selected = true;
			jpegRB.group = rbGroup;
			jpegRB.move(5, 5);
			this.addChild(jpegRB);
			
			var pngRB:RadioButton = new RadioButton();
			pngRB.label = "PNG";
			pngRB.value = "png";
			pngRB.group = rbGroup;
			pngRB.move(55, 5);
			this.addChild(pngRB);
			
			m_qualityLabel = new Label();
			m_qualityLabel.text = "品質 " + m_curQuality;
			m_qualityLabel.move(15, 35);
			this.addChild(m_qualityLabel);
			
			var s:Slider = new Slider();
			s.maximum = 100;
			s.minimum = 10;
			s.value = 70;
			s.snapInterval = 5;
			s.move(15, 55);
			s.addEventListener(SliderEvent.THUMB_DRAG, onSliderDrag);
			s.addEventListener(SliderEvent.CHANGE, onSliderDrag);
			this.addChild(s);
			
			var sizeLabel:Label = new Label();
			sizeLabel.text = "Size";
			sizeLabel.move(15, 70);
			this.addChild(sizeLabel);
			
			var sizeGroup:RadioButtonGroup = new RadioButtonGroup("Image Size");
			sizeGroup.addEventListener(MouseEvent.CLICK, onImageSizeSelect);
			
			var bigSizeRB:RadioButton = new RadioButton();
			bigSizeRB.label = "View";
			bigSizeRB.value = "view";
			bigSizeRB.selected = true;
			bigSizeRB.group = sizeGroup;
			bigSizeRB.move(5, 90);
			this.addChild(bigSizeRB);
			
			var smallSizeRB:RadioButton = new RadioButton();
			smallSizeRB.label = "Thumb";
			smallSizeRB.value = "thumb";
			smallSizeRB.group = sizeGroup;
			smallSizeRB.move(55, 90);
			this.addChild(smallSizeRB);
			
			var b:Button = new Button();
			b.label = "Save";
			b.addEventListener(MouseEvent.CLICK, onSaveBtnClick);
			b.move(15, 145);
			this.addChild(b);
			
			var b1:Button = new Button();
			b1.label = "Close";
			b1.addEventListener(MouseEvent.CLICK, onCloseBtnClick);
			b1.move(15, 175);
			this.addChild(b1);
			
			var background:Sprite = new Sprite();
			background.graphics.beginFill(0xa2c1d3);
			background.graphics.drawRoundRect(0, 0, this.width, this.height, 5, 5);
			background.graphics.endFill();
			this.addChildAt(background, 0);
			
		}
		
		protected function onCloseBtnClick(event:MouseEvent):void
		{
			if(this.parent)
				this.parent.removeChild(this);
		}
		
		protected function onSaveBtnClick(event:MouseEvent):void
		{
			if(m_bitmapData)
			{
				var b:BitmapData;
				if(m_curSize == "view")
				{	
					b = m_bitmapData;
				}
				else
				{
					var scaleW:Number = 217/View3DCons.WIDTH;
					var scaleH:Number = 107/View3DCons.HEIGHT;
					var bmap:Bitmap = new Bitmap(m_bitmapData);
					var m:Matrix = new Matrix();
					m.scale(scaleW, scaleH);
					b = new BitmapData(217, 107);
					b.draw(bmap, m);
				}
				
				var f:FileReference = new FileReference();
				if(m_curFormat == "jpg")
					f.save(new JPGEncoder(m_curQuality).encode(b), "view.jpg");
				else
					f.save(PNGEncoder.encode(b), "view.png");
			}
			
		}
		
		protected function onSliderDrag(event:SliderEvent):void
		{
			m_curQuality = event.value;
			m_qualityLabel.text = "品質 " + m_curQuality;
		}
		
		protected function onImageFormatSelect(event:MouseEvent):void
		{
			var v:String = event.target.selection.value;
			m_curFormat = v;
		}
		
		protected function onImageSizeSelect(event:MouseEvent):void
		{
			var v:String = event.target.selection.value;
			m_curSize = v;
		}

		public function get bitmapData():BitmapData
		{
			return m_bitmapData;
		}

		public function set bitmapData(value:BitmapData):void
		{
			m_bitmapData = value;
			m_bitmapSprite.removeChildren();
			
			var scaleW:Number = 217/View3DCons.WIDTH;
			var scaleH:Number = 107/View3DCons.HEIGHT;
			var bmap:Bitmap = new Bitmap(m_bitmapData);
			var m:Matrix = new Matrix();
			m.scale(scaleW, scaleH);
			var b:BitmapData = new BitmapData(217, 107);
			b.draw(bmap, m);
			
			m_bitmapSprite.addChild(new Bitmap(b));
		}

	}
}