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
	import away3d.cameras.*;
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.*;
	import away3d.controllers.*;
	import away3d.core.base.ISubGeometry;
	import away3d.core.base.SubMesh;
	import away3d.core.math.Vector3DUtils;
	import away3d.core.pick.PickingColliderType;
	import away3d.debug.*;
	import away3d.entities.*;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.events.MouseEvent3D;
	import away3d.library.assets.NamedAssetBase;
	import away3d.lights.*;
	import away3d.loaders.Loader3D;
	import away3d.loaders.parsers.DAEParser;
	import away3d.loaders.parsers.Max3DSParser;
	import away3d.loaders.parsers.OBJParser;
	import away3d.loaders.parsers.ParserBase;
	import away3d.loaders.parsers.Parsers;
	import away3d.materials.*;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.materials.utils.WireframeMapGenerator;
	import away3d.primitives.*;
	import away3d.primitives.data.Segment;
	import away3d.textures.BitmapTexture;
	import away3d.tools.helpers.data.MeshDebug;
	import away3d.utils.*;
	
	import com.infy.constant.View3DCons;
	import com.infy.constant.WireFrameConst;
	import com.infy.util.btn.DefaultBtn;
	import com.infy.util.obj.ObjEditor;
	import com.infy.util.primitive.PrimitiveCreator;
	import com.infy.util.scene.SceneObjectView;
	import com.infy.util.tools.getObject3DInfo;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	import flash.utils.*;
	
	import mx.utils.ObjectProxy;
	
	[SWF(backgroundColor="#dfe3e4", frameRate="60", quality="LOW")]
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
		
		//scene objects
		private var plane:Mesh;
		private var sphere:Mesh;
		private var cube:Mesh;
		private var torus:Mesh;
		
		//navigation variables
		private var move:Boolean = false;
		private var lastPanAngle:Number;
		private var lastTiltAngle:Number;
		private var lastMouseX:Number;
		private var lastMouseY:Number;
		
		private var _inactiveMaterial:ColorMaterial;
		private var _activeMaterial:ColorMaterial;

		private var m_curSelectObject:ObjectContainer3D = null;
		private var m_meshList:Vector.<Mesh> = new Vector.<Mesh>();
		
		private var m_objList:Vector.<Loader3D> = new Vector.<Loader3D>();
		
		private var m_segmentSetList:Vector.<SegmentSet> = new Vector.<SegmentSet>();
		
		private var roomPath:String = "..\\assets\\room\\room01";
		private var m_loaderScale:Number = 1.0;
		private var m_axis:WireframeAxesGrid = null;
		
		private var m_pathInput:TextField;
		private var m_roomPathInput:TextField;
		
		private var billboard:Sprite3D;
		
		private var m_meshInfo:TextField;
		private var m_cameraInfo:TextField;		
		private var m_lightInfo:TextField;
		
		private var m_sceneContainer:SceneObjectView;
		
		
		/**
		 * Constructor
		 */
		public function Away3D_Test()
		{
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
			
						
			//loadRoom(roomPath);
			
			//loadModel("..\\assets\\obj\\bear2\\bear001.obj");
			//loadModel("..\\assets\\obj\\doll\\doll.obj");		
			//loadModel("..\\assets\\obj\\cube\\Cube1.obj");
			//loadModel("..\\assets\\obj\\cube\\unityCube1.obj");
			//loadModel("..\\assets\\obj\\desktop\\ModernDeskOBJ.obj");
			//loadModel("..\\assets\\obj\\cube\\room.obj");
			//loadModel("..\\assets\\obj\\cube\\cubemaya.obj");
			//loadModel("..\\assets\\obj\\pumpkin\\model_mesh.obj");
			//loadModel("..\\assets\\obj\\room\\room.dae");
			//loadModel("..\\assets\\obj\\drone\\drone_dead_orbit_LP.obj");
			//loadModel("..\\assets\\dae\\hrncek1\\hrncek.dae");
			//loadModel("..\\assets\\obj\\bear\\Model.obj");
			//loadModel("..\\assets\\obj\\2room\\710-2人房.obj");
			//loadModel("..\\assets\\obj\\tt1\\mesh.obj");
		}
		
		private function initUI():void
		{
			/*var ui:WebDesignUI = new WebDesignUI();
			ui.curStep = 1;
			this.addChild(ui);*/
			
			var oe:ObjEditor = new ObjEditor();
			this.addChild(oe);
			oe.x = 10;
			oe.y = 100;
			
			oe.callback = onCreateObject;
			
			m_pathInput = new TextField();
			m_pathInput.type = TextFieldType.INPUT;
			//m_pathInput.autoSize = TextFieldAutoSize.LEFT;			
			m_pathInput.width = 300;			
			m_pathInput.height = 20;
			m_pathInput.text = '..\\assets\\obj\\bear2\\bear001.obj';
			m_pathInput.x = 200;
			m_pathInput.y = 10;
			m_pathInput.border = true;
			m_pathInput.background = true;
			m_pathInput.backgroundColor = 0x98dfca;			
			this.addChild(m_pathInput);
			
			var inputButton:DefaultBtn = new DefaultBtn("Enter", onInputEnter);
			inputButton.x = m_pathInput.x + m_pathInput.width + 10;
			inputButton.y = 10;
			this.addChild(inputButton);
			
			var wireframeBtn:DefaultBtn = new DefaultBtn("wireFrame", toggleWireFrame);
			wireframeBtn.x = inputButton.x + inputButton.width + 5;
			wireframeBtn.y = 10;
			this.addChild(wireframeBtn);
			
			m_roomPathInput = new TextField();
			m_roomPathInput.type = TextFieldType.INPUT;
			//m_roomPathInput.autoSize = TextFieldAutoSize.LEFT;			
			m_roomPathInput.width = 300;			
			m_roomPathInput.height = 20;
			m_roomPathInput.text = '..\\assets\\room\\room01';
			m_roomPathInput.x = 200;
			m_roomPathInput.y = 33;
			m_roomPathInput.border = true;
			m_roomPathInput.background = true;
			m_roomPathInput.backgroundColor = 0x98dfca;			
			this.addChild(m_roomPathInput);
			
			var roomPathBtn:DefaultBtn = new DefaultBtn("get room", loadRoomConfig);
			roomPathBtn.x = m_roomPathInput.x + m_roomPathInput.width + 5;
			roomPathBtn.y = 33;
			this.addChild(roomPathBtn);
			
			m_meshInfo = new TextField();
			m_meshInfo.background = true;
			m_meshInfo.border = true;
			m_meshInfo.width = 200;
			m_meshInfo.height = 200;
			m_meshInfo.x = 10;
			m_meshInfo.y = 570;
			m_meshInfo.text = "mesh info :";
			this.addChild(m_meshInfo);
			
			m_cameraInfo = new TextField();
			m_cameraInfo.background = true;
			m_cameraInfo.border = true;
			m_cameraInfo.width = 200;
			m_cameraInfo.height = 200;
			m_cameraInfo.x = 250;
			m_cameraInfo.y = 570;
			m_cameraInfo.text = "camera info :";
			this.addChild(m_cameraInfo);
			
			m_lightInfo = new TextField();
			m_lightInfo.background = true;
			m_lightInfo.border = true;
			m_lightInfo.width = 200;
			m_lightInfo.height = 200;
			m_lightInfo.x = 490;
			m_lightInfo.y = 570;
			m_lightInfo.text = "light info :";
			this.addChild(m_lightInfo);
			
			m_sceneContainer = new SceneObjectView();
			m_sceneContainer.x = 1300;
			m_sceneContainer.y = 30;
			m_sceneContainer.itemSelectCallback = onSceneItemSelect;
			this.addChild(m_sceneContainer);
		}
		
		protected function onInputEnter():void
		{
			// TODO Auto-generated method stub
			var path:String = m_pathInput.text;
			if(path == "" || path =="\n")
				return;
				
			loadModel(path, "obj", [0, 0, 0], [0, 0, 0], 1);
		}
		
		private var m_wireframeState:int = 0;
		private function toggleWireFrame():void
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
			light1.name = "light_dir_1";
			addToScene(light1);
			
			light2 = new DirectionalLight();
			light2.direction = new Vector3D(0, -1, 0);
			light2.color = 0xFFFFFF;
			light2.ambient = 0.1;
			light2.diffuse = 0.7;
			light2.name = "light_dir_2";
			addToScene(light2);
			
			lightPicker = new StaticLightPicker([light1, light2]);
		}
		
		/**
		 * Initialise the scene objects
		 */
		private function initObjects():void
		{				
			/*var p:Mesh = new Mesh(new PlaneGeometry(1000, 1000), new ColorMaterial(0xeeffff));
			addToScene(p);*/
			
			billboard = new Sprite3D(planeMaterial, 50, 50);
			billboard.x = 100;			
			addToScene(billboard);
			
			var wc:WireframeCube = new WireframeCube();
			wc.color = 0x999999;
			wc.thickness = 1.5;
			wc.scaleX = 3;
			wc.scaleY = 3;
			wc.scaleZ = 3;
			//addToScene(wc);
			
			var cg:Mesh = new Mesh(new CubeGeometry(), new ColorMaterial(0xff22ff));			
			cg.x = 100;
			//cg.addChild(wc);
			cg.y = 150;
			//addToScene(cg);
			cg.geometry.scale(3);
			
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
			// TODO Auto-generated method stub
			//event.target.material = cubeMaterial;
			event.target.material.texture = Cast.bitmapTexture(FloorDiffuse);
		}
		
		protected function onMouseOver(event:MouseEvent3D):void
		{
			// TODO Auto-generated method stub
			//event.target.material = _activeMaterial
			event.target.material.texture = Cast.bitmapTexture(TrinketDiffuse);
			//trace("onMouseOver : " + event.target.name);
		}
		
		/**
		 * Initialise the listeners
		 */
		private function initListeners():void
		{
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.addEventListener(Event.RESIZE, onResize);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onStageKeyDown);
			
			this.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			
			onResize();
		}
		
		protected function onMouseWheel(event:MouseEvent):void
		{	
			if(event.delta > 0) // forward
			{
				cameraController.distance += 50;
			}
			else
			{
				if(cameraController.distance > 50)
					cameraController.distance -= 50;
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
						cameraController = new HoverController(camera);
						cameraController.distance = 150;
						cameraController.minTiltAngle = -15;
						cameraController.maxTiltAngle = 90;
						cameraController.panAngle = 45;
						cameraController.tiltAngle = 20;
						break;
					
					case Keyboard.C:
						setCameraInfo(cameraController);
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
		
		private function toggleAxisShow():void
		{
			if(m_axis == null)
				m_axis = new WireframeAxesGrid();
			
			if(m_axis.parent == null)
				addToScene(m_axis);
			else
				scene.removeChild(m_axis);
		}
		
		/**
		 * Navigation and render loop
		 */
		private function onEnterFrame(event:Event):void
		{
			if (move) {
				cameraController.panAngle = 0.3*(stage.mouseX - lastMouseX) + lastPanAngle;
				cameraController.tiltAngle = 0.3*(stage.mouseY - lastMouseY) + lastTiltAngle;
			}
			
			light1.direction = new Vector3D(Math.sin(getTimer()/10000)*150000, 1000, Math.cos(getTimer()/10000)*150000);
			
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
			if(event.target is TextField)
				return;
			
			if(cameraController)
			{
				lastPanAngle = cameraController.panAngle;
				lastTiltAngle = cameraController.tiltAngle;
				lastMouseX = stage.mouseX;
				lastMouseY = stage.mouseY;
				move = true;
				stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);	
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
			
		}
		
		private function loadRoomConfig():void
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
		}
		
		private function parserRoom(data:String):void
		{
			var lines:Array = data.split("\r\n");
			lines.shift(); // skip first line;
			for(var i:int = 0; i < lines.length; i++)
			{
				var raw:String = lines[i];
				if(raw == "" || raw == "\n")
					continue;
				
				var args:Array = raw.split("\t");
				if(args[0] == "load")
					parserLoadCommand(args)
				else if(args[0] == "cam")
					setCamera(args);
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
		
		private function setCamera(args:Array):void
		{
			
		}
		
		private function createPrimitives(args:Array):void
		{
			var type:String = args.shift() as String;
			if(type == "box")
				createBox(args);
			else if(type == "plane")
				createPlane(args);
			else if(type == "model")				
				createModel(args);
		}
		
		private function createModel(args:Array):void
		{
			// TODO Auto Generated method stub
			
		}
		
		private function createPlane(args:Array):void
		{	
			var plane:Mesh = PrimitiveCreator.createPlane(args);
			m_meshList.push(plane);
			addToScene(plane);
			plane.addEventListener(MouseEvent3D.MOUSE_DOWN, on3DObjeMouseDown);
			plane.material.lightPicker = lightPicker;
		}
		
		private function createBox(args:Array):void
		{	
			var box:Mesh = PrimitiveCreator.createCube(args);
			addToScene(box);
			box.addEventListener(MouseEvent3D.MOUSE_DOWN, on3DObjeMouseDown);
			box.material.lightPicker = lightPicker;	
			m_meshList.push(box);
		}
		
		private function onSceneItemSelect(o:ObjectContainer3D):void
		{
			if(m_curSelectObject)
			{
				if(m_curSelectObject == o)
					return;
				
				hideBoundBox(m_curSelectObject);				
				m_curSelectObject = null;
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
			billboard.material = m.material;
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
					   "\ntriangles : " + getObject3DInfo.getFaceCounts(o)
					   "\nvertices : " + getObject3DInfo.getVertexCounts(o);
			}
			
			m_meshInfo.text = text;	
		}
		
		private function setCameraInfo(controller:ControllerBase):void
		{
			var text:String = "";
			var camera:Camera3D = controller.targetObject as Camera3D;
			
			if(controller is HoverController)
			{
				text = "HoverController\nname : " + camera.name +
					   "\n" + camera.frustumPlanes.toString();
					
			}
			else if(controller is FirstPersonController)
			{
				
			}
			
			trace(text);
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
		
		private function onCreateObject(data:String, type:String = "obj"):void
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
			l.loadData(data, null, null, p);
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
		
		
		private function loadModel(path:String, type:String, pos3:Array, rot3:Array, scale:Number):void
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
		
		protected function onModelLoadCompleted(event:LoaderEvent):void
		{
			//var m:ColorMaterial = new ColorMaterial(0xffffa5);
			//m.ambient = 0.5;
			//m.diffuseLightSources = 0.15;
			//m.specular = 0.75;
			//m.specularColor = 0xff0000;
			
			//var md:MeshDebug = new MeshDebug();
			
			var i:int;
			var mesh:Mesh;
			var len:uint = (event.target as Loader3D).numChildren;
			
			addObjectContainerToScene(event.target as ObjectContainer3D);
			
			this.addToScene(event.target as ObjectContainer3D);
			
			event.target.addEventListener(MouseEvent3D.MOUSE_DOWN, on3DObjeMouseDown);
			
			/*for(i = 0; i < len; i++)
			{
				mesh = (event.target as Loader3D).getChildAt(i) as Mesh;
				mesh.mouseEnabled = true;
				if(mesh.material is TextureMaterial)
				{
					//TextureMaterial(mesh.material).alphaBlending = true;
					TextureMaterial(mesh.material).alphaThreshold = 0.5;
				}
				//mesh.material = m;
				mesh.material.lightPicker = lightPicker;
				//md.displayVertexNormals(mesh, 0x66ccff, 15000);
				mesh.addEventListener(MouseEvent3D.MOUSE_DOWN, on3DObjeMouseDown);
				//drawWireFrame(mesh);				
			}*/
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
		
		private function deleteSceneObject(obj:ObjectContainer3D):void
		{
			/*if(mesh && scene.contains(mesh))
			{
				scene.removeChild(mesh);
				var idx:int = m_meshList.indexOf(mesh);
				m_meshList.splice(idx, 1);
			}
			mesh = null;*/
		}
		
		private function cleanScene():void
		{
			m_curSelectObject = null;
			while(m_meshList.length > 0)
			{
				var m:Mesh = m_meshList.pop();
				scene.removeChild(m);
				m.removeEventListener(MouseEvent3D.MOUSE_DOWN, on3DObjeMouseDown);
			}
			
			cleanLoadObject();
		}
		
		private function cleanLoadObject():void
		{
			while(m_objList.length > 0)
			{
				var l:Loader3D = m_objList.pop();
				scene.removeChild(l);
				
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
					
					ss.addSegment(new LineSegment(va, vb, WireFrameConst.START_COLOR, WireFrameConst.END_COLOR, WireFrameConst.THINKNESS));					
					ss.addSegment(new LineSegment(vb, vc, WireFrameConst.START_COLOR, WireFrameConst.END_COLOR, WireFrameConst.THINKNESS));
					ss.addSegment(new LineSegment(vc, va, WireFrameConst.START_COLOR, WireFrameConst.END_COLOR, WireFrameConst.THINKNESS));					
				}
			}
			ss.name = "wireframe";
			mesh.addChild(ss);
			m_segmentSetList.push(ss);
			//this.addToScene(ss);
			
			/*var b:BitmapData =  WireframeMapGenerator.generateSolidMap(mesh, 0xff0000, 1.5, 1, 0.85);
			
			var t:TextureMaterial = new TextureMaterial(Cast.bitmapTexture(b));
				
			mesh.material = t;*/
		}
		
		private var _idx:int = 0;
		private function testDrawWireFrame(mesh:Mesh):void
		{
			var all:Vector.<ISubGeometry> = mesh.geometry.subGeometries;
			var g:ISubGeometry = all[0];
			var ss:SegmentSet = new SegmentSet();
			
			var v1:int = g.indexData[_idx++];
			var v2:int = g.indexData[_idx++];
			var v3:int = g.indexData[_idx++];
			
			var va:Vector3D = new Vector3D(g.vertexPositionData[v1*3], g.vertexPositionData[v1*3 + 1], g.vertexPositionData[v1*3 + 2]);
			var vb:Vector3D = new Vector3D(g.vertexPositionData[v2*3], g.vertexPositionData[v2*3 + 1], g.vertexPositionData[v2*3 + 2]);
			var vc:Vector3D = new Vector3D(g.vertexPositionData[v3*3], g.vertexPositionData[v3*3 + 1], g.vertexPositionData[v3*3 + 2]);
			
			//va = mesh.sceneTransform.transformVector(va);
			//vb = mesh.sceneTransform.transformVector(vb);
			//vc = mesh.sceneTransform.transformVector(vc);
			
			ss.addSegment(new LineSegment(va, vb, 0xff0000, 0xff0000, 2));						
			ss.addSegment(new LineSegment(vb, vc, 0xff0000, 0xff0000, 2));
			ss.addSegment(new LineSegment(vc, va, 0xff0000, 0xff0000, 2));	
			
			mesh.addChild(ss);			
		}	
	}
}