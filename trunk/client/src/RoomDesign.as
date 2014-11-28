package
{
	import away3d.cameras.Camera3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.controllers.HoverController;
	import away3d.debug.AwayStats;
	import away3d.loaders.Loader3D;
	import away3d.loaders.parsers.DAEParser;
	import away3d.loaders.parsers.Max3DSParser;
	import away3d.loaders.parsers.OBJParser;
	import away3d.loaders.parsers.Parsers;
	
	import com.infy.constant.View3DCons;
	import com.infy.game.RoomGame;
	import com.infy.layer.Layer;
	import com.infy.layer.LayerManager;
	import com.infy.ui.RoomUI;
	
	import flash.display.Bitmap;
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
		
		[Embed(source="/../assets/pic/2.jpg")]
		public static var RoomBackground:Class;
		
		public var ui:RoomUI;
		public var game:RoomGame;
		
		public var scene:Scene3D;
		public var view:View3D;
		public var camera:Camera3D;
		
		public var cameraController:HoverController;
		
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
			initUI();
			initGame();
			initEngine();
			
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, onStageKeyDown);
			this.stage.addEventListener(Event.RESIZE, onResize);
			
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			onResize();
		}		
		
		private function initEngine():void
		{
			scene = new Scene3D();
			
			camera = new Camera3D();
			
			view = new View3D();
			view.antiAlias = 4;
			view.scene = scene;
			view.camera = camera;
			view.width = View3DCons.WIDTH;
			view.height = View3DCons.HEIGHT;
			view.backgroundColor = View3DCons.BACKGROUND_COLOR;
			//setup controller to be used on the camera
			cameraController = new HoverController(camera);
			cameraController.distance = 150;
			cameraController.minTiltAngle = -15;
			cameraController.maxTiltAngle = 90;
			cameraController.panAngle = 45;
			cameraController.tiltAngle = 20;
			
			addChild(view);
			var awayState:AwayStats = new AwayStats(view);
			awayState.x = 924;
			awayState.y = 85;
			addChild(awayState);
			
			Parsers.enableAllBundled();
			
			Loader3D.enableParser(OBJParser);
			Loader3D.enableParser(DAEParser);
			Loader3D.enableParser(Max3DSParser);
		}
		
		private function initGame():void
		{
			game = new RoomGame();
		}		
		
		protected function onEnterFrame(event:Event):void
		{
			game.update();
			view.render();
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
						ui.toggleTestBg();
						break;
				}
			}
			
		}
		
		protected function onResize(event:Event = null):void
		{
			if(stage.stageWidth < View3DCons.WIDTH)
			{
				view.width = stage.stageWidth;
				view.x = 0;
			}
			else
			{
				view.width = View3DCons.WIDTH;
				view.x = (stage.stageWidth - View3DCons.WIDTH)/2
			}
			
			if(stage.stageHeight > View3DCons.HEIGHT + View3DCons.GAP_TOP)
			{
				view.y = View3DCons.GAP_TOP;
				view.height = View3DCons.HEIGHT;
				
			}
			else if(stage.stageHeight < View3DCons.HEIGHT)
			{
				view.y = 0;
				view.height = stage.stageHeight;
			}
			else
			{
				view.y = (stage.stageHeight - View3DCons.HEIGHT)/2;
				view.height = View3DCons.HEIGHT;
			}
		}
		
		private function initLayer():void
		{			
			this.addChild(LayerManager.instance);
		}
		
		private function initUI():void
		{	
			ui = new RoomUI();
			
			LayerManager.instance.addChildAt(ui, Layer.UI);
			
		}
		
	}
}