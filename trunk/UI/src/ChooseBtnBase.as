package src
{
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.display.DisplayObject;
	import flash.display.Sprite;	

	public class ChooseBtnBase extends SimpleButton
	{
		
		private var m_id:String = "";
		public var cbChooseBtnClick:Function = null;
		
		protected var m_upState:DisplayObject = null;
		protected var m_overState:DisplayObject = null;
		protected var m_downState:DisplayObject = null;		
		protected var m_disibleState:DisplayObject = null;		
		
		public function ChooseBtnBase() 
		{
			// constructor code
			this.addEventListener(MouseEvent.CLICK,onBtnClick);
			m_upState = this.upState; 
			m_overState = this.overState;							
			m_downState = this.downState;							
			m_disibleState = this.hitTestState;	
		}
		
		
		public function set btnId(id:String):void
		{
			m_id = id;
		}
		
		public function set btnName(nameInfo:String):void
		{
			
			if(null == ((this.downState as Sprite).getChildAt(1) as TextField))
			{
				throw new Error("取不到文字框，該按鈕需要新增文字框！");
			}
			
			((m_upState as Sprite).getChildAt(1) as TextField).text = nameInfo;
			((m_overState as Sprite).getChildAt(1) as TextField).text = nameInfo;
			((m_downState as Sprite).getChildAt(1) as TextField).text = nameInfo;
			((m_disibleState as Sprite).getChildAt(1) as TextField).text = nameInfo;
		}
	
		private function onBtnClick(e:MouseEvent):void
		{
			if (cbChooseBtnClick != null)
				cbChooseBtnClick(m_id);
		}

	}
	
}
