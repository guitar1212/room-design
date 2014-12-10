package src
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	public class PageChooseItemBase extends MovieClip
	{
		public var cbItemDown:Function = null;
		public var cbItemUp:Function = null;
		public var cbLabelClick:Function = null;
		public var cbTrashClick:Function = null;
		
		private var m_labelArr:Array = null;
		private var m_goodsArr:Array = null;
		private var m_itemCount:int = 0;
		private var m_pageMaxItem:int = 5;
		
		
		public function PageChooseItemBase()
		{
			// constructor code
			m_labelArr = new Array();
			m_goodsArr = new Array();
			initUI();
			
		}
		
		
		
		/*LABEL_Array*/
		public function set labelArray(labelNameArr:Array):void
		{
			var nameLength:int = labelNameArr.length;
			while(this["labeItemlAnchor"].numChildren)
			{
				this["labeItemlAnchor"].removeChildAt(0);
			}
			for(var i:int = 0;i < nameLength;++i)
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
			for(var i:int = 0; i< labeArrLeng;++i)
			{
				m_labelArr[i].isLabelChoose = (i == index);
			}
		}
		
		
		/*物品Item*/
		public function set goodsItemVO(arr:Array):void
		{
			var itemLeng:int = arr.length;
			m_itemCount = arr.length;
			while(this["itemAnchor"].numChildren)
			{
				this["itemAnchor"].removeChildAt(0);
			}
			for(var i:int = 0; i< itemLeng;++i)
			{
				var goodsItem:DesignGoods = new DesignGoods();
				m_goodsArr.push(goodsItem);
				m_goodsArr[i].x = 127 * i;
				m_goodsArr[i].setPic(arr[i].itemIcon);
				m_goodsArr[i].setId(arr[i].id);
				this["itemAnchor"].addChild(m_goodsArr[i]);
				m_goodsArr[i].cbItemDown = onItemDown;
				m_goodsArr[i].cbItemUp = onItemUp;
			}
			
			this["nextBtn"].visible = (m_itemCount > 5);
			
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
			this["nextBtn"].addEventListener(MouseEvent.CLICK, onNextClick);
			this["preBtn"].addEventListener(MouseEvent.CLICK, onPreClick);
			this["preBtn"].visible = false;
		}
		
		private function onItemDown(id:String):void
		{
			if (cbItemDown != null)
				cbItemDown(id);
		}
		private function onItemUp(id:String):void
		{
			if (cbItemUp != null)
				cbItemUp(id);
		}
		
		private function onLabelClick(id:String):void
		{
			if(cbLabelClick != null)
				cbLabelClick(id)
			var labeArrLeng:int = m_labelArr.length;
			for(var i:int = 0; i< labeArrLeng;++i)
			{
				m_labelArr[i].isLabelChoose = (i == int(id));
			}
			
		}
		
		private function onNextClick(e:MouseEvent):void
		{	
			m_pageMaxItem++;
			this["itemAnchor"].x -= 127;
			this["nextBtn"].visible = !(m_pageMaxItem >= m_itemCount);
			this["preBtn"].visible = true;
		}
		private function onPreClick(e:MouseEvent):void
		{
			m_pageMaxItem--;
			this["itemAnchor"].x += 127;
			this["nextBtn"].visible = true;
			this["preBtn"].visible = (m_pageMaxItem >= 6);
		}

	}
	
}
