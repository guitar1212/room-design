package com.infy.util.scene
{
	import away3d.bounds.NullBounds;
	import away3d.containers.ObjectContainer3D;
	
	import fl.controls.Button;
	import fl.controls.List;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
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
		
		private var m_list:List = new List();
		private var m_cleanSceneBtn:Button = new Button();
		private var m_deleteObjBtn:Button = new Button();
		
		private var m_buttonClickCB:Function = null;
		private var m_itemSelectCB:Function = null;
		
		public function SceneObjectView()
		{
			super();
			
			m_list.width = 220;
			m_list.height = 350;
			m_list.addEventListener(Event.CHANGE, onItemSelectChange);
			this.addChild(m_list);
			
			m_cleanSceneBtn.label = "clean";
			m_cleanSceneBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			this.addChild(m_cleanSceneBtn);
			
			m_deleteObjBtn.label = "delete";
			m_deleteObjBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			this.addChild(m_deleteObjBtn);
			
			refresh();
		}
		
		protected function onItemSelectChange(event:Event):void
		{
			var item:Object = m_list.selectedItem;
			if(m_itemSelectCB != null)
				m_itemSelectCB(item.obj);
		}
		
		public function set itemSelectCallback(cb:Function):void
		{
			m_itemSelectCB = cb;
		}
		
		public function set buttonClickCallback(cb:Function):void
		{
			m_buttonClickCB = cb;
		}
		
		protected function onButtonClick(event:MouseEvent):void
		{			
			event.stopPropagation();
			
			if(m_buttonClickCB == null) return;
			
			if(event.target == m_cleanSceneBtn)
			{
				m_buttonClickCB(0);
			}
			else if(event.target == m_deleteObjBtn)
			{
				m_buttonClickCB(1);
			}
		}
		
		public function addSceneObjectItem(label:String, obj:ObjectContainer3D, sub:int = 0):void
		{
			var s:String = "";
			for(var i:int = 0; i < sub; i++)
				s += "    ";
			s += "- "
			label = s + label;
			m_list.addItem({label:label, obj:obj});
		}
		
		public function removeSelectItem():void
		{
			m_list.removeItemAt(m_list.selectedIndex);
		}
		
		public function removeItem(obj:ObjectContainer3D):void
		{
			var i:int = 0, len:int = m_list.length;
			for(i; i < len; i++)
			{
				var o:Object = m_list.getItemAt(i);
				if(o.obj == obj)
				{
					m_list.removeItem(o);
					break;
				}
			}
		}
		
				
		private function refresh():void
		{
			m_list.x = 0;
			m_list.y = 0;
			
			m_cleanSceneBtn.x = 0;
			m_cleanSceneBtn.y = m_list.y + m_list.height + 3;
			
			m_deleteObjBtn.x = 0;
			m_deleteObjBtn.y = m_cleanSceneBtn.y + m_cleanSceneBtn.height + 3;
		}
		
		public function clean():void
		{
			this.removeChildren();
		}
		
	}
}