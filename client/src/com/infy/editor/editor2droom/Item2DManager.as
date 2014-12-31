package com.infy.editor.editor2droom
{
	/**
	 * 
	 * @long  Dec 31, 2014
	 * 
	 */	
	public class Item2DManager
	{
		private var m_items:Vector.<Item2D> = new Vector.<Item2D>();
		
		private static var m_instance:Item2DManager = null;
		
		public function Item2DManager()
		{
		}
		
		public static function get instance():Item2DManager
		{
			if(m_instance == null)
				m_instance = new Item2DManager();
			
			return m_instance;
		}
		
		public function addItem(item:Item2D):void
		{
			m_items.push(item);
		}
		
		public function getItemByIndex(idx:int):Item2D
		{
			return m_items[idx];
		}
		
		public function getItemByName(name:String):Item2D
		{
			for(var i:int = 0; i < m_items.length; i++)
			{
				if(m_items[i].name == name)
					return m_items[i];
			}
			
			return null;
		}
	}
}