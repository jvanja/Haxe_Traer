package traer.physics;

/**
 * ...
 * @author Vanja Jelic
 */
import geom.Vector3D;

class Attraction implements Force
{
	private var a					:Particle;
	private var b					:Particle;
	
	private var strength			:Float; //k

	private var minDistance			:Float; //set to private as squared needs to be updated at the same time
	private var minDistanceSquared	:Float;

	private var on					:Bool;


	public function new(a:Particle, b:Particle, strength:Float, minDistance:Float) 
	{		
		this.a						= a;
		this.b						= b;
		this.strength				= strength;
		
		on							= true;
		
		this.minDistance			= minDistance;
		this.minDistanceSquared		= minDistance*minDistance;
		
	}
	
	public function getMinimumDistance():Float {
		return minDistance;
	}
	
	public function setMinimumDistance(d:Float):Void {
		minDistance = d;
		minDistanceSquared = d*d;
	}
	
	public  function turnOn():Void {
		on = true;
	}
	
	public  function turnOff():Void {
		on = false;
	}
	
	public  function isOn():Bool {
		return on;
	}
	
	public  function isOff():Bool {
		return !on;
	}
	
	public  function getStrength():Float {
		return strength;
	}
	
	public  function setStrength(k:Float):Void {
		strength = k;
	}
	
	public function setA(p:Particle):Void {
		a = p;
	}
	
	public function setB(p:Particle):Void {
		b = p;
	}
	
	public  function getOneEnd():Particle {
		return a;
	}
	
	public function getTheOtherEnd():Particle {
		return a;
	}
	
	public function apply():Void {
		
		if ( on && ( a.isFree() || b.isFree() ) ) {
			
			var a2bX:Float = a.position.x - b.position.x;
			var a2bY:Float = a.position.y - b.position.y;
			var a2bZ:Float = a.position.z - b.position.z;

			var a2bDistanceSquared:Float = a2bX*a2bX + a2bY*a2bY + a2bZ*a2bZ;

			if ( a2bDistanceSquared < minDistanceSquared ) a2bDistanceSquared = minDistanceSquared;

			var force:Float = strength * a.mass * b.mass / a2bDistanceSquared;

			var length:Float = Math.sqrt( a2bDistanceSquared );

			a2bX /= length;
			a2bY /= length;
			a2bZ /= length;
			
			a2bX *= force;
			a2bY *= force;
			a2bZ *= force;

			if (a.isFree()) a.force = a.force.add( new Vector3D(-a2bX, -a2bY, -a2bZ) );
			if (b.isFree()) b.force = b.force.add( new Vector3D(a2bX, a2bY, a2bZ) );

		}
		
	}
	
}
	
