package;
import flixel.FlxSprite;
import flixel.util.FlxTimer;


/**
 * ...
 * @author ...
 */
class Grass extends FlxSprite
{

	public function new(xpos:Int, ypos:Int, is_long:Bool) 
	{
		super();
		
		if (is_long) {
			loadGraphic("assets/images/grass-long-spritesheet.png", true, 16, 16);
		}else {
			loadGraphic("assets/images/grass-short-spritesheet.png", true, 8, 8);
		}
		animation.add("sway", [0, 1, 2, 3, 4, 5, 6, 7, 6, 5, 4, 3, 2, 1], 5, true);
		solid = false;
		immovable = true;
		
		setPosition(xpos, ypos);
		
		new FlxTimer().start(Math.random()).onComplete = function(t:FlxTimer):Void {
			animation.play("sway");
		}
		
	}
	
}