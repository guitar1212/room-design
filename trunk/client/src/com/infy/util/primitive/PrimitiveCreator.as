package com.infy.util.primitive
{
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.materials.SinglePassMaterialBase;
	import away3d.materials.methods.CelDiffuseMethod;
	import away3d.materials.methods.CelSpecularMethod;
	import away3d.materials.methods.FresnelEnvMapMethod;
	import away3d.materials.methods.HardShadowMapMethod;
	import away3d.materials.methods.ShadowMapMethodBase;
	import away3d.materials.methods.SimpleShadowMapMethodBase;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.PlaneGeometry;
	import away3d.primitives.SphereGeometry;
	
	import com.infy.light.LightInfo;
	import com.infy.light.LightManager;
	import com.infy.util.tools.ColorUtil;

	/**
	 * 
	 * @long  Nov 27, 2014
	 * 
	 */	
	public class PrimitiveCreator
	{
		public function PrimitiveCreator()
		{			
		}
		
		public static function createCube(args:Array):Mesh
		{
			var info:PrimitiveInfo = new PrimitiveInfo();
			info.parser(args);
			
			var m:ColorMaterial = new ColorMaterial(info.color, info.alpha);
			m.specular = 0.25;
			/*var sm:CelSpecularMethod = new CelSpecularMethod();
			var cm:CelDiffuseMethod = new CelDiffuseMethod();
			
			sm.specularColor = 0xff0000;
			sm.smoothness = 0.5;
			//m.specularMethod = sm;
			
			cm.smoothness = 0.1;
			//m.diffuseMethod = cm;*/
						
			//m.lightPicker = lightPicker;
			var box:Mesh = new Mesh(new CubeGeometry(info.size.x, info.size.y, info.size.z), m);
			box.name = info.name;
			box.position = info.pos;
			box.eulers = info.rotation;
//			box.rotationX = rotation[0];
//			box.rotationY = rotation[1];
//			box.rotationZ = rotation[2];
			//addToScene(box);
			box.mouseEnabled = true;
			box.castsShadows = info.castShadow;
			//box.addEventListener(MouseEvent3D.MOUSE_DOWN, on3DObjeMouseDown);			
			//m_meshList.push(box);
			return box;
		}
		
		public static function createPlane(args:Array):Mesh
		{
			var info:PrimitiveInfo = new PrimitiveInfo();
			info.parser(args);
						
			var m:ColorMaterial = new ColorMaterial(info.color, info.alpha);
			
			var plane:Mesh = new Mesh(new PlaneGeometry(info.size.x, info.size.y), m);
			plane.name = info.name;
			plane.position = info.pos;
			plane.eulers = info.rotation;
			plane.mouseEnabled = true;	
			plane.castsShadows = info.castShadow;
			
			if(info.reciveShadow)
			{
				var lightInfo:LightInfo = LightManager.instance.getLight("main_light");
				m.shadowMethod = new HardShadowMapMethod(lightInfo.lignt);
				(m.shadowMethod as SimpleShadowMapMethodBase).epsilon = 0.7;
			}
			
			return plane;
		}
		
		public static function createSphere(args:Array):Mesh
		{
			var info:PrimitiveInfo = new PrimitiveInfo();
			info.parser(args);
			
			var m:ColorMaterial = new ColorMaterial(info.color, info.alpha);
			
			var sphere:Mesh = new Mesh(new SphereGeometry(1, 12, 12), m);
			sphere.scaleX = info.size.x;
			sphere.scaleY = info.size.y;
			sphere.scaleZ = info.size.z;
			sphere.position = info.pos;
			sphere.eulers = info.rotation;
			sphere.castsShadows = info.castShadow;
			sphere.mouseEnabled = true;
			return sphere;
		}
		
		public static function get defaultCubeObjectData():String
		{
			return "mtllib defaultMtl.mtl" + "\n" +
				   "v 0.000000 20.000000 20.000000" + "\n" +
				   "v 0.000000 0.000000 20.000000" + "\n" +
				   "v 20.000000 0.000000 20.000000" + "\n" +
				   "v 20.000000 20.000000 20.000000" + "\n" +
				   "v 0.000000 20.000000 0.000000" + "\n" +
				   "v 0.000000 0.000000 0.000000" + "\n" +
				   "v 20.000000 0.000000 0.000000" + "\n" +
				   "v 20.000000 20.000000 0.000000" + "\n" +
				   "# 8 vertices" + "\n" +
				   "vt 0.000000 1.000000 0.000000" + "\n" +
				   "vt 0.000000 0.000000 0.000000" + "\n" +
				   "vt 1.000000 0.000000 0.000000" + "\n" +
				   "vt 1.000000 1.000000 0.000000" + "\n" +
				   "g front" + "\n" +
				   "usemtl defTexJPG" + "\n" +
				   "f 1/1 2/2 3/3 4/4" + "\n" +
				   "g back" + "\n" +
				   "usemtl blue" + "\n" +
				   "f 8 7 6 5" + "\n" +
				   "g right" + "\n" +
				   "usemtl green" + "\n" +
				   "f 4 3 7 8" + "\n" +
				   "g top" + "\n" +
				   "usemtl red" + "\n" +
				   "f 5 1 4 8" + "\n" +
				   "g left" + "\n" +
				   "usemtl orange" + "\n" +
				   "f 5 6 2 1" + "\n" +
				   "g bottom" + "\n" +
				   "usemtl defTexPNGalpha" + "\n" +
				   "f 2/1 6/2 7/3 3/4" + "\n"
				   ;
		}
		
	}
}