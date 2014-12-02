package src
{	
	import flash.display.DisplayObject;
	public class DesignViewItemVO
	{
		private var m_id:String = null;
		private var m_pos:int = -1;
		public var itemIcon:DisplayObject = null;
			
		public function get id():String
		{
			return m_id;
		}
		
		public function set id(_id:String):void
		{			
			m_id = _id;
		}		
		
		public function get pos():int
		{
			return m_pos;
		}
		
		public function set pos(_pos:int):void
		{			
			m_pos = _pos;
		}
	}
}