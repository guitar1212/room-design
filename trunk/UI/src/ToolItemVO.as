package src
{	
	import flash.display.DisplayObject;
	public class ToolItemVO
	{
		private var m_id:String = null;
		public var toolIcon:DisplayObject = null;
		public var isSelect:Boolean = false;
			
		public function get id():String
		{
			return m_id;
		}
		
		public function set id(_id:String):void
		{			
			m_id = _id;
		}		
		
	}
}