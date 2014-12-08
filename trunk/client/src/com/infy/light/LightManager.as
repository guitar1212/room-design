package com.infy.light
{
	

	/**
	 * 
	 * @long  Dec 8, 2014
	 * 
	 */	
	public class LightManager
	{
		private static var m_instance:LightManager = null;
		
		private var m_lightList:Vector.<LightInfo> = new Vector.<LightInfo>();
		
		public function LightManager()
		{
		}
		
		public static function get instance():LightManager
		{
			if(m_instance == null)
				m_instance = new LightManager();
			
			return m_instance;
		}
		
		public function addLight(light:LightInfo):void
		{
			m_lightList.push(light);
		}
		
		public function getLightInfoByIndex(index:int):LightInfo
		{
			return m_lightList[index];
		}
		
		public function getLight(name:String):LightInfo
		{
			for each(var l:LightInfo in m_lightList)
			{
				if(l.name == name)
					return l;
			}
			
			return null;
		}
	}
}