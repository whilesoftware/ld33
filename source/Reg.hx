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
	/**
	 * Generic levels Array that can be used for cross-state stuff.
	 * Example usage: Storing the levels of a platformer.
	 */
	public static var levels:Array<Dynamic> = [];
	/**
	 * Generic level variable that can be used for cross-state stuff.
	 * Example usage: Storing the current level number.
	 */
	public static var level:Int = 0;
	/**
	 * Generic scores Array that can be used for cross-state stuff.
	 * Example usage: Storing the scores for level.
	 */
	public static var scores:Array<Dynamic> = [];
	/**
	 * Generic score variable that can be used for cross-state stuff.
	 * Example usage: Storing the current score.
	 */
	public static var score:Int = 0;
	/**
	 * Generic bucket for storing different FlxSaves.
	 * Especially useful for setting up multiple save slots.
	 */
	public static var saves:Array<FlxSave> = [];
	
	
	public static var frame_number:Int = -1;
	
	public static var tilemap:FlxTilemap;
	
	public static var trees:Map<Int,Tree> = new Map<Int,Tree>();
	public static var enemies:Map<Int,Enemy> = new Map<Int,Enemy>();
	
	public static var gamestate:GameState;
	public static var monster:Monster;
	public static var rails:FlxGroup;
	public static var rail_colliders:FlxGroup;
	
	public static function update(elasped:Float) {
		frame_number++;
	}
	
	
}