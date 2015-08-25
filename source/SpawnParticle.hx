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

	var distance:Float = 50;
	
	public function new() 
	{
		super();
		makeGraphic(4, 4 ,0xffe70000);
	}
	
	public function gobabygo(xpos:Float, ypos:Float, _angle:Float) {
		// pick a point that is initial_distance away from this center, at some random angle
		var _angle:Float = MathHelper.RandomRangeFloat(_angle - 0.3, _angle + 0.3);
		
		var new_x = xpos + MathHelper.RandomRangeFloat(0.7, 1.3) * distance * Math.cos(_angle);
		var new_y = ypos + MathHelper.RandomRangeFloat(0.7, 1.3) * distance * Math.sin(_angle);
		x = xpos;
		y = ypos;
		
		// tween towards the center and then disappear
		FlxTween.tween(this, { x:new_x, y:new_y }, MathHelper.RandomRangeFloat(0.2, 0.5), { ease:FlxEase.expoOut } ).onComplete = 
			function(t:FlxTween):Void {
				FlxTween.tween(this, { y:new_y + MathHelper.RandomRangeInt(5,20) }, MathHelper.RandomRangeFloat(0.1,0.15), { ease:FlxEase.sineOut } );
			}
	}
	
}
