package com.infy.editor.editor2droom
{
	import flash.geom.Point;

	/**
	 * 
	 * @long  Dec 31, 2014
	 * 
	 */	
	public class DrawCircle extends DrawBase
	{
		public function DrawCircle()
		{
			super();
		}
		
		override protected function draw():void
		{
			super.draw();
			
			this.graphics.beginFill(drawColor, drawAlpha);		
			var dis:Point = endPoint.subtract(startPoint);
			this.graphics.drawCircle(startPoint.x, startPoint.y, dis.length);
			this.graphics.endFill();	
			
			this.graphics.lineStyle(1, 0xffff00, 0.55);
			this.graphics.moveTo(startPoint.x, startPoint.y);
			this.graphics.lineTo(endPoint.x, endPoint.y);
		}
	}
}