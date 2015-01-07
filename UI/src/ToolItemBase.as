package src
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import src.ToolItemVO;
	import src.UIColorMatrixFilter;

	public class ToolItemBase extends MovieClip
	{
		private var m_vo:ToolItemVO;
		private var m_id:String = "";
		private var m_select:Boolean = false;
		public var cbToolClick:Function = null;
		
		public function ToolItemBase() 
		{
			// constructor code
			this.buttonMode = true;
			this.addEventListener(MouseEvent.MOUSE_OVER,onOver);
			this.addEventListener(MouseEvent.MOUSE_OUT,onOut);
			this.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		private function onOver(e:MouseEvent):void
		{
			this["toolPicAnchor"].filters = (m_select)?[UIColorMatrixFilter.instance.grayFilter]: UIColorMatrixFilter.instance.whiteGlowFilters;
		}
		private function onOut(e:MouseEvent):void
		{
			this["toolPicAnchor"].filters = null;
		}
		
		public function set toolVO(vo:ToolItemVO):void
		{
			m_vo = vo;
		}
		
		public function set toolPic(pic:DisplayObject):void
		{
			while(this["toolPicAnchor"].numChildren > 0)
			{
				this["toolPicAnchor"].removeChildAt(0);
			}			
			
			if(pic != null)
			{
				this["toolPicAnchor"].addChild(pic);
			}						
			
		}
		
		public function set toolId(id:String):void
		{
			m_id = id;
		}
		public function set isSelect(b:Boolean):void
		{
			m_select = b;
			this["toolMask"].visible = b;
		}
		
		private function onClick(e:MouseEvent):void
		{
			if (cbToolClick != null)
				cbToolClick(m_id);
		}

	}
	
}
