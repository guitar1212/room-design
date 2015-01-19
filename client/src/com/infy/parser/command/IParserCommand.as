package com.infy.parser.command
{
	import com.infy.editor.editor2droom.event.Editor2DEvent;

	public interface IParserCommand
	{
		function parser(args:Array):void
		function excute():void
		function updateCommand():void
		function toString():String
		function create2DEvnet():Editor2DEvent
	}
}