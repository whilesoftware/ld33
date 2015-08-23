package;
import flixel.group.FlxGroup;
import flixel.FlxSprite;

import flixel.util.FlxTimer;
/**
 * ...
 * @author ...
 */
class Enemy extends FlxGroup 
{
	public var enemy_collider:EnemyCollider;
	
	private static var next_enemy_id:Int = 0;
	
	var mouth:FlxSprite = new FlxSprite();
	var chest:FlxSprite = new FlxSprite();
	var left_leg:FlxSprite = new FlxSprite();
	var right_leg:FlxSprite = new FlxSprite();
	var left_arm:FlxSprite = new FlxSprite();
	var right_arm:FlxSprite = new FlxSprite();
	
	var base_x:Float;
	var base_y:Float;
	
	public var id:Int = -1;
	
	private static function get_new_jd():Int {
		var retval:Int = next_enemy_id;
		next_enemy_id++;
		return retval;
	}
	
	public function new() 
	{
		super();
		
		id = get_new_jd();
		
		enemy_collider = new EnemyCollider();
		enemy_collider.enemy_id = id;
		//add(enemy_collider);
		
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
		
		enemy_collider.setPosition(base_x, base_y);
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
		/*
		if (h_move_direction != 0 || v_move_direction != 0) {
			// we are walking in some direction
			left_leg_pos.x += 1.1 * ((Reg.frame_number % 8) - 3.5);
			right_leg_pos.x += 1.1 * (((Reg.frame_number + 4) % 8) - 3.5);
		}else {
			// we are not walking
		}
		*/
		
		// finally, apply the new positions to each body part
		mouth.setPosition(mouth_pos.x, mouth_pos.y);
		chest.setPosition(chest_pos.x, chest_pos.y);
		left_leg.setPosition(left_leg_pos.x, left_leg_pos.y);
		right_leg.setPosition(right_leg_pos.x, right_leg_pos.y);
		left_arm.setPosition(left_arm_pos.x, left_arm_pos.y);
		right_arm.setPosition(right_arm_pos.x, right_arm_pos.y);
	}
	
	public function move():Void {
	}
	
	public function gather_input():Void {
	}
	
	public function act() {
		
	}
	
	public override function update(elapsed:Float) {
		base_x = enemy_collider.x;
		base_y = enemy_collider.y;
		
		gather_input();
		
		move();
		
		animate();
		
		act();
		
		super.update(elapsed);
		
		//TODO - on death remove these from the Mainstate's enemies group
	}
	
}