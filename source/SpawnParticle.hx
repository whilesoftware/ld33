package;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.util.FlxSpriteUtil;
import flixel.math.FlxPoint;
#if not mac
import lime.math.Vector2;
#end
import flixel.tweens.FlxEase;

/**
 * ...
 * @author ...
 */
class SpawnParticle extends FlxSprite 
{
	var distance:Float = 30;
	var spatter_size:Int = 1;
	var fall_time:Float = 0;
	
	public function new() 
	{
		super();
		spatter_size = MathHelper.RandomRangeInt(4, 6);
		fall_time = MathHelper.RandomRangeFloat(0.5, 1);
		
		var rancolor:Int = MathHelper.RandomRangeInt(0, 3);
		if (rancolor == 0) {
			makeGraphic(spatter_size, spatter_size , 0xff444444);
		}else if (rancolor == 1) {
			makeGraphic(spatter_size, spatter_size , 0xff777777);
		}else {
			makeGraphic(spatter_size, spatter_size , 0xffaaaaaa);	
		}
		
		//FlxSpriteUtil.drawPolygon(this,[FlxPoint.get(2.5, 0), FlxPoint.get(5, 2.5), FlxPoint.get(2.5, 5), FlxPoint.get(0, 2.5)], 0xffffffff);
//		FlxSpriteUtil.drawPolygon(this,[FlxPoint.get(0, 0), FlxPoint.get(3, 0), FlxPoint.get(3,3), FlxPoint.get(0, 3)], 0xffe70000);
		//setSize(1, 1);
	}
	
	public function gobabygo(xpos:Float, ypos:Float, _angle:Float) {
		// pick a point that is initial_distance away from this center, at some random angle
		var _angle:Float = MathHelper.RandomRangeFloat(_angle - 0.3, _angle + 0.3);
		
		var new_x = xpos + MathHelper.RandomRangeFloat(0.1,0.5) * distance * Math.cos(_angle);
		//var new_y = ypos + MathHelper.RandomRangeFloat(0.7, 1.3) * distance * Math.sin(_angle);
		var new_y = ypos + MathHelper.RandomRangeFloat(0.1,0.5) * distance * Math.sin(_angle);
		x = xpos;
		y = ypos;
		
		// tween towards the destination and then disappear
		var flytime:Float = MathHelper.RandomRangeFloat(0.2, 0.5);
		FlxTween.tween(this, { x:new_x, y:new_y }, flytime, { ease:FlxEase.sineOut } ).onComplete = 
			function(t:FlxTween):Void {
				FlxTween.tween(this, { y:new_y + MathHelper.RandomRangeInt(2,6) }, MathHelper.RandomRangeFloat(0.05,0.1) / fall_time, { ease:FlxEase.sineOut } );
			}
	}
	
}
