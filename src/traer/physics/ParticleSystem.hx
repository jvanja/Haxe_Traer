package traer.physics;

/**
 * ...
 * @author Vanja Jelic
 */

import geom.Vector3D;

class ParticleSystem 
{
	public static var RUNGE_KUTTA		:Int;
	public static var MODIFIED_EULER	:Int;
	
	private var integrator				:Integrator;
	
	public var gravity					:Vector3D;
	public var drag						:Float;
	
	public var particles				:Array<Particle>;
	private var springs				:Array<Spring>;
	private var attractions			:Array<Attraction>;
	private var custom					:Array<Force>;

	private var hasDeadParticles		:Bool;	

	public function new(gravity:Vector3D = null, drag:Float = 0.001) 
	{
		
		RUNGE_KUTTA = 0;
		MODIFIED_EULER = 1;
		hasDeadParticles = false;
		integrator	= new RungeKuttaIntegrator(this);
		
		particles	= new Array<Particle>();
		springs		= new Array<Spring>();
		attractions = new Array<Attraction>();
		custom		= new Array<Force>();
		
		this.gravity = (gravity != null)? gravity : new Vector3D();
		
		this.drag = drag;
	}
	
	public function setIntegrator(integrator:Int):Void {
		
		switch (integrator) {
			
			case RUNGE_KUTTA:
				this.integrator = new RungeKuttaIntegrator(this);
			
			case MODIFIED_EULER:
				this.integrator = new ModifiedEulerIntegrator(this);			
		}
		
	}
	
	public function setGravity(gravity:Vector3D):Void {
		this.gravity = gravity;
	}
	
	public function setDrag(d:Float):Void {
		this.drag = d;
	}
	
	public function tick(t:Float = 1):Void {
		integrator.step(t);
	}
	
	public function makeParticle(mass:Float = 1, position:Vector3D = null):Particle {
		var p:Particle = new Particle(mass, position);
		particles.push(p);
		return p;
	}
	
	public function makeSpring(a:Particle, b:Particle, springConstant:Float, damping:Float, restLength:Float):Spring {
		var s:Spring = new Spring(a, b, springConstant, damping, restLength);
		springs.push(s);
		return s;
	}
	
	public function makeAttraction(a:Particle, b:Particle, strength:Float, minDistance:Float):Attraction {
		var m:Attraction = new Attraction(a, b, strength, minDistance);
		attractions.push(m);
		return m;
	}
	
	public function clear():Void {
		
		var i:Int;
		
		for (i in 0...particles.length) {
			particles[i] = null;
		}
		for (i in 0...springs.length) {
			springs[i] = null;
		}
		for (i in 0...attractions.length) {
			attractions[i] = null;
		}
								
		particles	= new Array<Particle>();
		springs		= new Array<Spring>();
		attractions = new Array<Attraction>();

	}
	
	public function applyForces():Void {
		
		var i:Int;
		var p_length:Int = particles.length;
		var s_length:Int = springs.length;
		var a_length:Int = attractions.length;
		var c_length:Int = custom.length;
		
		//trace(gravity)
								
		if ( gravity.x != 0 || gravity.y != 0 || gravity.x != 0) {
			for (i in 0...p_length) {
				particles[i].force = particles[i].force.add(gravity);
			}
		}
		
		for (i in 0...p_length) {
			var p:Particle = particles[i];
			var vdrag:Vector3D = p.velocity.clone();
			vdrag.scaleBy(-drag);
			p.force = p.force.add(vdrag);
		}
		
		for (i in 0...s_length) {
			springs[i].apply();
		}
		
		for (i in 0...a_length) {
			attractions[i].apply();
		}
		
		for (i in 0...c_length) {
			custom[i].apply();
		}
		
	}
	
	public function clearForces():Void {

		var p_length:Int = particles.length;

		for (i in 0...p_length) {
			var p:Particle = particles[i];
			p.force.x = 0; p.force.y = 0; p.force.z = 0;
		}
		
	}
	
	public function numberOfParticles():Int {
		return particles.length;
	}
	
	public function numberOfSprings():Int {
		return springs.length;
	}
	
	public function numberOfAttractions():Int {
		return attractions.length;
	}
	
	public function getParticle(i:Int):Particle {
		return particles[i];
	}
	
	public function getSpring(i:Int):Spring {
		return springs[i];
	}
	
	public function getAttraction(i:Int):Attraction {
		return attractions[i];
	}
	
	public function addCustomForce(f:Force):Void {
		custom.push(f);
	}
	
	public function numberOfCustomForces():Int {
		return custom.length;
	}
	
	public function getCustomForce(i:Int):Force {
		return custom[i];
	}
	
	public function removeCustomForce(i:Int):Void {
		custom[i] = null;
		custom.splice(i, 1);
	}
	
	public function removeCustomForceByReference(f:Force):Bool {
		var i:Int;
		var n:Int = -1;
		var c_length:Int = custom.length;
		for (i in 0...c_length) {
			if (custom[i] == f) {
				n = i;
				break;
			}
		}
		if (n != -1) {
			custom[n] = null;
			custom.splice(n, 1);
			return true;
		} else {
			return false;
		}
	}
	
	public function removeSpring(i:Int):Void {
		springs[i] = null;
		springs.splice(i, 1);
	}
	
	public function removeSpringByReference(s:Spring):Bool {
		var i:Int;
		var n:Int = -1;
		var s_length:Int = springs.length;
		for (i in 0...s_length) {
			if (springs[i] == s) {
				n = i;
				break;
			}
		}
		if (n != -1) {
			springs[n] = null;
			springs.splice(n, 1);
			return true;
		} else {
			return false;
		}
	}
	
	public function removeAttraction(i:Int):Void {
		attractions[i] = null;
		attractions.splice(i, 1);
	}
	
	public function removeAttractionByReference(s:Attraction):Bool {
		var i:Int;
		var n:Int = -1;
		var a_length:Int = attractions.length;
		for (i in 0...a_length) {
			if (attractions[i] == s) {
				n = i;
				break;
			}
		}
		if (n != -1) {
			attractions[n] = null;
			attractions.splice(n, 1);
			return true;
		} else {
			return false;
		}
	}
	
	public function removeParticle(i:Int):Void {
		particles[i] = null;
		particles.splice(i, 1);
	}
	
	public function removeParticleByReference(p:Particle):Bool {
		var i:Int;
		var n:Int = -1;
		var p_length:Int = particles.length;
		for (i in 0...p_length) {
			if (particles[i] == p) {
				n = i;
				break;
			}
		}
		if (n != -1) {
			particles[n] = null;
			particles.splice(n, 1);
			return true;
		} else {
			return false;
		}
	}
}
	
