package src
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	public class ToolUIBase extends MovieClip
	{
		public var cbToolClick:Function = null;
		
		private var m_toolArr:Array = null;
		private var m_direction:int = 0;
		
		
		public function ToolUIBase()
		{
			// constructor code
			m_toolArr = new Array();
			initUI();
		}
		public function set toolDirection(_direction):void
		{
			m_direction = _direction;
		}
		
		public function set toolArray(toolArr:Array):void
		{
			var toolLength:int = toolArr.length;
			while(this["toolAnchor"].numChildren)
			{
				this["toolAnchor"].removeChildAt(0);
			}
			for(var i:int = 0;i < toolLength;++i)
			{
				var tool:ToolItem = new ToolItem();
				tool.toolVO = toolArr[i];
				tool.toolId = toolArr[i].id;
				tool.toolPic = toolArr[i].toolIcon;
				tool.isSelect = toolArr[i].isSelect;
				
				m_toolArr.push(tool);
				this["toolAnchor"].addChild(m_toolArr[i]);
				m_toolArr[i].cbToolClick = onToolClick;
				
				if(m_direction == 0)
				{
					tool.x = 26 * i;
				}
				else
				{
					tool.y = 26 * i;
				}
			}
			
		}
		
		
		
		private function addSingleChild(mc:DisplayObjectContainer, child:DisplayObject = null):void
		{
			while(mc.numChildren > 0)
			{
				mc.removeChildAt(0);
			}			
			
			if(child != null)
			{
				mc.addChild(child);
			}							
		}
		
		private function initUI():void
		{			
			
		}
		
		private function onToolClick(id:String):void
		{
			if (cbToolClick != null)
				cbToolClick(id);
		}
		
		

	}
	
}
