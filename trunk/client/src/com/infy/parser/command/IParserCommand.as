package com.infy.parser.command
{
	public interface IParserCommand
	{
		function parser(args:Array):void
		function excute():void
		function updateCommand():void
		function toString():String
	}
}