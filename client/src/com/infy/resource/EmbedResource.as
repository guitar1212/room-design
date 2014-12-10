package com.infy.resource
{
	/**
	 * 
	 * @long  Dec 10, 2014
	 * 
	 */	
	public class EmbedResource
	{
		[Embed(source="/../embeds/item01_002.jpg")]
		public static var DefaultGoosIcon:Class;
		
		public function EmbedResource()
		{
		}
	}
}