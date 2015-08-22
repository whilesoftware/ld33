package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

/**
 * A FlxState which can be used for the game's menu.
 */
class GameState extends FlxState
{
	var monster:Monster;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		FlxG.camera.bgColor = 0xff262626;
		
		// create a few grasses in random positions
		for (x in 1...100) {
			add(new Grass(Math.floor(Math.random() * FlxG.width), Math.floor(Math.random() * FlxG.height), Math.random() > 0.6));
		}
		
		// create the monster and put him in the middle of the screen
		monster = new Monster();
		add(monster);
		monster.setposition(FlxG.width / 2, FlxG.height / 2);
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update(elapsed:Float):Void
	{
		Reg.update(elapsed);
		
		monster.update(elapsed);
		super.update(elapsed);
		
	}	
}