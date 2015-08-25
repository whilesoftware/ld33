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
class BloodParticle extends FlxSprite 
{

	var distance:Float = 90;
	
	public function new() 
	{
		super();
		makeGraphic(3, 3, 0xffe70000);
		//FlxSpriteUtil.drawPolygon(this,[FlxPoint.get(2.5, 0), FlxPoint.get(5, 2.5), FlxPoint.get(2.5, 5), FlxPoint.get(0, 2.5)], 0xffffffff);
		FlxSpriteUtil.drawPolygon(this,[FlxPoint.get(0, 0), FlxPoint.get(3, 0), FlxPoint.get(3,3), FlxPoint.get(0, 3)], 0xffe70000);
		//setSize(1, 1);
	}
	
	public function gobabygo(xpos:Float, ypos:Float, _angle:Float) {
		// pick a point that is initial_distance away from this center, at some random angle
		var _angle:Float = MathHelper.RandomRangeFloat(_angle - 0.3, _angle + 0.3);
		
		var new_x = xpos + MathHelper.RandomRangeFloat(0.7, 1.3) * distance * MathHelper.RandomRangeFloat(5,50) * Math.cos(_angle);
		var new_y = ypos + MathHelper.RandomRangeFloat(0.7, 1.3) * distance * MathHelper.RandomRangeFloat(5,50) * Math.sin(_angle);
		x = xpos;
		y = ypos;
		
		// tween towards the center and then disappear
		FlxTween.tween(this, { x:new_x, y:new_y }, MathHelper.RandomRangeFloat(0.2, 0.5), { ease:FlxEase.expoOut } ).onComplete = 
			function(t:FlxTween):Void {
				FlxTween.tween(this, { y:new_y - MathHelper.RandomRangeInt(5,20) }, MathHelper.RandomRangeFloat(0.2,0.3), { ease:FlxEase.sineOut } );
			}
	}
	
}