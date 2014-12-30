package com.infy.editor
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	/**
	 * 
	 * @long  Dec 30, 2014
	 * 
	 */	
	public class Editor2DRoom extends Sprite
	{
		
		[Embed(source="/../embeds/Ediror2DRoom/ic_cancel_black_24dp.png")]
		public static var cancelIcon:Class;
		
		[Embed(source="/../embeds/Ediror2DRoom/ic_grid_on_black_24dp.png")]
		public static var gridIcon:Class;
		
		[Embed(source="/../embeds/Ediror2DRoom/ic_add_circle_outline_black_24dp.png")]
		public static var plusIcon:Class;
		
		[Embed(source="/../embeds/Ediror2DRoom/ic_remove_circle_outline_black_24dp.png")]
		public static var subIcon:Class;
		
		[Embed(source="/../embeds/Ediror2DRoom/ic_crop_din_black_24dp.png")]
		public static var drawRecIcon:Class;
		
		[Embed(source="/../embeds/Ediror2DRoom/ic_panorama_fisheye_black_24dp.png")]
		public static var drawCircleIcon:Class;
		
		private static const GRID_SIZE:Number = 200;
		private static const GRID_WIDTH:Number = 10;
			
		private static const DIALOG_WIDTH:Number = 800;
		private static const DIALOG_HEIGHT:Number = 600;
		
		private static const DRAW_AREA_WIDTH:Number = 750;
		private static const DRAW_AREA_HEIGHT:Number = 450;
		
		private var m_scale:Number = 1;
		
		private var m_layerList:Vector.<Sprite> = new Vector.<Sprite>();
		private static const TOTAL_LAYERS:int = 3;
		
		private var m_background:Sprite;
		private var m_drawArea:Sprite;
		private var m_grid:Sprite;
		
		private var m_lastX:Number;
		private var m_lastY:Number;
		private var m_bMove:Boolean = false;
		
		private var m_buttonList:Array = [];
		private var m_functionButtonBar:Sprite;
		
		public function Editor2DRoom()
		{
			super();
			
			firstInitialize();
		}
		
		private function firstInitialize():void
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onInit);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRelease);
			
			for(var i:int = 0; i < TOTAL_LAYERS; i++)
			{
				var layer:Sprite = new Sprite();
				m_layerList.push(layer);
				this.addChild(layer);
			}
			
			m_background = new Sprite();
			m_background.graphics.beginFill(0x888888);
			m_background.graphics.drawRect(0,0,DIALOG_WIDTH,DIALOG_HEIGHT);
			m_background.graphics.endFill();
			this.addChildToLayer(0, m_background);
			
			m_drawArea = new Sprite();
			m_drawArea.graphics.beginFill(0x333333);
			var _x:Number = (DIALOG_WIDTH - DRAW_AREA_WIDTH)/2;
			var _y:Number = (DIALOG_HEIGHT - DRAW_AREA_HEIGHT)/2;
			m_drawArea.graphics.drawRect(0,0,DRAW_AREA_WIDTH,DRAW_AREA_HEIGHT);
			m_drawArea.graphics.endFill();
			m_drawArea.x = _x;
			m_drawArea.y = _y;
			this.addChildToLayer(0, m_drawArea);
						
			m_grid = new Sprite();
			m_drawArea.addChild(m_grid);
			
			var drawMash:Sprite = new Sprite();
			drawMash.graphics.beginFill(0xffffff);
			drawMash.graphics.drawRect(0,0,DRAW_AREA_WIDTH,DRAW_AREA_HEIGHT);
			drawMash.graphics.endFill();
			m_drawArea.addChild(drawMash);
			m_drawArea.mask = drawMash;
			
			m_functionButtonBar = new Sprite();
			m_functionButtonBar.x = 20;
			m_functionButtonBar.y = 40;
			this.addChild(m_functionButtonBar);
			
			var cancelBtn:SimpleButton = createButton(cancelIcon, onCancelBtnClick, false);
			this.addChild(cancelBtn);
			
			createButton(gridIcon, ToggleGrid, true);			
			createButton(plusIcon, onScaleUp, true);
			createButton(subIcon, onScaleDown, true);
			createButton(drawRecIcon, onDrawRectangle, true);
			createButton(drawCircleIcon, onDrawCircle, true);
			
			onResize(null);			
		}
		
		private function createButton(c:Class, cb:Function, isFunctionList:Boolean):SimpleButton
		{
			var b:SimpleButton = new SimpleButton();
			var icon:Bitmap = new c() as Bitmap;
			b.upState = icon;
			
			icon = new c() as Bitmap;
			icon.x = 1;
			icon.y = 1;
			icon.filters = [new GlowFilter(0xffff11, 0.8, 4, 4)];
			b.downState = icon;
			
			icon = new c() as Bitmap;
			b.hitTestState = icon;
			
			icon = new c() as Bitmap;
			icon.filters = [new GlowFilter(0xffff00, 0.6, 3, 3)];
			b.overState = icon;
			b.addEventListener(MouseEvent.CLICK, cb);
			
			if(isFunctionList)
				m_functionButtonBar.addChild(b);
			
			return b;
		}
		
		protected function onInit(event:Event):void
		{
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			this.alpha = 0;
			drawGrid(scale);
			
			m_background.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			m_background.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			this.addEventListener(Event.RESIZE, onResize);
		}
		
		protected function onRelease(event:Event):void
		{
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			m_background.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			m_background.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			this.removeEventListener(Event.RESIZE, onResize);
			m_bMove = false;
		}
		
		protected function onMouseUp(event:MouseEvent):void
		{
			m_bMove = false;
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			m_lastX = event.stageX;
			m_lastY = event.stageY;
			m_bMove = true;
		}	

		public function get scale():Number
		{
			return m_scale;
		}

		public function set scale(value:Number):void
		{
			m_scale = value;
			drawGrid(m_scale);
		}
		
		private function addChildToLayer(layerIndex:int, child:DisplayObject):void
		{
			var layer:Sprite = m_layerList[layerIndex];
			if(layer)
				layer.addChild(child);
		}
		
		private function removeChildFromLayer(layerIndex:int, child:DisplayObject):void
		{
			var layer:Sprite = m_layerList[layerIndex];
			if(layer && layer.contains(child))
				layer.removeChild(child);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			if(this.alpha < 1)
			{
				this.alpha += 0.05;
				if(this.alpha > 1) alpha = 1;
			}
			
			if(m_bMove)
			{
				this.x += (stage.mouseX - m_lastX);
				this.y += (stage.mouseY - m_lastY);
				
				m_lastX = stage.mouseX;
				m_lastY = stage.mouseY;
			}
		}
		
		private function onCancelBtnClick(e:MouseEvent):void
		{
			if(this.parent)
				this.parent.removeChild(this);
		}
		
		private function ToggleGrid(e:MouseEvent):void
		{
			m_grid.visible = !m_grid.visible;
		}
		
		private function onScaleUp(e:MouseEvent):void
		{
			this.scale = m_scale*2;
		}
		
		private function onScaleDown(e:MouseEvent):void
		{
			if(m_scale > 0.1)
				scale = m_scale/2;
			
		}
		
		private function onDrawRectangle(e:MouseEvent):void
		{
			
		}
		
		private function onDrawCircle(e:MouseEvent):void
		{
			
		}
		
		private function drawGrid(scale:Number):void
		{
			m_grid.graphics.clear();
			
			//m_grid.graphics.beginFill(0xaaaaaa, 0.8);
			m_grid.graphics.lineStyle(1, 0xaaaaaa, 0.8);
			
			var total_len:Number = scale*GRID_SIZE;
			var unit_width:Number = scale*GRID_WIDTH;
			
			var units:int = ~~(total_len/unit_width);
			
			var centerX:Number = m_drawArea.width/2;
			var centerY:Number = m_drawArea.height/2;
			
			var i:int = 0;
			var dx:Number = 0, dy:Number = 0;
			var maxX:Number = centerX + units*unit_width;
			if(maxX > m_drawArea.width) maxX = m_drawArea.width;
			var minX:Number = centerX - units*unit_width;
			if(minX < 0) minX = 0;
			var maxY:Number = centerY + units*unit_width;
			if(maxY > m_drawArea.height) maxY = m_drawArea.height;
			var minY:Number = centerY - units*unit_width;
			if(minY < 0) minY = 0;
			while(i < units)
			{				
				m_grid.graphics.moveTo(centerX + unit_width*(1 + i), maxY);
				m_grid.graphics.lineTo(centerX + unit_width*(1 + i), minY);
				
				m_grid.graphics.moveTo(centerX - unit_width*(1 + i), maxY);
				m_grid.graphics.lineTo(centerX - unit_width*(1 + i), minY);
				
				m_grid.graphics.moveTo(minX, centerY + unit_width*(1 + i));
				m_grid.graphics.lineTo(maxX, centerY + unit_width*(1 + i));
				
				m_grid.graphics.moveTo(minX, centerY - unit_width*(1 + i));
				m_grid.graphics.lineTo(maxX, centerY - unit_width*(1 + i));
				
				i++;
			}
			
			m_grid.graphics.lineStyle(1.5, 0xff0000, 0.8);
			m_grid.graphics.moveTo(minX, centerY);
			m_grid.graphics.lineTo(maxX, centerY);
			
			m_grid.graphics.lineStyle(1.5, 0x0000ff, 0.8);
			m_grid.graphics.moveTo(centerX, minY);
			m_grid.graphics.lineTo(centerX, maxY);
			
			
			//m_grid.graphics.endFill();
		}
		
		private function onResize(event:Event):void
		{
			var i:int = 0, len:int = m_functionButtonBar.numChildren;
			var dx:int = 5;
			var dy:int = 0;
			for(i; i < len; i++)
			{
				var b:SimpleButton = m_functionButtonBar.getChildAt(i) as SimpleButton;
				b.x = dx;
				b.y = dy;
				
				dx += b.width;				
			}
		}

	}
}