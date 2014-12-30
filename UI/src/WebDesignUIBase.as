package src
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.display.SimpleButton;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class WebDesignUIBase extends MovieClip
	{
		public var cbMouseClick:Function = null;
		public var cbItemClick:Function = null;
		public var cbLabelClick:Function = null;
		public var cbBtnChooseClick:Function = null;
		public var cbLabelItemClick:Function = null;
		public var cbGoodsItemDown:Function = null;
		public var cbGoodsItemUp:Function = null;
		public var cbRightViewClick:Function = null;
		public var cbTrashClick:Function = null;
		public var cbDirectionDown:Function = null;
		
		
		private var m_miniViewArr:Array = null;
		private var m_labelArr:Array = null;
		private var m_btnArr:Array = null;
		private var m_timer:Timer = null;
		
		
		public function WebDesignUIBase()
		{
			// constructor code
			m_miniViewArr = new Array();
			m_labelArr = new Array();
			m_btnArr = new Array();
			m_timer = new Timer(1000);
			initUI();
		}
		
		public function set curStep(step:int):void
		{			
			this["nextStepBtn"].visible = (step != 2);
			this["miniAnchor"].visible = (step != 1);
			
			this["labelAnchor"].visible = (step == 0);
			this["btnAnchor"].visible = (step == 2);
			this["titleTf"].visible = (step != 1);
			this["roomIntroTf"].visible = (step != 1);
			this["page1"].visible = (step == 1);
			this["directionSetting"].visible = (step == 2);
			
			switch(step)
			{
				case 0:
					this["step0"]["stepPointMC"].gotoAndStop(1);
					this["step1"]["stepPointMC"].gotoAndStop(2);
					this["step2"]["stepPointMC"].gotoAndStop(2);
					this["step0"]["stepTf"].textColor = "0x000000";
					this["step1"]["stepTf"].textColor = "0xffffff";
					this["step2"]["stepTf"].textColor = "0xffffff";
					
					this["step0"]["setpWordTf"].textColor = "0x9FC057";
					this["step1"]["setpWordTf"].textColor = "0x999999";
					this["step2"]["setpWordTf"].textColor = "0x999999";
					break;
				case 1:
					this["step0"]["stepPointMC"].gotoAndStop(3);
					this["step1"]["stepPointMC"].gotoAndStop(1);
					this["step2"]["stepPointMC"].gotoAndStop(2);
					this["step0"]["stepTf"].textColor = "0x000000";
					this["step1"]["stepTf"].textColor = "0x000000";
					this["step2"]["stepTf"].textColor = "0xffffff";
					
					this["step0"]["setpWordTf"].textColor = "0xffffff";
					this["step1"]["setpWordTf"].textColor = "0x9FC057";
					this["step2"]["setpWordTf"].textColor = "0x999999";
					break;
				case 2:
					this["step0"]["stepPointMC"].gotoAndStop(3);
					this["step1"]["stepPointMC"].gotoAndStop(3);
					this["step2"]["stepPointMC"].gotoAndStop(1);
					this["step0"]["stepTf"].textColor = "0x000000";
					this["step1"]["stepTf"].textColor = "0x000000";
					this["step2"]["stepTf"].textColor = "0x000000";
					
					this["step0"]["setpWordTf"].textColor = "0xffffff";
					this["step1"]["setpWordTf"].textColor = "0xffffff";
					this["step2"]["setpWordTf"].textColor = "0x9FC057";
					break;
					
			}
			
		}
		public function setStepInfo(step:int,infoString:String):void
		{
			this["step" + step]["setpWordTf"].text = infoString;
			
		}
		/*LABEL_Array*/
		public function set labelArray(labelNameArr:Array):void
		{
			var nameLength:int = labelNameArr.length;
			while(this["labelAnchor"].numChildren)
			{
				this["labelAnchor"].removeChildAt(0);
			}
			for(var i:int = 0;i < nameLength;++i)
			{
				var labelMC:LabelMC = new LabelMC();
				labelMC.x = 125 * i;
				labelMC.labelName = labelNameArr[i];
				labelMC.labelId = String(i);
				m_labelArr.push(labelMC);
				this["labelAnchor"].addChild(m_labelArr[i]);
				m_labelArr[i].cbLabelClick = onLabelClick;
			}
			
		}
		public function set labelCurChoose(index:int):void
		{
			var labeArrLeng:int = m_labelArr.length;
			for(var i:int = 0; i< labeArrLeng;++i)
			{
				m_labelArr[i].isLabelChoose = (i == index);
			}
		}
		/*BTN_Array*/
		
		public function set btnArray(btnNameArr:Array):void
		{
			var nameLength:int = btnNameArr.length;
			while(this["btnAnchor"].numChildren)
			{
				this["btnAnchor"].removeChildAt(0);
			}
			for(var i:int = 0;i < nameLength;++i)
			{
				var btn:ChooseBtn = new ChooseBtn();
				btn.x = 125 * i;
				btn.btnText = btnNameArr[i];
				btn.btnId = String(i);
				m_btnArr.push(btn);
				this["btnAnchor"].addChild(m_btnArr[i]);
				m_btnArr[i].cbChooseBtnClick = onBtnChooseClick;
			}
			
		}
		
		public function set viewObject(view:DisplayObject):void
		{
			addSingleChild(this["viewAnchor"],view);
		}
		
		public function set roomIntroDesc(desc:String):void
		{
			this["roomIntroTf"].text = desc;
		}
		
		/*視角Item*/
		public function set viewItemVO(arr:Array):void
		{
			var itemLeng:int = arr.length;
			while(this["miniAnchor"].numChildren)
			{
				this["miniAnchor"].removeChildAt(0);
			}
			for(var i:int = 0; i< itemLeng;++i)
			{
				var viewItem:DesignViewItem = new DesignViewItem();
				m_miniViewArr.push(viewItem);
				m_miniViewArr[i].x = 225 * i;
				m_miniViewArr[i].setViewPic(arr[i].itemIcon);
				m_miniViewArr[i].setId(arr[i].id);
				m_miniViewArr[i].isSelect = arr[i].isSelect;
				m_miniViewArr[i].pos = i;
				this["miniAnchor"].addChild(m_miniViewArr[i]);
				m_miniViewArr[i].cbItemClick = onItemClick;
			}
			
		}
		
		/*Page2 相關接口*/
		public function set labelItemArray(labelNameArr:Array):void
		{
			this["page1"].labelArray = labelNameArr;
			this["page1"].cbLabelClick = onLabelItemClick;
		}
		public function set labelItemCurChoose(index:int):void
		{
			this["page1"].labelCurChoose = index;
			
		}
		
		public function set goodsVOArr(arr:Array):void
		{
			this["page1"].goodsItemVO = arr;
			this["page1"].cbItemDown = onGoodsItemDown;
			this["page1"].cbItemUp = onGoodsItemUp;
		}
		public function set rightViewVOArr(arr:Array):void
		{
			this["page1"].viewItemVO = arr;
			this["page1"].cbViewClick = onRightViewClick;
		}
		
		private function addSingleChild(mc:DisplayObjectContainer, child:DisplayObject = null):void
		{
			while(mc.numChildren > 0)
			{
				mc.removeChildAt(0);
			}			
			
			if(child != null)
			{
				mc.addChild(child);
			}							
		}
		
		private function initUI():void
		{
			for(var i:int = 0; i < 3; ++i)
			{
				this["step" + i]["stepTf"].mouseEnabled = false;
				this["step" + i]["setpWordTf"].mouseEnabled = false;
				this["step" + i]["stepTf"].text = i + 1;
			}
			this["titleTf"].mouseEnabled = false;
			this["roomIntroTf"].mouseEnabled = false;
			this["nextStepBtn"].addEventListener(MouseEvent.CLICK, onBtnClick);
			this["directionSetting"]["dUpBtn"].addEventListener(MouseEvent.MOUSE_DOWN, onDirectionClick);
			this["directionSetting"]["dDownBtn"].addEventListener(MouseEvent.MOUSE_DOWN, onDirectionClick);
			this["directionSetting"]["dRightBtn"].addEventListener(MouseEvent.MOUSE_DOWN, onDirectionClick);
			this["directionSetting"]["dLeftBtn"].addEventListener(MouseEvent.MOUSE_DOWN, onDirectionClick);
			//m_timer.addEventListener(TimerEvent.TIMER,onChange);
			
		}
		
		private function onBtnClick(e:MouseEvent):void
		{
			if (cbMouseClick != null)
				cbMouseClick();
		}
		
		private function onDirectionClick(e:MouseEvent):void
		{
			var target:String = "";
			switch (e.currentTarget.name)
			{
				case "dUpBtn":
					target = "up";
					break;
				case "dDownBtn":
					target = "down";
					break;
				case "dRightBtn":
					target = "right";
					break;
				case "dLeftBtn":
					target = "left";
					break;
			}
			
			if (cbDirectionDown != null)
				cbDirectionDown(target);
		}
		private function onItemClick(id:String):void
		{
			if (cbItemClick != null)
				cbItemClick(id);
		}
		
		private function onLabelClick(id:String):void
		{
			if(cbLabelClick != null)
				cbLabelClick(id)			
		}
		
		private function onLabelItemClick(id:String):void
		{
			if(cbLabelItemClick != null)
				cbLabelItemClick(id)
		}
		private function onGoodsItemDown(id:String):void
		{
			if(cbGoodsItemDown != null)
				cbGoodsItemDown(id)
		}
		private function onGoodsItemUp(id:String):void
		{
			if(cbGoodsItemUp != null)
				cbGoodsItemUp(id)
		}
		
		private function onRightViewClick(id:String):void
		{
			if(cbRightViewClick != null)
				cbRightViewClick(id)
		}
		
		private function onBtnChooseClick(id:String):void
		{
			if(cbBtnChooseClick != null)
				cbBtnChooseClick(id)
			
		}
		
		
		private function onChange(e:TimerEvent):void
		{
			trace(e + "...");
		}

	}
	
}
