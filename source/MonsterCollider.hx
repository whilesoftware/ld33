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
		makeGraphic(34, 22);
		visible = false;
		this.immovable = false;
		this.set_moves(true);
		this.set_solid(true);
	}
	
}