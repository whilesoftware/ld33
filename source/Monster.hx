package;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.input.keyboard.FlxKey;
#if not mac
import lime.math.Vector2;
#end

import flixel.math.FlxVector;

/**
 * ...
 * @author ...
 */
class Monster extends FlxGroup
{
	public var monster_collider:MonsterCollider;
	var monster_collider_offset_x:Int = 16;
	var monster_collider_offset_y = 42;
	
	var mouse_offset:Vector2 = new Vector2();
	
	var charge_effect:ChargeEffect;
	
	var offset_x:Int = 33;
	var offset_y:Int = 37;
	
	var eye:FlxSprite = new FlxSprite();
	var pupil:FlxSprite = new FlxSprite();
	var chest:FlxSprite = new FlxSprite();
	var left_leg:FlxSprite = new FlxSprite();
	var right_leg:FlxSprite = new FlxSprite();
	
	var shadow:FlxSprite = new FlxSprite();
	
	public var base_x:Float;
	public var base_y:Float;
	
	var LEFT:Int = -1;
	var RIGHT:Int = 1;
	var UP:Int = -1;
	var DOWN:Int = 1;
	var h_move_direction:Int = 0;
	var v_move_direction:Int = 0;
	
	var h_move_speed:Float = 1;
	var v_move_speed:Float = 1;
	
	var active_h_speed:Float = 0;
	var active_v_speed:Float = 0;
	
	var is_crouching:Bool = false;
	var crouch_start_time:Int = -1;
	
	var is_charging:Bool = false;
	var charge_start_time:Int = -1;
	
	var fire_weapon:Bool = false;
	
	public function new() 
	{
		super();
		
		//trace("new monster!");
		
		monster_collider = new MonsterCollider();
		add(monster_collider);
		
		charge_effect = new ChargeEffect();
		add(charge_effect);
		
		shadow.loadGraphic("assets/images/shadow.png", false, 64, 64);
		shadow.solid = false;
		shadow.immovable = true;
		
		eye.loadGraphic("assets/images/monster-spritesheet.png", true, 64, 64);
		eye.animation.add("cycle", [12, 13, 14, 15], 10, true);
		eye.solid = false;
		eye.immovable = true;
		
		pupil.loadGraphic("assets/images/monster-spritesheet.png", true, 64, 64);
		pupil.animation.add("throb", [16, 17, 18, 19, 18, 17], 10, true);
		pupil.animation.add("0", [16], 1, false);
		pupil.animation.add("1", [17], 1, false);
		pupil.animation.add("2", [18], 1, false);
		pupil.animation.add("3", [19], 1, false);
		pupil.solid = false;
		pupil.immovable = true;
		
		
		chest.loadGraphic("assets/images/monster-spritesheet.png", true, 64, 64);
		chest.animation.add("cycle", [8, 9, 10, 11/*,9,8,11,10*/], 10, true);
		chest.solid = false;
		chest.immovable = true;
		
		
		left_leg.loadGraphic("assets/images/monster-spritesheet.png", true, 64, 64);
		left_leg.animation.add("cycle", [0, 1, 2, 3/*, 1, 0, 3, 2, 2, 0, 1, 3*/], 10, true);
		left_leg.solid = false;
		left_leg.immovable = true;
		
		right_leg.loadGraphic("assets/images/monster-spritesheet.png", true, 64, 64);
		right_leg.animation.add("cycle", [4, 5, 6, 7/*, 5, 7, 4, 6, 7, 4, 6, 5, 4, 7, 5, 6*/], 10, true);
		right_leg.solid = false;
		right_leg.immovable = true;
		
		add(shadow);
		add(left_leg);
		add(right_leg);
		add(chest);
		add(eye);
		add(pupil);
		
		new FlxTimer().start(Math.random() * 0.1).onComplete = function(t:FlxTimer):Void {
			eye.animation.play("cycle");
		}
		new FlxTimer().start(Math.random() * 0.1).onComplete = function(t:FlxTimer):Void {
			pupil.animation.play("0");
		}
		new FlxTimer().start(Math.random() * 0.1).onComplete = function(t:FlxTimer):Void {
			chest.animation.play("cycle");
		}
		new FlxTimer().start(Math.random() * 0.1).onComplete = function(t:FlxTimer):Void {
			left_leg.animation.play("cycle");
		}
		new FlxTimer().start(Math.random() * 0.1).onComplete = function(t:FlxTimer):Void {
			right_leg.animation.play("cycle");
		}
		
		
	}
	
