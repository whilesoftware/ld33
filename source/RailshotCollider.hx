package;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;

class RailshotCollider extends FlxSprite 
{
	public var id:Int;
	public var spawn_time:Int;
	
	public static var next_id:Int = 0;
	
	public function _disable() {
		kill();
		Reg.rail_colliders.remove(this);
	}
	
	public function new(_id:Int, _width:Float, _height:Float, _center_x:Float, _center_y:Float, _angle:Float) 
	{
		super();
		
		id = next_id;
		next_id++;
		// create a new graphic of the appropriate size
		makeGraphic(Math.ceil(_width), Math.ceil(_height), FlxColor.MAGENTA);
		x = _center_x - width/2;
		y = _center_y - height/2;
		angle = _angle;
		visible = true;
		immovable = true;
		solid = true;
		
		Reg.rail_colliders.add(this);
		
		spawn_time = Reg.frame_number;
		
		trace("created a new rail collider!");
		
	}
	
	public override function update(elapsed:Float) {
		
		if (Reg.frame_number > spawn_time) {
			_disable();
		}
		
		super.update(elapsed);
	}
	
}