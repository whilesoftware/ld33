package;
import flixel.group.FlxGroup.FlxTypedGroup;

/**
 * ...
 * @author ...
 */
class ChargeEffect extends FlxTypedGroup<ChargeParticle> 
{

	public function new() 
	{
		super();
		/*
		for (i in 0...100) {
			var p:ChargeParticle = new ChargeParticle();
			p.kill();
			add(p);
		}
		*/
	}
	
	public function SpawnSome(n:Int, x:Float, y:Float):Void {
		for (count in 0...n) {
			var p:ChargeParticle = new ChargeParticle(this);//recycle();//getFirstAvailable();
			add(p);
			p.gobabygo(x, y);
		}
	}
	
}