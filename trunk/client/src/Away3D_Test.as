/*

Shading example in Away3d

Demonstrates:

How to create multiple lightsources in a scene.
How to apply specular maps, normals maps and diffuse texture maps to a material.

Code by Rob Bateman
rob@infiniteturtles.co.uk
http://www.infiniteturtles.co.uk

This code is distributed under the MIT License

Copyright (c) The Away Foundation http://www.theawayfoundation.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the “Software”), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/

package
{

	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.OrthographicLens;
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.controllers.ControllerBase;
	import away3d.controllers.FirstPersonController;
	import away3d.controllers.HoverController;
	import away3d.core.base.ISubGeometry;
	import away3d.debug.WireframeAxesGrid;
	import away3d.entities.Mesh;
	import away3d.entities.SegmentSet;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.events.MouseEvent3D;
	import away3d.filters.BloomFilter3D;
	import away3d.lights.DirectionalLight;
	import away3d.lights.LightBase;
	import away3d.lights.LightProbe;
	import away3d.lights.PointLight;
	import away3d.loaders.Loader3D;
	import away3d.loaders.misc.AssetLoaderContext;
	import away3d.loaders.parsers.DAEParser;
	import away3d.loaders.parsers.Max3DSParser;
	import away3d.loaders.parsers.OBJParser;
	import away3d.loaders.parsers.ParserBase;
	import away3d.materials.ColorMaterial;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.LineSegment;
	import away3d.primitives.WireframeCube;
	import away3d.primitives.WireframePrimitiveBase;
	import away3d.textures.BitmapTexture;
	import away3d.tools.utils.Drag3D;
	
	import com.infy.camera.CameraInfo;
	import com.infy.camera.CameraInfoManager;
	import com.infy.constant.View3DCons;
	import com.infy.constant.WireFrameConst;
	import com.infy.editor.Editor2DRoom;
	import com.infy.editor.editor2droom.event.Editor2DEvent;
	import com.infy.editor.ui.ImageSavePanel;
	import com.infy.editor.ui.ObjectInfoUI;
	import com.infy.event.CameraEvent;
	import com.infy.event.GameEvent;
	import com.infy.event.ObjEvent;
	import com.infy.event.RoomEvent;
	import com.infy.game.EditRoomGame;
	import com.infy.grid.Grid;
	import com.infy.light.LightInfo;
	import com.infy.light.LightManager;
	import com.infy.parser.RoomConfigParser;
	import com.infy.parser.command.CameraParserCommand;
	import com.infy.parser.command.LightParserCommand;
	import com.infy.parser.command.LoadParserCommand;
	import com.infy.parser.command.ParserCommandType;
	import com.infy.parser.command.PrimitiveParserCommand;
	import com.infy.path.GamePath;
	import com.infy.ui.CameraInfoUI;
	import com.infy.ui.Modify3DObjectUI;
	import com.infy.ui.ModifyCameraUI;
	import com.infy.ui.ModifyLightUI;
	import com.infy.ui.TextEditorBaseUI;
	import com.infy.util.primitive.PrimitiveCreator;
	import com.infy.util.primitive.PrimitiveInfo;
	import com.infy.util.scene.SceneObjectView;
	import com.infy.util.tools.ColorUtil;
	import com.infy.util.zip.ZipLoader;
	
	import fl.controls.Button;
	import fl.controls.TextInput;
	import fl.core.UIComponent;
	import fl.events.SliderEvent;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	[SWF(backgroundColor="#A2A2A2", frameRate="60", quality="LOW")]
	public class Away3D_Test extends Sprite
	{
		private var game:EditRoomGame;
		
		private var roomParser:RoomConfigParser;
		
		private var m_objMenu:ClickMenuUI;
		
		private var m_loading:LoadingSimpleUI;
		
		private var m_objInfoUI:ObjectInfoUI;
		
		private var m_saveImgPanel:ImageSavePanel;
		
		private var m_bTopView:Boolean = false;
		
		private var m_edit2D:Editor2DRoom;
		
		//signature variables
		//private var Signature:Sprite;
		//private var SignatureBitmap:Bitmap;
		
		//material objects
		private var planeMaterial:TextureMaterial;
		private var sphereMaterial:TextureMaterial;
		private var cubeMaterial:TextureMaterial;
		private var torusMaterial:TextureMaterial;
		
		//navigation variables
		private var move:Boolean = false;
		//private var m_shiftKeyDown:Boolean = false;
		private var lastPanAngle:Number;
		private var lastTiltAngle:Number;
		private var lastMouseX:Number;
		private var lastMouseY:Number;
		private var lastPanX:Number;
		private var lastPanY:Number;
		
		private var _inactiveMaterial:ColorMaterial;
		private var _activeMaterial:ColorMaterial;

		private var m_curSelectObject:ObjectContainer3D = null;
		private var m_meshList:Vector.<Mesh> = new Vector.<Mesh>();
		
		private var m_objList:Vector.<Loader3D> = new Vector.<Loader3D>();
		
		private var m_segmentSetList:Vector.<SegmentSet> = new Vector.<SegmentSet>();
		
		private var m_loaderScale:Number = 1.0;
		private var m_axis:WireframeAxesGrid = null;
		
		private var m_pathInput:TextInput;
		private var m_roomPathInput:TextInput;
		private var roomEditorBtn:Button;
		private var wireframeBtn:Button;
		private var createLightBtn:Button;
		private var saveRoomBtn:Button;
		
		//private var billboard:Sprite3D;
		
		private var m_cameraInfo:TextField;		
		private var m_lightInfo:TextField;
		private var m_mouseInfoText:TextField;
		
		private var m_sceneContainer:SceneObjectView;
		
		private var m_cameraModifyUI:ModifyCameraUI;
		private var m_objModifyUI:Modify3DObjectUI;
		private var m_lightModifyUI:ModifyLightUI;
		
		private var m_objeditor:TextEditorBaseUI;
		private var m_roomEditor:TextEditorBaseUI;
		
		private var m_cameraInfoUI:CameraInfoUI;
		
		private var m_textureSprite:Sprite = new Sprite();
		
		private var m_underButtonList:Array = [];
		
		private var m_file:FileReference;
		
		/**
		 * Constructor
		 */
		public function Away3D_Test()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			
		}
		
		protected function onAddToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			init();
		}
		
		/**
		 * Global initialise function
		 */
		private function init():void
		{
			game = new EditRoomGame(this);
			game.lockCamera = false;
			roomParser = new RoomConfigParser(game);
			
			initUI();
			initMaterials();
			initObjects();
			initListeners();			
		}
		
		private function initUI():void
		{
			m_objMenu = new ClickMenuUI();
			m_objMenu.menuArray = ['移動', '旋轉', '刪除'];
			m_objMenu.cbMenuClick = onObjectMenuClick;
			
			m_loading = new LoadingSimpleUI();
			
			m_saveImgPanel = new ImageSavePanel();
			
			// OBJ Editor
			m_objeditor = new TextEditorBaseUI(250, 350,  onCreateObject, null);			
			this.addChild(m_objeditor);
			m_objeditor.visible = false;
			m_objeditor.x = 5;
			m_objeditor.y = 100;
			m_objeditor.data = PrimitiveCreator.defaultCubeObjectData;
			
			this.addChild(m_textureSprite);
			
			createUnderButtons();
			
			// Input Obj Loading
			m_pathInput = new TextInput();
			m_pathInput.width = 300;			
			m_pathInput.height = 20;
			//m_pathInput.text = '..\\assets\\obj\\bear2\\bear001.obj';
			m_pathInput.text = '..\\assets\\model\\obj\\sofa\\sofa.obj';
			m_pathInput.x = 200;
			m_pathInput.y = 5;
			m_pathInput.addEventListener(KeyboardEvent.KEY_DOWN, onPathInputChange);
			this.addChild(m_pathInput);
			
			var inputBtn:Button = new Button();
			inputBtn.label = "Load";
			inputBtn.x = m_pathInput.x + m_pathInput.width + 5;
			inputBtn.y = m_pathInput.y;
			inputBtn.addEventListener(MouseEvent.CLICK, onInputEnter);			
			this.addChild(inputBtn);
			
			var objBrowser:Button = new Button();
			objBrowser.label = "ObjBrowser";
			objBrowser.x = inputBtn.x;
			objBrowser.y = m_pathInput.y + 25;
			objBrowser.addEventListener(MouseEvent.CLICK, onBrowserRoomConfig);			
			this.addChild(objBrowser);
			
			// input room config loading
			m_roomPathInput = new TextInput();
			m_roomPathInput.width = 300;			
			m_roomPathInput.height = 20;
			m_roomPathInput.text = '..\\assets\\setting\\room\\room01';
			m_roomPathInput.x = inputBtn.x + inputBtn.width + 45;
			m_roomPathInput.y = m_pathInput.y;			
			this.addChild(m_roomPathInput);
			
			var roomPathBtn:Button = new Button();
			roomPathBtn.label = "Get Room";
			roomPathBtn.x = m_roomPathInput.x + m_roomPathInput.width + 5;
			roomPathBtn.y = m_roomPathInput.y;
			roomPathBtn.addEventListener(MouseEvent.CLICK, onRoomConfigBtnClick);
			this.addChild(roomPathBtn);
			
			var browser:Button = new Button();
			browser.label = "Browse";
			browser.x = roomPathBtn.x + roomPathBtn.width + 5;
			browser.y = roomPathBtn.y;
			browser.addEventListener(MouseEvent.CLICK, onBrowserRoomConfig);			
			this.addChild(browser);
			
			// show mesh info
			m_objInfoUI = new ObjectInfoUI();
			m_objInfoUI.x = 10;
			m_objInfoUI.y = 500;			
			this.addChild(m_objInfoUI);
			
			// show camera info
			m_cameraInfo = new TextField();
			m_cameraInfo.background = true;
			m_cameraInfo.border = true;
			m_cameraInfo.width = 200;
			m_cameraInfo.height = 200;
			m_cameraInfo.x = 250;
			m_cameraInfo.y = m_objInfoUI.y;
			m_cameraInfo.text = "camera info :";
			this.addChild(m_cameraInfo);
			
			// show light info
			m_lightInfo = new TextField();
			m_lightInfo.background = true;
			m_lightInfo.border = true;
			m_lightInfo.width = 200;
			m_lightInfo.height = 200;
			m_lightInfo.x = 490;
			m_lightInfo.y = m_objInfoUI.y;
			m_lightInfo.text = "light info :";
			this.addChild(m_lightInfo);
			
			// scene obje contianer
			m_sceneContainer = new SceneObjectView();
			m_sceneContainer.x = 1300;
			m_sceneContainer.y = 30;
			m_sceneContainer.itemSelectCallback = onSceneItemSelect;
			m_sceneContainer.buttonClickCallback = onSceneObjectViewButtonResponse;
			this.addChild(m_sceneContainer);
			
			// camera modify ui
			m_cameraModifyUI = new ModifyCameraUI();
			m_cameraModifyUI.x = 700;
			m_cameraModifyUI.y = m_objInfoUI.y;
			m_cameraModifyUI.target = game.cameraController;
			m_cameraModifyUI.checkCallback = toggleCameraLocked;
			this.addChild(m_cameraModifyUI);
			m_cameraModifyUI.addEventListener(CameraEvent.CHANGE, onCameraInfoChange);
			
			// 3dObject modify UI
			m_objModifyUI = new Modify3DObjectUI();
			m_objModifyUI.x = 950;
			m_objModifyUI.y = m_objInfoUI.y;			
			m_objModifyUI.addEventListener(ObjEvent.CHANGE, on3DObjectInfoChange);
			this.addChild(m_objModifyUI);
			
			m_lightModifyUI = new ModifyLightUI("Directional Light");
			m_lightModifyUI.x = 1200;
			m_lightModifyUI.y = m_objInfoUI.y;
			m_lightModifyUI.addEventListener(SliderEvent.CHANGE, onLightInfoChange)
			this.addChild(m_lightModifyUI);
			
			
			// room editro ui
			m_roomEditor = new TextEditorBaseUI();
			m_roomEditor.x = 275;
			m_roomEditor.y = 460;
			m_roomEditor.visible = false;
			this.addChild(m_roomEditor);
			
			// show mouse info
			m_mouseInfoText = new TextField();
			m_mouseInfoText.selectable = false;
			m_mouseInfoText.mouseEnabled = false;
			this.addChild(m_mouseInfoText);
			
			// cameraInfo UI
			m_cameraInfoUI = new CameraInfoUI();
			m_cameraInfoUI.x = 5;
			m_cameraInfoUI.y = 250;
			m_cameraInfoUI.selectCallback = changeCamera;
			m_cameraInfoUI.buttonCallback = onCameraUIButtonClick;
			m_cameraInfoUI.createCameraCallback = onCreateCameraBtnclick;
			this.addChild(m_cameraInfoUI);
		}
		
		/**
		 * Initialise the materials
		 */
		private function initMaterials():void
		{
			/*planeMaterial = new TextureMaterial(Cast.bitmapTexture(FloorDiffuse));
			planeMaterial.specularMap = Cast.bitmapTexture(FloorSpecular);
			planeMaterial.normalMap = Cast.bitmapTexture(FloorNormals);
			planeMaterial.lightPicker = game.lightPicker;
			planeMaterial.repeat = true;
			planeMaterial.mipmap = false;
			
			sphereMaterial = new TextureMaterial(Cast.bitmapTexture(BeachBallDiffuse));
			sphereMaterial.specularMap = Cast.bitmapTexture(BeachBallSpecular);
			sphereMaterial.lightPicker = game.lightPicker;
			
			cubeMaterial = new TextureMaterial(Cast.bitmapTexture(TrinketDiffuse));
			cubeMaterial.specularMap = Cast.bitmapTexture(TrinketSpecular);
			cubeMaterial.normalMap = Cast.bitmapTexture(TrinketNormals);
			cubeMaterial.lightPicker = game.lightPicker;
			cubeMaterial.mipmap = false;
			
			var weaveDiffuseTexture:BitmapTexture = Cast.bitmapTexture(WeaveDiffuse);
			torusMaterial = new TextureMaterial(weaveDiffuseTexture);
			torusMaterial.specularMap = weaveDiffuseTexture;
			torusMaterial.normalMap = Cast.bitmapTexture(WeaveNormals);
			torusMaterial.lightPicker = game.lightPicker;
			torusMaterial.repeat = true;
			
			_activeMaterial = new ColorMaterial( 0xFF0000 );
			_activeMaterial.lightPicker = game.lightPicker;
			_inactiveMaterial = new ColorMaterial( 0xCCCCCC );
			_inactiveMaterial.lightPicker = game.lightPicker;*/
		}
		
		/**
		 * Initialise the scene objects
		 */
		private function initObjects():void
		{	
			/*billboard = new Sprite3D(planeMaterial, 50, 50);
			billboard.x = 100;			
			addToScene(billboard);*/
			
			/*var cone:Mesh = new Mesh(new ConeGeometry(), new ColorMaterial(0x2d56ef));
			cone.z = 100;
			cone.y = 40;
			//cone.scale();
			addToScene(cone);
			cone.showBounds = true;
			drawWireFrame(cone)*/;
			
			/*var plane2:Mesh = new Mesh(new PlaneGeometry(100, 100));
			//plane2.geometry.scaleUV(2, 2);
			plane2.y = 0;
			
			addToScene(plane2);
			
			plane = new Mesh(new PlaneGeometry(1000, 1000), planeMaterial);
			plane.geometry.scaleUV(2, 2);
			plane.y = -20;
			
			addToScene(plane);
			
			sphere = new Mesh(new SphereGeometry(150, 40, 20), sphereMaterial);
			sphere.x = 300;
			sphere.y = 160;
			sphere.z = 300;
			sphere.mouseEnabled = true;
			//sphere.pickingCollider = PickingColliderType.AS3_BEST_HIT;
			sphere.pickingCollider = PickingColliderType.AS3_FIRST_ENCOUNTERED;
			addToScene(sphere);
			
			cube = new Mesh(new CubeGeometry(200, 200, 200, 1, 1, 1, false), cubeMaterial);
			cube.x = 300;
			cube.y = 160;
			cube.z = -250;
			cube.mouseEnabled = true;
			cube.addEventListener(MouseEvent3D.MOUSE_OVER, onMouseOver);
			cube.addEventListener(MouseEvent3D.MOUSE_OUT, onMouseOut);
			cube.addEventListener(MouseEvent3D.MOUSE_DOWN, onCubeMouseDown);
			
			addToScene(cube);
			
			torus = new Mesh(new TorusGeometry(150, 60, 40, 20), torusMaterial);
			torus.geometry.scaleUV(10, 5);
			torus.x = -250;
			torus.y = 160;
			torus.z = -250;
			
			addToScene(torus);
			*/
		}
		
		/**
		 * Initialise the listeners
		 */
		private function initListeners():void
		{
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.addEventListener(MouseEvent.DOUBLE_CLICK, onMouseDobuleClick);
			stage.addEventListener(Event.RESIZE, onResize);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onStageKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onStageKeyUp);
			stage.addEventListener(MouseEvent.CLICK, stageMouseClickHandler);
			
			this.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			
			//
			game.addEventListener(RoomEvent.CREATE_OBJECT, onRoomObjectCreate);
			game.addEventListener(RoomEvent.CREATE_CAMERA, onRoomCameraCreate);
			game.addEventListener(RoomEvent.CREATE_LIGHT, onRoomLightCreate);
			game.addEventListener(RoomEvent.LOAD_COMPLETED, onRoomObjectsLoadCompleted);
			game.addEventListener(GameEvent.CAPTURE_SCREEN_COMPLETE, onCaptureScreenComplete);
			onResize();
		}
		
		private function createUnderButtons():void
		{
			// toggle roomeditro ui button
			roomEditorBtn = new Button();
			roomEditorBtn.label = "Open Room Editor";
			roomEditorBtn.addEventListener(MouseEvent.CLICK, toggleRoomConfigEditor);
			this.addChild(roomEditorBtn);
			m_underButtonList.push(roomEditorBtn);
			
			var objEditorBtn:Button = new Button();
			objEditorBtn.label = "Obj Editor";
			objEditorBtn.addEventListener(MouseEvent.CLICK, toggleObjEditorEditor);
			this.addChild(objEditorBtn);
			m_underButtonList.push(objEditorBtn);
			
			// toggle wireframe button
			wireframeBtn = new Button();
			wireframeBtn.label = "wireFrame";
			wireframeBtn.addEventListener(MouseEvent.CLICK, toggleWireFrame);
			wireframeBtn.enabled = false;
			this.addChild(wireframeBtn);
			m_underButtonList.push(wireframeBtn);
			
			// create light button
			createLightBtn = new Button();
			createLightBtn.label = "create Light";			
			createLightBtn.addEventListener(MouseEvent.CLICK, onCreateLightBtnClick);			
			this.addChild(createLightBtn);
			m_underButtonList.push(createLightBtn);
			
			// save btn
			saveRoomBtn = new Button();
			saveRoomBtn.label = "Save Room";
			saveRoomBtn.addEventListener(MouseEvent.CLICK, saveRoom);
			this.addChild(saveRoomBtn);
			m_underButtonList.push(saveRoomBtn);
			
			var captureBtn:Button = new Button();
			captureBtn.label = "Capture Screen";
			captureBtn.addEventListener(MouseEvent.CLICK, onCaptureStart);
			this.addChild(captureBtn);
			m_underButtonList.push(captureBtn);
			
			var topViewBtn:Button = new Button();
			topViewBtn.label = "TopView";
			topViewBtn.addEventListener(MouseEvent.CLICK, onTopViewBtnClick);
			this.addChild(topViewBtn);
			m_underButtonList.push(topViewBtn);
			
			var toggleGridBtn:Button = new Button();
			toggleGridBtn.label = "toggleGrid";
			toggleGridBtn.addEventListener(MouseEvent.CLICK, onToggleGridBtnClick);
			this.addChild(toggleGridBtn);
			m_underButtonList.push(toggleGridBtn);
			
			var open2DEditorBtn:Button = new Button();
			open2DEditorBtn.label = "Edit 2D";
			open2DEditorBtn.addEventListener(MouseEvent.CLICK, onToggle2DEditorBtnClick);
			this.addChild(open2DEditorBtn);
			m_underButtonList.push(open2DEditorBtn);
		}

		private var ground:ObjectContainer3D;
		private function onRoomObjectCreate(event:RoomEvent):void
		{
			var o:ObjectContainer3D = event.object as ObjectContainer3D;
			
			if(o == null) return;
			
			if(o.name == "ground")
				ground = o;
			
			addToScene(o);
			
			if(o is Mesh)
			{
				m_meshList.push(event.object);
				(o as Mesh).material.lightPicker = game.lightPicker;
			}
			else if(o is Loader3D)
			{
				m_objList.push(event.object);
				//addObjectContainerToScene(o);
				game.prepareObjectContainer(o);
			}
			
			
			o.addEventListener(MouseEvent3D.DOUBLE_CLICK, on3DObjeMouseDown);
			//game.addObjectToScene(event.object as ObjectContainer3D);
		}
		
		private function onRoomCameraCreate(event:RoomEvent):void
		{
			var camInfo:CameraInfo = event.object as CameraInfo;
			createCameraInfo(camInfo);
			
			if(camInfo.isDefault)
				setCamera(camInfo);
		}
		
		private function onRoomLightCreate(event:RoomEvent):void
		{
			var lightInfo:LightInfo = event.object as LightInfo;
			createLight(lightInfo);	
		}
		
		private function onRoomObjectsLoadCompleted(event:RoomEvent):void
		{
			hideLoading();
		}
		
		private var m_captureBitmapData:BitmapData;
		private function onCaptureScreenComplete(event:GameEvent):void
		{
			//saveCaptureBtn.enabled = true;
			m_captureBitmapData = event.bitmapData;
			m_saveImgPanel.bitmapData = m_captureBitmapData;
		}
			
		protected function onPathInputChange(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.ENTER)
			{
				onInputEnter(null);
				this.stage.focus = stage;
			}
		}
		
		protected function toggleRoomConfigEditor(event:MouseEvent):void
		{
			m_roomEditor.visible = !m_roomEditor.visible;
			if(m_roomEditor.visible)
				roomEditorBtn.label = "Hide RoomEditor";
			else
				roomEditorBtn.label = "Open RoomEditor";
		}
		
		private function toggleObjEditorEditor(event:MouseEvent):void
		{
			m_objeditor.visible = !m_objeditor.visible;
		}
		
		protected function onCameraInfoChange(event:CameraEvent):void
		{
			setCameraInfo(game.cameraController);
		}
		
		protected function on3DObjectInfoChange(event:ObjEvent):void
		{
			if(m_curSelectObject)
				setObjectInfo(m_curSelectObject);
		}
		
		protected function onLightInfoChange(event:SliderEvent):void
		{
			if(m_curSelectObject is LightBase)
				setLightInfo(m_curSelectObject as LightBase);
		}
		
		private function toggleCameraLocked(lock:Boolean):void
		{
			game.lockCamera = lock;
		}
		
		protected function onInputEnter(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			var path:String = m_pathInput.text;
			if(path == "" || path =="\n")
				return;
			
			var ta:Array = path.split(".");
			var type:String = String(ta[ta.length - 1]).toLocaleLowerCase();
			
			loadModel(path, type, [0, 0, 0], [0, 0, 0], 1, [1, 1, 1]);
		}
		
		private function onBrowserRoomConfig(e:MouseEvent):void
		{		
			m_file = null;
			m_file = new FileReference();
			m_file.addEventListener(Event.SELECT, onRoomConfigFileSelect, false, 0, true);
			m_file.addEventListener(Event.COMPLETE, onLoadRoomConfigComplete, false, 0, true);
			
			var b:Button = e.target as Button;
			if(b.label == "ObjBrowser")
				m_file.browse([new FileFilter("OBJ", "*.obj")]);
			else
				m_file.browse([new FileFilter("RoomConfig", "*.*")]);
			
		}
		
		protected function onRoomConfigFileSelect(event:Event):void
		{
			var fileName:String = m_file.name;
						
			m_file.load();
		}
		
		private function showLoading():void
		{
			//m_loading.x = (stage.stageWidth + View3DCons.WIDTH)/2;
			m_loading.x = game.view.x + game.view.width/2 - 5;
			m_loading.y = 250;
			this.addChild(m_loading);
		}
		
		private function hideLoading():void
		{
			this.removeChild(m_loading);
		}
		
		protected function onLoadRoomConfigComplete(event:Event):void
		{
			// TODO Auto-generated method stub
			//parserRoom(event.target.data.toString());
			if(m_file.type == ".obj")
				onCreateObject(event.target.data.toString());
			else
			{
				roomParser.parserRoomConfig(event.target.data.toString());
				showLoading();
			}
		}
		
		private var m_wireframeState:int = 0;
		private function toggleWireFrame(event:MouseEvent):void
		{
			if(m_curSelectObject)
			{
				// create wireframe
				if(m_wireframeState == 0)
				{
					drawWireFrame(m_curSelectObject);
				}
				// only wireframe
				else if(m_wireframeState == 1)
				{	
					removeWireFrame(m_curSelectObject);					
				}
				
				m_wireframeState++;
				if(m_wireframeState > 1)
					m_wireframeState = 0;
			}
		}

		private var m_lightCount:int = 0;
		private function onCreateLightBtnClick(event:MouseEvent):void
		{	
			var info:LightInfo = new LightInfo();
			
			LightManager.instance.addLight(info);
			
			createLight(info);
			
			var lightCmd:LightParserCommand = new LightParserCommand(game);
			lightCmd.setLightInfo(info);
			roomParser.addCommand(ParserCommandType.LIGHT, lightCmd);
		}
		
		private function createLight(info:LightInfo):void
		{
			var light:LightBase = game.createLight(info);
			addToScene(light);
			
			m_lightCount++;
		}
		
		
		private function saveRoom(event:MouseEvent):void
		{
			roomParser.refresh();
			var saveData:String = roomParser.data;
			
			var f:FileReference = new FileReference();
			f.save(saveData)
			
			trace(saveData);
		}
		
		private function onCaptureStart(event:MouseEvent):void
		{
			game.captureScreen();
			
			showImageSavePanel();
			
			//saveCaptureBtn.enabled = false;
		}
		
		private function onTopViewBtnClick(event:MouseEvent):void
		{
			var info:CameraInfo = new CameraInfo();
			info.type = "O";
			info.name = "topViewCam";
			info.distance = 500;
			info.projectionHeight = 500;
			info.panAngle = 180;
			info.tiltAngle = 90;
			setCamera(info);
			
			m_bTopView = true;
		}
		
		private var m_grid:Grid;
		private var m_bShowGrid:Boolean = false;
		private function onToggleGridBtnClick(event:MouseEvent = null):void
		{
			if(m_grid == null)
				m_grid = new Grid(10, 50, .2, 0x333333);
			
			m_bShowGrid = !m_bShowGrid;
			
			if(m_bShowGrid)
				addToScene(m_grid);
			else
				removeFromeScene(m_grid);
		}
		
		private function onToggle2DEditorBtnClick(event:MouseEvent):void
		{
			if(m_edit2D == null)
				m_edit2D = new Editor2DRoom();
			
			if(m_edit2D.parent == null)
			{
				this.addChild(m_edit2D);
				onResize();
				
				create2DRoom();
			}
			else
				m_edit2D.parent.removeChild(m_edit2D);
					
					
		}
		
		private function create2DRoom():void
		{
			// update command
			roomParser.refresh();
			
			var commands:Vector.<PrimitiveParserCommand> = roomParser.primiteCommand;
			var i:int, len:int = commands.length;
			var e:Editor2DEvent;
			for(i = 0; i < len; i++)
			{				
				var cmd:PrimitiveParserCommand = commands[i];
				if(cmd.isDelete) continue;
				
				if(cmd.cmd == ParserCommandType.BOX || cmd.cmd == ParserCommandType.PLANE)
				{
					e = new Editor2DEvent(Editor2DEvent.CREATE);
					e.name = cmd.name;
					e.style = "rectangle";
					e.depth = cmd.size.y;
					e.position.setTo(cmd.position.x, cmd.position.z);
					e.size.setTo(cmd.size.x, cmd.size.z);
					e.rotation = cmd.rotation.y;
					e.color = ColorUtil.getHexCode(cmd.color[0], cmd.color[1], cmd.color[2]);
					m_edit2D.dispatchEvent(e);
				}
			}
			
			var loadCmd:Vector.<LoadParserCommand> = roomParser.loadCommand;
			len = loadCmd.length;
			for(i = 0; i < len; i++)
			{				
				var lmd:LoadParserCommand = loadCmd[i];
				
				if(lmd.isDelete) continue;
				
				var target:ObjectContainer3D = lmd.target;
				var sizeX:Number = (target.maxX - target.minX)*target.scaleX;
				var sizeY:Number = (target.maxZ - target.minZ)*target.scaleZ;
				
				
				e = new Editor2DEvent(Editor2DEvent.CREATE);
				e.name = lmd.name;
				e.style = "rectangle";
				e.depth = lmd.size.y;
				e.position.setTo(lmd.position.x, -lmd.position.z);
				e.size.setTo(sizeX, sizeY);
				e.rotation = lmd.rotation.y;
				e.color = ColorUtil.getHexCode(lmd.color[0], lmd.color[1], lmd.color[2]);
				m_edit2D.dispatchEvent(e);
			}
		}
		
		/*private function onSaveCapture(event:MouseEvent):void
		{
			
			if(m_captureBitmapData)
			{
				var f:FileReference = new FileReference();
				var j:JPGEncoder = new JPGEncoder();
				var ba:ByteArray = j.encode(m_captureBitmapData);
				f.save(ba);
			}
		}*/
		
		
		/*protected function onCubeMouseDown(event:MouseEvent3D):void
		{
			cube.translateLocal(new Vector3D(0, 1, 0), 5);
			event.preventDefault();
		}*/
		
		/*protected function onMouseOut(event:MouseEvent3D):void
		{
			//event.target.material = cubeMaterial;
			event.target.material.texture = Cast.bitmapTexture(FloorDiffuse);
		}*/
		
		/*protected function onMouseOver(event:MouseEvent3D):void
		{
			//event.target.material = _activeMaterial
			event.target.material.texture = Cast.bitmapTexture(TrinketDiffuse);
		}*/
		
		
		protected function stageMouseClickHandler(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			if(!event.bubbles)
				this.stage.focus = stage;
			
			setMouseInfo();
		}
		
		protected function onMouseWheel(event:MouseEvent):void
		{	
			if(event.target is TextField || event.target is UIComponent) 
			{
				event.stopPropagation();
				return;
			}
			
			if(event.target.parent && event.target.parent is View3D)
			{
				if(game.cameraController)
				{
					if(game.camera.lens is OrthographicLens)
					{
						if(event.delta < 0) // forward
						{
							OrthographicLens(game.camera.lens).projectionHeight += 20;
						}
						else
						{
							if(OrthographicLens(game.camera.lens).projectionHeight > 50)
								OrthographicLens(game.camera.lens).projectionHeight -= 20;
						}
					}
					else
					{
						if(event.delta < 0) // forward
						{
							game.cameraController.distance += 20;
						}
						else
						{
							if(game.cameraController.distance > 50)
								game.cameraController.distance -= 20;
						}
					}
					setCameraInfo(game.cameraController);
					m_cameraModifyUI.refresh();
					event.stopImmediatePropagation();
				}
			}
		}
		
		protected function onStageKeyDown(event:KeyboardEvent):void
		{
			if(event.ctrlKey)
			{
				switch(event.keyCode)
				{
					case Keyboard.DELETE:
						cleanScene();
						m_sceneContainer.clean();
						break;
				}
					
			}
			else if(event.shiftKey)
			{
				//m_shiftKeyDown = true;
				switch(event.keyCode)
				{
					case Keyboard.DELETE:
						cleanLoadObject();
						break;
					
					case Keyboard.NUMBER_1:
						toggleAxisShow();						
						break;
				}
			}
			else
			{
				switch(event.keyCode)
				{
					case Keyboard.INSERT:					
						//loadRoom(roomPath);			
						game.captureScreen();
						break;						
					
					/*case Keyboard.NUMBER_9:
						testDrawWireFrame(m_meshList[0]);
						break;*/
					/*case Keyboard.NUMBER_1:
						var c:CameraInfo = CameraInfoManager.instance.getCameraInfo("cam01");
						setCamera(c, camera);						
						break;
					
					case Keyboard.NUMBER_2:
						var c2:CameraInfo = CameraInfoManager.instance.getCameraInfo("cam02");
						setCamera(c2, camera);
						break;*/
					
					case Keyboard.NUMBER_9:
						var b:BloomFilter3D = new BloomFilter3D();
						game.view.filters3d = [b];
						break;
					
					case Keyboard.NUMBER_0:
						game.view.filters3d = null;
						break;
				}
			}
			
			
			// TODO Auto-generated method stub
			if(m_curSelectObject == null)
				return;
			
			switch(event.keyCode)
			{
				case Keyboard.LEFT:
					m_curSelectObject.x += 1;
					break;
				case Keyboard.RIGHT:
					m_curSelectObject.x -= 1;
					break;
				case Keyboard.UP:
					if(event.ctrlKey)
						m_curSelectObject.y += 1;
					else
						m_curSelectObject.z -= 1;
					break;
				case Keyboard.DOWN:
					if(event.ctrlKey)
						m_curSelectObject.y -= 1;
					else
						m_curSelectObject.z += 1;
					break;
				
				case Keyboard.DELETE:
					deleteSceneObject(m_curSelectObject);
					m_curSelectObject = null;
					break;		
				
				case Keyboard.NUMPAD_ADD:
					m_loaderScale = 2;
					m_curSelectObject.scale(m_loaderScale);
					setObjectInfo(m_curSelectObject);
					break;
				case Keyboard.NUMPAD_SUBTRACT:
					m_loaderScale = 0.5;
					m_curSelectObject.scale(m_loaderScale);
					setObjectInfo(m_curSelectObject);
					break;	
				
				case Keyboard.ESCAPE:
					cleanItemSelect();
					break;
			}
		}
		
		protected function onStageKeyUp(event:KeyboardEvent):void
		{
			//m_shiftKeyDown = event.shiftKey;		
			
		}
		
		private function toggleAxisShow():void
		{
			if(m_axis == null)
				m_axis = new WireframeAxesGrid();
			
			if(m_axis.parent == null)
				addToScene(m_axis);
			else
				removeFromeScene(m_axis);
		}
		
		/**
		 * Navigation and render loop
		 */
		private function onEnterFrame(event:Event):void
		{
			if(move) 
			{
				/*if(m_shiftKeyDown)
				{
					var dx:Number = 0.3*(stage.mouseX - lastPanX);
					var dy:Number = 0.3*(stage.mouseY - lastPanY);
					
					game.cameraController.lookAtPosition.x += dx;
					
					if(m_bTopView)
						game.cameraController.lookAtPosition.z -= dy;
					else
						game.cameraController.lookAtPosition.y += dy;
					game.cameraController.update();
					lastPanX = stage.mouseX;
					lastPanY = stage.mouseY;
					lastMouseX = stage.mouseX;
					lastMouseY = stage.mouseY;
				}
				else*/
				{
//					game.cameraController.panAngle = 0.3*(stage.mouseX - lastMouseX) + lastPanAngle;
//					game.cameraController.tiltAngle = 0.3*(stage.mouseY - lastMouseY) + lastTiltAngle;	
					
					m_bTopView = false;
				}
				setCameraInfo(game.cameraController);
				m_cameraModifyUI.refresh();
				hideObjMenu();
			}
			
			if(tempDragObj)
			{
				if(tempDragObj.object3d.scenePosition.x < (ground.maxX + ground.scenePosition.x))
					tempDragObj.updateDrag();
				else
					tempDragObj.object3d.scenePosition.x = (ground.maxX + ground.scenePosition.x) - 1;
			}
			
			if(m_bShowGrid)
			{
			
			}
			
			//light1.direction = new Vector3D(Math.sin(getTimer()/10000)*150000, 1000, Math.cos(getTimer()/10000)*150000);
			
			//cube.roll(1);
			//sphere.rotationX += 1;
			
			//loader.rotationY += 1;
			game.update();
			game.view.render();
			
		}
		
		private function onMouseDobuleClick(event:MouseEvent):void
		{
			
		}
		
		/**
		 * Mouse stage leave listener for navigation
		 */
