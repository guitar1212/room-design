/*
mtllib defaultMtl.mtl
v 0.000000 20.000000 20.000000
v 0.000000 0.000000 20.000000
v 20.000000 0.000000 20.000000
v 20.000000 20.000000 20.000000
v 0.000000 20.000000 0.000000
v 0.000000 0.000000 0.000000
v 20.000000 0.000000 0.000000
v 20.000000 20.000000 0.000000
# 8 vertices
vt 0.000000 1.000000 0.000000
vt 0.000000 0.000000 0.000000
vt 1.000000 0.000000 0.000000
vt 1.000000 1.000000 0.000000
g front
usemtl defTex
f 1/1 2/2 3/3 4/4
g back
usemtl blue
f 8 7 6 5
g right
usemtl green
f 4 3 7 8
g top
usemtl red
f 5 1 4 8
g left
usemtl orange
f 5 6 2 1
g bottom
usemtl purple
f 2 6 7 3

*/


package com.infy.util.obj
{
	import away3d.controllers.SpringController;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * 
	 * @long  Nov 19, 2014
	 * 
	 */	
	public class ObjEditor extends Sprite
	{
		private var m_text:TextField = new TextField();
		
		private var m_enterBtt:Sprite = new Sprite();
		
		private var m_enterCb:Function = null;
		
		public function ObjEditor()
		{
			super();
			
			var tf:TextFormat = new TextFormat();
			tf.size = 14;
			tf.color = 0x000000;
			tf.bold = true;
			tf.align = TextFormatAlign.LEFT;
			
			m_text.border = true;
			m_text.width = 180;
			m_text.height = 400;
			m_text.backgroundColor = 0xcccccc;
			m_text.background = true;
			//m_text.autoSize = TextFieldAutoSize.LEFT;
			m_text.alpha = 0.7;
			
			m_text.defaultTextFormat = tf;
			m_text.type = TextFieldType.INPUT;
			m_text.text = "# Simple Wavefront file\nmtllib defaultMtl.mtl\nv 0.0 0.0 0.0\nv 0.0 100.0 0.0\nv 50.0 0.0 0.0\nusemtl red\nf 1 2 3\n";
			
			m_text.multiline = true;
			this.addChild(m_text);
			
			m_enterBtt.x = 5;
			m_enterBtt.y = m_text.height + 5;
			m_enterBtt.addEventListener(MouseEvent.CLICK, onEnterBtnClick);
			m_enterBtt.graphics.beginFill(0xccdd22, 0.85);
			m_enterBtt.graphics.drawRect(0, 0, 100, 30);
			var t:TextField = new TextField();
			m_enterBtt.addChild(t);
			t.text = "Create";
			m_enterBtt.mouseChildren = false;
			m_enterBtt.mouseEnabled = true;
			m_enterBtt.useHandCursor = true;
			m_enterBtt.buttonMode = true;
			this.addChild(m_enterBtt);
		}
		
		protected function onEnterBtnClick(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			if(m_enterCb != null)
				m_enterCb(m_text.text);
		}
		
		public function set callback(cb:Function):void
		{
			m_enterCb = cb;
		}
	}
}