	public function setposition(x:Float, y:Float) {
		base_x = x;
		base_y = y;
		
		monster_collider.setPosition(base_x + monster_collider_offset_x, base_y + monster_collider_offset_y);
	}
	
	public function animate():Void {
		// set the base position for each body part
		var eye_pos:Vector2 = new Vector2(base_x, base_y);
		var pupil_pos:Vector2 = new Vector2(base_x, base_y);
		var chest_pos:Vector2 = new Vector2(base_x, base_y);
		var left_leg_pos:Vector2 = new Vector2(base_x, base_y);
		var right_leg_pos:Vector2 = new Vector2(base_x, base_y);
		
		// shadow is always static
		shadow.setPosition(base_x, base_y);
		
		// set offset of each body part to further animate
		// walk cycle (bounces up and down, feet shuffle left/right)
		var bounce_offset:Vector2 = new Vector2(0, 0);
		
		// walking?
		if (h_move_direction != 0 || v_move_direction != 0) {
			// we are walking in some direction
			left_leg_pos.x += 1.1 * ((Reg.frame_number % 8) - 3.5);
			right_leg_pos.x += 1.1 * (((Reg.frame_number + 4) % 8) - 3.5);
			
			bounce_offset.y = Math.sin(Reg.frame_number / 5 * Math.PI);
		}else {
			// we are not walking
			bounce_offset.y = Math.sin(Reg.frame_number / 60 * Math.PI);
		}
		
		eye_pos.y += bounce_offset.y;
		pupil_pos.y += bounce_offset.y;
		chest_pos.y += bounce_offset.y;
		
		// eyes point towards the mouse cursor
		mouse_offset.x = FlxG.mouse.getWorldPosition().x;
		mouse_offset.y = FlxG.mouse.getWorldPosition().y;
		mouse_offset.x -= (base_x + 33);
		mouse_offset.y -= (base_y + 37);
		
		if (mouse_offset.x == 0 && mouse_offset.y == 0) {
			// mouse is directly over the player. pupil stays in the center
		}else {
			mouse_offset.normalize(1);
			// pupil should point towards the mouse
			pupil_pos.x += mouse_offset.x * 4;
			pupil_pos.y += mouse_offset.y * 4;
		}
		
		//pupil_pos.x += h_move_direction * 3;
		//pupil_pos.y += v_move_direction * 3;
		
		// crouch? move upper body down
		if (is_crouching) {
			var crouch_distance:Float = 6;
			eye_pos.y += crouch_distance;
			pupil_pos.y += crouch_distance;
			chest_pos.y += crouch_distance;
		}
		
		// charging? generate some charge particles
		if (is_charging) {
			charge_effect.SpawnSome(2, base_x + offset_x, base_y + offset_y);
			
			// the pupil gets bigger as we charge longer
			var ctime:Float = (Reg.frame_number - charge_start_time) / 60;
			if (ctime < 0.15) {
				pupil.animation.play("0");
			}else if (ctime < 0.3) {
				pupil.animation.play("1");
			}else if (ctime < 0.45) {
				pupil.animation.play("2");
			}else {
				pupil.animation.play("3");
			}
		}else {
			// set the eyes to their default state
			pupil.animation.play("0");
		}
		
		
		
		
		// finally, apply the new positions to each body part
		eye.setPosition(eye_pos.x, eye_pos.y);
		pupil.setPosition(pupil_pos.x, pupil_pos.y);
		chest.setPosition(chest_pos.x, chest_pos.y);
		left_leg.setPosition(left_leg_pos.x, left_leg_pos.y);
		right_leg.setPosition(right_leg_pos.x, right_leg_pos.y);
	}
	
	public function move():Void {
		active_h_speed = h_move_speed * h_move_direction;
		active_v_speed = v_move_speed * v_move_direction;
		
		if (h_move_direction != 0 && v_move_direction == 0) {
			active_h_speed *= 1.41;
		}
		if (v_move_direction != 0 && h_move_direction == 0) {
			active_v_speed *= 1.2;
		}
		
		if (is_crouching) {
			active_h_speed /= 2;
			active_v_speed /= 2;
		}
		
		//base_x += active_h_speed;
		//base_y += active_v_speed;
		monster_collider.velocity.x = active_h_speed * 100;
		monster_collider.velocity.y = active_v_speed * 100;
		
		//trace("monster - moving at speed: " + active_h_speed + " " + active_v_speed);
	}
	
