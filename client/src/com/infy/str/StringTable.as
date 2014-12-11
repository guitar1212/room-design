package com.infy.str
{
	import flash.utils.Dictionary;

	/**
	 * 
	 * @long  Dec 1, 2014
	 * 
	 */	
	public class StringTable
	{
		private static var m_strDic:Dictionary = new Dictionary();
		
		public function StringTable()
		{
			
		}
		
		public static function initialize():void
		{
			var group:String = "UI_STEP";
			var data:Object = {};
			data["STEP1"] = "選擇房型   Select";
			data["STEP2"] = "設計房間   Design";
			data["STEP3"] = "完成設計   Finish";			
			m_strDic[group] = data;
			
			
			group = "LABEL_TYPE";
			data = {};
			data["TYPE_1"] = "空間氣氛";
			data["TYPE_2"] = "寢具家飾";
			data["TYPE_3"] = "文創小物";
			data["TYPE_4"] = "特色點心";
			data["TYPE_5"] = "衛浴用品";
			m_strDic[group] = data;
		}
		
		public static function setString(group:String, key:String, contex:String):void
		{
			if(m_strDic.hasOwnProperty(group))
			{
				m_strDic[group][key] = contex;
			}
			else
			{
				var data:Object = {};
				data[key] = contex;
				m_strDic[group] = data;
			}
		}
		
		public static function getString(group:String, key:String):String
		{
			return m_strDic[group][key] as String;
		}
	}
}