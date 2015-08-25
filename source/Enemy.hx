package;
import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;

import flixel.util.FlxTimer;
/**
 * ...
 * @author ...
 */
class Enemy extends FlxGroup 
{
	public var enemy_collider:EnemyCollider;
	
	private static var next_enemy_id:Int = 0;
	
	public var  health:Int = 20;
	
	var mouth:FlxSprite = new FlxSprite();
	public var chest:FlxSprite = new FlxSprite();
	var left_leg:FlxSprite = new FlxSprite();
	var right_leg:FlxSprite = new FlxSprite();
	var left_arm:FlxSprite = new FlxSprite();
	var right_arm:FlxSprite = new FlxSprite();
	
	public var base_x:Float;
	public var base_y:Float;
	
	public var id:Int = -1;
	
	var next_pathfind_time:Int = 0;
	var pathfind_timeout:Int = 60;
	
	var the_path:Array<FlxPoint> = null;
	var cpath_index:Int = -1;
	
	var h_move_direction:Float = 0;
	var v_move_direction:Float = 0;
	var h_move_speed:Float = 1;
	var v_move_speed:Float = 1;
	var active_h_speed:Float = 0;
	var active_v_speed:Float = 0;
	
	var enemy_collider_offset_x:Int = 16;
	var enemy_collider_offset_y:Int = 40;
	
	private static function get_new_jd():Int {
		var retval:Int = next_enemy_id;
		next_enemy_id++;
		return retval;
	}
	
