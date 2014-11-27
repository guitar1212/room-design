package com.infy.util.tools
{
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.ISubGeometry;
	import away3d.entities.Mesh;

	/**
	 * 
	 * @long  Nov 27, 2014
	 * 
	 */	
	public class getObject3DInfo
	{
		public function getObject3DInfo()
		{
		}
		
		/**
		 *	取得此模型的面數 
		 * @param o
		 * @return 
		 * 
		 */		
		public static function getFaceCounts(o:ObjectContainer3D):int
		{
			var faces:int = 0;
			if(o is Mesh)
			{
				var all:Vector.<ISubGeometry> = Mesh(o).geometry.subGeometries;				
				for each(var g:ISubGeometry in all)
				{
					faces += g.numTriangles;
				}				
			}
			else
			{
				var i:int = 0, len:int = o.numChildren;
				for(i; i < len; i++)
				{
					faces += getFaceCounts(o.getChildAt(i));	
				}				
			}
			
			
			return faces;
		}
		
		/**
		 *	計算模型的頂點數量 
		 * @param o
		 * @return 
		 * 
		 */		
		public static function getVertexCounts(o:ObjectContainer3D):int
		{
			var vertices:int = 0;
			
			if(o is Mesh)
			{
				var all:Vector.<ISubGeometry> = Mesh(o).geometry.subGeometries;				
				for each(var g:ISubGeometry in all)
				{
					vertices += g.numVertices;
				}				
			}
			else
			{
				var i:int = 0, len:int = o.numChildren;
				for(i; i < len; i++)
				{
					vertices += getVertexCounts(o.getChildAt(i));	
				}				
			}
			
			return vertices;
		}
	}
}