package;
import flixel.group.FlxGroup;
import flixel.util.FlxTimer;
/**
 * ...
 * @author ...
 */
class EnemySpawner extends FlxGroup
{
	var start_time:Int = 0;
	var particle_timeout:Int = 100;
	var base_x:Float;
	var base_y:Float;

	public function new() 
	{
		super();
	}
	
	public function begin(_x:Float, _y:Float) {
		start_time = Reg.frame_number;
		
		base_x = _x;
		base_y = _y;
		
		// when the effect is almost over, create the actual enemy
		new FlxTimer().start(particle_timeout / 60).onComplete = function(t:FlxTimer):Void {
			var enemy:Enemy = new Enemy();
			enemy.setposition(_x, _y);
			Reg.gamestate.enemies.add(enemy);
			
			kill();
			Reg.gamestate.spawn_particle_group.remove(this);
		}
		
	}
	
	public override function update(elapsed:Float):Void {
		if (Reg.frame_number < start_time + particle_timeout) {
			var p:SpawnParticle = new SpawnParticle();
			add(p);
			p.gobabygo(base_x + 32, base_y + 32, MathHelper.RandomRangeFloat(0,Math.PI * 2));
		}
	}
}