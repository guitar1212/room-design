package com.infy.editor.editor2droom
{
	import flash.geom.Point;

	public class DrawRectangle extends DrawBase
	{	
		public function DrawRectangle()
		{
			super();
		}
		
		
		override protected function draw():void
		{
			super.draw();
			
			this.graphics.beginFill(drawColor, drawAlpha);			
			this.graphics.drawRect(startPoint.x, startPoint.y, endPoint.x - startPoint.x, endPoint.y - startPoint.y);
			this.graphics.endFill();			
		}
		
	}
}