package;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.input.keyboard.FlxKey;
import lime.math.Vector2;

/**
 * ...
 * @author ...
 */
class Monster extends FlxGroup
{
	var eye:FlxSprite = new FlxSprite();
	var pupil:FlxSprite = new FlxSprite();
	var chest:FlxSprite = new FlxSprite();
	var left_leg:FlxSprite = new FlxSprite();
	var right_leg:FlxSprite = new FlxSprite();
	
	var base_x:Float;
	var base_y:Float;
	
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
	
	public function new() 
	{
		super();
		
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
	}
	
	public function animate():Void {
		// set the base position for each body part
		var eye_pos:Vector2 = new Vector2(base_x, base_y);
		var pupil_pos:Vector2 = new Vector2(base_x, base_y);
		var chest_pos:Vector2 = new Vector2(base_x, base_y);
		var left_leg_pos:Vector2 = new Vector2(base_x, base_y);
		var right_leg_pos:Vector2 = new Vector2(base_x, base_y);
		
		
		
		// set offset of each body part to further animate
		// walk cycle (bounces up and down, feet shuffle left/right)
		
		// eyes point towards the mouse cursor
		var mouse_offset:Vector2 = new Vector2(FlxG.mouse.getWorldPosition().x, FlxG.mouse.getWorldPosition().y);
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
		
		// walking?
		if (h_move_direction != 0 || v_move_direction != 0) {
			// we are walking in some direction
			left_leg_pos.x += 1.1 * ((Reg.frame_number % 8) - 3.5);
			right_leg_pos.x += 1.1 * (((Reg.frame_number + 4) % 8) - 3.5);
		}else {
			// we are not walking
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
		
		base_x += active_h_speed;
		base_y += active_v_speed;
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
	}
	
	public override function update(elapsed:Float) {
		gather_input();
		
		move();
		
		animate();
		
		super.update(elapsed);
	}
}