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
	import com.infy.camera.CameraInfo;
	import com.infy.camera.CameraInfoManager;
	import com.infy.constant.View3DCons;
	import com.infy.constant.WireFrameConst;
	import com.infy.event.CameraEvent;
	import com.infy.event.ObjEvent;
	import com.infy.light.LightInfo;
	import com.infy.light.LightManager;
	import com.infy.ui.CameraInfoUI;
	import com.infy.ui.Modify3DObjectUI;
	import com.infy.ui.ModifyCameraUI;
	import com.infy.ui.ModifyLightUI;
	import com.infy.ui.RoomUI;
	import com.infy.ui.TextEditorBaseUI;
	import com.infy.util.primitive.PrimitiveCreator;
	import com.infy.util.scene.SceneObjectView;
	import com.infy.util.tools.getObject3DInfo;
	import com.infy.util.zip.ZipLoader;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.controllers.ControllerBase;
	import away3d.controllers.FirstPersonController;
	import away3d.controllers.HoverController;
	import away3d.core.base.ISubGeometry;
	import away3d.debug.AwayStats;
	import away3d.debug.WireframeAxesGrid;
	import away3d.entities.Mesh;
	import away3d.entities.SegmentSet;
	import away3d.entities.Sprite3D;
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
	import away3d.loaders.parsers.Parsers;
	import away3d.materials.ColorMaterial;
	import away3d.materials.TextureMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.materials.methods.FilteredShadowMapMethod;
	import away3d.materials.methods.HardShadowMapMethod;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.LineSegment;
	import away3d.primitives.WireframeCube;
	import away3d.primitives.WireframePrimitiveBase;
	import away3d.textures.BitmapTexture;
	import away3d.utils.Cast;
	
	import fl.controls.BaseButton;
	import fl.controls.Button;
	import fl.controls.TextInput;
	import fl.events.SliderEvent;
	
	[SWF(backgroundColor="#A2A2A2", frameRate="60", quality="LOW")]
	public class Away3D_Test extends Sprite
	{
		//signature swf
		[Embed(source="/../embeds/signature.swf", symbol="Signature")]
		private var SignatureSwf:Class;
		
		//cube textures
		[Embed(source="/../embeds/trinket_diffuse.jpg")]
		public static var TrinketDiffuse:Class;
		[Embed(source="/../embeds/trinket_specular.jpg")]
		public static var TrinketSpecular:Class;
		[Embed(source="/../embeds/trinket_normal.jpg")]
		public static var TrinketNormals:Class;
		
		//sphere textures
		[Embed(source="/../embeds/beachball_diffuse.jpg")]
		public static var BeachBallDiffuse:Class;
		[Embed(source="/../embeds/beachball_specular.jpg")]
		public static var BeachBallSpecular:Class;
		
		//torus textures
		[Embed(source="/../embeds/weave_diffuse.jpg")]
		public static var WeaveDiffuse:Class;
		[Embed(source="/../embeds/weave_normal.jpg")]
		public static var WeaveNormals:Class;
		
		//plane textures
		[Embed(source="/../embeds/floor_diffuse.jpg")]
		public static var FloorDiffuse:Class;
		[Embed(source="/../embeds/floor_specular.jpg")]
		public static var FloorSpecular:Class;
		[Embed(source="/../embeds/floor_normal.jpg")]
		public static var FloorNormals:Class;
		
		//engine variables
		private var scene:Scene3D;
		private var camera:Camera3D;
		private var view:View3D;
		private var cameraController:HoverController;
		
		//signature variables
		private var Signature:Sprite;
		private var SignatureBitmap:Bitmap;
		
		//material objects
		private var planeMaterial:TextureMaterial;
		private var sphereMaterial:TextureMaterial;
		private var cubeMaterial:TextureMaterial;
		private var torusMaterial:TextureMaterial;
		
		//light objects
		private var light1:DirectionalLight;
		private var light2:DirectionalLight;
		private var lightPicker:StaticLightPicker;
		private var noShadowLightPicker:StaticLightPicker;
		
		//scene objects
		private var plane:Mesh;
		private var sphere:Mesh;
		private var cube:Mesh;
		private var torus:Mesh;
		
		//navigation variables
		private var move:Boolean = false;
		private var m_shiftKeyDown:Boolean = false;
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
		
		private var roomPath:String = "..\\assets\\room\\room01";
		private var m_loaderScale:Number = 1.0;
		private var m_axis:WireframeAxesGrid = null;
		
		private var m_pathInput:TextInput;
		private var m_roomPathInput:TextInput;
		private var roomEditorBtn:Button;
		private var wireframeBtn:Button;
		private var createLightBtn:Button;
		private var saveRoomBtn:Button;
		
		//private var billboard:Sprite3D;
		
		private var m_meshInfo:TextField;
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
		
		private var m_bLockCamera:Boolean = false;
		
		private var m_textureSprite:Sprite = new Sprite();
		
		private var m_underButtonList:Array = [];
		
		private var m_ui:RoomUI;
		
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
			initEngine();
			initUI();
			initLights();
			initMaterials();
			initObjects();
			initListeners();			
		}
		
		private function initUI():void
		{
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
			m_pathInput.text = '..\\assets\\obj\\emma\\model_mesh.obj';
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
			
			// input room config loading
			m_roomPathInput = new TextInput();
			m_roomPathInput.width = 300;			
			m_roomPathInput.height = 20;
			m_roomPathInput.text = '..\\assets\\room\\room01';
			m_roomPathInput.x = inputBtn.x + inputBtn.width + 15;
			m_roomPathInput.y = m_pathInput.y;			
			this.addChild(m_roomPathInput);
			
			var roomPathBtn:Button = new Button();
			roomPathBtn.label = "Get Room";
			roomPathBtn.x = m_roomPathInput.x + m_roomPathInput.width + 5;
			roomPathBtn.y = m_roomPathInput.y;
			roomPathBtn.addEventListener(MouseEvent.CLICK, loadRoomConfig);
			this.addChild(roomPathBtn);
			
			var browser:Button = new Button();
			browser.label = "Browse";
			browser.x = roomPathBtn.x + roomPathBtn.width + 5;
			browser.y = roomPathBtn.y;
			browser.addEventListener(MouseEvent.CLICK, onBrowserRoomConfig);			
			this.addChild(browser);
			
			// show mesh info
			m_meshInfo = new TextField();
			m_meshInfo.background = true;
			m_meshInfo.border = true;
			m_meshInfo.width = 200;
			m_meshInfo.height = 200;
			m_meshInfo.x = 10;
			m_meshInfo.y = 570;
			m_meshInfo.text = "mesh info :";
			this.addChild(m_meshInfo);
			
			// show camera info
			m_cameraInfo = new TextField();
			m_cameraInfo.background = true;
			m_cameraInfo.border = true;
			m_cameraInfo.width = 200;
			m_cameraInfo.height = 200;
			m_cameraInfo.x = 250;
			m_cameraInfo.y = 570;
			m_cameraInfo.text = "camera info :";
			this.addChild(m_cameraInfo);
			
			// show light info
			m_lightInfo = new TextField();
			m_lightInfo.background = true;
			m_lightInfo.border = true;
			m_lightInfo.width = 200;
			m_lightInfo.height = 200;
			m_lightInfo.x = 490;
			m_lightInfo.y = 570;
			m_lightInfo.text = "light info :";
			this.addChild(m_lightInfo);
			
			// scene obje contianer
			m_sceneContainer = new SceneObjectView();
			m_sceneContainer.x = 1300;
			m_sceneContainer.y = 30;
			m_sceneContainer.itemSelectCallback = onSceneItemSelect;
			this.addChild(m_sceneContainer);
			
			// camera modify ui
			m_cameraModifyUI = new ModifyCameraUI();
			m_cameraModifyUI.x = 700;
			m_cameraModifyUI.y = 550;
			m_cameraModifyUI.checkCallback = toggleCameraLocked;
			this.addChild(m_cameraModifyUI);
			m_cameraModifyUI.addEventListener(CameraEvent.CHANGE, onCameraInfoChange);
			
			// 3dObject modify UI
			m_objModifyUI = new Modify3DObjectUI();
			m_objModifyUI.x = 950;
			m_objModifyUI.y = 550;			
			m_objModifyUI.addEventListener(ObjEvent.CHANGE, on3DObjectInfoChange);
			this.addChild(m_objModifyUI);
			
			m_lightModifyUI = new ModifyLightUI("Directional Light");
			m_lightModifyUI.x = 1200;
			m_lightModifyUI.y = 550;
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
			this.addChild(m_cameraInfoUI);
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
			createLightBtn.addEventListener(MouseEvent.CLICK, createLight);			
			this.addChild(createLightBtn);
			m_underButtonList.push(createLightBtn);
			
			// save btn
			saveRoomBtn = new Button();
			saveRoomBtn.label = "Save Room";
			saveRoomBtn.addEventListener(MouseEvent.CLICK, saveRoom);
			this.addChild(saveRoomBtn);
			m_underButtonList.push(saveRoomBtn);
			
			var cleanSceneBtn:Button = new Button();
			cleanSceneBtn.label = "Clean Room";
			cleanSceneBtn.addEventListener(MouseEvent.CLICK, cleanScene);
			this.addChild(cleanSceneBtn);
			m_underButtonList.push(cleanSceneBtn);
			
			var deleteObjBtn:Button = new Button();
			deleteObjBtn.label = "Delete Obj";
			deleteObjBtn.addEventListener(MouseEvent.CLICK, onDeleteButtonClick);
			this.addChild(deleteObjBtn);
			m_underButtonList.push(deleteObjBtn);
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
			setCameraInfo(cameraController);
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
			m_bLockCamera = lock;
		}
		
		protected function onInputEnter(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			var path:String = m_pathInput.text;
			if(path == "" || path =="\n")
				return;
			
			var ta:Array = path.split(".");
			var type:String = String(ta[ta.length - 1]).toLocaleLowerCase();
			
			loadModel(path, type, [0, 0, 0], [0, 0, 0], 1);
		}
		
		private function onBrowserRoomConfig(e:MouseEvent):void
		{
			m_file = new FileReference();
			m_file.addEventListener(Event.SELECT, onRoomConfigFileSelect);
			m_file.addEventListener(Event.COMPLETE, onLoadRoomConfigComplete);
			m_file.browse([new FileFilter("RoomConfig", "*.*")]);
			
		}
		
		protected function onRoomConfigFileSelect(event:Event):void
		{
			var fileName:String = m_file.name;
						
			m_file.load();
			
		}
		
		protected function onLoadRoomConfigComplete(event:Event):void
		{
			// TODO Auto-generated method stub
			parserRoom(event.target.data.toString());
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
					/*var s:SegmentSet;
					for(var i:int = 0; i < m_curSelectObject.numChildren; i++)
					{					
						
						s = m_curSelectObject.getChildAt(i) as SegmentSet;
						
						if(s is WireframePrimitiveBase)
							continue;
						
						m_curSelectObject.removeChild(s);
						s.removeAllSegments();
						s.dispose();
						s = null;
						//s.updateImplicitVisibility();
						break;
					}*/
				}
				/*else if(m_wireframeState == 2)
				{					
					m_curSelectObject.visible = true;
					
					var s:SegmentSet = m_curSelectObject.getChildAt(m_curSelectObject.numChildren - 1) as SegmentSet;
					if(s)
					{	
						s.removeAllSegments();
						m_curSelectObject.removeChild(s);
						s.dispose();
						s = null;
					}
				}*/
				
				m_wireframeState++;
				if(m_wireframeState > 1)
					m_wireframeState = 0;
			}
		}

		private var m_lightCount:int = 0;
		private function createLight(event:MouseEvent):void
		{
			var light:LightBase = new DirectionalLight();
			DirectionalLight(light).direction = new Vector3D(0, -1, 0);
			light.ambient = 1.0;
			light.diffuse = 1.0;
			light.name = "light_" + m_lightCount;
			addToScene(light);
			
			var lights:Array = lightPicker.lights;
			lights.push(light);
			lightPicker.lights = lights;
			
			m_lightCount++;
		}
		
		private function saveRoom(event:MouseEvent):void
		{
			var i:int = 0, len:int = scene.numChildren;
			for(i; i < len; i++)
			{
				var c:ObjectContainer3D = scene.getChildAt(i);
				trace(c);
			}
		}
		/**
		 * Initialise the engine
		 */
		private function initEngine():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			scene = new Scene3D();
			
			var lens:PerspectiveLens = new PerspectiveLens();
			lens.near = 5;
			camera = new Camera3D(lens);
			camera.name = "mainCamera";
			
			view = new View3D();
			view.antiAlias = 4;
			view.scene = scene;
			view.camera = camera;
			view.backgroundColor = View3DCons.BACKGROUND_COLOR;
			view.width = View3DCons.WIDTH;
			view.height = View3DCons.HEIGHT;
			//setup controller to be used on the camera
			/*cameraController = new HoverController(camera);
			cameraController.distance = 150;
			cameraController.minTiltAngle = -15;
			cameraController.maxTiltAngle = 90;
			cameraController.panAngle = 45;
			cameraController.tiltAngle = 20;*/
			
			view.addSourceURL("srcview/index.html");
			addChild(view);
			
			addChild(new AwayStats(view));
			
			Parsers.enableAllBundled();
			
			Loader3D.enableParser(OBJParser);
			Loader3D.enableParser(DAEParser);
			Loader3D.enableParser(Max3DSParser);
		}
		
		/**
		 * Initialise the materials
		 */
		private function initMaterials():void
		{
			planeMaterial = new TextureMaterial(Cast.bitmapTexture(FloorDiffuse));
			planeMaterial.specularMap = Cast.bitmapTexture(FloorSpecular);
			planeMaterial.normalMap = Cast.bitmapTexture(FloorNormals);
			planeMaterial.lightPicker = lightPicker;
			planeMaterial.repeat = true;
			planeMaterial.mipmap = false;
			
			sphereMaterial = new TextureMaterial(Cast.bitmapTexture(BeachBallDiffuse));
			sphereMaterial.specularMap = Cast.bitmapTexture(BeachBallSpecular);
			sphereMaterial.lightPicker = lightPicker;
			
			cubeMaterial = new TextureMaterial(Cast.bitmapTexture(TrinketDiffuse));
			cubeMaterial.specularMap = Cast.bitmapTexture(TrinketSpecular);
			cubeMaterial.normalMap = Cast.bitmapTexture(TrinketNormals);
			cubeMaterial.lightPicker = lightPicker;
			cubeMaterial.mipmap = false;
			
			var weaveDiffuseTexture:BitmapTexture = Cast.bitmapTexture(WeaveDiffuse);
			torusMaterial = new TextureMaterial(weaveDiffuseTexture);
			torusMaterial.specularMap = weaveDiffuseTexture;
			torusMaterial.normalMap = Cast.bitmapTexture(WeaveNormals);
			torusMaterial.lightPicker = lightPicker;
			torusMaterial.repeat = true;
			
			_activeMaterial = new ColorMaterial( 0xFF0000 );
			_activeMaterial.lightPicker = lightPicker;
			_inactiveMaterial = new ColorMaterial( 0xCCCCCC );
			_inactiveMaterial.lightPicker = lightPicker;
			
			var tM:TextureMaterial = new TextureMaterial();
		}
		
		/**
		 * Initialise the lights
		 */
		private function initLights():void
		{
			light1 = new DirectionalLight();
			light1.direction = new Vector3D(0, -1, 0);
			light1.ambient = 1.0;
			light1.diffuse = 1.0;
			light1.name = LightInfo.MAIN_LIGHT;
			light1.castsShadows
			/*light1.castsShadows = true;
			light1.shadowMapper.depthMapSize = 2048;*/
			//addToScene(light1);
			addLight(light1);
			
			light2 = new DirectionalLight();
			light2.direction = new Vector3D(0, -1, 0);
			light2.color = 0xFFFFFF;
			light2.ambient = 0.1;
			light2.diffuse = 0.7;
			light2.name = "no_shadow_light";
			//addToScene(light2);
			addLight(light2);
			
			lightPicker = new StaticLightPicker([light1]);
			noShadowLightPicker = new StaticLightPicker([light2]);
			
			
		}
		
		private function addLight(light:LightBase):void
		{
			addToScene(light);
			var info:LightInfo = new LightInfo();
			info.name = light.name;
			info.lignt = light;
			LightManager.instance.addLight(info);
		}
		
		/**
		 * Initialise the scene objects
		 */
		private function initObjects():void
		{				
			/*var p:Mesh = new Mesh(new PlaneGeometry(1000, 1000), new ColorMaterial(0xeeffff));
			addToScene(p);*/
			
			/*billboard = new Sprite3D(planeMaterial, 50, 50);
			billboard.x = 100;			
			addToScene(billboard);*/
			
			/*var wc:WireframeCube = new WireframeCube();
			wc.color = 0x999999;
			wc.thickness = 1.5;
			wc.scaleX = 3;
			wc.scaleY = 3;
			wc.scaleZ = 3;
			addToScene(wc);*/
			
			/*var cg:Mesh = new Mesh(new CubeGeometry(), new ColorMaterial(0xff22ff));			
			cg.x = 100;
			//cg.addChild(wc);
			cg.y = 150;
			//addToScene(cg);
			cg.geometry.scale(3);*/
			
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
		
		protected function onCubeMouseDown(event:MouseEvent3D):void
		{
			cube.translateLocal(new Vector3D(0, 1, 0), 5);
			event.preventDefault();
		}
		
		protected function onMouseOut(event:MouseEvent3D):void
		{
			//event.target.material = cubeMaterial;
			event.target.material.texture = Cast.bitmapTexture(FloorDiffuse);
		}
		
		protected function onMouseOver(event:MouseEvent3D):void
		{
			//event.target.material = _activeMaterial
			event.target.material.texture = Cast.bitmapTexture(TrinketDiffuse);
		}
		
		/**
		 * Initialise the listeners
		 */
		private function initListeners():void
		{
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			this.addEventListener(MouseEvent.DOUBLE_CLICK, onMouseDobuleClick);
			stage.addEventListener(Event.RESIZE, onResize);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onStageKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onStageKeyUp);
			stage.addEventListener(MouseEvent.CLICK, stageMouseClickHandler);
			
			this.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			
			onResize();
		}
		
		
		protected function stageMouseClickHandler(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			if(!event.bubbles)
				this.stage.focus = stage;
			
			setMouseInfo();
		}
		
		protected function onMouseWheel(event:MouseEvent):void
		{	
			if(event.target is TextField) 
			{
				event.stopPropagation();
				return;
			}
			
			if(cameraController)
			{
				if(event.delta > 0) // forward
				{
					cameraController.distance += 20;
				}
				else
				{
					if(cameraController.distance > 50)
						cameraController.distance -= 20;
				}
				setCameraInfo(cameraController);
				m_cameraModifyUI.refresh();
				event.stopImmediatePropagation();
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
				m_shiftKeyDown = true;
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
						loadRoom(roomPath);
						break;						
					
					/*case Keyboard.NUMBER_9:
						testDrawWireFrame(m_meshList[0]);
						break;*/
					case Keyboard.NUMBER_1:
						var c:CameraInfo = CameraInfoManager.instance.getCameraInfo("cam01");
						setCamera(c, camera);						
						break;
					
					case Keyboard.NUMBER_2:
						var c2:CameraInfo = CameraInfoManager.instance.getCameraInfo("cam02");
						setCamera(c2, camera);
						break;
					
					case Keyboard.NUMBER_9:
						var b:BloomFilter3D = new BloomFilter3D();
						view.filters3d = [b];
						break;
					
					case Keyboard.NUMBER_0:
						view.filters3d = null;
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
					break;
				case Keyboard.NUMPAD_SUBTRACT:
					m_loaderScale = 0.5;
					m_curSelectObject.scale(m_loaderScale);
					break;	
				
				case Keyboard.ESCAPE:
					cleanItemSelect();
					break;
			}
		}
		
		protected function onStageKeyUp(event:KeyboardEvent):void
		{
			m_shiftKeyDown = event.shiftKey;			
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
			if (move && !m_bLockCamera) 
			{
				if(m_shiftKeyDown)
				{
					var dx:Number = 0.3*(stage.mouseX - lastPanX);
					var dy:Number = 0.3*(stage.mouseY - lastPanY);
					
					cameraController.lookAtPosition.x += dx;
					cameraController.lookAtPosition.y += dy;
					cameraController.update();
					lastPanX = stage.mouseX;
					lastPanY = stage.mouseY;
					lastMouseX = stage.mouseX;
					lastMouseY = stage.mouseY;
				}
				else
				{
					cameraController.panAngle = 0.3*(stage.mouseX - lastMouseX) + lastPanAngle;
					cameraController.tiltAngle = 0.3*(stage.mouseY - lastMouseY) + lastTiltAngle;					
				}
				setCameraInfo(cameraController);
				m_cameraModifyUI.refresh();
			}
			
			//light1.direction = new Vector3D(Math.sin(getTimer()/10000)*150000, 1000, Math.cos(getTimer()/10000)*150000);
			
			//cube.roll(1);
			//sphere.rotationX += 1;
			
			//loader.rotationY += 1;
			
			view.render();
		}
		
		/**
		 * Mouse down listener for navigation
		 */
		private function onMouseDown(event:MouseEvent):void
		{
			// 滑鼠在UI上點擊 不用
			if(event.target is TextField) 
				return;
			else if(event.target is BaseButton)
				return;
			
			if(cameraController)
			{
				lastPanAngle = cameraController.panAngle;
				lastTiltAngle = cameraController.tiltAngle;
				lastMouseX = stage.mouseX;
				lastMouseY = stage.mouseY;
				move = true;
				stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
				if(event.shiftKey)
				{
					lastPanX = stage.mouseX;
					lastPanY = stage.mouseY;
				}
			}			
		}
		
		/**
		 * Mouse up listener for navigation
		 */
		private function onMouseUp(event:MouseEvent):void
		{
			move = false;
			removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
		
		private function onMouseDobuleClick(event:MouseEvent):void
		{
			
		}
		
		/**
		 * Mouse stage leave listener for navigation
		 */
		private function onStageMouseLeave(event:Event):void
		{
			move = false;
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
		
		/**
		 * stage listener for resize events
		 */
		private function onResize(event:Event = null):void
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
			
			m_sceneContainer.x = stage.stageWidth - m_sceneContainer.width - 30;
			
			m_mouseInfoText.x = view.x;
			m_mouseInfoText.y = view.y - 25;
			
			var dx:int = view.x;
			for(var i:int = 0; i < m_underButtonList.length; i++)
			{
				var b:Button = m_underButtonList[i];
				b.y = view.y + view.height + 3;
				b.x = dx;
				dx += b.width + 5;
			}
		}
		
		private function setMouseInfo():void
		{
			m_mouseInfoText.text = "(" + stage.mouseX + ", " + stage.mouseY + ")";
		}
		
		private function loadRoomConfig(event:MouseEvent = null):void
		{
			var path:String = m_roomPathInput.text;
			loadRoom(path);
		}
		
		private function loadRoom(roomPath:String):void
		{
			var urlLoader:URLLoader = new URLLoader();			
			urlLoader.load(new URLRequest(roomPath));
			urlLoader.addEventListener(Event.COMPLETE, onLoadRoomComplete);			
		}
		
		protected function onLoadRoomComplete(event:Event):void
		{
			var urlLoader:URLLoader = event.target as URLLoader;
			
			parserRoom(urlLoader.data);
			m_roomEditor.data = urlLoader.data;
		}
		
		private function parserRoom(data:String):void
		{
			//var lines:Array = data.split("\r\n");
			data = data.replace(/[\r]/g, "");
			var lines:Array = data.split("\n");
			lines.shift(); // skip first line;
			for(var i:int = 0; i < lines.length; i++)
			{
				var raw:String = lines[i];0
				if(raw == "" || raw == "\n")
					continue;
				
				var args:Array = raw.split("\t");
				if(args[0] == "load")
					parserLoadCommand(args)
				else if(args[0] == "camera")
					parseCameraInfo(args);
				/*else if(args[0] == "light")
					parseLightInfo(args);
				else if(args[0] == "sound")
					parsSoundInfo(args);*/
				else
					createPrimitives(args);
			}
			
		}
		
		private function parserLoadCommand(args:Array):void
		{
			// skip first arg		
			args.shift();
			
			var path:String = args.shift();
			var pos:Array = String(args.shift()).split(",");
			var rotation:Array = String(args.shift()).split(",");
			var size:Number = args.shift();
			
			if(path != "" && path != "\n")
				loadModel(path, "obj", pos, rotation, size);
		}
		
		private function parseCameraInfo(args:Array):void
		{
			var keyword:String = args.shift() as String;
			var cam_name:String = args.shift() as String;
			var isDefault:Boolean = String(args.shift()) == "Y" ? true : false;
			var type:String = args.shift();
			var near:Number = args.shift();
			var far:Number = args.shift();
			var fov:Number = args.shift();
			var distance:Number = args.shift();
			var panAngle:Number = args.shift();
			var tiltAngle:Number = args.shift();
			var lookAt:Array = String(args.shift()).split(",");
			
			var camInfo:CameraInfo = new CameraInfo();
			camInfo.name = cam_name;
			camInfo.isDefault = isDefault;
			camInfo.near = near;
			camInfo.far = far;
			camInfo.fov = fov;
			camInfo.distance = distance;
			camInfo.panAngle = panAngle;
			camInfo.tiltAngle = tiltAngle;
			camInfo.lookAt = new Vector3D(lookAt[0], lookAt[1], lookAt[2]);
			
			CameraInfoManager.instance.addCameraInfo(camInfo.name, camInfo);
			m_cameraInfoUI.addCameraInfo(camInfo.name, camInfo);
			
			if(isDefault)
			{
				setCamera(camInfo, camera);
			}			
		}
		
		private function setCamera(info:CameraInfo, camera:Camera3D):void
		{
			cameraController = null;
			cameraController = new HoverController(camera);
			cameraController.distance = info.distance;
			cameraController.minTiltAngle = -15;
			cameraController.maxTiltAngle = 90;
			cameraController.panAngle = info.panAngle;
			cameraController.tiltAngle = info.tiltAngle;
			camera.lens.near = info.near;
			camera.lens.far = info.far;
			PerspectiveLens(camera.lens).fieldOfView = info.fov;
			HoverController(cameraController).lookAtPosition = info.lookAt;
			
			setCameraInfo(cameraController);
			m_cameraModifyUI.target = cameraController;
		}
		
		private function changeCamera(camName:String):void
		{
			var info:CameraInfo = CameraInfoManager.instance.getCameraInfo(camName);
			if(info)
				setCamera(info, camera);
		}
		
		private function onCameraUIButtonClick(btnIndex:int):void
		{
			if(btnIndex == 0) // create
			{	
				var camInfo:CameraInfo = getCurrentCamraInfo();
				var data:String = camInfo.toString();
				m_cameraInfoUI.showConfirmUI(data);
			}
			else if(btnIndex == 1) //delete
			{
				
			}
		}
		
		private function getCurrentCamraInfo():CameraInfo
		{
			var info:CameraInfo = new CameraInfo();
			info.name = "new cam";
			info.near = camera.lens.near;
			info.far = camera.lens.far;
			info.fov = PerspectiveLens(camera.lens).fieldOfView;
			info.distance = cameraController.distance;
			info.tiltAngle = cameraController.tiltAngle;
			info.panAngle = cameraController.panAngle;
			info.lookAt = cameraController.lookAtPosition;
			info.type = "P";
			info.isDefault = false;
			return info;
		}
		
		private function createPrimitives(args:Array):void
		{
			var type:String = args.shift() as String;
			if(type == "box")
				createBox(args);
			else if(type == "plane")
				createPlane(args);
			else if(type == "sphere")
				createSphere(args);
			else if(type == "model")				
				createModel(args);
		}
		
		private function createModel(args:Array):void
		{
			
		}
		
		private function createPlane(args:Array):void
		{	
			var plane:Mesh = PrimitiveCreator.createPlane(args);
			
			// make shadow????			
			/*(plane.material as ColorMaterial).shadowMethod = new FilteredShadowMapMethod(light1);
			(plane.material as ColorMaterial).shadowMethod.epsilon = 1;*/
			
			/*(plane.material as ColorMaterial).shadowMethod = new HardShadowMapMethod(light1);
			(plane.material as ColorMaterial).shadowMethod.epsilon = 1;*/
			
			m_meshList.push(plane);
			addToScene(plane);
			plane.addEventListener(MouseEvent3D.DOUBLE_CLICK, on3DObjeMouseDown);
			plane.material.lightPicker = lightPicker;
		}
		
		private function createSphere(args:Array):void
		{
			var sphere:Mesh = PrimitiveCreator.createSphere(args);
			m_meshList.push(sphere);
			addToScene(sphere);
			sphere.addEventListener(MouseEvent3D.DOUBLE_CLICK, on3DObjeMouseDown);
			sphere.material.lightPicker = lightPicker;
		}
		
		private function createBox(args:Array):void
		{	
			var box:Mesh = PrimitiveCreator.createCube(args);			
			
			//(box.material as ColorMaterial).shadowMethod = new FilteredShadowMapMethod(light1);
			//(box.material as ColorMaterial).shadowMethod.epsilon = 0.2;
			addToScene(box);
			box.addEventListener(MouseEvent3D.DOUBLE_CLICK, on3DObjeMouseDown);
			//box.material.lightPicker = noShadowLightPicker;	
			m_meshList.push(box);
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
			var text:String = "";
			
			if(o)
			{
				text = "Object Info :\nname : " + o.name + 
					   "\ntype : " + o.assetType +
					   "\npos : " + o.position.toString() + 
					   "\n sPos : " + o.scenePosition.toString() +
					   "\nrot : " + o.eulers.toString() +
					   "\nscale : " + o.scaleX + ", " + o.scaleY + ", " + o.scaleZ +
					   "\nclas : " + getQualifiedClassName(o) +
					   "\ntriangles : " + getObject3DInfo.getFaceCounts(o) + 
					   "\nvertices : " + getObject3DInfo.getVertexCounts(o) +
					   "\nbounds size : " + (o.maxX - o.minX).toFixed(2) + ", " + (o.maxY - o.minY).toFixed(2) + ", " + (o.maxZ - o.minZ).toFixed(2)
						;
					   
			}
			
			m_meshInfo.text = text;
		}
		
		private function setCameraInfo(controller:ControllerBase):void
		{
			var text:String = "";
			var camera:Camera3D = controller.targetObject as Camera3D;
			
			if(controller is HoverController)
			{
				var lookAt:Vector3D = HoverController(controller).lookAtPosition;
				text = "HoverController\nname : " + camera.name +
					   "\n" + camera.lens.toString() +
					   "\npos : " + camera.position.x.toFixed(2) + ", " + camera.position.y.toFixed(2) + ", " + camera.position.y.toFixed(2) +
					   "\nnear : " + camera.lens.near + 
					   "\nfar : " + camera.lens.far +
					   "\nfov : " + PerspectiveLens(camera.lens).fieldOfView + 
					   "\nfocalLength :  " + PerspectiveLens(camera.lens).focalLength +
					   "\ndistance :" + HoverController(controller).distance +
					   "\npanAngle : " + HoverController(controller).panAngle.toFixed(2) + " (" +  HoverController(controller).minPanAngle + ", " + HoverController(controller).maxPanAngle + ")" +
					   "\ntiltAngle : " + HoverController(controller).tiltAngle.toFixed(2) + " (" +  HoverController(controller).minTiltAngle + ", " + HoverController(controller).maxTiltAngle + ")" +
					   "\nlookAt : " + lookAt.x.toFixed(2) + ", " + lookAt.y.toFixed(2) + ", " + lookAt.z.toFixed(2) +
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
		
		private function loadModel(path:String, type:String, pos3:Array, rot3:Array, scale:Number):void
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
			
			addObjectContainerToScene(event.target as ObjectContainer3D);
			
			this.addToScene(event.target as ObjectContainer3D);
			
			event.target.addEventListener(MouseEvent3D.DOUBLE_CLICK, on3DObjeMouseDown);			
		}
		
		private function addObjectContainerToScene(container:ObjectContainer3D):void
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
					mesh.material.lightPicker = lightPicker;
					//md.displayVertexNormals(mesh, 0x66ccff, 15000);
					//mesh.addEventListener(MouseEvent3D.MOUSE_DOWN, on3DObjeMouseDown);
					//drawWireFrame(mesh);
				}
				else
				{
					addObjectContainerToScene(o);
				}
					
			}
		}
		
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
			/*if(mesh && scene.contains(mesh))
			{
				removeFromeScene(mesh);
				var idx:int = m_meshList.indexOf(mesh);
				m_meshList.splice(idx, 1);
			}
			mesh = null;*/
			
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
		}
		
		private function cleanLoadObject():void
		{
			while(m_objList.length > 0)
			{
				var l:Loader3D = m_objList.pop();
				removeFromeScene(l);
				
				m_sceneContainer.removeObject(l.name);
			}
		}
		
		private function addToScene(o:ObjectContainer3D):void
		{
			var on:String = o.name;
			if(on == "" || on == "null")
				on = o.assetType;
			m_sceneContainer.addObject(on, o);
			this.scene.addChild(o);
			
			for(var i:int = 0; i < o.numChildren; i++)
			{
				var c:ObjectContainer3D = o.getChildAt(i);
				m_sceneContainer.addObject(c.name, c, 1);
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
						removeFromeScene(m);
					}	
				}
				m_sceneContainer.removeObject(o);
			}	
			else if(o is Mesh)
			{
				m_sceneContainer.removeObject(o);
			}
			
			if(scene.contains(o))
				scene.removeChild(o);
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
		
		private function removeMeshWireFrame(m:Mesh):void
		{
			
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
	}
}