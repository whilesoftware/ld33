package;

/**
 * ...
 * @author ...
 */
class MathHelper 
{
	public static function RandomRangeFloat(min:Float, max:Float) {
		return Math.random() * (max - min) + min;
	}
	
	public static function RandomRangeInt(min:Int, max:Int) {
		return Math.round(Math.random() * (max - min)) + min;
	}
	
}