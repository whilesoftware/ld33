package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxStringUtil;
import flixel.FlxCamera.FlxCameraFollowStyle;
import openfl.Assets;

/**
 * A FlxState which can be used for the game's menu.
 */
class GameState extends FlxState
{
	var monster:Monster;
	var tilemap:FlxTilemap;
	
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
		
		
		// generate level geometry
		// add the collidable level geometry/sprites first (always in background)
		tilemap = new FlxTilemap();
		var bmdata:String = FlxStringUtil.bitmapToCSV(Assets.getBitmapData("assets/images/small-map-32x32.png"));
		tilemap.loadMapFromCSV(bmdata, "assets/images/tile-32.png", 32, 32);
		//tilemap.visible = true;
		add(tilemap);
		Reg.tilemap = tilemap;
		
		
		// create the monster and put him in the middle of the screen
		monster = new Monster();
		add(monster);
		monster.setposition(FlxG.width / 2, FlxG.height / 2);
		
		
		
		
		// create the non-collidable level geometry/sprites last (always in foreground)
		
		// tell the camera to follow the character
		FlxG.camera.follow(monster.monster_collider,FlxCameraFollowStyle.TOPDOWN,null,0.5);
		FlxG.camera.setScrollBoundsRect(0, 0, 32 * 32, 32 * 32);
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
		
		FlxG.collide(tilemap, monster.monster_collider);
		//FlxG.overlap(monster.monster_collider, bad_guys);
	}	
}