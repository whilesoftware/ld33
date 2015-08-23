package;
import flixel.group.FlxGroup;

import flixel.util.FlxTimer;

import flixel.FlxSprite;

/**
 * ...
 * @author ...
 */
class Tree extends FlxGroup 
{
	var tree_collider:TreeCollider;
	
	private static var next_tree_id:Int = 0;
	
	var trunk:FlxSprite = new FlxSprite();
	public  var bush:FlxSprite = new FlxSprite();
	
	var base_x:Float;
	var base_y:Float;
	
	public var has_bush:Bool = true;
	
	public var id:Int = -1;
	
	var bush_cycle_offset:Int = 0;
	var bush_cycle:Float = 0;
	
	private static function get_new_jd():Int {
		var retval:Int = next_tree_id;
		next_tree_id++;
		return retval;
	}
	
	public function SetPosition(X:Float, Y:Float):Void {
		base_x = X;
		base_y = Y;
	}
	
	public function new() 
	{
		super();
		
		
		id = get_new_jd();
		
		tree_collider = new TreeCollider();
		tree_collider.tree_id = id;
		add(tree_collider);
		
		trunk.loadGraphic("assets/images/tree.png", true, 64, 64);
		trunk.animation.add("0", [0], 2, true);
		trunk.animation.add("1", [1], 2, true);
		trunk.animation.add("2", [2], 2, true);
		trunk.animation.add("3", [3], 2, true);
		trunk.solid = false;
		trunk.immovable = true;
		
		bush.loadGraphic("assets/images/tree.png", true, 64, 64);
		bush.animation.add("0", [8], 2, true);
		bush.animation.add("1", [9], 2, true);
		bush.animation.add("2", [12], 2, true);
		bush.animation.add("3", [13], 2, true);
		bush.solid = false;
		bush.immovable = true;
		
		add(trunk);
		// we don't add the bush here, the gamestate adds it later
		
		new FlxTimer().start(Math.random() * 0.1).onComplete = function(t:FlxTimer):Void {
			var val:Float = MathHelper.RandomRangeFloat(0, 1);
			if (val < 0.25) {
				bush.animation.play("0");
			}else if (val < 0.5) {
				bush.animation.play("1");
			}else if (val < 0.5) {
				bush.animation.play("2");
			}else{
				bush.animation.play("3");
			}
		}
		new FlxTimer().start(Math.random() * 0.1).onComplete = function(t:FlxTimer):Void {
			var val:Float = MathHelper.RandomRangeFloat(0, 1);
			if (val < 0.25) {
				trunk.animation.play("0");
			}else if (val < 0.5) {
				trunk.animation.play("1");
			}else if (val < 0.5) {
				trunk.animation.play("2");
			}else{
				trunk.animation.play("3");
			}
		}
		
		bush_cycle_offset = MathHelper.RandomRangeInt(0, 60);
		bush_cycle = MathHelper.RandomRangeFloat(0.01, 0.05);
	}
	
	public override function update(elapsed:Float):Void {
		// set position
		trunk.setPosition(base_x, base_y);
		
		
		// update visibility
		bush.set_visible(has_bush);
		
		if (has_bush) {
			// animate the bush
			bush.setPosition(base_x + 3 * Math.cos((Reg.frame_number + bush_cycle_offset) * bush_cycle), base_y);
		}
		
		super.update(elapsed);
	}
	
}
