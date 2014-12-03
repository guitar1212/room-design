package com.infy.util.scene
{
	import away3d.containers.ObjectContainer3D;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Dictionary;
	
	/**
	 * 
	 * @long  Nov 24, 2014
	 * 
	 */	
	public class SceneObjectView extends Sprite
	{
		private var m_itemClickCb:Function = null;
		
		private var m_itemDic:Dictionary = new Dictionary();
		
		private var m_lastSelectItem:TextField;
		
		public function SceneObjectView()
		{
			super();
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
			this.addEventListener(MouseEvent.CLICK, onMouseClick, false, 0, true);
			refresh();
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			event.stopPropagation();
		}
		
		protected function onMouseClick(event:MouseEvent):void
		{
			var t:TextField = event.target as TextField;
			setSelect(t);
		}
		
		private function setSelect(t:TextField):void
		{
			if(t)
			{
				if(m_lastSelectItem == t)
					return;
				
				var key:String = t.text;
				if(m_itemDic[key] && m_itemClickCb != null)
					m_itemClickCb(m_itemDic[key]);
				
				if(m_lastSelectItem)
					m_lastSelectItem.filters = [];
				
				t.filters = [new GlowFilter(0xffff00)];
				m_lastSelectItem = t;
			}
		}
		
		public function addObject(key:String, obj:*, sub:int = 0):void
		{
			var t:TextField = new TextField();
			t.selectable = false;
			t.autoSize = TextFieldAutoSize.LEFT;
			var s:String = "";
			var data:Object = {};
			for(var i:int = 0; i < sub; i++)
				s += "    ";
			s += "- "
			t.text = s + key;
			data.index = this.numChildren;
			data.obj = obj;
			data.text = t;
			m_itemDic[s + key] = data;
			
			this.addChild(t);
			
			refresh();
		}
		
		public function removeObject(obj:*):void
		{
			var b:Boolean = false;
			var o:Object;
			for (var key:String in m_itemDic)
			{
				o = m_itemDic[key];
				if(o.obj == obj)
				{
					b = true;
					break;
				}
			}
			
			if(!b) return;
			
			this.removeChild(o.text);
			
			o = null;
						
			m_itemDic[key] = null;
			delete m_itemDic[key];
				
			refresh();
		}
		
		public function set itemSelectCallback(cb:Function):void
		{
			m_itemClickCb = cb;
		}
		
		public function setSelectItem(obj:ObjectContainer3D):void
		{
			var o:Object;
			for (var key:String in m_itemDic)
			{
				o = m_itemDic[key];
				if(o.obj == obj)
				{
					setSelect(o.text);
					break;
				}
			}
		}
		
		private function refresh():void
		{
			var i:int = 0, len:int = this.numChildren;
			var dx:int = 3, dy:int = 2;
			var gapY:int = 20;
			for(i; i < len; i++)
			{
				this.getChildAt(i).x = dx;
				this.getChildAt(i).y = dy;
				dy += gapY;
			}
			
			var h:Number = len*gapY + 20;
			if(h < 300)
				h = 300;
			
			this.graphics.clear();
			
			this.graphics.beginFill(0x88213a, 0.75);
			this.graphics.drawRect(0, 0, 180, h);
			this.graphics.endFill();				
		}
		
		public function clean():void
		{
			this.removeChildren();
		}
		
	}
}