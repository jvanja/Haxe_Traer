package traer.physics;

/**
 * ...
 * @author Vanja Jelic
 */
import geom.Vector3D;

class Spring implements Force
{
	private var a					:Particle;
	private var b					:Particle;
	
	private var springConstant		:Float; //ks
	
	private var damping				:Float;
	private var restLength			:Float;
	
	private var on					:Bool;
	
	public function new(a:Particle, b:Particle, springConstant:Float, damping:Float, restLength:Float) 
	{
		this.a 					= a;
		this.b					= b;
		this.springConstant		= springConstant;
		this.damping			= damping;
		this.restLength			= restLength;
		on = true;
	}
	
	public function turnOn():Void {
		on = true;
	}
	
	public function turnOff():Void {
		on = false;
	}
	
	public function isOn():Bool {
		return on;
	}
	
	public function isOff():Bool {
		return !on;
	}
	
	public function currentLength():Float {
		return Vector3D.distance(a.position, b.position);
	}
	
	public function getStrength():Float {
		return springConstant;
	}
	
	public function setStrength(ks:Float):Void {
		springConstant = ks;
	}
	
	public function getDamping():Float {
		return damping;
	}
	
	public function setDamping(d:Float):Void {
		damping = d;
	}
	
	public function getRestLength():Float {
		return restLength;
	}
	
	public function setRestLength(l:Float):Void {
		restLength = l;
	}
	
	public function setA(p:Particle):Void {
		a = p;
	}
	
	public function setB(p:Particle):Void {
		b = p;
	}
	
	public function getOneEnd():Particle {
		return a;
	}
	
	public function getTheOtherEnd():Particle {
		return b;
	}
	
	public function apply():Void {

		if ( on && ( a.isFree() || b.isFree() ) ) {

			var a2bX:Float = a.position.x - b.position.x;
			var a2bY:Float = a.position.y - b.position.y;
			var a2bZ:Float = a.position.z - b.position.z;
			
			var a2bDistance:Float = Math.sqrt(a2bX*a2bX + a2bY*a2bY + a2bZ*a2bZ);
			
			if (a2bDistance == 0) {
				
				a2bX = 0;
				a2bY = 0;
				a2bZ = 0;
				
			} else {
				
				a2bX /= a2bDistance;
				a2bY /= a2bDistance;
				a2bZ /= a2bDistance;
				
			}
			
			var springForce:Float = -( a2bDistance - restLength ) * springConstant;
			
			var Va2bX:Float = a.velocity.x - b.velocity.x;
			var Va2bY:Float = a.velocity.y - b.velocity.y;
			var Va2bZ:Float = a.velocity.z - b.velocity.z;
			
			var dampingForce:Float = -damping * ( a2bX*Va2bX + a2bY*Va2bY + a2bZ*Va2bZ );
			var r:Float = springForce + dampingForce;
			
			a2bX *= r;
			a2bY *= r;
			a2bZ *= r;

			if (a.isFree()) a.force = a.force.add( new Vector3D(a2bX, a2bY, a2bZ) );
			if (b.isFree()) b.force = b.force.add( new Vector3D(-a2bX, -a2bY, -a2bZ) );

		}
	}
	
}

