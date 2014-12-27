package src
{	
	import flash.display.DisplayObject;
	public class DesignViewItemVO
	{
		private var m_id:String = null;
		public var itemIcon:DisplayObject = null;
		public var itemCount:int = 0;
		public var itemEnabled:Boolean = false;
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