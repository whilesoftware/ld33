package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxStringUtil;
import flixel.FlxCamera.FlxCameraFollowStyle;
import openfl.Assets;
import flixel.util.FlxCollision;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;

/**
 * A FlxState which can be used for the game's menu.
 */
class GameState extends FlxState
{
	public var score:Int = 0;
	var title_text:FlxText;
	var instructions_text:FlxText;
	var score_text:FlxText;
	var gameover_text:FlxText;

	var monster:Monster;
	var tilemap:FlxTilemap;
	
	var tile_width:Int = 64;
	var tile_height:Int = 32;
	public var arena_width:Int = 16;
	public var arena_height:Int = 32;
	
	var spawn_points:Map<Int,FlxPoint> = new Map<Int,FlxPoint>();
	
	var bushgroup:FlxGroup;
	var enemies:FlxTypedGroup<Enemy>;
	var railshot_colliders:FlxGroup;
	
	var next_spawn_time:Int = -1;
	var next_spawn_count:Int = 1;
	var total_spawn_count:Int = 0;
	
	public var particle_group:FlxGroup;
	public var blood_group:FlxGroup;
	public var kill_particle_group:FlxGroup;
	
	static inline var pregame:Int = -1;
	static inline var playing:Int = 0;
	static inline var gameover:Int = 1;
	public var state:Int = -100;
	public var state_start_time:Int = 0;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();

		score = 0;
		//FlxG.camera.bgColor = 0xff262626;
		FlxG.camera.bgColor = 0xff5c5c5c;

		title_text = new FlxText(8*64-50,290,200,"Moster Garten", 16);
		instructions_text = new FlxText(10*64,700,300,"WASD + mouse - click to begin", 8);
		score_text = new FlxText(185 , 20, 300, "the score", 24);
		score_text.alignment = FlxTextAlign.CENTER;
		score_text.scrollFactor.set(0, 0);
		gameover_text = new FlxText(10*64,700,300,"das baby schlaft nicht");
		
		FlxG.worldBounds.set(0, 0, tile_width * arena_width, tile_height * arena_height);
		
		Reg.gamestate = this;
		
		Reg.frame_number = -1;
		Reg.trees = new Map<Int,Tree>();
		Reg.enemies = new Map<Int,Enemy>();
		
		next_spawn_count = 1;
		total_spawn_count = 0;
		
		spawn_points[0] = FlxPoint.get(5, 4);
		spawn_points[1] = FlxPoint.get(10, 4);
		spawn_points[2] = FlxPoint.get(1, 14);
		spawn_points[3] = FlxPoint.get(14, 14);
		spawn_points[4] = FlxPoint.get(5, 25);
		spawn_points[5] = FlxPoint.get(10, 25);
		spawn_points[6] = FlxPoint.get(7, 28);
		spawn_points[7] = FlxPoint.get(8, 28);
		
		for (key in spawn_points.keys()) {
			spawn_points[key].x *= tile_width;
			spawn_points[key].y *= tile_height;
		}
		
		blood_group = new FlxGroup();
		add(blood_group);
		
		kill_particle_group = new FlxGroup();
		add(kill_particle_group);
		
