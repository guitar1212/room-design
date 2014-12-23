package com.infy.editor.ui
{
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.materials.TextureMaterial;
	import away3d.textures.BitmapTexture;
	
	import com.infy.util.tools.getObject3DInfo;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	/**
	 * 
	 * @long  Dec 23, 2014
	 * 
	 */	
	public class ObjectInfoUI extends EditorInfoUIBase
	{
		private var m_target:ObjectContainer3D;
		
		private var m_attributeList:Array = ["name", "type", "x", "y", "z", "rotX", "rotY", "rotZ", "scaleX", "scaleY", "scaleZ", "triangles", "vertices", "texture"];
		
		public function ObjectInfoUI(w:int=200, h:int=300)
		{
			super(w, h);
			
			this.setColumns(["Attirbute", "value"]);
			
			for(var i:int = 0; i < m_attributeList.length; i++)
				this.addData(m_attributeList[i], "");			
		}
		
		public function set target(obj:ObjectContainer3D):void
		{
			m_target = obj;
			update();
		}
		
		public function get target():ObjectContainer3D
		{
			return m_target;
		}
		
		override public function update():void
		{
			if(m_target)
			{
				setData(0, m_target.name);
				setData(1, m_target.assetType);
				setData(2, m_target.position.x);
				setData(3, m_target.position.y);
				setData(4, m_target.position.z);
				setData(5, m_target.rotationX);
				setData(6, m_target.rotationY);
				setData(7, m_target.rotationZ);
				setData(8, m_target.scaleX);
				setData(9, m_target.scaleY);
				setData(10, m_target.scaleZ);
				setData(11, getObject3DInfo.getFaceCounts(m_target));
				setData(12, getObject3DInfo.getVertexCounts(m_target));
				
				if(m_target is Mesh)
				{
					var m:Mesh = m_target as Mesh;
					var b:BitmapData = null;
					if(m.material is TextureMaterial)
					{
						b = (TextureMaterial(m.material).texture as BitmapTexture).bitmapData;
						var tn:String = (TextureMaterial(m.material).texture as BitmapTexture).name;
						setData(13, tn);
					}
					else
						setData(13, "");
				}
				else
					setData(13, "");
			}
			
			super.update();
		}
		
		override public function onDataChange(row:int, data:Object):void
		{
			if(m_target)
			{
				var n:Number = Number(data);
				if(row == 0)
					m_target.name = String(data);				
				else if(row == 2)
					m_target.x = n
				else if(row == 3)
					m_target.y = n;
				else if(row == 4)
					m_target.z = n;
				else if(row == 5)
					m_target.rotationX = n;
				else if(row == 6)
					m_target.rotationY = n;
				else if(row == 7)
					m_target.rotationZ = n;
				else if(row == 8)
					m_target.scaleX = n;
				else if(row == 9)
					m_target.scaleY = n;
				else if(row == 10)
					m_target.scaleZ = n;	
			}
		}
	}
}