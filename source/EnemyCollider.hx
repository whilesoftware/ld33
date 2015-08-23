package;
import flixel.FlxSprite;
/**
 * ...
 * @author ...
 */
class EnemyCollider extends FlxSprite 
{
	public var enemy_id:Int = -1;

	public function new() 
	{
		super();
		makeGraphic(64, 64);
		visible = true;
		this.immovable = true;
		this.set_moves(true);
		this.set_solid(true);
	}
	
	
	
}