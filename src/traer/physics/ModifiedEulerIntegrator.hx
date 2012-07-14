package traer.physics;

/**
 * ...
 * @author Vanja Jelic
 */

import geom.Vector3D;

class ModifiedEulerIntegrator implements Integrator 
{
	
	private var s	:ParticleSystem;

	public function new(s:ParticleSystem) {
		this.s = s;		
	}
	
	public function step(t:Float):Void {
		
		var particles = s.particles;
		var p_length = particles.length;
		
		s.clearForces();
		s.applyForces();
		
		var halftt:Float = (t*t)*.5;
		var one_over_t:Float = 1/t;
		
		for (i in 0...p_length) {
			
			var p:Particle = particles[i];
			
			if (! p.fixed) {
				
				var ax:Float = p.force.x/p.mass;
				var ay:Float = p.force.y/p.mass;
				var az:Float = p.force.z/p.mass;
				
				var vel_div_t:Vector3D = p.velocity.clone();
				vel_div_t.scaleBy(one_over_t);
				p.position = p.position.add(vel_div_t);
				p.position = p.position.add(new Vector3D(ax*halftt, ay*halftt, az*halftt));
				p.velocity = p.velocity.add(new Vector3D(ax*one_over_t, ay*one_over_t, az*one_over_t));
				
			}
			
		}

	}
	
}
