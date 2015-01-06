package com.infy.editor
{
	import com.infy.editor.editor2droom.DrawBase;
	import com.infy.editor.editor2droom.DrawCircle;
	import com.infy.editor.editor2droom.DrawRectangle;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.ui.Keyboard;
	
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
		
		[Embed(source="/../embeds/Ediror2DRoom/ic_mode_edit_black_24dp.png")]
		public static var editIcon:Class;
		
		private static const GRID_SIZE:Number = 200;
		private static const GRID_WIDTH:Number = 10;
			
		private static const DIALOG_WIDTH:Number = 800;
		private static const DIALOG_HEIGHT:Number = 600;
		
		private static const DRAW_AREA_WIDTH:Number = 750;
		private static const DRAW_AREA_HEIGHT:Number = 450;
		
		private static const DRAW_AREA_CENTER_X:Number = DRAW_AREA_WIDTH/2;
		private static const DRAW_AREA_CENTER_Y:Number = DRAW_AREA_HEIGHT/2;
		
		private var m_scale:Number = 1;
		
		private var m_layerList:Vector.<Sprite> = new Vector.<Sprite>();
		private static const TOTAL_LAYERS:int = 3;
		
		private var m_background:Sprite;
		private var m_drawArea:Sprite;
		private var m_drawObjectContainer:Sprite;
		private var m_grid:Sprite;
		
		private var m_lastX:Number;
		private var m_lastY:Number;
		private var m_bMove:Boolean = false;
		
		private var m_bSnapGrid:Boolean = false;
		private var m_bEditMode:Boolean = false;
		
		private var m_functionButtonBar:Sprite;
		
		private var m_drawPoint:Sprite;
		
		private var m_curSelectDrawObject:DrawBase = null;
		
		private var m_msg:TextField = new TextField();
		
		private var m_penOffset:Point = new Point();
		
		
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
			
			m_drawObjectContainer = new Sprite();
			m_drawArea.addChild(m_drawObjectContainer);
			
			var drawMash:Sprite = new Sprite();
			drawMash.mouseEnabled = false;
			drawMash.mouseChildren = false;
			drawMash.graphics.beginFill(0xffffff);
			drawMash.graphics.drawRect(0,0,DRAW_AREA_WIDTH,DRAW_AREA_HEIGHT);
			drawMash.graphics.endFill();
			m_drawArea.addChild(drawMash);
			m_drawArea.mask = drawMash;
			
			
			m_drawPoint = new Sprite();			
			m_drawPoint.mouseEnabled = false;
			m_drawPoint.mouseChildren = false;
			m_drawArea.addChild(m_drawPoint);
			changeDrawPoint(0);
			
			m_functionButtonBar = new Sprite();
			m_functionButtonBar.x = 20;
			m_functionButtonBar.y = 40;
			this.addChild(m_functionButtonBar);
			
			var cancelBtn:SimpleButton = createButton(cancelIcon, onCancelBtnClick, false);
			this.addChild(cancelBtn);
			
			createButton(gridIcon, ToggleGrid, true);			
			createButton(plusIcon, onScaleUp, true);
			createButton(subIcon, onScaleDown, true);
			createButton(editIcon, onEditItem, true);
			createButton(drawRecIcon, onDrawRectangle, true);
			createButton(drawCircleIcon, onDrawCircle, true);
			
			m_msg.autoSize = TextFieldAutoSize.LEFT;
			m_msg.x = m_drawArea.x;
			m_msg.y = m_drawArea.y + m_drawArea.height + 3;
			this.addChild(m_msg);
			
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
			this.stage.scaleMode = StageScaleMode.NO_SCALE; 
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			this.alpha = 0;
			drawGrid(scale);
			
			m_background.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			m_background.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			m_drawArea.addEventListener(MouseEvent.MOUSE_DOWN, onDrawStart);
			m_drawArea.addEventListener(MouseEvent.MOUSE_UP, onDrawEnd);
			
			this.addEventListener(Event.RESIZE, onResize);
			
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown)
		}
		
		protected function onRelease(event:Event):void
		{
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			m_background.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			m_background.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			m_drawArea.removeEventListener(MouseEvent.MOUSE_DOWN, onDrawStart);
			m_drawArea.removeEventListener(MouseEvent.MOUSE_UP, onDrawEnd);
			this.removeEventListener(Event.RESIZE, onResize);
			this.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown)
			m_bMove = false;
		}
		
		private function onKeyDown(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case Keyboard.DELETE:
					if(event.shiftKey)
						cleanAllDrawItem();
					break;
				
				case Keyboard.S:
					m_bSnapGrid = !m_bSnapGrid;
					break;
				
				case Keyboard.UP:
					m_penOffset.y -= 2;
					m_drawObjectContainer.y -= 2;
					m_grid.y -= 2;
					break;
				
				case Keyboard.DOWN:
					m_penOffset.y += 2;
					m_drawObjectContainer.y += 2;
					m_grid.y += 2;
					break;
				
				case Keyboard.LEFT:
					m_penOffset.x -= 2;
					m_drawObjectContainer.x -= 2;
					m_grid.x -= 2;
					break;
				
				case Keyboard.RIGHT:
					m_penOffset.x += 2;
					m_drawObjectContainer.x += 2;
					m_grid.x += 2;
					break;
				
				case Keyboard.NUMPAD_ADD:
					onScaleUp(null);
					break;
				
				case Keyboard.NUMPAD_SUBTRACT:
					onScaleDown(null);
					break;
				
				case Keyboard.R:
					if(m_curSelectDrawObject)
						rotationFromCenter(m_curSelectDrawObject, 45);
					break;
			}
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
		
		private var m_bStartDraw:Boolean = false;
		private var m_drawObj:DrawBase;
		private function onDrawStart(event:MouseEvent):void
		{
			if(m_bEditMode)
			{
				if(event.target is DrawBase)
				{
					var d:DrawBase = event.target as DrawBase;
					if(m_curSelectDrawObject == d)
					{
						return;
					}
					m_curSelectDrawObject = d;
					//d.select = !d.select;
					selectDrawObject(d);
				}
				return;	
			}
			
			if(bDrawRec || bDrawCircle)
			{
				m_bStartDraw = true;
				//var p:Point = m_drawArea.globalToLocal(new Point(stage.mouseX, stage.mouseY));
				var p:Point = new Point(m_drawPoint.x - m_penOffset.x, m_drawPoint.y - m_penOffset.y);
				if(bDrawRec)
				{
					m_drawObj = new DrawRectangle();
					m_drawObj.name = "drawRec";
				}
				else if(bDrawCircle)
				{
					m_drawObj = new DrawCircle();
					m_drawObj.name = "drawCir";
				}
				m_drawObj.oriScale = this.scale;
				m_drawObj.startDraw(p.x, p.y);
				m_drawObj.refrenceObject = m_drawPoint;
				var offset:Point = new Point();
				offset.x = p.x - DRAW_AREA_CENTER_X;// + m_penOffset.x;
				offset.y = p.y - DRAW_AREA_CENTER_Y;// + m_penOffset.y;
				
				m_drawObj.offset.x = offset.x;
				m_drawObj.offset.y = offset.y;
				m_drawObjectContainer.addChild(m_drawObj);
			}
		}
		
		private function selectDrawObject(d:DrawBase):void
		{
			for(var i:int = 0; i < m_drawObjectContainer.numChildren; i++)
			{
				var draw:DrawBase = m_drawObjectContainer.getChildAt(i) as DrawBase;
				if(draw == d)
				{
					draw.select = true;
				}
				else
				{
					draw.select = false;
				}
			}
		}
		
		private function onDrawEnd(event:MouseEvent):void
		{
			if(bDrawRec || bDrawCircle)
			{
				m_bStartDraw = false;				
				
				if(m_drawObj)
				{
					//var p:Point = m_drawArea.globalToLocal(new Point(stage.mouseX, stage.mouseY));
					//var p:Point = new Point(m_drawPoint.x, m_drawPoint.y);
					var p:Point = new Point(m_drawPoint.x - m_penOffset.x, m_drawPoint.y - m_penOffset.y);
					m_drawObj.endDraw(p.x, p.y);
					
					m_drawObj = null;
				}
			}
		}

		public function get scale():Number
		{
			return m_scale;
		}

		public function set scale(value:Number):void
		{
			m_scale = value;
			
			
			scaleDrawItem(value);
			
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
			
			if(m_bSnapGrid)
			{
				var np:Point = getNearestGridPoint(stage.mouseX, stage.mouseY);
				m_drawPoint.x = np.x;
				m_drawPoint.y = np.y;
			}
			else
			{
				var p:Point = m_drawArea.globalToLocal(new Point(stage.mouseX, stage.mouseY));
				m_drawPoint.x = p.x;
				m_drawPoint.y = p.y;
			}
			
			if(m_bStartDraw)
			{
				
			}
			
			updateMsg();
			
			
		}
		
		private function updateMsg():void
		{
			var s:Point = m_drawArea.localToGlobal(new Point(m_drawPoint.x, m_drawPoint.y));
			var p:Point = getDrawCoordinatePosition(s.x, s.y);
			
			m_msg.text = "Mouse(" + stage.mouseX + "," + stage.mouseY + ").  Scale = " + scale + ".  PanOffset = " + m_penOffset + 
				         "\nDrawPoint @DrawArea(" + m_drawPoint.x + ", " + m_drawPoint.y + ")  @DrawCoordinate(" + p.x + ", " + p.y + ")";
			
			if(m_curSelectDrawObject)
			{
				var text:String = "\nSelectObj : " +  m_curSelectDrawObject.name + ", (x = " + m_curSelectDrawObject.x + ", y = " + m_curSelectDrawObject.y + ")  w = " + m_curSelectDrawObject.width + ", h = " + m_curSelectDrawObject.height + ",  scale = " + m_curSelectDrawObject.scaleX + ", oriScale = " + m_curSelectDrawObject.oriScale + ". offset = " + m_curSelectDrawObject.offset;
				m_msg.appendText(text);
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
		
		private function onEditItem(e:MouseEvent):void
		{
			m_bEditMode = !m_bEditMode;
			
		}
		
		private var bDrawRec:Boolean = false;
		private function onDrawRectangle(e:MouseEvent):void
		{
			bDrawRec = !bDrawRec;
			var b:SimpleButton = e.target as SimpleButton;
			if(b)
			{
				if(bDrawRec)
				{
					b.upState = b.downState;
				
					// change mouse cursor
					changeDrawPoint(1);
				}
				else
				{
					b.upState = b.hitTestState;
				}
			}
		}
		
		private var bDrawCircle:Boolean = false;
		
		private function onDrawCircle(e:MouseEvent):void
		{
			bDrawCircle = !bDrawCircle;
			if(bDrawCircle)
			{
				changeDrawPoint(2);				
			}			
		}
		
		private function cleanAllDrawItem():void
		{
			for(var i:int = 0; i < m_drawObjectContainer.numChildren; i++)
			{
				var d:DrawBase = m_drawObjectContainer.getChildAt(i) as DrawBase;
				d.graphics.clear();
			}
			
			m_drawObjectContainer.removeChildren();
		}
		
		private function scaleDrawItem(value:Number):void
		{
			for(var i:int = 0; i < m_drawObjectContainer.numChildren; i++)
			{
				var d:DrawBase = m_drawObjectContainer.getChildAt(i) as DrawBase;
				scaleFromCenter(d, value, value);
			}
		}
		
		private function scaleFromCenter(obj:DrawBase, sX:Number, sY:Number):void
		{
			var _sX:Number = sX/obj.oriScale;
			var _sY:Number = sY/obj.oriScale;
			
			obj.scaleX = _sX;
			obj.scaleY = _sY;
			obj.x = (_sX*(obj.offset.x) + DRAW_AREA_CENTER_X);
			obj.y = (_sY*(obj.offset.y) + DRAW_AREA_CENTER_Y);
			
			// 中心點 在縮放時會跑掉  跟 m_penOffset 有關
		}
		
		private function rotationFromCenter(obj:DrawBase, angle:Number):void
		{
//			var oriCenterX:Number = obj.width/2; + obj.x;
//			var oriCenterY:Number = obj.height/2 + obj.y;
			
			obj.rotation = angle;
			
//			var newCenterX:Number = obj.width/2; + obj.x;
//			var newCenterY:Number = obj.height/2 + obj.y;
//			
//			var dx:Number = newCenterX - oriCenterX;
//			var dy:Number = newCenterY - oriCenterX;
//			
//			var len:Number = Math.sqrt(dx*dx + dy*dy);
//			obj.x += Math.cos(angle);
//			obj.y -= Math.sin(angle);
		}
		
		private function drawGrid(scale:Number):void
		{
			m_grid.graphics.clear();
			
			//m_grid.graphics.beginFill(0xaaaaaa, 0.8);
			m_grid.graphics.lineStyle(1, 0xaaaaaa, 0.8);
			
			var total_len:Number = scale*GRID_SIZE;
			var unit_width:Number = scale*GRID_WIDTH;
			
			var units:int = ~~(total_len/unit_width);
			
			var i:int = 0;
			var dx:Number = 0, dy:Number = 0;
			var maxX:Number = DRAW_AREA_CENTER_X + units*unit_width;
			if(maxX > DRAW_AREA_WIDTH) maxX = DRAW_AREA_WIDTH;
			var minX:Number = DRAW_AREA_CENTER_X - units*unit_width;
			if(minX < 0) minX = 0;
			var maxY:Number = DRAW_AREA_CENTER_Y + units*unit_width;
			if(maxY > DRAW_AREA_HEIGHT) maxY = DRAW_AREA_HEIGHT;
			var minY:Number = DRAW_AREA_CENTER_Y - units*unit_width;
			if(minY < 0) minY = 0;
			while(i < units)
			{				
				m_grid.graphics.moveTo(DRAW_AREA_CENTER_X + unit_width*(1 + i), maxY);
				m_grid.graphics.lineTo(DRAW_AREA_CENTER_X + unit_width*(1 + i), minY);
				
				m_grid.graphics.moveTo(DRAW_AREA_CENTER_X - unit_width*(1 + i), maxY);
				m_grid.graphics.lineTo(DRAW_AREA_CENTER_X - unit_width*(1 + i), minY);
				
				m_grid.graphics.moveTo(minX, DRAW_AREA_CENTER_Y + unit_width*(1 + i));
				m_grid.graphics.lineTo(maxX, DRAW_AREA_CENTER_Y + unit_width*(1 + i));
				
				m_grid.graphics.moveTo(minX, DRAW_AREA_CENTER_Y - unit_width*(1 + i));
				m_grid.graphics.lineTo(maxX, DRAW_AREA_CENTER_Y - unit_width*(1 + i));
				
				i++;
			}
			
			m_grid.graphics.lineStyle(1.5, 0xff0000, 0.8);
			m_grid.graphics.moveTo(minX, DRAW_AREA_CENTER_Y);
			m_grid.graphics.lineTo(maxX, DRAW_AREA_CENTER_Y);
			
			m_grid.graphics.lineStyle(1.5, 0x0000ff, 0.8);
			m_grid.graphics.moveTo(DRAW_AREA_CENTER_X, minY);
			m_grid.graphics.lineTo(DRAW_AREA_CENTER_X, maxY);
			
			
			//m_grid.graphics.endFill();
		}
		
		private function getNearestGridPoint(stageX:Number, stageY:Number):Point
		{
			var p:Point = new Point();
			
			var unit_width:Number = scale*GRID_WIDTH;
			
			var localPoint:Point = m_drawArea.globalToLocal(new Point(stageX, stageY));
			localPoint.x -= DRAW_AREA_CENTER_X;
			localPoint.y -= DRAW_AREA_CENTER_Y;
			
			localPoint.x -= m_penOffset.x;
			localPoint.y -= m_penOffset.y;
			
			p.x = Math.round(localPoint.x/unit_width)*unit_width + DRAW_AREA_CENTER_X + m_grid.x;
			p.y = Math.round(localPoint.y/unit_width)*unit_width + DRAW_AREA_CENTER_Y + m_grid.y;
			
			return p;
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
		
		private function changeDrawPoint(type:int):void
		{
			m_drawPoint.graphics.clear();
			
			if(type == 0)
			{
				m_drawPoint.graphics.beginFill(0x00ff00, 0.7);
				m_drawPoint.graphics.drawCircle(0, 0, 3);
				m_drawPoint.graphics.endFill();
			}
			else if(type == 1) // draw rectangle
			{
				m_drawPoint.graphics.beginFill(0x00ffff, 0.7);
				m_drawPoint.graphics.drawRect(-2, -2, 4, 4);
				m_drawPoint.graphics.endFill();
			}
			else if(type == 2)
			{
				m_drawPoint.graphics.beginFill(0xffff00, 0.7);
				m_drawPoint.graphics.drawCircle(0, 0, 3);
				m_drawPoint.graphics.endFill();
			}
		}
		
		public function calculateDrawObjectPosition(obj:DrawBase):Point
		{
			var p:Point = new Point();
			
			
			return p;
		}
		
		public function getDrawCoordinatePosition(stageX:Number, stageY:Number):Point
		{
			var p:Point = m_drawArea.globalToLocal(new Point(stageX, stageY));
			
			p.x -= DRAW_AREA_CENTER_X;
			p.y -= DRAW_AREA_CENTER_Y;
			
			p.x -= m_penOffset.x;
			p.y -= m_penOffset.y;
			
			p.x = p.x/m_scale;
			p.y = p.y/m_scale;
			
			return p;
		}

	}
}