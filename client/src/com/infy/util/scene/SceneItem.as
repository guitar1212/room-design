package com.infy.util.scene
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import away3d.containers.ObjectContainer3D;
	
	public class SceneItem extends Sprite
	{
		private var m_text:TextField;
		
		private var m_obj:ObjectContainer3D;
		
		
		public function SceneItem()
		{
			super();
			
			m_text = new TextField();
			m_text.selectable = false;
			m_text.autoSize = TextFieldAutoSize.LEFT;
			this.addChild(m_text);
			this.mouseChildren = false;
		}
		
		public function set text(str:String):void
		{
			m_text.text = str;
		}
		
		public function set target(o:ObjectContainer3D):void
		{
			m_obj = o;
		}
		
		public function get target():ObjectContainer3D
		{
			return m_obj;
		}
								   
	}
}