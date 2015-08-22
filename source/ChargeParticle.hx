package;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.util.FlxSpriteUtil;
import flixel.math.FlxPoint;
import lime.math.Vector2;
import flixel.tweens.FlxEase;

/**
 * ...
 * @author ...
 */
class ChargeParticle extends FlxSprite 
{
	
	var initial_distance:Float = 40;
	var my_parent:ChargeEffect;
	
	public function new(_parent:ChargeEffect) 
	{
		super();
		my_parent = _parent;
		makeGraphic(1, 1, 0x99ffffff);
		//FlxSpriteUtil.drawPolygon(this,[FlxPoint.get(2.5, 0), FlxPoint.get(5, 2.5), FlxPoint.get(2.5, 5), FlxPoint.get(0, 2.5)], 0xffffffff);
		FlxSpriteUtil.drawPolygon(this,[FlxPoint.get(0, 0), FlxPoint.get(1, 0), FlxPoint.get(1,1), FlxPoint.get(0, 1)], 0x99ffffff);
		//setSize(1, 1);
	}
	
	public function gobabygo(xpos:Float, ypos:Float) {
		// pick a point that is initial_distance away from this center, at some random angle
		var _angle:Float = MathHelper.RandomRangeFloat(0, 2* Math.PI);
		
		x = xpos + initial_distance * Math.cos(_angle);
		y = ypos + initial_distance * Math.sin(_angle);
		
		trace("started a new particle!");
		
		// tween towards the center and then disappear
		FlxTween.tween(this, { x:xpos, y:ypos, alpha:0 }, MathHelper.RandomRangeFloat(0.2, 0.4), { ease:FlxEase.quadIn } ).onComplete = 
			function(t:FlxTween):Void {
				kill();
				my_parent.remove(this);
			}
	}
	
}
