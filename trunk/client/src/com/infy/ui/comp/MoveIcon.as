package com.infy.ui.comp
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * 
	 * @long  Dec 4, 2014
	 * 
	 */	
	public class MoveIcon extends Sprite
	{
		[Embed(source="/../embeds/ic_gamepad_black_24dp.png")]
		public static var MoveButtonIcon:Class;
		
		
		public function MoveIcon()
		{
			super();
			
			var icon:Bitmap = new MoveButtonIcon() as Bitmap;
			addChild(icon);
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		protected function onMouseUp(event:Event):void
		{
			if(this.parent == null) return;
			else if(this.parent is MovieClip)
			{
				MovieClip(this.parent).stopDrag();
				this.parent.alpha = 1;
			}
			
		}
		
		protected function onMouseDown(event:Event):void
		{
			if(this.parent == null) return;
			else if(this.parent is MovieClip)
			{
				MovieClip(this.parent).startDrag();
				this.parent.alpha = 0.3;
			}
			
		}
	}
}