		// create a few grasses in random positions
		for (x in 1...500) {
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
					Reg.trees[iy * arena_width + ix] = tree;
				}
			}
		}
		
		enemies = new FlxTypedGroup<Enemy>();
		add(enemies);
		
		// create the monster and put him in the middle of the screen
		monster = new Monster();
		add(monster);
		monster.setposition(8*64 + 80,16*32);
		
		Reg.monster = monster;
		
		Reg.rails = new FlxGroup();
		Reg.rail_colliders = new FlxTypedGroup<RailshotCollider>();
		add(Reg.rails);
		add(Reg.rail_colliders);
		
		
		bushgroup = new FlxGroup();
		// walk list of trees in Reg
		for (key in Reg.trees.keys()) {
			bushgroup.add(Reg.trees[key].bush);
		}
		add(bushgroup);
		
		particle_group = new FlxGroup();
		add(particle_group);
		
		// tell the camera to follow the character
		FlxG.camera.follow(monster.monster_collider,FlxCameraFollowStyle.TOPDOWN,null,0.5);
		FlxG.camera.setScrollBoundsRect(0, 0, 32 * 32, 32 * 32);
		
		state = pregame;

		add(title_text);
		add(instructions_text);
		add(score_text);
		add(gameover_text);
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
		
		switch(state) {
			case pregame:
				// show the title screen
				title_text.visible = true;
				instructions_text.visible = true;
				score_text.visible = false;
				gameover_text.visible = false;
				
				if (FlxG.mouse.get_justPressed()) {
					state = playing;
					// spawn the first enemy in 30 frames (1/2 second)
					next_spawn_time = Reg.frame_number + 30;
					next_spawn_count = 1;
				}
				
			case playing:
				title_text.visible = false;
				instructions_text.visible = false;
				score_text.visible = true;
				score_text.text = Std.string(score);
				//score_text.x = monster.base_x;
				//score_text.y = monster.base_y - 30;
				gameover_text.visible = false;

				// update the score text

				// is it time to spawn a bad guy?
				if (Reg.frame_number == next_spawn_time) {
					for (t in 0...next_spawn_count) {
						var enemy:Enemy = new Enemy();
						var spawn_position:FlxPoint = spawn_points[MathHelper.RandomRangeInt(0, 7)];
						enemy.setposition(spawn_position.x, spawn_position.y);
						enemies.add(enemy);
						
						total_spawn_count++;
					}
					
					if (total_spawn_count > 50) {
						next_spawn_time = Reg.frame_number + 1 * 60;
						next_spawn_count = 5;
					}else if (total_spawn_count > 18) {
						next_spawn_time = Reg.frame_number + 3 * 60;
						next_spawn_count = 4;
					}else if (total_spawn_count > 8) {
						next_spawn_time = Reg.frame_number + 3 * 60;
						next_spawn_count = 3;
					}else if (total_spawn_count > 3) {
						next_spawn_time = Reg.frame_number + 5 * 60;
						next_spawn_count = 2;
					}else {
						next_spawn_count = 1;
						next_spawn_time = Reg.frame_number + 5 * 60;
					}
				}
				
				
				
			case gameover:
				title_text.visible = false;
				instructions_text.visible = false;
				score_text.visible = true;
				gameover_text.visible = true;
				// show the kill count
				
				// if they press "retry", reset the game
				if (FlxG.mouse.get_justPressed() && Reg.frame_number - state_start_time > 120) {
					FlxG.resetGame();
				}
		}
		
		if (FlxG.keys.anyPressed([FlxKey.R])) {
			FlxG.resetGame();
		}
		
		
		FlxG.collide(tilemap, monster.monster_collider);
		FlxG.collide(tilemap, enemies);
		FlxG.overlap(monster.monster_collider, enemies,kill_monster);
		//FlxG.overlap(monster.monster_collider, bad_guys);
		//FlxG.overlap(enemies, Reg.rail_colliders, enemy_hit);
		
		// check each railshot collider against each enemy
		// brute force. slow. i'm embarrassed. don't do this in production
		for (_enemy in enemies.members) {
			if (_enemy == null || !_enemy.alive) {
				continue;
			}
			for (_rail in Reg.rail_colliders.members) {
				if (_rail == null || !_rail.alive) {
					continue;
				}
				if (FlxCollision.pixelPerfectCheck(_rail, _enemy.chest)) {
					_enemy.hit(_rail.the_rail);
					
					// create one blood particle for every point of intensity in the rail
					for (count in 0..._rail.the_rail.power * 2) {
						var p:BloodParticle = new BloodParticle();
						blood_group.add(p);
						p.gobabygo(_enemy.base_x + 32, _enemy.base_y + 32, _rail.the_rail.direction.radians );
					}
				}
			}
		}
		
		super.update(elapsed);
	}	
	
	function kill_monster(a:FlxObject, b:FlxObject) {
		state = gameover;
		state_start_time = Reg.frame_number;
		
		monster.visible = false;
		monster.kill();
		for (count in 0...40) {
			var p:BloodParticle = new BloodParticle();
			blood_group.add(p);
			p.gobabygo(monster.base_x + 32, monster.base_y + 32, 0 );
			p = new BloodParticle();
			p.gobabygo(monster.base_x + 32, monster.base_y + 32, Math.PI/2 );
			blood_group.add(p);
			p = new BloodParticle();
			p.gobabygo(monster.base_x + 32, monster.base_y + 32, Math.PI );
			blood_group.add(p);
			p = new BloodParticle();
			p.gobabygo(monster.base_x + 32, monster.base_y + 32, 3*Math.PI/2 );
			blood_group.add(p);
			
			p = new BloodParticle();
			blood_group.add(p);
			p.gobabygo(monster.base_x + 32, monster.base_y + 32, 0 + Math.PI/4);
			p = new BloodParticle();
			p.gobabygo(monster.base_x + 32, monster.base_y + 32, Math.PI/2 + Math.PI/4 );
			blood_group.add(p);
			p = new BloodParticle();
			p.gobabygo(monster.base_x + 32, monster.base_y + 32, Math.PI + Math.PI/4 );
			blood_group.add(p);
			p = new BloodParticle();
			p.gobabygo(monster.base_x + 32, monster.base_y + 32, 3*Math.PI/2 + Math.PI/4 );
			blood_group.add(p);
			
		}
		
		// put all the enemies in celebration mode
		for (_enemy in enemies.members) {
			if (_enemy == null || !_enemy.alive) {
				continue;
			}
			_enemy.celebrate();
		}
	}
}
