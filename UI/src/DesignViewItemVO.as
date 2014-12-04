package src
{	
	import flash.display.DisplayObject;
	public class DesignViewItemVO
	{
		private var m_id:String = null;
		public var itemIcon:DisplayObject = null;
			
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