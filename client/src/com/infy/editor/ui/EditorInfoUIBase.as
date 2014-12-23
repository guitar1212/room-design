package com.infy.editor.ui
{
	import com.infy.ui.comp.MoveIcon;
	
	import fl.controls.DataGrid;
	import fl.data.DataProvider;
	import fl.events.DataChangeEvent;
	import fl.events.DataGridEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * 
	 * @long  Dec 23, 2014
	 * 
	 */	
	public class EditorInfoUIBase extends MovieClip
	{
		private var m_datagrid:DataGrid;
		
		private var m_dataProvider:DataProvider;
		
		private var m_columns:Array = []; 
		
		public function EditorInfoUIBase(w:int = 250, h:int = 300)
		{
			super();
			
			m_dataProvider = new DataProvider();
			
			m_datagrid = new DataGrid();
			m_datagrid.setSize(w, h);
			m_datagrid.editable = true;
			m_datagrid.dataProvider = m_dataProvider;
			m_datagrid.y = 10;
			this.addChild(m_datagrid);
			
			m_datagrid.addEventListener(DataGridEvent.ITEM_FOCUS_OUT, onFoucsOut);
			
			this.addChild(new MoveIcon());
		}
		
		protected function onFoucsOut(event:DataGridEvent):void
		{						
			var column:int = event.columnIndex;
			var row:int = int(event.rowIndex);
			var data:Object = m_dataProvider.getItemAt(row);
			trace("onFoucsOut " + data[m_columns[column]]);
			onDataChange(row, data[m_columns[column]]);
		}
		
		public function onDataChange(row:int, data:Object):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function setColumns(columns:Array):void
		{
			m_columns = columns;
			m_datagrid.columns = columns;
			
			m_datagrid.getColumnAt(0).editable = false;
			/*m_datagrid.getColumnAt(0).setWidth(100);
			m_datagrid.getColumnAt(1).setWidth(150);*/
			for(var i:int = 0; i < columns.length; i++)
				m_datagrid.getColumnAt(i).sortable = false;
		}
		
		public function addData(... args):void
		{
			var data:Object = {};
			for(var i:int = 0; i < args.length; i++)
			{
				data[m_columns[i]] = args[i];
			}
			
			m_dataProvider.addItem(data);			
		}
		
		public function setData(index:int, value:Object):void
		{
			m_dataProvider.getItemAt(index)[m_columns[1]] = value;		
		}
		
		public function update():void
		{
			m_datagrid.dataProvider = m_dataProvider;
		}
		
	}
}