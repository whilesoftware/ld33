package;
import flixel.FlxSprite;

/**
 * ...
 * @author ...
 */
class TreeCollider extends FlxSprite 
{

	public var tree_id:Int = -1;

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