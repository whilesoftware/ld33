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

	public function new() 
	{
		super();
		
		trace("railshot:new()");
		
		shot_body = new FlxSprite();
		shot_body.loadGraphic("assets/images/wide-railshot.png", true, 128, 16);
		shot_body.animation.add("cycle", [0, 1, 2, 3], 10, true);
		shot_body.solid = false;
		shot_body.immovable = true;
		shot_body.visible = false;
		add(shot_body);
	}
	
	public function gogogo(xstart:Float, ystart:Float, _angle:Float, _length:Float, angle_x:Float, angle_y:Float, size:Float, fvec:FlxVector) {
		trace("railshot:gogogo()");
		/*
		var new_sprite:FlxSprite = new FlxSprite();
		new_sprite.makeGraphic(64, 2, FlxColor.MAGENTA);
		//new_sprite.setPosition(xstart + angle_x * 64, ystart + angle_y * 64);
		new_sprite.setPosition(200, 200);
		new_sprite.origin.set(0, 1);
		trace("angle = " + _angle);
		new_sprite.angle = _angle * 180 / Math.PI;
		add(new_sprite);
		
		new FlxTimer().start(0.3).onComplete = function(t:FlxTimer):Void {
			kill();
			pgroup.remove(this);
		}
		return;
		*/
		
		//_length = 128;
		// start position
		//var center_pos:FlxPoint = new FlxPoint(xstart + _length/2 * Math.cos(_angle), ystart + _length/2 * Math.sin(_angle));
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
				0, 
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