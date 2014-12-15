package com.infy.parser
{
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.ObjectContainer3D;
	import away3d.controllers.HoverController;
	import away3d.entities.Mesh;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.loaders.Loader3D;
	import away3d.loaders.misc.AssetLoaderContext;
	import away3d.loaders.parsers.DAEParser;
	import away3d.loaders.parsers.Max3DSParser;
	import away3d.loaders.parsers.OBJParser;
	import away3d.loaders.parsers.ParserBase;
	
	import com.infy.camera.CameraInfo;
	import com.infy.camera.CameraInfoManager;
	import com.infy.event.RoomEvent;
	import com.infy.game.RoomGame;
	import com.infy.path.GamePath;
	import com.infy.util.primitive.PrimitiveCreator;
	import com.infy.util.primitive.PrimitiveInfo;
	import com.infy.util.zip.ZipLoader;
	
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import mx.utils.object_proxy;

	public class RoomConfigParser
	{
		private var m_game:RoomGame = null;
		
		public function RoomConfigParser(game:RoomGame)
		{
			m_game = game;
		}
		
		public function loadRoomSetting(roomID:String):void
		{
			// get room config
			var path:String = GamePath.ROOM_SETTING_PATH + roomID;
			
			var urlLoader:URLLoader = new URLLoader();			
			urlLoader.load(new URLRequest(path));
			urlLoader.addEventListener(Event.COMPLETE, onLoadRoomComplete);
		}
		
		protected function onLoadRoomComplete(event:Event):void
		{
			var urlLoader:URLLoader = event.target as URLLoader;
			
			parserRoom(urlLoader.data);
			
		}
		
		private function parserRoom(data:String):void
		{
			data = data.replace(/[\r]/g, "");
			var lines:Array = data.split("\n");
			//lines.shift(); // skip first line;
			for(var i:int = 0; i < lines.length; i++)
			{
				var raw:String = lines[i];
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
				loadModel(path, "obj", pos, rotation, size, [1, 1, 1]);
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
			//m_cameraInfoUI.addCameraInfo(camInfo.name, camInfo);
			
			if(isDefault)
			{
				setCamera(camInfo, m_game.camera);
			}			
		}
		
		private function setCamera(info:CameraInfo, camera:Camera3D):void
		{
			m_game.cameraController = null;
			m_game.cameraController = new HoverController(camera);
			m_game.cameraController.distance = info.distance;
			m_game.cameraController.minTiltAngle = -15;
			m_game.cameraController.maxTiltAngle = 90;
			m_game.cameraController.panAngle = info.panAngle;
			m_game.cameraController.tiltAngle = info.tiltAngle;
			camera.lens.near = info.near;
			camera.lens.far = info.far;
			PerspectiveLens(camera.lens).fieldOfView = info.fov;
			HoverController(m_game.cameraController).lookAtPosition = info.lookAt.clone();
			
			//setCameraInfo(cameraController);
			//m_cameraModifyUI.target = cameraController;
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
			var info:PrimitiveInfo = new PrimitiveInfo();
			info.parser(args);
			
			var path:String = GamePath.ASSET_MODEL_PATH + info.type + "/" + info.name  +"/" + info.name + "." + info.type;
			
			var pos3:Array = [info.pos.x, info.pos.y, info.pos.z];
			var rot3:Array = [info.rotation.x, info.rotation.y, info.rotation.z];
			var s3:Array = [info.size.x, info.size.y, info.size.z];
			loadModel(path, info.type, pos3, rot3, 1, s3);
		}
		
		private function createPlane(args:Array):void
		{	
			var plane:Mesh = PrimitiveCreator.createPlane(args);
			
			// make shadow????			
			/*(plane.material as ColorMaterial).shadowMethod = new FilteredShadowMapMethod(light1);
			(plane.material as ColorMaterial).shadowMethod.epsilon = 1;*/
			
			/*(plane.material as ColorMaterial).shadowMethod = new HardShadowMapMethod(light1);
			(plane.material as ColorMaterial).shadowMethod.epsilon = 1;*/
			
			//m_meshList.push(plane);
			m_game.addObjectToScene(plane);
			//plane.addEventListener(MouseEvent3D.DOUBLE_CLICK, on3DObjeMouseDown);
			plane.material.lightPicker = m_game.lightPicker;
			
			var event:RoomEvent = new RoomEvent(RoomEvent.CREATE_OBJECT);
			event.target = plane;
			event.objType = "plane";
			m_game.dispatchEvent(event);
		}
		
		private function createSphere(args:Array):void
		{
			var sphere:Mesh = PrimitiveCreator.createSphere(args);
			//m_meshList.push(sphere);
			m_game.addObjectToScene(sphere);
			//sphere.addEventListener(MouseEvent3D.DOUBLE_CLICK, on3DObjeMouseDown);
			sphere.material.lightPicker = m_game.lightPicker;
			
			var event:RoomEvent = new RoomEvent(RoomEvent.CREATE_OBJECT);
			event.target = sphere;
			event.objType = "sphere";
			m_game.dispatchEvent(event);
		}
		
		private function createBox(args:Array):void
		{	
			var box:Mesh = PrimitiveCreator.createCube(args);			
			
			//(box.material as ColorMaterial).shadowMethod = new FilteredShadowMapMethod(light1);
			//(box.material as ColorMaterial).shadowMethod.epsilon = 0.2;
			m_game.addObjectToScene(box);
			//box.addEventListener(MouseEvent3D.DOUBLE_CLICK, on3DObjeMouseDown);
			box.material.lightPicker = m_game.lightPicker;	
			//m_meshList.push(box);
			
			var event:RoomEvent = new RoomEvent(RoomEvent.CREATE_OBJECT);
			event.target = box;
			event.objType = "box";
			m_game.dispatchEvent(event);
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
		
		private function loadZipOBJComplete(fileName:String, data:ByteArray, path:String):void
		{
			var a:Array = path.split("\\");
			a.pop();
			var p:String = a.join("\\");
			onCreateObject(data.toString(), fileName.split(".").pop(), p);
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
			m_game.addObjectToScene(l);
			
			m_objList.push(l);
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
		
		protected function onAssetCompleted(event:AssetEvent):void
		{
			
		}
		
		protected function onModelLoadCompleted(event:LoaderEvent):void
		{
			var i:int;
			var mesh:Mesh;
			var len:uint = (event.target as Loader3D).numChildren;
			
			//addObjectContainerToScene(event.target as ObjectContainer3D);
			
			m_game.addObjectToScene(event.target as ObjectContainer3D);
			
			//event.target.addEventListener(MouseEvent3D.DOUBLE_CLICK, on3DObjeMouseDown);
			
			var roomEvent:RoomEvent = new RoomEvent(RoomEvent.CREATE_OBJECT);
			roomEvent.objType = "load_model";
			roomEvent.target = event.target;
			m_game.dispatchEvent(roomEvent);			
		}
	}
}