package com.infy.util.primitive
{
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.PlaneGeometry;

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
			var color:uint = r << 16 | g << 8 | b;
			var alpha:Number = args.shift();
			var m:ColorMaterial = new ColorMaterial(color, alpha);
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
		
	}
}