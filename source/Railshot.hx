package;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;


/**
 * ...
 * @author ...
 */
class Railshot extends FlxGroup 
{
	var shot_body:FlxSprite;
	
	public var power:Int = 0;
	public var direction:FlxVector = new FlxVector();

	public function new() 
	{
		super();
		
		//trace("railshot:new()");
		
		shot_body = new FlxSprite();
		shot_body.loadGraphic("assets/images/wide-railshot.png", true, 128, 16);
		shot_body.animation.add("cycle", [0, 1, 2, 3], 10, true);
		shot_body.solid = false;
		shot_body.immovable = true;
		shot_body.visible = false;
		add(shot_body);
	}
	
	public function gogogo(xstart:Float, ystart:Float, _angle:Float, _length:Float, angle_x:Float, angle_y:Float, size:Float, fvec:FlxVector) {
		
		direction.x = angle_x;
		direction.y = angle_y;
		direction.normalize();
		
		power = Math.round(size * 13);
		
		// start position
		var center_pos:FlxPoint = new FlxPoint(xstart, ystart);
		
		
		shot_body.setPosition(center_pos.x, center_pos.y);
		shot_body.origin.set(0, 8);
		shot_body.angle = _angle * 180 / Math.PI;
		new FlxTimer().start(0.25).onComplete = function(t:FlxTimer):Void {
			kill();
			Reg.rails.remove(this);
		}
		
		shot_body.scale.x = _length / 128;
		shot_body.scale.y = 0.01;
		shot_body.visible = true;
		FlxTween.tween(shot_body.scale, { y:0.9 * size }, 0.15, { ease:FlxEase.quintOut } ).onComplete = 
			function(t:FlxTween):Void {
				FlxTween.tween(shot_body.scale, { y: 0 }, 0.1, { ease:FlxEase.quintIn } );
			}
		shot_body.animation.play("cycle");
		
		var rc:RailshotCollider = 
			new RailshotCollider(
				this, 
				_length, 
				size * 8, 
				xstart +  fvec.x / 2, 
				ystart + fvec.y / 2, 
				_angle * 180 / Math.PI);
		
		/*
		FlxTween.tween(shot_body.scale, { x:1, y:1}, 0.05, { ease:FlxEase.quintOut } ).onComplete = 
			function(t:FlxTween):Void {
				kill();
				my_parent.remove(this);
			}
		*/
	}
	
}