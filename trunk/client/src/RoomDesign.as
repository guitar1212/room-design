package
{
	import com.infy.game.RoomGame;
	import com.infy.layer.LayerManager;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	/**
	 * 
	 * @long  Nov 26, 2014
	 * 
	 */	
	[SWF(backgroundColor="#dfe3e4", frameRate="60", quality="LOW", width="1024", height="768")]
	public class RoomDesign extends Sprite
	{		
		[Embed(source="/../embeds/viewBG.jpg")]
		public static var RoomBackground:Class;
		
		
		public var game:RoomGame;
		
		
		public function RoomDesign()
		{
			super();
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		
		protected function onAddToStage(event:Event):void
		{
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.TOP_LEFT;
			
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
						
			initLayer();		
			
			initGame();
			
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, onStageKeyDown);
			this.stage.addEventListener(Event.RESIZE, onResize);
			
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			onResize();
		}
		
		
		private function initGame():void
		{
			game = new RoomGame(this);
		}		
		
		protected function onEnterFrame(event:Event):void
		{
			game.update();
			game.render();
		}
		
		protected function onStageKeyDown(event:KeyboardEvent):void
		{
			var key:uint = event.keyCode;
			if(event.ctrlKey && event.shiftKey)
			{
				
			}
			else if(event.ctrlKey)
			{
				
			}
			else if(event.shiftKey)
			{
				
			}
			else
			{
				switch(key)
				{
					case Keyboard.B:
						
						break;
				}
			}
			
			game.onKeyDown(event.keyCode, event.ctrlKey, event.shiftKey, event.altKey);
		}
		
		protected function onResize(event:Event = null):void
		{	
			game.resize(this.stage);
		}
		
		private function initLayer():void
		{			
			this.addChild(LayerManager.instance);
		}
		
	}
}