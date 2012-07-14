package com.vanjajelic;

import js.Dom;
import js.JQuery;
import js.Lib;
import js.Stats;

import traer.physics.ParticleSystem;
import traer.physics.Particle;
import traer.physics.Spring;
import geom.Vector3D;

import js.three.Three;

/**
 * ...
 * @author Vanja Jelic
 */

class Main 
{
	private var numberOfPArticles:Int;
	
	private var s:traer.physics.ParticleSystem;
	private var anchor:Particle;
	private var particle:Particle;
	
	private var renderer:WebGLRenderer;
	private var camera:PerspectiveCamera;
	private var pointLight:PointLight;
	private var scene:Scene;
	private var spheresArray :Array<Mesh>;
	private var particleArray :Array<Particle>;
	private var stats:Stats;
	private var SPHERE_SIZE:Int;
	private var timer:Float;
	private var ambientLight:AmbientLight;
	private var fixParticle:Particle;
	private var mainSpring:Spring;
	private var lineMaterial:LineBasicMaterial;
	private var linesArray:Array<Line>;
	
	private function new()
	{
		numberOfPArticles = 80;
		SPHERE_SIZE = 10;
		
		var container = Lib.document.createElement( 'div' );
        Lib.document.body.appendChild( container );
	
    	stats = new Stats();
	    stats.getDomElement().style.position = 'absolute';
        stats.getDomElement().style.top = '0px';
        container.appendChild( stats.getDomElement() );
		
		initPhysics();
		initLines();
		init3dScene();
		
		
		haxe.Timer.delay( moveFixedParticle, 5000);
		
	}
	
	
	
	private function moveFixedParticle() 
	{
		fixParticle.position = new Vector3D( Math.random() * 500 - 300, Math.random() * 500 - 300, Math.random() * 400 - 300);
		haxe.Timer.delay( moveFixedParticle, 5000);
	}
	
	private function initPhysics() 
	{
		var springConst :Float = 0.05; // 0.1
		var damping     :Float = 0.8; // 0.08
		var repelConst  :Float = -5000;
			
		
		particleArray = new Array<Particle>();
		
		s 	= new traer.physics.ParticleSystem(new Vector3D(0, 0, 0), .2);
		
		fixParticle = s.makeParticle(.8, new Vector3D(0, 0, 0));
		fixParticle.makeFixed();
		
		for (i in 0...numberOfPArticles) 
		{
			particleArray.push( s.makeParticle(.8, new Vector3D(Math.random()*300 - 150, Math.random()*300, Math.random()*30)) );
			mainSpring = s.makeSpring(fixParticle, particleArray[i], springConst, damping, 150);
			if (i > 0) 
			{
				var counter = i - 1;
				while (counter >= 0) 
				{
					s.makeAttraction(particleArray[i], particleArray[counter], repelConst, 20);				   counter--;
				}
			
			}			
		}
	}

	private function init3dScene():Void 
	{
		var w = Lib.window.innerWidth;
        var h = Lib.window.innerHeight;
		
		spheresArray = new Array<Mesh>();
		
		scene = new Scene();
		var material = new MeshLambertMaterial( { color:0xDD0000 } );
		
		// add point light
        pointLight = new PointLight(0xffffff, 1, 0);
        pointLight.position.set(0, 0, 0);
        scene.add(pointLight);
        
		// add ambient light
        ambientLight = new AmbientLight(0xffffff);
        ambientLight.position.set(0, 0, 500);
        scene.add(ambientLight);
		
		// and a camera
        camera = new PerspectiveCamera(70, w/h, 1, 1000);
        camera.position.z = 500;
		camera.lookAt(new Vector3(0, 0, 0));
        scene.add(camera);
        
		// setup renderer in the document
        renderer = new WebGLRenderer(null);
        renderer.setSize(w, h);
        Lib.document.body.appendChild(renderer.domElement);
        
				
		for (i in 0...numberOfPArticles) 
		{
			spheresArray.push( new Mesh( new SphereGeometry(SPHERE_SIZE, 10, 10), material) );
			scene.add(spheresArray[i]);
			scene.add(linesArray[i]);
        }		
		render();
	}
	
	private function initLines() 
	{
		linesArray = new Array<Line>();
		lineMaterial = new LineBasicMaterial( {  color: 0x0000cc } );
		
		for (i in 0...numberOfPArticles) 
		{
			var lineGeometry = new Geometry();
			//lineGeometry.__dirtyVertices = true;
			//lineGeometry.dynamic = true;
			lineGeometry .vertices.push(new Vertex(new Vector3(fixParticle.position.x, fixParticle.position.y, fixParticle.position.z)));
			lineGeometry .vertices.push(new Vertex(new Vector3(particleArray[i].position.x, particleArray[i].position.y, particleArray[i].position.z)));
			var line = new Line(lineGeometry , lineMaterial);
			linesArray.push(line);
			
		}
			
	}
	
	public function render ():Void 
	{
		s.tick(1);
		stats.update();
		
		RequestAnimationFrame.request (render);
		renderer.render(scene, camera, null, null);
		

      
		for (i in 0...numberOfPArticles) 
		{
			spheresArray[i].position.set( particleArray[i].position.x, particleArray[i].position.y, particleArray[i].position.z);
			/*
			scene.removeObject(linesArray[i]);
			linesArray[i].geometry.vertices[0] = new Vertex(new Vector3(fixParticle.position.x, fixParticle.position.y, fixParticle.position.z));
			linesArray[i].geometry.vertices[0] = new Vertex(new Vector3(particleArray[i].position.x, particleArray[i].position.y, particleArray[i].position.z));			
			scene.addObject(linesArray[i]);
			*/
        }
		
		timer += 0.0035;
		camera.position.x = Math.cos( timer ) * 500;
		camera.position.y = Math.cos( timer ) * 30;
		camera.position.z = Math.sin( timer ) * 500;
		camera.lookAt(new Vector3(0, 0, 0));		
		
    }
	
	static function main() 
	{
		new Main();
	}	
}