package src
{
	import flash.display.MovieClip;
	
	public class ClickMenuUIBase extends MovieClip
	{
		private var m_menuArr:Array = null;
		public var cbMenuClick:Function = null;
		
		public function ClickMenuUIBase()
		{
			// constructor code
			initUI();
			m_menuArr = new Array();
		}
		
		private function initUI():void
		{
			
		}
		
		/*menuArray*/
		public function set menuArray(menuArr:Array):void
		{
			var menuLength:int = menuArr.length;
			while(this["menuAnchor"].numChildren)
			{
				this["menuAnchor"].removeChildAt(0);
			}
			for(var i:int = 0;i < menuLength;++i)
			{
				var menuMC:ClickMenuItem = new ClickMenuItem();
				menuMC.y = 22 * i;
				menuMC.menuInfo = menuArr[i];
				menuMC.menuId = String(i) ;
				m_menuArr.push(menuMC);
				this["menuAnchor"].addChild(m_menuArr[i]);
				m_menuArr[i].cbMenuClick = onMenuClick;
				
			}
			this["bg"].height = 23 * menuLength;
			
		}
		
		private function onMenuClick(id:String):void
		{
			if(cbMenuClick != null)
				cbMenuClick(id)
		}
		
		

	}
	
}
