package com.infy.util.primitive
{
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.materials.methods.CelDiffuseMethod;
	import away3d.materials.methods.CelSpecularMethod;
	import away3d.materials.methods.FresnelEnvMapMethod;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.PlaneGeometry;
	
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
			var objName:String = args.shift();
			var pos:Array = String(args.shift()).split(",");
			var rotation:Array = String(args.shift()).split(",");
			var size:Array = String(args.shift()).split(",");
			var colorArr:Array = String(args.shift()).split(",");
			var r:uint = colorArr[0];
			var g:uint = colorArr[1];
			var b:uint = colorArr[2];
			var color:uint = ColorUtil.getHexCode(r, g, b);
			var alpha:Number = args.shift();
			var m:ColorMaterial = new ColorMaterial(color, alpha);
			m.specular = 0.25;
			/*var sm:CelSpecularMethod = new CelSpecularMethod();
			var cm:CelDiffuseMethod = new CelDiffuseMethod();
			
			sm.specularColor = 0xff0000;
			sm.smoothness = 0.5;
			//m.specularMethod = sm;
			
			cm.smoothness = 0.1;
			//m.diffuseMethod = cm;*/
			
			m.alpha = 0.4;			
			
			//m.lightPicker = lightPicker;
			var box:Mesh = new Mesh(new CubeGeometry(size[0], size[1], size[2]), m);
			box.name = objName;
			box.x = pos[0];
			box.y = pos[1];
			box.z = pos[2];
			box.rotationX = rotation[0];
			box.rotationY = rotation[1];
			box.rotationZ = rotation[2];
			//addToScene(box);
			box.mouseEnabled = true;
			//box.addEventListener(MouseEvent3D.MOUSE_DOWN, on3DObjeMouseDown);			
			//m_meshList.push(box);
			return box;
		}
		
		public static function createPlane(args:Array):Mesh
		{
			var objName:String = args.shift();
			var pos:Array = String(args.shift()).split(",");
			var rotation:Array = String(args.shift()).split(",");
			var size:Array = String(args.shift()).split(",");
			var colorArr:Array = String(args.shift()).split(",");
			var r:uint = colorArr[0];
			var g:uint = colorArr[1];
			var b:uint = colorArr[2];
			var color:uint = r << 16 | g << 8 | b;
			var alpha:Number = args.shift();
			var m:ColorMaterial = new ColorMaterial(color, alpha);
			
			var plane:Mesh = new Mesh(new PlaneGeometry(size[0], size[1]), m);
			plane.name = objName;
			plane.x = pos[0];
			plane.y = pos[1];
			plane.z = pos[2];
			plane.rotationX = rotation[0];
			plane.rotationY = rotation[1];
			plane.rotationZ = rotation[2];
			plane.mouseEnabled = true;	
			return plane;
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