	public function new() 
	{
		super();
		
		pathfind_timeout += MathHelper.RandomRangeInt( -5, 60);
		next_pathfind_time = Reg.frame_number + pathfind_timeout;
		
		id = get_new_jd();
		
		enemy_collider = new EnemyCollider();
		enemy_collider.enemy_id = id;
		add(enemy_collider);
		
		chest.loadGraphic("assets/images/YV.png", true, 64, 64);
		chest.animation.add("cycle", [24, 25, 26, 27], 10, true);
		chest.solid = false;
		chest.immovable = true;
		
		mouth.loadGraphic("assets/images/YV.png", true, 64, 64);
		mouth.animation.add("cycle", [28, 29, 30, 31], 10, true);
		mouth.solid = false;
		mouth.immovable = true;
		
		left_leg.loadGraphic("assets/images/YV.png", true, 64, 64);
		left_leg.animation.add("cycle", [0, 1, 2, 3], 10, true);
		left_leg.solid = false;
		left_leg.immovable = true;
		
		right_leg.loadGraphic("assets/images/YV.png", true, 64, 64);
		right_leg.animation.add("cycle", [4, 5, 6, 7], 10, true);
		right_leg.solid = false;
		right_leg.immovable = true;
		
		left_arm.loadGraphic("assets/images/YV.png", true, 64, 64);
		left_arm.animation.add("cycle", [16, 17, 18, 19], 10, true);
		left_arm.animation.add("cycle2", [20, 21, 22, 23], 10, true);
		left_arm.solid = false;
		left_arm.immovable = true;
		
		right_arm.loadGraphic("assets/images/YV.png", true, 64, 64);
		right_arm.animation.add("cycle", [8, 9, 10, 11], 10, true);
		right_arm.animation.add("cycle2", [12, 13, 14, 15], 10, true);
		right_arm.solid = false;
		right_arm.immovable = true;
		
		add(left_leg);
		add(right_leg);
		add(chest);
		add(left_arm);
		add(right_arm);
		add(mouth);
		
		new FlxTimer().start(Math.random() * 0.1).onComplete = function(t:FlxTimer):Void {
			chest.animation.play("cycle");
		}
		new FlxTimer().start(Math.random() * 0.1).onComplete = function(t:FlxTimer):Void {
			mouth.animation.play("cycle");
		}
		new FlxTimer().start(Math.random() * 0.1).onComplete = function(t:FlxTimer):Void {
			left_arm.animation.play("cycle");
		}
		new FlxTimer().start(Math.random() * 0.1).onComplete = function(t:FlxTimer):Void {
			right_arm.animation.play("cycle");
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
		
		enemy_collider.setPosition(base_x + enemy_collider_offset_x, base_y + enemy_collider_offset_y);
	}
	
	public function animate():Void {
		// set the base position for each body part
		var mouth_pos:Vector2 = new Vector2(base_x, base_y);
		var chest_pos:Vector2 = new Vector2(base_x, base_y);
		var left_leg_pos:Vector2 = new Vector2(base_x, base_y);
		var right_leg_pos:Vector2 = new Vector2(base_x, base_y);
		var left_arm_pos:Vector2 = new Vector2(base_x, base_y);
		var right_arm_pos:Vector2 = new Vector2(base_x, base_y);
		
		
		
		// set offset of each body part to further animate
		// walk cycle (bounces up and down, feet shuffle left/right)
		
		
		
		
		// walking?
		if (h_move_direction != 0 || v_move_direction != 0) {
			// we are walking in some direction
			left_leg_pos.x += 1.1 * ((Reg.frame_number % 8) - 3.5);
			right_leg_pos.x += 1.1 * (((Reg.frame_number + 4) % 8) - 3.5);
		}else {
			// we are not walking
		}
		
		
		// finally, apply the new positions to each body part
		mouth.setPosition(mouth_pos.x, mouth_pos.y);
		chest.setPosition(chest_pos.x, chest_pos.y);
		left_leg.setPosition(left_leg_pos.x, left_leg_pos.y);
		right_leg.setPosition(right_leg_pos.x, right_leg_pos.y);
		left_arm.setPosition(left_arm_pos.x, left_arm_pos.y);
		right_arm.setPosition(right_arm_pos.x, right_arm_pos.y);
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
		
		active_h_speed *= 1.5;
		active_v_speed *= 1.5;
		
		//base_x += active_h_speed;
		//base_y += active_v_speed;
		enemy_collider.velocity.x = active_h_speed * 100;
		enemy_collider.velocity.y = active_v_speed * 100;
		
		//trace("enemy -   moving at speed: " + active_h_speed + " " + active_v_speed);
	}
	
	public function gather_input():Void {
		if (next_pathfind_time >= Reg.frame_number) {
			next_pathfind_time = Reg.frame_number + pathfind_timeout;
			
			// pick ourselves a path
			if (Reg.monster.alive) {
				the_path = Reg.tilemap.findPath(FlxPoint.get(base_x + 32, base_y + 42), FlxPoint.get(Reg.monster.base_x + 32, Reg.monster.base_y + 42));
			}else{
				the_path = null;
			}

			
			cpath_index = -1;
		}
		
		if (the_path == null) {
			// don't move
			h_move_direction = 0;
			v_move_direction = 0;
		}else {
			var waypoint:FlxPoint = the_path[cpath_index + 1];
			waypoint.x -= 32;
			waypoint.y -= 42;
			var _path:FlxVector = new FlxVector(waypoint.x - base_x, waypoint.y - base_y);
			
			// if we're within a few pixels of the waypoint, move on to the next one
			if (_path.length < 5) {
				cpath_index++;
				if (cpath_index >= the_path.length-1) {
					//trace("reached the end of the path! no more moving for me");
					h_move_direction = 0;
					v_move_direction = 0;
					return;
				}else{
					waypoint = the_path[cpath_index + 1];
					waypoint.x -= 32;
					waypoint.y -= 42;
					_path = new FlxVector(waypoint.x - base_x, waypoint.y - base_y);
				}
			}
			
			// move towards the next waypoint
			_path.normalize();
			h_move_direction = _path.x;
			v_move_direction = _path.y;
		}
	}
	
	public function act() {
		
	}
	public function hit(the_rail:Railshot) {
		health -= the_rail.power;
		
		// push them back in the direction the rail was fired
		enemy_collider.physics.x = the_rail.direction.x * the_rail.power * 100;
		enemy_collider.physics.y = the_rail.direction.y * the_rail.power * 100;
		
		if (health <= 0) {
			die();
		}
	}
	public function die() {
		//trace("enemy died! " + id);
		Reg.gamestate.score++;
		kill();
	}
	
	public override function update(elapsed:Float) {
		base_x = enemy_collider.x - enemy_collider_offset_x;
		base_y = enemy_collider.y - enemy_collider_offset_y;
		
		gather_input();
		
		move();
		
		animate();
		
		act();
		
		super.update(elapsed);
		
		//TODO - on death remove these from the Mainstate's enemies group
	}
	
}
