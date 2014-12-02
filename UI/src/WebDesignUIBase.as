﻿package src
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	public class WebDesignUIBase extends MovieClip
	{
		public var cbMouseClick:Function = null;
		public var cbItemClick:Function = null;
		public var miniViewArr:Array = new Array();
		
		public function WebDesignUIBase()
		{
			// constructor code
			initUI();
		}
		
		public function set curStep(step:int):void
		{			
			this["nextBtn"].visible = step != 2;
			this["miniAnchor"].visible = step != 1;
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
				miniViewArr.push(viewItem);
				miniViewArr[i].x = 220 * i;
				miniViewArr[i].setViewPic(arr[i].itemIcon);
				miniViewArr[i].setId(arr[i].id);
				this["miniAnchor"].addChild(miniViewArr[i]);
				miniViewArr[i].cbItemClick = onItemClick;
			}
			
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
			this["nextBtn"].addEventListener(MouseEvent.CLICK, onBtnClick);
			
		}
		
		private function onBtnClick(e:MouseEvent):void
		{
			if (cbMouseClick != null)
				cbMouseClick();
		}
		private function onItemClick(id:String):void
		{
			if (cbItemClick != null)
				cbItemClick(id);
		}

	}
	
}