	public function gather_input():Void {
		h_move_direction = 0;
		v_move_direction = 0;
		
		// get input
		if (FlxG.keys.anyPressed([FlxKey.A, FlxKey.LEFT])) {
			h_move_direction = LEFT;
		}else if (FlxG.keys.anyPressed([FlxKey.D, FlxKey.RIGHT])) {
			h_move_direction = RIGHT;
		}
		if (FlxG.keys.anyPressed([FlxKey.W, FlxKey.UP])) {
			v_move_direction = UP;
		}else if (FlxG.keys.anyPressed([FlxKey.S, FlxKey.DOWN])) {
			v_move_direction = DOWN;
		}
		
		if (FlxG.keys.anyJustPressed([FlxKey.SPACE])) {
			is_crouching = true;
			crouch_start_time = Reg.frame_number;
		}
		
		if (FlxG.keys.anyJustReleased([FlxKey.SPACE])) {
			is_crouching = false;
		}
		
		if (FlxG.mouse.justPressed) {
			is_charging = true;
			charge_start_time = Reg.frame_number;
		}
		
		if (FlxG.mouse.justReleased && is_charging && alive) {
			is_charging = false;
			fire_weapon = true;
			//trace("mouse just released!");
		}
	}
	
	public function act() {
		if (fire_weapon) {
			fire_weapon = false;
			// fire the gun
			var new_rail:Railshot = new Railshot();
			Reg.rails.add(new_rail);
			
			if (mouse_offset.x == 0 && mouse_offset.y == 0) {
				mouse_offset.y = 1;
			}
			
			var startpos:FlxPoint = 
				new FlxPoint(base_x + offset_x + mouse_offset.x * 20, base_y + offset_y - 3 + mouse_offset.y * 16);
				//new FlxPoint(base_x + offset_x, base_y + offset_y);
				
			var endpos:FlxPoint = new FlxPoint(startpos.x, startpos.y);
			endpos.x += mouse_offset.x * 1000;
			endpos.y += mouse_offset.y * 1000;
			var rayresult:FlxPoint = new FlxPoint();
			
			//trace("basepos: " + base_x + " - " + base_y);
			//trace("startpos: " + startpos.toString());
			//trace("endpos: " + endpos.toString());
			
			
			// where is this going to strike?
			var tree:Tree = null;
			if (! Reg.tilemap.ray(startpos, endpos, rayresult)) {
				endpos = rayresult;
				
				// what tree is that going to hit?
				var remainder:Int;
				var xindex:Int = Math.floor(endpos.x / 64);
				
				remainder = Math.round(endpos.x) % 64;
				if (mouse_offset.x < 0 && remainder < 10) {
					xindex--;
				}
				if (mouse_offset.x > 0 && remainder > 50) {
					xindex++;
				}
				
				
				
				var yindex:Int = Math.floor(endpos.y / 32);
				
				remainder = Math.round(endpos.y) % 32;
				if (mouse_offset.y > 0 && remainder > 25) {
					yindex++;
				}
				if (mouse_offset.y < 0 && remainder < 6) {
					yindex--;
				}
				
				//trace(xindex + " - " + yindex);
				
				tree = Reg.trees[yindex * Reg.gamestate.arena_width + xindex];
				
				
			}else {
				return;	
			}
			
			var rail_vector:FlxVector = new FlxVector(endpos.x - startpos.x, endpos.y - startpos.y);
			
			var intensity:Float = Math.min(1, (Reg.frame_number - charge_start_time) / 30);
			
			new_rail.gogogo(startpos.x, startpos.y, rail_vector.radians, rail_vector.length, mouse_offset.x, mouse_offset.y, intensity, rail_vector); 
			
			FlxG.camera.shake(0.005 * intensity, 0.2);
			FlxG.camera.flash(0x66ffffff, 0.02 * intensity);
			
			rail_vector.normalize();
			monster_collider.physics.x += -rail_vector.x * 1000 * intensity;
			monster_collider.physics.y += -rail_vector.y * 1000 * intensity;
			
			if (tree != null) {
				if (intensity > 0.5) {
				tree.blowup(rail_vector.radians);
			}else {
				tree.shake();
			}
			}
			
		}
	}
	
	public override function update(elapsed:Float) {
		super.update(elapsed);
		
		base_x = monster_collider.x - monster_collider_offset_x;
		base_y = monster_collider.y - monster_collider_offset_y;
		
		gather_input();
		
		move();
		
		animate();
		
		act();
	}
}
