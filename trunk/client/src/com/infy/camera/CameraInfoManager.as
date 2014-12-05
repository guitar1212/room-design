package com.infy.camera
{
	import flash.utils.Dictionary;

	/**
	 * 
	 * @long  Dec 5, 2014
	 * 
	 */	
	public class CameraInfoManager
	{
		private static var m_instance:CameraInfoManager = null;
		
		private var m_camInfoDic:Dictionary = new Dictionary();
		
		public function CameraInfoManager()
		{
		}
		
		public static function get instance():CameraInfoManager
		{
			if(m_instance == null)
				m_instance = new CameraInfoManager();
			
			return m_instance;
		}
		
		public function addCameraInfo(key:String, camInfo:CameraInfo):void
		{
			m_camInfoDic[key] = camInfo;
		}
		
		public function getCameraInfo(key:String):CameraInfo
		{
			return m_camInfoDic[key];
		}
	}
}