package;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

/**
 * ...
 * @author ...
 */
class MonsterCollider extends FlxSprite 
{
	
	public var physics:FlxPoint = new FlxPoint();
	
	public function new() 
	{
		super();
		physics.set(0, 0);
		makeGraphic(34, 22);
		visible = false;
		this.immovable = false;
		this.set_moves(true);
		this.set_solid(true);
	}
	
	public override function update(elapsed:Float):Void {
		
		velocity.x += physics.x;
		velocity.y += physics.y;
		physics.set(0, 0);
		super.update(elapsed);
		
		
	}
	
}