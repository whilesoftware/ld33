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
	}
	
	public function SpawnSome(n:Int, x:Float, y:Float):Void {
		for (count in 0...n) {
			var p:ChargeParticle = new ChargeParticle(this);//recycle();//getFirstAvailable();
			add(p);
			p.gobabygo(x, y);
		}
	}
	
}