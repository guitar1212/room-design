package com.infy.message
{
	import com.infy.message.base.DMessageBase;
	import com.infy.message.base.IMessageController;
	
	import flash.utils.Dictionary;
	
	
	public class MessageDispatecher
	{
		private static var m_instance:MessageDispatecher = null;
		
		private var m_classDic:Dictionary = new Dictionary();
		
		private var m_controllerDic:Dictionary = new Dictionary();
		
		public function MessageDispatecher()
		{
		}
		
		public static function get instance():MessageDispatecher
		{
			if(m_instance == null)
				m_instance = new MessageDispatecher();
			
			return m_instance;
		}
		
		public function regisgerClass(mode:int, c:Class):void
		{
			m_classDic[mode.toString()] = c;
		}
		
		public function registerController(mode:int, controller:IMessageController):void
		{
			if(m_controllerDic.hasOwnProperty(mode.toString()))
			{
				var a:Array = m_controllerDic[mode.toString()];
				if(a.indexOf(controller) == -1)
					a.push(controller);
				m_controllerDic[mode.toString()] = a;
			}
			else
			{
				m_controllerDic[mode.toString()] = [controller];
			}
		}
		
		public function dispatch(mode:int, data:Object):void
		{
			for(var key:String in m_controllerDic)
			{
				if(key == mode.toString())
				{
					var msg:DMessageBase = findClass(mode);
					if(msg == null)
						break;
					
					msg.Data = data;
					msg.mode = mode;
					var controllers:Array = m_controllerDic[key];
					for(var i:int = 0; i < controllers.length; i++)
					{
						var controller:IMessageController = controllers[i];
						
						
						
						controller.reciveMessage(msg);
					}
					break;
				}
			}
		}
		
		private function findClass(mode:int):DMessageBase
		{
			var m:DMessageBase;
			
			for(var key:String in m_classDic)
			{
				if(key == mode.toString())
				{
					m = new m_classDic[key]() as DMessageBase;
					break;
				}
			}
			
			return m;
		}
	}
}