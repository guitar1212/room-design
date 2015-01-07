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
		
		override public function endDraw(endX:Number, endY:Number):void
		{
			super.endDraw(endX, endY);
			
			var sX:Number = this.x;
			var sY:Number = this.y;
			
			var cX:Number = (endX + sX)/2;
			var cY:Number = (endY + sY)/2;
			
			this.x = cX;
			this.y = cY;
			var w:Number = this.width;
			var h:Number = this.height;
			this.graphics.clear();
			this.graphics.beginFill(drawColor, drawAlpha);
			this.graphics.drawRect(-w/2, -h/2, w, h);
			this.graphics.endFill();
			
			//drawCenter();
			
			// modify offset
			this.offset.x -= (sX - cX);
			this.offset.y -= (sY - cY);
		}
		
		private function drawCenter():void
		{
			this.graphics.beginFill(0xff0000, 0.7);
			this.graphics.drawCircle(0, 0, 2);
			this.graphics.endFill();
		}
		
	}
}