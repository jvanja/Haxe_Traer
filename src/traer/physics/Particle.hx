package traer.physics;

/**
 * ...
 * @author Vanja Jelic
 */
import geom.Vector3D;
 
class Particle 
{
	public var position	:Vector3D;
	public var velocity	:Vector3D;
	public var force	:Vector3D;
	public var mass		:Float;
	public var age		:Float;
	public var fixed	:Bool;

	public var dead		:Bool;

	public function new(mass:Float, position:Vector3D = null) 
	{
		this.mass	= mass;

		this.position	= (position != null) ? position : new Vector3D();
		
		velocity	= new Vector3D();
		force		= new Vector3D();

		fixed		= false;
		age			= 0;
		dead		= false;
	}

	public function distanceTo(p:Particle):Float 
	{
		return Vector3D.distance(this.position, p.position);
	}

	public function makeFixed():Void 
	{
		fixed = true;
		velocity.x = 0; velocity.y = 0; velocity.z = 0;
	}

	public function makeFree():Void 
	{
		fixed = false;
	}

	public function isFixed():Bool 
	{
		return fixed;
	}

	public function isFree():Bool 
	{
		return !fixed;
	}

	public function setMass(m:Float):Void 
	{
		mass = m;
	}

	private function reset():Void 
	{
		age = 0;
		dead = false;
		position.x	= 0; position.y	= 0; position.z	= 0;
		velocity.x	= 0; velocity.y	= 0; velocity.z	= 0;
		force.x		= 0; force.y	= 0; force.z	= 0;
		mass = 1;
	}

	public function toString():String
	{
		return ("[object Particle]\tm:" + mass + " [" + position.x + ", " + position.y + ", " + position.z +"]");
	}
	

}
