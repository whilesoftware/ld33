package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxObject;
import flixel.group.FlxGroup;
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
	
	var tile_width:Int = 64;
	var tile_height:Int = 32;
	var arena_width:Int = 16;
	var arena_height:Int = 32;
	
	var bushgroup:FlxGroup;
	var enemies:FlxGroup;
	var railshot_colliders:FlxGroup;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		FlxG.camera.bgColor = 0xff262626;
		
		FlxG.worldBounds.set(0, 0, tile_width * arena_width, tile_height * arena_height);
		
		Reg.gamestate = this;
		
		// create a few grasses in random positions
		for (x in 1...100) {
			add(new Grass(Math.floor(Math.random() * tile_width * arena_width), Math.floor(Math.random() * tile_height * arena_height), Math.random() > 0.6));
		}
		
		
		// generate level geometry
		// add the collidable level geometry/sprites first (always in background)
		tilemap = new FlxTilemap();
		var bmdata:String = FlxStringUtil.bitmapToCSV(Assets.getBitmapData("assets/images/arena2.png"));
		tilemap.loadMapFromCSV(bmdata, "assets/images/tiles.png", 64, 32);
		tilemap.setTileProperties(1, FlxObject.ANY);
		tilemap.visible = false;
		add(tilemap);
		Reg.tilemap = tilemap;
		
		// create trees where we have black tiles
		for (iy in 0...arena_height) {
			for (ix in 0...arena_width) {
				// if this tile is == "1', create a tree here
				if (tilemap.getTile(ix, iy) == 1) {
					var tree:Tree = new Tree();
					tree.SetPosition(ix * tile_width + MathHelper.RandomRangeInt(-3,3), iy * tile_height - 32);
					add(tree);
					Reg.trees[tree.id] = tree;
				}
			}
		}
		
		enemies = new FlxGroup();
		add(enemies);
		for (t in 0...10) {
			var enemy:Enemy = new Enemy();
			enemy.setposition(Math.floor(Math.random() * 600), Math.floor(Math.random() * 600));
			add(enemy);
			enemies.add(enemy.enemy_collider);
		}
		
		// create the monster and put him in the middle of the screen
		monster = new Monster();
		add(monster);
		monster.setposition(FlxG.width / 2, FlxG.height / 2);
		
		Reg.monster = monster;
		
		Reg.rails = new FlxGroup();
		Reg.rail_colliders = new FlxGroup();
		add(Reg.rails);
		add(Reg.rail_colliders);
		
		
		bushgroup = new FlxGroup();
		// walk list of trees in Reg
		for (key in Reg.trees.keys()) {
			bushgroup.add(Reg.trees[key].bush);
		}
		add(bushgroup);
		
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
		
		
		FlxG.collide(tilemap, monster.monster_collider);
		//FlxG.overlap(monster.monster_collider, bad_guys);
		FlxG.overlap(enemies, Reg.rail_colliders, enemy_hit);
		
		super.update(elapsed);
	}	
	
	public function enemy_hit(enemy:EnemyCollider, rail:RailshotCollider) {
		trace("enemy " + enemy.enemy_id + " hit by rail " + rail.id);
		enemy.visible = false;
	}
}