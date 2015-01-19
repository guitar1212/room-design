package com.infy.parser
{
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.library.AssetLibrary;
	import away3d.library.assets.IAsset;
	import away3d.loaders.Loader3D;
	import away3d.loaders.misc.AssetLoaderContext;
	import away3d.loaders.parsers.DAEParser;
	import away3d.loaders.parsers.Max3DSParser;
	import away3d.loaders.parsers.OBJParser;
	import away3d.loaders.parsers.ParserBase;
	import away3d.materials.ColorMaterial;
	import away3d.materials.methods.CelDiffuseMethod;
	import away3d.materials.methods.CelSpecularMethod;
	import away3d.materials.methods.OutlineMethod;
	
	import com.infy.camera.CameraInfo;
	import com.infy.camera.CameraInfoManager;
	import com.infy.editor.editor2droom.event.Editor2DEvent;
	import com.infy.event.RoomEvent;
	import com.infy.game.GameBase;
	import com.infy.parser.command.CameraParserCommand;
	import com.infy.parser.command.IParserCommand;
	import com.infy.parser.command.LightParserCommand;
	import com.infy.parser.command.LoadParserCommand;
	import com.infy.parser.command.ParserCommandBase;
	import com.infy.parser.command.ParserCommandType;
	import com.infy.parser.command.PrimitiveParserCommand;
	import com.infy.path.GamePath;
	import com.infy.util.primitive.PrimitiveCreator;
	import com.infy.util.primitive.PrimitiveInfo;
	import com.infy.util.zip.ZipLoader;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Vector3D;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	public class RoomConfigParser
	{
		private var m_game:GameBase = null;
		
		private var m_editor2DRoom:EventDispatcher;
		
		private var m_loadCommand:Vector.<LoadParserCommand> = new Vector.<LoadParserCommand>();
		private var m_loadCount:int = 0;
		
		private var m_cameraCommand:Vector.<CameraParserCommand> = new Vector.<CameraParserCommand>();		
		
		private var m_primitiveCommand:Vector.<PrimitiveParserCommand> = new Vector.<PrimitiveParserCommand>();
		
		private var m_lightCommand:Vector.<LightParserCommand> = new Vector.<LightParserCommand>();
		
		public var useToonshadingForModel:Boolean = true;
		
		public function RoomConfigParser(game:GameBase, editor2D:EventDispatcher)
		{
			m_game = game;
			m_editor2DRoom = editor2D; 
		}
		
		public function loadRoomSetting(roomID:String):void
		{
			// get room config
			var path:String = GamePath.ROOM_SETTING_PATH + roomID;
			
			loadRoomSettingWithPaht(path);
		}
		
		public function loadRoomSettingWithPaht(path:String):void
		{
			var urlLoader:URLLoader = new URLLoader();			
			urlLoader.load(new URLRequest(path));
			urlLoader.addEventListener(Event.COMPLETE, onLoadRoomComplete);	
		}
		
		protected function onLoadRoomComplete(event:Event):void
		{
			var urlLoader:URLLoader = event.target as URLLoader;
			
			parserRoomConfig(urlLoader.data);
		}
		
		public function parserRoomConfig(data:String):void
		{
			perpareCommand(data);
			
			excuteLightCommand();
			excuteLoadCommand();
		}
		
		public function cleanParserCommand():void
		{
			m_loadCommand.length = 0;
			m_loadCount = 0;
			m_cameraCommand.length = 0;
			m_primitiveCommand.length = 0;
			m_lightCommand.length = 0;
		}
		
		public function addCommand(type:String, cmd:ParserCommandBase):void
		{
			if(type == ParserCommandType.CAMERA)
				m_cameraCommand.push(cmd);
			else if(type == ParserCommandType.LIGHT)
				m_lightCommand.push(cmd);
			else if(type == "privimitive")
				m_primitiveCommand.push(cmd);
			else if(type == ParserCommandType.MODEL)
				m_loadCommand.push(cmd);
		}
		
		private function perpareCommand(data:String):void
		{
			cleanParserCommand();
			
			data = data.replace(/[\r]/g, "");
			var lines:Array = data.split("\n");
			
			for(var i:int = 0; i < lines.length; i++)
			{
				var raw:String = lines[i];
				if(raw == "" || raw == "\n")
					continue;
				
				var args:Array = raw.split("\t");
				var cmd:String = args[0];				
				
				if(cmd == "load")
				{
					m_loadCommand.push(args);
				}
				else if(cmd == "camera")
				{
					m_cameraCommand.push(new CameraParserCommand(m_game, args));
				}
				else if(cmd == "light")
				{
					m_lightCommand.push(new LightParserCommand(m_game, args));
				}
				else if(cmd == "sound")
				{
				}
				else if(cmd == ParserCommandType.MODEL)
				{
					var loadCmd:LoadParserCommand = new LoadParserCommand(m_game, args);
					loadCmd.excuteMethod = loadObjModel;
					m_loadCommand.push(loadCmd);
				}
				else if(cmd == ParserCommandType.BOX || cmd == ParserCommandType.PLANE || cmd == ParserCommandType.SPHERE)
				{
					var primiCmd:PrimitiveParserCommand = new PrimitiveParserCommand(m_game, args);					
					m_primitiveCommand.push(primiCmd);
				}
			}
		}
		
		
		/*public function parserRoom(data:String):void
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
				else
					createPrimitives(args);
			}
		}*/
		
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
			
			var event:RoomEvent = new RoomEvent(RoomEvent.CREATE_CAMERA);
			event.objType = "camera";
			event.object = camInfo;
			m_game.dispatchEvent(event);			
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
			event.object = plane;
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
			event.object = sphere;
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
			event.object = box;
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
				
				loadObjModel(path, type, pos3, rot3, scale, scale3);
				//addToScene(loader);
				//m_objList.push(loader);
			}
		}
		
		private function loadObjModel(path:String, type:String, pos3:Array, rot3:Array, scale:Number, scale3:Array):ObjectContainer3D
		{
			var asset:IAsset = AssetLibrary.getAsset(path);
			if(asset == null)
			{
				var loader:Loader3D = new Loader3D(true, "main");
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
				return loader;
			}
			else
			{
				return asset as ObjectContainer3D;
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
			
			//m_objList.push(l);
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
			if(useToonshadingForModel)
			{
				setToonShading(event.target as ObjectContainer3D);
			}
			
			//addObjectContainerToScene(event.target as ObjectContainer3D);
			
			m_game.addObjectToScene(event.target as ObjectContainer3D);
			
			//event.target.addEventListener(MouseEvent3D.DOUBLE_CLICK, on3DObjeMouseDown);			
			
			var roomEvent:RoomEvent = new RoomEvent(RoomEvent.CREATE_OBJECT);
			roomEvent.objType = "load_model";
			roomEvent.object = event.target as Loader3D;
			m_game.dispatchEvent(roomEvent);
			
			m_loadCount++;
			if(m_loadCount >= m_loadCommand.length)
			{
				var e:RoomEvent = new RoomEvent(RoomEvent.LOAD_COMPLETED);
				m_game.dispatchEvent(e);
			
				excutePrivimiteCommand();
				excuteCameraCommand();
			}
		}
		
		private function setToonShading(container:ObjectContainer3D):void
		{
			var i:int;
			var mesh:Mesh;
			var len:uint = container.numChildren;
			var material:ColorMaterial = testToonShading();
			for(i = 0; i < len; ++i) 
			{
				var c:ObjectContainer3D = container.getChildAt(i);
				if(c is Mesh)
				{
					mesh = Mesh(c);
					mesh.material = material;
				}
				else
					setToonShading(c);
			}
		}
		
		private function testToonShading():ColorMaterial
		{
			var material : ColorMaterial = new ColorMaterial(0xffffff);
			//material.ambientColor = 0xdd5525;
			material.ambientColor = 0xffffff;
			material.ambient = 1; //0xdd5525;
			material.specular = .25;
			material.diffuseMethod = new CelDiffuseMethod(3);
			material.specularMethod = new CelSpecularMethod();
			material.addMethod(new OutlineMethod(0x000000, 25/50));
			CelSpecularMethod(material.specularMethod).smoothness = .01;
			CelDiffuseMethod(material.diffuseMethod).smoothness = .01;
			material.lightPicker = m_game.lightPicker;
			return material;
		}
		
		public function get primiteCommand():Vector.<PrimitiveParserCommand>
		{
			return m_primitiveCommand; 
		}
		
		public function get loadCommand():Vector.<LoadParserCommand>
		{
			return m_loadCommand; 
		}
		
		private function excuteLoadCommand():void
		{
			for(var i:int = 0; i < m_loadCommand.length; i++)
			{
				m_loadCommand[i].excute();
			}
		}
		
		private function excutePrivimiteCommand():void
		{
			for(var i:int = 0; i < m_primitiveCommand.length; i++)
				m_primitiveCommand[i].excute();
		}
		
		private function excuteCameraCommand():void
		{
			for(var i:int = 0; i < m_cameraCommand.length; i++)
			{
				m_cameraCommand[i].excute();
			}
		}
		
		private function excuteLightCommand():void
		{
			for(var i:int = 0; i < m_lightCommand.length; i++)
			{
				m_lightCommand[i].excute();
			}
		}
		
		public function refresh():void
		{
			var cmd:IParserCommand
			for each(cmd in m_cameraCommand)
			{
				cmd.updateCommand();
			}
			
			for each(cmd in m_lightCommand)
			{
				cmd.updateCommand();
			}
			
			for each(cmd in m_primitiveCommand)
			{
				cmd.updateCommand();
			}
			
			for each(cmd in m_loadCommand)
			{
				cmd.updateCommand();
			}
		}
		
		public function get data():String
		{
			var str:String = "";
			var cmd:IParserCommand
			for each(cmd in m_cameraCommand)
			{
				str += cmd.toString() + "\n";
			}
			
			for each(cmd in m_lightCommand)
			{
				str += cmd.toString() + "\n";
			}
			
			for each(cmd in m_primitiveCommand)
			{
				str += cmd.toString() + "\n";
			}
			
			for each(cmd in m_loadCommand)
			{
				str += cmd.toString() + "\n";
			}
			
			return str;
		}
		
		public function excute2DCommand():void
		{
			var cmd:ParserCommandBase;
			var event:Editor2DEvent;
			for each(cmd in m_cameraCommand)
			{
				if(cmd.isDelete) continue;
				
				event = cmd.create2DEvnet();				
				if(event)
					m_editor2DRoom.dispatchEvent(event);
			}
			
			for each(cmd in m_lightCommand)
			{
				if(cmd.isDelete) continue;
				
				event = cmd.create2DEvnet();
				if(event)
					m_editor2DRoom.dispatchEvent(event);
			}
			
			for each(cmd in m_primitiveCommand)
			{
				if(cmd.isDelete) continue;
				
				event = cmd.create2DEvnet();
				if(event)
					m_editor2DRoom.dispatchEvent(event);
			}
			
			for each(cmd in m_loadCommand)
			{
				if(cmd.isDelete) continue;
				
				event = cmd.create2DEvnet();
				if(event)
					m_editor2DRoom.dispatchEvent(event);
			}
			
		}
	}
}
