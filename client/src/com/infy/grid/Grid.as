package com.infy.grid
{
	import flash.geom.Vector3D;
	
	import away3d.entities.Mesh;
	import away3d.entities.SegmentSet;
	import away3d.events.MouseEvent3D;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.LineSegment;
	import away3d.primitives.PlaneGeometry;
	import away3d.primitives.SphereGeometry;
	
	public class Grid extends SegmentSet
	{
		private var m_offsetY:Number = 1;
		private var m_plane:Mesh;
		private var m_locationTracer:Mesh;
		
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
				var vx0:Vector3D = new Vector3D(startX - i*gridSize, m_offsetY, startZ);
				var vx1:Vector3D = new Vector3D(startX - i*gridSize, m_offsetY, -startZ);
				var lineX:LineSegment = new LineSegment(vx0, vx1, color, color, thickness);
				addSegment(lineX);
				
				var vz0:Vector3D = new Vector3D(startX, m_offsetY, startZ - i*gridSize);
				var vz1:Vector3D = new Vector3D(-startX, m_offsetY, startZ - i*gridSize);
				var lineZ:LineSegment = new LineSegment(vz0, vz1, color, color, thickness);
				addSegment(lineZ);
			}
			
			m_plane = new Mesh(new PlaneGeometry(width, width), new ColorMaterial());
			m_plane.mouseEnabled = true;
			m_plane.addEventListener( MouseEvent3D.MOUSE_MOVE, onMeshMouseMove );
			this.addChild(m_plane);
			
			// To trace picking positions.
			m_locationTracer = new Mesh( new SphereGeometry( 5 ), new ColorMaterial( 0x00FF00, 0.5 ) );
			m_locationTracer.mouseEnabled = m_locationTracer.mouseChildren = false;
			m_locationTracer.visible = true;
			addChild(m_locationTracer );
		}
		
		protected function onMeshMouseMove(event:MouseEvent3D):void
		{
			var p:Vector3D = event.scenePosition;
			//p.y = m_offsetY;
			m_locationTracer.position = p;
			trace('scenePosition  ' + event.scenePosition);
		}		
		
	}
}