//		private function onStageMouseLeave(event:Event):void
//		{
//			move = false;
//			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
//		}
		
		/**
		 * stage listener for resize events
		 */
		private function onResize(event:Event = null):void
		{
			if(stage.stageWidth < View3DCons.WIDTH)
			{
				game.view.width = stage.stageWidth;
				game.view.x = 0;
			}
			else
			{
				game.view.width = View3DCons.WIDTH;
				game.view.x = (stage.stageWidth - View3DCons.WIDTH)/2
			}
			
			if(stage.stageHeight > View3DCons.HEIGHT + View3DCons.GAP_TOP)
			{
				game.view.y = View3DCons.GAP_TOP;
				game.view.height = View3DCons.HEIGHT;
				
			}
			else if(stage.stageHeight < View3DCons.HEIGHT)
			{
				game.view.y = 0;
				game.view.height = stage.stageHeight;
			}
			else
			{
				game.view.y = (stage.stageHeight - View3DCons.HEIGHT)/2;
				game.view.height = View3DCons.HEIGHT;
			}
			
			m_sceneContainer.x = stage.stageWidth - m_sceneContainer.width - 30;
			
			m_mouseInfoText.x = game.view.x;
			m_mouseInfoText.y = game.view.y - 25;
			
			var dx:int = game.view.x;
			var dy:int = game.view.y + game.view.height + 3;
			var bpl:int = 7;	// buttons per line
			for(var i:int = 0; i < m_underButtonList.length; i++)
			{
				var b:Button = m_underButtonList[i];
				var c:int = ~~(i/bpl);
				b.y = dy + c*(b.height + 1);
				b.x = dx;
				
				if(i != 0 && i%(bpl-1) == 0)
					dx = game.view.x;
				else
					dx += b.width + 3;
			}
			
			if(m_edit2D)
			{
				m_edit2D.x = (stage.stageWidth - m_edit2D.width)/2;
				m_edit2D.y = (stage.stageHeight - m_edit2D.height)/2;
			}
		}
		
		private function setMouseInfo():void
		{
			m_mouseInfoText.text = "(" + stage.mouseX + ", " + stage.mouseY + ")";
		}
		
		
		/**
		 *	 
		 * @param event
		 * 
		 */		
		private function onRoomConfigBtnClick(event:MouseEvent = null):void
		{
			var path:String = m_roomPathInput.text;
			loadRoomSetting(path);
			
			showLoading();
		}
		
		private function loadRoomSetting(roomPath:String):void
		{
			roomParser.loadRoomSettingWithPaht(roomPath);			
		}
		
		
		
		private function setCamera(info:CameraInfo):void
		{
			game.setCamera(info);
			
			setCameraInfo(game.cameraController);
			m_cameraModifyUI.target = game.cameraController;
		}
		
		private function changeCamera(camName:String):void
		{
			var info:CameraInfo = CameraInfoManager.instance.getCameraInfo(camName);
			if(info)
				setCamera(info);
		}
		
		private function onCameraUIButtonClick(btnIndex:int):void
		{
			if(btnIndex == 0) // create
			{	
				var camInfo:CameraInfo = getCurrentCamraInfo();
				
				m_cameraInfoUI.showConfirmUI(camInfo);
			}
			else if(btnIndex == 1) //delete
			{
				var info:CameraInfo = m_cameraInfoUI.getSelectCameraInfo();
				if(info)
				{
					CameraInfoManager.instance.removeCameraInfo(info.name);
					m_cameraInfoUI.removeSelectCameraInfo();
				}
			}
		}
		
		private function createCameraInfo(info:CameraInfo):void
		{
			CameraInfoManager.instance.addCameraInfo(info.name, info);
			m_cameraInfoUI.addCameraInfo(info.name, info);			
		}
		
		private function onCreateCameraBtnclick(info:CameraInfo):void
		{
			createCameraInfo(info);
			
			var cameraCmd:CameraParserCommand = new CameraParserCommand(game);
			cameraCmd.setCameraInfo(info);
			roomParser.addCommand(ParserCommandType.CAMERA, cameraCmd);
		}
		
		private function getCurrentCamraInfo():CameraInfo
		{
			if(game.cameraController == null)
			{
				game.cameraController = new HoverController(game.camera);
				m_cameraModifyUI.target = game.cameraController;
			}
			
			var info:CameraInfo = new CameraInfo();
			info.name = "new cam";
			info.near = game.camera.lens.near;
			info.far = game.camera.lens.far;
			if(game.camera.lens is PerspectiveLens)
			{
				info.type = "P";
				info.fov = PerspectiveLens(game.camera.lens).fieldOfView;
			}
			else
			{
				info.type = "O";
				info.projectionHeight = OrthographicLens(game.camera.lens).projectionHeight;
			}
				
			info.distance = game.cameraController.distance;
			info.tiltAngle = game.cameraController.tiltAngle;
			info.panAngle = castPanAngle(game.cameraController.panAngle);
			info.lookAt = game.cameraController.lookAtPosition.clone();
			info.isDefault = false;
			return info;
		}
		
		private function castPanAngle(angle:int):Number
		{
			var panAngle:Number = angle;
			if(angle > 360)
			{
				while(panAngle > 360)
				{
					panAngle -= 360;
				}
			}
			else if(angle < 0)
			{
				while(angle < 0)
				{
					angle += 360;
				}
			}
			
			return panAngle;
		}
		
		
		
		private function createModel(args:Array):void
		{
			var info:PrimitiveInfo = new PrimitiveInfo();
			info.parser(args);
			
			var path:String = GamePath.ASSET_MODEL_PATH + info.type + "/" + info.name  +"/" + info.name + "." + info.type;
			
			var pos3:Array = [info.pos.x, info.pos.y, info.pos.z];
			var rot3:Array = [info.rotation.x, info.rotation.y, info.rotation.z];
			var s3:Array = [info.size.x, info.size.y, info.size.z];
			loadModel(path, info.type, pos3, rot3, 1, s3);
		}
		
		
		private function onSceneItemSelect(o:ObjectContainer3D):void
		{
			if(m_curSelectObject)
			{
				if(m_curSelectObject == o)
					return;
				
				cleanItemSelect();
			}
			
			if(o is Mesh)
			{
				selectMesh(o as Mesh);
			}
			else if(o is Loader3D)
			{
				selectLoader3D(o as Loader3D);
			}
			else
			{
				select3DObject(o);
			}
			
			if(o is LightBase)
			{
				setLightInfo(o as LightBase);
				lightTest(o);
				m_lightModifyUI.target = o as LightBase;
			}
			this.stage.focus = stage;
			
			showObjMenu();
		}
		
		
		private function onSceneObjectViewButtonResponse(btnIndex:int):void
		{
			// clean
			if(btnIndex == 0)
			{
				cleanScene();	
			}
			// delete
			else if(btnIndex == 1)
			{
				onDeleteButtonClick(null);
			}
		}
		
		private function lightTest(o:ObjectContainer3D):void
		{
			// TODO Auto Generated method stub
			
		}
		
		private function select3DObject(o:ObjectContainer3D):void
		{
			m_curSelectObject = o;
			drawBoundBox(o);
			
			setObjectInfo(o);
			wireframeBtn.enabled = true;
			
			m_objModifyUI.target = m_curSelectObject;
		}
		
		private function drawBoundBox(o:ObjectContainer3D):void
		{	
			var color:uint = 0x11ff32;
			var thinkness:Number = 1.5;
			
			if(o is Mesh)
			{
				var m:Mesh = o as Mesh;
				m.bounds.boundingRenderable.color = color;
				m.bounds.boundingRenderable.thickness = thinkness;
				m.showBounds = true;
			}
			else
			{
				var w:Number = o.maxX - o.minX;
				var h:Number = o.maxY - o.minY;
				var d:Number = o.maxZ - o.minZ;
				
				var wc:WireframeCube = new WireframeCube(w, h, d, color, thinkness);
				wc.x = o.minX + w/2;
				wc.y = o.minY + h/2;
				wc.z = o.minZ + d/2;
				wc.name = "boundingBox";
				o.addChild(wc);
			}
		}
		
		private function hideBoundBox(o:ObjectContainer3D):void
		{
			if(o is Mesh)
			{
				var m:Mesh = o as Mesh;
				m.showBounds = false;
			}
			else
			{
				var i:int = 0, len:int = o.numChildren;
				for(i; i < len; i++)
				{
					var c:ObjectContainer3D = o.getChildAt(i);
					if(c.name == "boundingBox")
					{
						o.removeChild(c);
						c.dispose();
						c = null;
						break;
					}
				}
			}
		}
		
		private function selectMesh(m:Mesh):void
		{	
			select3DObject(m as ObjectContainer3D);
			
			
			/*if(m_curSelectObject.material is TextureMaterial)
			TextureMaterial(billboard.material).texture = TextureMaterial(m_curSelectObject.material).texture;*/			
			
			//billboard.material = m.material;
			
			var b:BitmapData = null;
			if(m.material is TextureMaterial)
				b = (TextureMaterial(m.material).texture as BitmapTexture).bitmapData;
			
			m_textureSprite.graphics.clear();
			if(b)
			{
				m_textureSprite.graphics.beginBitmapFill(b);
				m_textureSprite.graphics.drawRect(0, 0, 128, 128);
				m_textureSprite.graphics.endFill();
			}
		}
		
		private function selectLoader3D(l:Loader3D):void
		{
			select3DObject(l as ObjectContainer3D);
			
		}
		
		private function cleanItemSelect():void
		{
			if(m_curSelectObject)
			{
				//m_curSelectObject.showBounds = false;
				hideBoundBox(m_curSelectObject);
				
				setObjectInfo(null);
				m_curSelectObject = null;
				wireframeBtn.enabled = false;
				
				hideObjMenu();
			}
		}
		
		protected function on3DObjeMouseDown(event:MouseEvent3D):void
		{
			/*var m:Mesh = event.target as Mesh;
			
			selectMesh(m);*/
			
			var o:ObjectContainer3D = event.target as ObjectContainer3D;
			onSceneItemSelect(o);
			
		}
		
		private function setObjectInfo(o:ObjectContainer3D):void
		{	
			m_objInfoUI.target = o;
		}
		
		private function setCameraInfo(controller:ControllerBase):void
		{
			var text:String = "";
			var camera:Camera3D = controller.targetObject as Camera3D;

			if(controller is HoverController)
			{
				var str:String = "";
				if(camera.lens is PerspectiveLens)
					str = "\nfov : " + PerspectiveLens(camera.lens).fieldOfView;
				else
					str = "\nproectHeight : " + OrthographicLens(camera.lens).projectionHeight;
				
				var lookAt:Vector3D = HoverController(controller).lookAtPosition;
				text = "HoverController\nname : " + camera.name +
					   "\n" + camera.lens.toString() +
					   "\npos : " + camera.position.x.toFixed(2) + ", " + camera.position.y.toFixed(2) + ", " + camera.position.y.toFixed(2) +
					   "\nnear : " + camera.lens.near + 
					   "\nfar : " + camera.lens.far +
					   //"\nfov : " + PerspectiveLens(camera.lens).fieldOfView + 
					   //"\nfocalLength :  " + PerspectiveLens(camera.lens).focalLength +
					   "\ndistance :" + HoverController(controller).distance +
					   "\npanAngle : " + HoverController(controller).panAngle.toFixed(2) + " (" +  HoverController(controller).minPanAngle + ", " + HoverController(controller).maxPanAngle + ")" +
					   "\ntiltAngle : " + HoverController(controller).tiltAngle.toFixed(2) + " (" +  HoverController(controller).minTiltAngle + ", " + HoverController(controller).maxTiltAngle + ")" +
					   "\nlookAt : " + lookAt.x.toFixed(2) + ", " + lookAt.y.toFixed(2) + ", " + lookAt.z.toFixed(2) +
					   str 
					   "\n";
					
			}
			else if(controller is FirstPersonController)
			{
				
			}
			
			m_cameraInfo.text = text;
		}
		
		private function setLightInfo(light:LightBase):void
		{
			var text:String = "Light Info : \nname : " + light.name + "\n";
			if(light is DirectionalLight)
				text += "type : Direction\nDir : " + DirectionalLight(light).direction.toString();
			else if(light is PointLight)
				text += ("type : Point");
			else if(light is LightProbe)
				text += ("type : LightProbe");
			
			text += "\ncolor : " + light.color.toString(16) + 
					"\nambient : " + light.ambient + "\nambient color : " + light.ambientColor.toString(16) +  
				    "\ndiffuse : " + light.diffuse +
					"\nspecular : " + light.specular;
			
			m_lightInfo.text = text;
		}
		
		private function onCreateObject(data:String, type:String = "obj", path:String = ""):void
		{			
			var p:ParserBase;
			/*var p:ParserBase = new OBJParser();
			p.addEventListener(AssetEvent.MATERIAL_COMPLETE, onParserMeterialComplete);*/
			switch(type)
			{
				case "obj":
					p = new OBJParser();
					break;
				case "3ds":
					p = new Max3DSParser();
					break;
				case "dae":
					p = new DAEParser();
			}
			
			var l:Loader3D = new Loader3D(false);
			var a:AssetLoaderContext = new AssetLoaderContext(true, path);			
			l.loadData(data, a, null, p);
			l.addEventListener(LoaderEvent.RESOURCE_COMPLETE, onModelLoadCompleted);
			l.addEventListener(AssetEvent.MATERIAL_COMPLETE, assetCompleteHandler);
			l.addEventListener(AssetEvent.ASSET_COMPLETE, assetCompleteHandler);
			l.addEventListener(AssetEvent.TEXTURE_COMPLETE, assetCompleteHandler);
			this.addToScene(l);
			
			m_objList.push(l);
		}
		
		protected function onParserMeterialComplete(event:AssetEvent):void
		{
			/*if(event.asset is TextureMaterial)
				TextureMaterial(event.asset).alphaBlending = true;*/				
		}
		
		protected function assetCompleteHandler(event:AssetEvent):void
		{
			switch(event.type)
			{
				case AssetEvent.ASSET_COMPLETE:
					break;
				
				case AssetEvent.MATERIAL_COMPLETE:					
					break;
				
				case AssetEvent.TEXTURE_COMPLETE:
					break;
			}
			trace("assetCompleteHandler = " + event.type + ",  assetType = " + event.assetPrevName);
		}
		
		private function loadZipOBJComplete(fileName:String, data:ByteArray, path:String):void
		{
			var a:Array = path.split("\\");
			a.pop();
			var p:String = a.join("\\");
			onCreateObject(data.toString(), fileName.split(".").pop(), p);
		}
		
		private function loadModel(path:String, type:String, pos3:Array, rot3:Array, scale:Number, scale3:Array):void
		{		
			if(type == "zip")
			{
				var z:ZipLoader = new ZipLoader();
				z.load(path);
				z.completeCallback = loadZipOBJComplete;
			}
			else //if(type == "obj")
			{
				var loader:Loader3D = new Loader3D();
				loader.addEventListener(LoaderEvent.RESOURCE_COMPLETE, onModelLoadCompleted);
				loader.addEventListener(AssetEvent.ASSET_COMPLETE, onAssetCompleted);
				loader.load(new URLRequest(path));			
				loader.rotationX = rot3[0];
				loader.rotationY = rot3[1];
				loader.rotationZ = rot3[2];
				loader.x = pos3[0];
				loader.y = pos3[1];
				loader.z = pos3[2];
				loader.scaleX = scale3[0];
				loader.scaleY = scale3[1];
				loader.scaleZ = scale3[2];
				loader.scale(scale);
				
				loader.mouseEnabled = true;
				loader.mouseChildren = true;
			 	
				//addToScene(loader);
				m_objList.push(loader);
			}
		}
		
		protected function onModelLoadCompleted(event:LoaderEvent):void
		{
			var i:int;
			var mesh:Mesh;
			var len:uint = (event.target as Loader3D).numChildren;
			
			//addObjectContainerToScene(event.target as ObjectContainer3D);
			game.prepareObjectContainer(event.target as ObjectContainer3D);
			
			this.addToScene(event.target as ObjectContainer3D);
			
			event.target.addEventListener(MouseEvent3D.DOUBLE_CLICK, on3DObjeMouseDown);			
		}
		
		/*private function addObjectContainerToScene(container:ObjectContainer3D):void
		{
			var i:int = 0, len:int = container.numChildren;
			for(i; i < len; i++)
			{
				var o:ObjectContainer3D = container.getChildAt(i);
				if(o is Mesh)
				{
					var mesh:Mesh = o as Mesh;
					mesh.mouseEnabled = true;
					if(mesh.material is TextureMaterial)
					{
						//TextureMaterial(mesh.material).alphaBlending = true;
						TextureMaterial(mesh.material).alphaThreshold = 0.5;
					}
					//mesh.material = m;
					mesh.material.lightPicker = game.lightPicker;
					//md.displayVertexNormals(mesh, 0x66ccff, 15000);
					//mesh.addEventListener(MouseEvent3D.MOUSE_DOWN, on3DObjeMouseDown);
					//drawWireFrame(mesh);
				}
				else
				{
					addObjectContainerToScene(o);
				}
					
			}
		}*/
		
		protected function onAssetCompleted(event:AssetEvent):void
		{
			
		}
		
		private function onDeleteButtonClick(event:MouseEvent):void
		{
			if(m_curSelectObject)
				deleteSceneObject(m_curSelectObject);
		}
		
		private function deleteSceneObject(obj:ObjectContainer3D):void
		{	
			removeFromeScene(obj);
		}
		
		private function cleanScene(event:MouseEvent = null):void
		{
			m_curSelectObject = null;
			while(m_meshList.length > 0)
			{
				var m:Mesh = m_meshList.pop();
				removeFromeScene(m)				
				m.removeEventListener(MouseEvent3D.DOUBLE_CLICK, on3DObjeMouseDown);
			}
			
			cleanLoadObject();
			
			game.cleanScene();
			
			m_cameraInfoUI.clean();
			
			CameraInfoManager.instance.clean();
			
			var i:int = 0, len:int = LightManager.instance.numLights;
			for(i; i < len; i++)
			{
				var light:LightInfo = LightManager.instance.getLightInfoByIndex(i);
				m_sceneContainer.removeItem(light.light);
			}
			LightManager.instance.clean();
		}
		
		private function cleanLoadObject():void
		{
			while(m_objList.length > 0)
			{
				var l:Loader3D = m_objList.pop();
				removeFromeScene(l);
				
				m_sceneContainer.removeItem(l);
				//m_sceneContainer.removeObject(l.name);
			}
		}
		
		private function addToScene(o:ObjectContainer3D):void
		{
			var on:String = o.name;
			if(on == "" || on == "null")
				on = o.assetType;
			m_sceneContainer.addSceneObjectItem(on, o);
			game.addObjectToScene(o);
			
			for(var i:int = 0; i < o.numChildren; i++)
			{
				var c:ObjectContainer3D = o.getChildAt(i);
				m_sceneContainer.addSceneObjectItem(c.name, c, 1);
			}
		}
		
		private function removeFromeScene(o:ObjectContainer3D):void
		{
			if(o is Loader3D)
			{
				var i:int = 0, len:int = o.numChildren;
				
				for(i; i < len; i++)
				{
					var m:Mesh = o.getChildAt(i) as Mesh;
					if(m)
					{
						//removeFromeScene(m);
						m_sceneContainer.removeItem(m);
					}	
				}
				m_sceneContainer.removeItem(o);
			}	
			else if(o is Mesh)
			{
				m_sceneContainer.removeItem(o);
			}
			else if(o is SegmentSet)
			{
				m_sceneContainer.removeItem(o);
			}
			
			/*if(scene.contains(o))
				scene.removeChild(o);*/
			if(o.parent)
				o.parent.removeChild(o);
		}
		
		private function removeWireFrame(o:ObjectContainer3D):void
		{
			// TODO Auto Generated method stub
			var s:SegmentSet;
			for(var i:int = 0; i < o.numChildren; i++)
			{					
				var c:ObjectContainer3D = o.getChildAt(i);
				if(c is SegmentSet)
				{
					if(c.name == "wireframe")
					{
						o.removeChild(c);
						SegmentSet(c).removeAllSegments();
						SegmentSet(c).dispose();
						c = null;
					}
				}
				else
				{
					removeWireFrame(c);
				}
			}
		}
		
		private function drawWireFrame(obj:ObjectContainer3D):void
		{
			if(obj is Mesh)
				drawMeshWireFrame(obj as Mesh);
			else
			{
				var i:int = 0, len:int = obj.numChildren;
				for(i; i < len; i++)
				{
					var c:ObjectContainer3D = obj.getChildAt(i);
					if(c is Mesh)
						drawMeshWireFrame(c as Mesh);
					else if(c is WireframePrimitiveBase)
						continue;
					else
						drawWireFrame(c);
				}
			}
		}
		
		
		private function drawMeshWireFrame(mesh:Mesh):void
		{
			var all:Vector.<ISubGeometry> = mesh.geometry.subGeometries;
			var g:ISubGeometry;
			var ss:SegmentSet = new SegmentSet();
			var sCount:int = 0;		
			
			data = null;
			data = new Dictionary();
			trace("start draw wirdFrame : " + getTimer());
			for(var i:int = 0; i < all.length; i++)
			{
				g = all[i];
				// index data
				var idx:int = 0;
				while(idx < g.indexData.length)
				{
					var v1:int = g.indexData[idx++];
					var v2:int = g.indexData[idx++];
					var v3:int = g.indexData[idx++];
					
					var va:Vector3D = new Vector3D(g.vertexPositionData[v1*3], g.vertexPositionData[v1*3 + 1], g.vertexPositionData[v1*3 + 2]);
					var vb:Vector3D = new Vector3D(g.vertexPositionData[v2*3], g.vertexPositionData[v2*3 + 1], g.vertexPositionData[v2*3 + 2]);
					var vc:Vector3D = new Vector3D(g.vertexPositionData[v3*3], g.vertexPositionData[v3*3 + 1], g.vertexPositionData[v3*3 + 2]);
					//va = mesh.sceneTransform.transformVector(va);
					//vb = mesh.sceneTransform.transformVector(vb);
					//vc = mesh.sceneTransform.transformVector(vc);
					
					if(!chcekLine(v1, v2))
					{
						ss.addSegment(new LineSegment(va, vb, WireFrameConst.START_COLOR, WireFrameConst.END_COLOR, WireFrameConst.THINKNESS));
						sCount++;
					}
					if(!chcekLine(v2, v3))
					{
						ss.addSegment(new LineSegment(vb, vc, WireFrameConst.START_COLOR, WireFrameConst.END_COLOR, WireFrameConst.THINKNESS));
						sCount++;
					}
					if(!chcekLine(v3, v1))
					{
						ss.addSegment(new LineSegment(vc, va, WireFrameConst.START_COLOR, WireFrameConst.END_COLOR, WireFrameConst.THINKNESS));
						sCount++;
					}
				}
			}
			ss.name = "wireframe";
			mesh.addChild(ss);
			m_segmentSetList.push(ss);
			trace("wireFrames : " + sCount);
			//this.addToScene(ss);
			
			/*var b:BitmapData =  WireframeMapGenerator.generateSolidMap(mesh, 0xff0000, 1.5, 1, 0.85);
			
			var t:TextureMaterial = new TextureMaterial(Cast.bitmapTexture(b));
				
			mesh.material = t;*/
			
			trace("end draw wirdFrame : " + getTimer());
		}
		
		private var data:Dictionary = new Dictionary();
		private function chcekLine(v1:int, v2:int):Boolean
		{				
			var isHaveLine:Boolean = false;
			
			//檢查起點
			var d:Array = data[v1] as Array;
			if(d)
			{				
				if(d.indexOf(v2) > -1)
					isHaveLine = true;
				else
				{
					d.push(v2);
				}				
			}
			else
			{
				data[v1] = [v2];				
			}
			
			// 檢查終點
			var d2:Array = data[v2] as Array;
			if(d2)
			{
				if(d2.indexOf(v1) > -1)
					isHaveLine = true;
				else
				{
					d2.push(v1);
				}	
			}
			else
			{
				data[v2] = [v1];
			}
			
			return isHaveLine;
			
			/*var t:int = v1 + v2;
			
			if(data[t])
			{
				var d:Array = data[t] as Array;
				if(d.indexOf(v1) > -1 || d.indexOf(v2) > -1)
					return true;
				else
					d.push(v1, v2);
			}
			else
			{
				var a:Array = [v1, v2];
				data[t] = a;
			}
			return false;*/
			
			
			/*if(data[v2])
			{
				var d:Array = data[v2] as Array;
				if(d.indexOf(v1) > -1)
					return true;
				else
				{
					d.push(v1);
					return false;
				}
					
			}
			else
			{
				var a:Array = [v1];
				data[v2] = a;
				return false;
			}*/
		}
		
		private var tempObj:ObjectContainer3D = null;
		private var tempDragObj:Drag3D;
		private function onObjectMenuClick(id:int):void
		{
			if(id == 0)
			{
				// move obj
				if(m_curSelectObject)
				{
					tempObj = null;
					tempObj = m_curSelectObject.clone() as ObjectContainer3D;
					//tempObj.addEventListener(MouseEvent3D.MOUSE_MOVE, onMoveObject3D, false, 0, true);
					game.addObjectToScene(tempObj);
					tempDragObj = new Drag3D(game.view, tempObj);
					tempDragObj.offsetCenter = true;
					tempDragObj.debug = true;
					if(ground)
						tempDragObj.planeObject3d = ground;
				}
			}
			else if(id == 1)
			{
				// rotete obj
				if(m_curSelectObject)
				{
					m_curSelectObject.rotationY += 45;
					setObjectInfo(m_curSelectObject);
				}
			}
			else if(id == 2)
			{
				// delete obj
				deleteSceneObject(m_curSelectObject)
				cleanItemSelect();
			}
		}
		
		protected function onMoveObject3D(event:MouseEvent3D):void
		{
			if(tempObj)
				tempObj.position = event.scenePosition;
			
		}
		
		private function showObjMenu():void
		{
			var dx:int;
			var dy:int;
			if(stage.mouseX > stage.stageWidth/2)
				dx = stage.mouseX - 50;
			else
				dx = stage.mouseX + 50;
			
			if(stage.mouseY > stage.stageHeight/2)
				dy = stage.mouseY - 50;
			else
				dy = stage.mouseY + 50;
			
			m_objMenu.x = dx;
			m_objMenu.y = dy;
			this.addChild(m_objMenu);
		}
		
		private function hideObjMenu():void
		{
			if(m_objMenu.parent)
				this.removeChild(m_objMenu);
		}
		
		public function showImageSavePanel():void
		{
			m_saveImgPanel.x = stage.mouseX;
			m_saveImgPanel.y = stage.mouseY;
			this.addChild(m_saveImgPanel);
		}
		
		public function hideImageSavePanel():void
		{
			if(m_saveImgPanel.parent)
				this.removeChild(m_saveImgPanel);
		}
	}
}