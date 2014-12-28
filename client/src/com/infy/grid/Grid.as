package com.infy.grid
{
	import flash.geom.Vector3D;
	
	import away3d.entities.SegmentSet;
	import away3d.primitives.LineSegment;
	
	public class Grid extends SegmentSet
	{
		public function Grid(halfWidthGrids:uint = 50, gridSize:uint = 10, thickness:Number = 1, color:uint = 0x0000FF)
		{
			super();
			this.name = "grid";
			var width:int = halfWidthGrids*gridSize*2;
			var height:int = width;
			var lines:int = halfWidthGrids*2 + 1;
			
			var startX:int = halfWidthGrids*gridSize;
			var startZ:int = halfWidthGrids*gridSize;
			
			for(var i:int = 0; i < lines; i++)
			{
				var vx0:Vector3D = new Vector3D(startX - i*gridSize, 1, startZ);
				var vx1:Vector3D = new Vector3D(startX - i*gridSize, 1, -startZ);
				var lineX:LineSegment = new LineSegment(vx0, vx1, color, color, thickness);
				addSegment(lineX);
				
				var vz0:Vector3D = new Vector3D(startX, 1, startZ - i*gridSize);
				var vz1:Vector3D = new Vector3D(-startX, 1, startZ - i*gridSize);
				var lineZ:LineSegment = new LineSegment(vz0, vz1, color, color, thickness);
				addSegment(lineZ);
			}
		}
		
		
	}
}