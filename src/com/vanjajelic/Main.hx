package com.vanjajelic;

/**
 * ...
 * @author Vanja Jelic
 */

 import haxe.Timer;
 
import js.Dom;
import js.JQuery;
import js.Lib;

import traer.physics.ParticleSystem;
import traer.physics.Particle;
import traer.physics.Spring;
import geom.Vector3D;

class Main 
{
	private var _timer:Timer;
	private var _timerSpeed:Int;
	private var _countTimer:Int;
	private var s:ParticleSystem;
	private var anchor:Particle;
	private var particle:Particle;
	
	private var attractor:Particle;
	
	private var particles_fixed	:Array<Particle>;
	private var particles_free	:Array<Particle>;
	private var particles_gfx	:Array<JQuery>;
	
	private var particle1:Particle;
	private var particle2:Particle;
	private var particle3:Particle;
	private var particle4:Particle;
	private var particle5:Particle;
	private var particle6:Particle;
	
	private var fixParticle1:Particle;
	private var fixParticle2:Particle;
	private var fixParticle3:Particle;
	private var fixParticle4:Particle;
	private var fixParticle5:Particle;
	private var fixParticle6:Particle;
	
	private var _particle1_gfx:JQuery;
	private var _particle2_gfx:JQuery;
	private var _particle3_gfx:JQuery;
	private var _particle4_gfx:JQuery;
	private var _particle5_gfx:JQuery;
	private var _particle6_gfx:JQuery;
	
	private var spring:Spring;
	
	private var mouseX:Int;
	private var mouseY:Int;

	
	private function new()
	{
		createSystem();
		
		_onload();
	}
	
	static function main() 
	{
		var m = new Main();
	}
	
	private function createSystem():Void
	{
				
		particles_fixed = new Array<Particle>();
		particles_free = new Array<Particle>();
		particles_gfx = new Array<JQuery>();
		s = new ParticleSystem(new Vector3D(0, 0, 0), .2);
		
		makeParticles(10);
		
		makeAttractions();
					
		pullGraphics();
		
		_timerSpeed = Std.int(1000 / 30); // 30 FPS
		_countTimer = 0;
		_timer = new Timer(_timerSpeed);
		_timer.run = _tick;
 
	}
	
	private function makeParticles(numberOfParticles):Void
	{
		
		particle1	= s.makeParticle(.8, new Vector3D());
		particle2	= s.makeParticle(.8, new Vector3D());
		particle3	= s.makeParticle(.8, new Vector3D());
		particle4	= s.makeParticle(.8, new Vector3D());
		particle5	= s.makeParticle(.8, new Vector3D());
		particle6	= s.makeParticle(.8, new Vector3D());
		
		fixParticle1 	= s.makeParticle(.8, new Vector3D(200, 200, 0));
		fixParticle1.makeFixed();
		fixParticle2 	= s.makeParticle(.8, new Vector3D(400, 200, 0));
		fixParticle2.makeFixed();
		fixParticle3 	= s.makeParticle(.8, new Vector3D(600, 200, 0));
		fixParticle3.makeFixed();
		fixParticle4 	= s.makeParticle(.8, new Vector3D(200, 400, 0));
		fixParticle4.makeFixed();
		fixParticle5 	= s.makeParticle(.8, new Vector3D(400, 400, 0));
		fixParticle5.makeFixed();
		fixParticle6 	= s.makeParticle(.8, new Vector3D(600, 400, 0));
		fixParticle6.makeFixed();
		
/*		for (i in 0...numberOfParticles)
		{
			var p  = s.makeParticle(.8, new Vector3D());
			var fp = s.makeParticle(.8, new Vector3D(50*i, 200, 0));
			particles_free.push(p);
			particles_fixed.push(fp);
		}
*/				
		attractor	= s.makeParticle(1, new Vector3D(300, 300, 0)); attractor.makeFixed();			

	}
	
	private function makeAttractions():Void
	{
		var springConst :Float = 0.1; // 0.1
		var repelConst  :Float = -0.05;
		var damping     :Float = 0.008; // 0.08
		
		var mouseForce  :Int = 30000; // 46800
		var distance:Int = 40;
		
/*
		for (i in 0...particles_free.length) 
		{
			s.makeSpring(particles_fixed[i], particles_free[i], springConst, damping, 0);
			//s.makeAttraction(attractor, particles_free[i], mouseForce, distance);
		}
*/		
		s.makeAttraction(attractor, particle1, mouseForce, distance);
		s.makeAttraction(attractor, particle2, mouseForce, distance);
		s.makeAttraction(attractor, particle3, mouseForce, distance);
		s.makeAttraction(attractor, particle4, mouseForce, distance);	
		s.makeAttraction(attractor, particle5, mouseForce, distance);	
		s.makeAttraction(attractor, particle6, mouseForce, distance);	
	
				// particles being attracted by center fixed particle
		s.makeSpring(fixParticle1, particle1, springConst, damping, 0);
		s.makeSpring(fixParticle2, particle2, springConst, damping, 0);
		s.makeSpring(fixParticle3, particle3, springConst, damping, 0);
		s.makeSpring(fixParticle4, particle4, springConst, damping, 0);
		s.makeSpring(fixParticle5, particle5, springConst, damping, 0);
		s.makeSpring(fixParticle6, particle6, springConst, damping, 0);
		
	}
	
	private function pullGraphics():Void
	{
/*		for (i in 0...particles_free.length) 
		{
			particles_gfx[i] = new JQuery("#main").append("<div class='img'><img src='img/red_circle.png'/></div>");
		}
*/
		_particle1_gfx = new JQuery('#img1');
		_particle2_gfx = new JQuery('#img2');
		_particle3_gfx = new JQuery('#img3');
		_particle4_gfx = new JQuery('#img4');
		_particle5_gfx = new JQuery('#img5');
		_particle6_gfx = new JQuery('#img6');	
	}
	
	private function _tick():Void 
	{
		s.tick(1);
		attractor.position.x = mouseX - 25;
		attractor.position.y = mouseY - 20;

/*		for (i in 0...particles_free.length) 
		{
			particles_gfx[i].css( { top: particles_free[i].position.y, left: particles_free[i].position.x } );
		}
*/
		_particle1_gfx.css( { top: particle1.position.y, left: particle1.position.x } );
		_particle2_gfx.css( { top: particle2.position.y, left: particle2.position.x } );
		_particle3_gfx.css( { top: particle3.position.y, left: particle3.position.x } );
		_particle4_gfx.css( { top: particle4.position.y, left: particle4.position.x } );
		_particle5_gfx.css( { top: particle5.position.y, left: particle5.position.x } );
		_particle6_gfx.css( { top: particle6.position.y, left: particle6.position.x } );
		
	}
	
	private function _onload():Void
	{
		new JQuery("#main").mousemove(function(e){
			mouseX = e.pageX; 
			mouseY = e.pageY;
		}); 
		
	}
}