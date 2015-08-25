package;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;

class RailshotCollider extends FlxSprite 
{
	public var the_rail:Railshot;
	public var spawn_time:Int;
	
	public function _disable() {
		kill();
		Reg.rail_colliders.remove(this);
	}
	
	public function new(_rail:Railshot, _width:Float, _height:Float, _center_x:Float, _center_y:Float, _angle:Float) 
	{
		super();
		
		
		
		the_rail = _rail;
		
		// create a new graphic of the appropriate size
		makeGraphic(Math.ceil(_width), Math.ceil(_height), FlxColor.MAGENTA);
		x = _center_x - width/2;
		y = _center_y - height/2;
		angle = _angle;
		visible = false;
		immovable = true;
		solid = true;
		
		Reg.rail_colliders.add(this);
		
		spawn_time = Reg.frame_number;
		
		//trace("created a new rail collider!");
		
	}
	
	public override function update(elapsed:Float) {
		
		if (Reg.frame_number > spawn_time) {
			_disable();
		}
		
		
		super.update(elapsed);
	}
	
}