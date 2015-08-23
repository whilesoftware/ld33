package;
import flixel.FlxSprite;

/**
 * ...
 * @author ...
 */
class MonsterCollider extends FlxSprite 
{
	
	public function new() 
	{
		super();
		makeGraphic(64, 64);
		visible = false;
		this.immovable = false;
		this.set_moves(true);
		this.set_solid(true);
	}
	
}