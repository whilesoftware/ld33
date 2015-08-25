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
class BushParticle extends FlxSprite 
{
	
	var distance:Float = 90;
	
	public function new() 
	{
		super();
		makeGraphic(8, 8, 0xff202020);
		//FlxSpriteUtil.drawPolygon(this,[FlxPoint.get(2.5, 0), FlxPoint.get(5, 2.5), FlxPoint.get(2.5, 5), FlxPoint.get(0, 2.5)], 0xffffffff);
		FlxSpriteUtil.drawPolygon(this,[FlxPoint.get(0, 0), FlxPoint.get(8, 0), FlxPoint.get(8,8), FlxPoint.get(0, 8)], 0xff202020);
		//setSize(1, 1);
	}
	
	public function gobabygo(xpos:Float, ypos:Float, _angle:Float) {
		// pick a point that is initial_distance away from this center, at some random angle
		var _angle:Float = MathHelper.RandomRangeFloat(_angle - 1, _angle + 1);
		
		var new_x = xpos + MathHelper.RandomRangeFloat(0.7, 1.3) * distance * Math.cos(_angle);
		var new_y = ypos + MathHelper.RandomRangeFloat(0.7, 1.3) * distance * Math.sin(_angle);
		x = xpos;
		y = ypos;
		
		// tween towards the center and then disappear
		FlxTween.tween(this, { x:new_x, y:new_y, alpha:0.1 }, MathHelper.RandomRangeFloat(0.4, 0.8), { ease:FlxEase.expoOut } ).onComplete = 
			function(t:FlxTween):Void {
				kill();
			}
	}
}
