package;

import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import flixel.util.FlxSave;

/**
 * Handy, pre-built Registry class that can be used to store 
 * references to objects and other things for quick-access. Feel
 * free to simply ignore it or change it in any way you like.
 */
class Reg
{
	public static var score:Int = 0;
	
	
	
	public static var frame_number:Int = -1;
	
	public static var tilemap:FlxTilemap;
	
	public static var trees:Map<Int,Tree>;
	public static var enemies:Map<Int,Enemy>;
	
	public static var gamestate:GameState;
	public static var monster:Monster;
	public static var rails:FlxGroup;
	public static var rail_colliders:FlxTypedGroup<RailshotCollider>;
	
	public static function update(elasped:Float) {
		frame_number++;
	}
	
	
}