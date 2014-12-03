package com.infy.util.zip
{
	import com.adobe.protocols.dict.events.ErrorEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	
	import nochump.util.zip.ZipEntry;
	import nochump.util.zip.ZipFile;

	/**
	 * 
	 * @long  Dec 3, 2014
	 * 
	 */	
	public class ZipLoader extends EventDispatcher
	{
		private static const RETRY_TIMES:int = 3;
		
		private var m_loader:URLStream = new URLStream();
		
		private var m_retryCount:int = 0;
		
		private var m_path:String;
		
		private var m_cb:Function = null;
		
		public function ZipLoader()
		{
		}
		
		public function load(path:String):void
		{
			m_path = path;
			m_loader.load(new URLRequest(path));
			m_loader.addEventListener(Event.COMPLETE, onLoadComplete);
			m_loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
		}
		
		protected function onLoadComplete(event:Event):void
		{
			m_loader.removeEventListener(Event.COMPLETE, onLoadComplete);
			m_loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			
			parseZip(m_loader);
			
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function parseZip(loader:URLStream):void
		{
			var zip:ZipFile = new ZipFile(m_loader);
			
			var fileName:String = "";
			var entry:ZipEntry;
			var i:int = 0, len:int = zip.entries.length;
			for(i; i < len; i++)
			{
				entry = zip.entries[i];				
				
				fileName = entry.name.split(".")[0];
				getZipData(fileName, zip.getInput(entry));
			}
		}
		
		private function getZipData(fileName:String, data:ByteArray):void
		{	
			trace("getZipData " + fileName);
			if(m_cb != null)
				m_cb(fileName, data, m_path);
		}
		
		protected function onError(event:IOErrorEvent):void
		{
			m_retryCount++;
			if(m_retryCount >= RETRY_TIMES)
			{
				trace("Load (" + m_path + ") error !!");
				this.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
			}
			else
			{
				m_loader.load(new URLRequest(m_path));
			}
				
		}
		
		public function set completeCallback(cb:Function):void
		{
			m_cb = cb;
		}
	}
}