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
	var spatter_size:Int = 1;
	var fall_time:Float = 0;
	var narrow_factor:Float = 1;
	
	public function new(_distance:Float=90, _narrow_factor:Float=1) 
	{
		super();
		distance = _distance;
		narrow_factor = _narrow_factor;
		spatter_size = MathHelper.RandomRangeInt(2, 4);
		fall_time = MathHelper.RandomRangeFloat(0.5, 1);
		
		makeGraphic(spatter_size, spatter_size , 0xffe70000);
		//FlxSpriteUtil.drawPolygon(this,[FlxPoint.get(2.5, 0), FlxPoint.get(5, 2.5), FlxPoint.get(2.5, 5), FlxPoint.get(0, 2.5)], 0xffffffff);
//		FlxSpriteUtil.drawPolygon(this,[FlxPoint.get(0, 0), FlxPoint.get(3, 0), FlxPoint.get(3,3), FlxPoint.get(0, 3)], 0xffe70000);
		//setSize(1, 1);
	}
	
	public function gobabygo(xpos:Float, ypos:Float, _angle:Float) {
		// pick a point that is initial_distance away from this center, at some random angle
		var _angle:Float = MathHelper.RandomRangeFloat(_angle - 0.3 * narrow_factor, _angle + 0.3 * narrow_factor);
		
		var new_x = xpos + (3/spatter_size + MathHelper.RandomRangeFloat(0.1,0.5)) * distance * Math.cos(_angle);
		//var new_y = ypos + MathHelper.RandomRangeFloat(0.7, 1.3) * distance * Math.sin(_angle);
		var new_y = ypos + (3/spatter_size + MathHelper.RandomRangeFloat(0.1,0.5)) * distance * Math.sin(_angle);
		x = xpos;
		y = ypos;
		
		// tween towards the center and then disappear
		var flytime:Float = MathHelper.RandomRangeFloat(0.2, 0.5);
		FlxTween.tween(this, { x:new_x, y:new_y }, flytime, { ease:FlxEase.expoOut } ).onComplete = 
			function(t:FlxTween):Void {
				FlxTween.tween(this, { y:new_y + MathHelper.RandomRangeInt(2,6) }, MathHelper.RandomRangeFloat(0.05,0.1) / fall_time, { ease:FlxEase.sineOut } );
			}
	}
	
}
