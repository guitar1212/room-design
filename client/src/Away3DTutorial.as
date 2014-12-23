package
{
	import fl.controls.List;
	import fl.events.ListEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.registerClassAlias;
	import flash.utils.getDefinitionByName;
	
	import tutorial.picking.PickingTutorialListing02;
	import tutorial.picking.PickingTutorialListing03;
	import tutorial.picking.PickingTutorialListing04;
	import tutorial.picking.PickingTutorialListing05;
	
	/**
	 * 
	 * @long  Dec 19, 2014
	 * 
	 */	
	public class Away3DTutorial extends Sprite
	{
		private var m_container:Sprite = new Sprite();
		
		public function Away3DTutorial()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onInit);
		}
		
		protected function onInit(event:Event):void
		{			
			m_container.x = 150;
			m_container.y = 50;
			this.addChild(m_container);
			
			var tuorialContainerUI:List = new List();
			tuorialContainerUI.addEventListener(ListEvent.ITEM_CLICK, onItemClick);
			tuorialContainerUI.addItem({label:"PickingTutorialListing02", data:new PickingTutorialListing02()});
			tuorialContainerUI.addItem({label:"PickingTutorialListing03", data:new PickingTutorialListing03()});
			tuorialContainerUI.addItem({label:"PickingTutorialListing04", data:new PickingTutorialListing04()});
			tuorialContainerUI.addItem({label:"PickingTutorialListing05", data:new PickingTutorialListing05()});
			
			this.addChild(tuorialContainerUI);
			// TODO Auto-generated method stub
			//this.addChild(new PickingTutorialListing02());
			
			
		}
		
		protected function onItemClick(event:ListEvent):void
		{
			m_container.removeChildren();
			
			m_container.addChild(event.item.data);
			
		}
	}
}