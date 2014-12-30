package src
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.display.SimpleButton;

	public class PageChooseItemBase extends MovieClip
	{
		public var cbItemDown:Function = null;
		public var cbItemUp:Function = null;
		public var cbLabelClick:Function = null;
		public var cbTrashClick:Function = null;
		public var cbViewClick:Function = null;

		private var m_labelArr:Array = null;
		private var m_goodsArr:Array = null;
		private var m_itemCount:int = 0;
		private var m_pageMaxItem:int = 5;

		private var m_miniViewArr:Array = null;

		public function PageChooseItemBase()
		{
			// constructor code
			m_labelArr = new Array();
			m_goodsArr = new Array();
			m_miniViewArr = new Array();
			initUI();

		}



		/*LABEL_Array*/
		public function set labelArray(labelNameArr:Array):void
		{
			var nameLength:int = labelNameArr.length;
			while (this["labeItemlAnchor"].numChildren)
			{
				this["labeItemlAnchor"].removeChildAt(0);
			}
			for (var i:int = 0; i < nameLength; ++i)
			{
				var labelMC:LabelItemMC = new LabelItemMC();
				labelMC.x = 90 * i;
				labelMC.labelName = labelNameArr[i];
				labelMC.labelId = String(i);
				m_labelArr.push(labelMC);
				this["labeItemlAnchor"].addChild(m_labelArr[i]);
				m_labelArr[i].cbLabelClick = onLabelClick;
			}

		}
		public function set labelCurChoose(index:int):void
		{
			var labeArrLeng:int = m_labelArr.length;
			for (var i:int = 0; i< labeArrLeng; ++i)
			{
				m_labelArr[i].isLabelChoose = (i == index);
			}
		}


		/*物品Item*/
		public function set goodsItemVO(arr:Array):void
		{
			var itemLeng:int = arr.length;
			m_itemCount = arr.length;
			while (this["itemAnchor"].numChildren)
			{
				this["itemAnchor"].removeChildAt(0);
			}
			for (var i:int = 0; i< itemLeng; ++i)
			{
				var goodsItem:DesignGoods = new DesignGoods();
				m_goodsArr.push(goodsItem);
				m_goodsArr[i].x = 127 * i;
				m_goodsArr[i].setPic(arr[i].itemIcon);
				m_goodsArr[i].setCount(arr[i].itemCount);
				m_goodsArr[i].setItemEnable(arr[i].itemEnabled);
				m_goodsArr[i].setId(arr[i].id);
				this["itemAnchor"].addChild(m_goodsArr[i]);
				m_goodsArr[i].cbItemDown = onItemDown;
				m_goodsArr[i].cbItemUp = onItemUp;
			}

			this["nextBtn"].visible = (m_itemCount > 5);

		}

		/*視角Item*/
		public function set viewItemVO(arr:Array):void
		{
			var itemLeng:int = arr.length;
			while (this["rigthMiniAnchor"].numChildren)
			{
				this["rigthMiniAnchor"].removeChildAt(0);
			}
			for (var i:int = 0; i< itemLeng; ++i)
			{
				var viewItem:DesignRightViewItem = new DesignRightViewItem();
				m_miniViewArr.push(viewItem);
				m_miniViewArr[i].y = 65 * i;
				m_miniViewArr[i].setViewPic(arr[i].itemIcon);
				m_miniViewArr[i].setId(arr[i].id);
				m_miniViewArr[i].isSelect = arr[i].isSelect;
				this["rigthMiniAnchor"].addChild(m_miniViewArr[i]);
				m_miniViewArr[i].cbItemClick = onViewClick;
			}

		}

		private function addSingleChild(mc:DisplayObjectContainer, child:DisplayObject = null):void
		{
			while (mc.numChildren > 0)
			{
				mc.removeChildAt(0);
			}

			if (child != null)
			{
				mc.addChild(child);
			}
		}

		private function initUI():void
		{
			(this["nextBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, onNextClick);
			(this["preBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, onPreClick);
			(this["preBtn"] as SimpleButton).visible = false;
			
		}

		private function onItemDown(id:String):void
		{
			if (cbItemDown != null)
			{
				cbItemDown(id);
			}
		}
		private function onItemUp(id:String):void
		{
			if (cbItemUp != null)
			{
				cbItemUp(id);
			}
		}
		
		private function onViewClick(id:String):void
		{
			if (cbViewClick != null)
				cbViewClick(id);
		}

		private function onLabelClick(id:String):void
		{
			if (cbLabelClick != null)
			{
				cbLabelClick(id);
			}
			var labeArrLeng:int = m_labelArr.length;
			for (var i:int = 0; i< labeArrLeng; ++i)
			{
				m_labelArr[i].isLabelChoose = (i == int(id));
			}

		}

		private function onNextClick(e:MouseEvent):void
		{
			m_pageMaxItem++;
			this["itemAnchor"].x -=  127;
			(this["nextBtn"] as SimpleButton).visible = !(m_pageMaxItem >= m_itemCount);
			(this["preBtn"] as SimpleButton).visible = true;
		}
		private function onPreClick(e:MouseEvent):void
		{
			m_pageMaxItem--;
			this["itemAnchor"].x +=  127;
			(this["nextBtn"] as SimpleButton).visible = true;
			(this["preBtn"] as SimpleButton).visible = (m_pageMaxItem >= 6);
		}

	}

}