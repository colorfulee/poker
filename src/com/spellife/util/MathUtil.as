package com.spellife.util
{
	import flash.geom.Point;
	
	import starling.display.Graphics;

	/** 
	 * @Content 
	 * @Author jim 
	 * @Version 1.0.0 
	 * @Date：Mar 19, 2013 4:13:20 PM 
	 * @description:
	 */ 
	public class MathUtil
	{
		/* 根据一二起始点，计算零点 */
		public static function makeStartPoint(first:Point, second:Point):Point
		{
			return first.subtract(second).add(first);
		}
		
		public static function drawSingleSector(target:Graphics,x:Number, y:Number, radius:Number, angle:Number):void
		{
			if(angle>360)
				angle = angle % 360;
			target.beginFill(0xffffff,1);
			target.lineStyle(2, 0xffffff, .8);
			target.moveTo(x, y);
			target.lineTo(x, y - radius);
			
			var n:int = Math.ceil(angle / 45);    
			var angleE:Number = angle / n;
			var startAngle:Number = 0;
			var ctrlLength:Number = radius / Math.cos(angleE/2 / 180 * Math.PI);
			var tmpAngle:Number ;
			for (var i:int = 0; i < n ; i++ )
			{
				startAngle += angleE;
				tmpAngle = startAngle - angleE / 2;
				var tmpCtrlX:Number = x + ctrlLength * Math.sin(tmpAngle / 180 * Math.PI);
				var tmpCtrlY:Number = y - ctrlLength * Math.cos(tmpAngle / 180 * Math.PI);
				var tmpEndX:Number = x + radius * Math.sin(startAngle / 180 * Math.PI);
				var tmpEndY:Number = y - radius * Math.cos(startAngle / 180 * Math.PI);
				target.curveTo(tmpCtrlX, tmpCtrlY, tmpEndX, tmpEndY);
			}
			target.lineTo(x, y);
			target.endFill();
		}
		
		public static function drawSector(obj:Graphics,x:Number=0,y:Number=0,radius:Number=100,fromRadian:Number=0,radian:Number=0):void
		{
			obj.moveTo(x,y);
			if(Math.abs(radian) > Math.PI * 2){
				obj.drawCircle(x,y,radius);
			}else{
				var n:int = Math.ceil(radian * 4 / Math.PI);
				var angleAvg:Number = radian / n;
				var angleMid:Number, bx:Number, by:Number,cx:Number, cy:Number;
				obj.lineTo(x + radius * Math.cos(fromRadian),y + radius * Math.sin(fromRadian));
				for (var i:uint=1; i<=n; i++)
				{
					fromRadian +=  angleAvg;
					angleMid = fromRadian - angleAvg * .5;
					bx=x + radius * Math.cos(angleMid) / Math.cos(angleAvg * .5);
					by=y + radius * Math.sin(angleMid) / Math.cos(angleAvg * .5);
					cx = x + radius * Math.cos(fromRadian);
					cy = y + radius * Math.sin(fromRadian);
					obj.curveTo(bx,by,cx,cy);
				}
				obj.lineTo(x,y);
			}
		}
		
		public static function drawPieMask (graphics:Graphics , percentage:Number , radius:Number = 50, x:Number = 0, y:Number = 0, rotation:Number = 0 , sides:int = 6) :void  {
			graphics.clear();
			
//			graphics.beginTextureFill(_testTex );
			// graphics should have its beginFill function already called by now
			graphics.moveTo(x , y );
			if (sides < 3 ) sides = 3; // 3 sides minimum
			// Increase the length of the radius to cover the whole target
			radius /= Math.cos (1 /sides * Math.PI );
			// Shortcut function
			var lineToRadians:Function = function (rads:Number ): void {
				graphics.lineTo (Math.cos (rads ) * radius + x , Math. sin( rads) * radius + y) ;
			};
			// Find how many sides we have to draw
			var sidesToDraw:int = Math.floor (percentage * sides );
			for ( var i:int = 0; i <= sidesToDraw; i ++)
				lineToRadians ((i / sides ) * (Math.PI * 2 ) + rotation) ;
			// Draw the last fractioned side
			if (percentage * sides != sidesToDraw )
				lineToRadians (percentage * (Math.PI * 2 ) + rotation) ;
			graphics.lineTo (x ,y );
			
			graphics.endFill ();
		}   

	}
}