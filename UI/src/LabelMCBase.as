package src
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class LabelMCBase extends MovieClip
	{
		private var m_id:String = "";
		private var m_choose:Boolean = false;
		public var cbLabelClick:Function = null;
		
		public function LabelMCBase() 
		{
			// constructor code
			this["labelOverMC"].visible = false;
			this["labelChooseMC"].visible = false;
			this["labelOverMC"].mouseEnabled = false;
			this["labelChooseMC"].mouseEnabled = false;
			this["labelNameTf"].mouseEnabled = false;
			this["labelNameTf"].textColor = "0x000000";
			this.addEventListener(MouseEvent.MOUSE_OVER,onOver);
			this.addEventListener(MouseEvent.MOUSE_OUT,onOut);
			this.addEventListener(MouseEvent.CLICK,onLabelClick);
		}
		
		private function onOver(e:MouseEvent):void
		{
			this["labelOverMC"].visible = (m_choose || true);
			this["labelNameTf"].textColor = "0xffffff";
		}
		private function onOut(e:MouseEvent):void
		{
			this["labelOverMC"].visible = (m_choose || false);
			this["labelNameTf"].textColor = m_choose?"0xffffff":"0x000000";
		}

		public function set labelId(id:String):void
		{
			m_id = id;
		}
		
		public function set labelName(nameInfo:String):void
		{
			this["labelNameTf"].text = nameInfo;
		}
		
		public function set isLabelChoose(choose:Boolean):void
		{
			m_choose = choose;
			this["labelChooseMC"].visible = choose;
			this["labelOverMC"].visible = choose;
			this["labelNameTf"].textColor = m_choose?"0xffffff":"0x000000";
		}

		private function onLabelClick(e:MouseEvent):void
		{
			if (cbLabelClick != null)
				cbLabelClick(m_id);
		}

	}
	
}
