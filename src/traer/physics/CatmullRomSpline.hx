package traer.physics;

/**
 * ...
 * @author Vanja Jelic
 */

import geom.Vector3D;
import geom.Point;

class CatmullRomSpline 
{

	private var vertices		:Array<Vector3D>;
	private var n				:Int;
	private var t_inc			:Float;
	private var tension			:Float;
	private var isClosed		:Bool;
	
	private var tangents		:Array<Object>;
	
	public function new(vertices:Array<Vector3D>, subdivisions:Int, tension:Float, isClosed:Bool) {
		
		this.vertices		= vertices.concat(); //work off a copy since closed path will need to alter the structure
		this.n				= subdivisions;
		this.tension		= tension;
		this.isClosed		= isClosed;
		
		t_inc				= 1/n;
		
		computeTangents();
		
	}
	private function computeTangents():Void {
		
		tangents = new Array<Object>();
		
		for (i in 0...vertices.length-1) {
			
			//get necessary coordinates
				var p0x:Float		= vertices[i].x;
				var p0y:Float		= vertices[i].y;
				var p1x:Float		= vertices[i+1].x;
				var p1y:Float		= vertices[i+1].y;
				
				var p2x:Float;
				var p2y:Float;
				var pn1x:Float;
				var pn1y:Float;
				
				if (i != 0) {
					pn1x = vertices[i-1].x;
					pn1y = vertices[i-1].y;
				} else {
					//for the first segment there is no previous point, we need to use a phantom point to calculate the staring tangent
					if (! isClosed) {
						if (! p2x) {
							p2x = vertices[i+2].x;
							p2y = vertices[i+2].y;
						}
						pn1x = p0x + p2x - p1x;
						pn1y = p0y + p2y - p1y;
					} else {
						pn1x = vertices[vertices.length-1].x;
						pn1y = vertices[vertices.length-1].y;
					}
				}
				
				if (i < vertices.length-2) {
					p2x = vertices[i+2].x;
					p2y = vertices[i+2].y;
				} else {
					//for the last segment, there is no next point, we need to use a phantom point to calculate the ending tangent
					if (! isClosed) {
						p2x = p1x + (p1x - p0x);
						p2y = p1y + (p1y - p0y);
					} else {
						p2x = vertices[0].x;
						p2y = vertices[0].y;
					}
				}
				
			//define starting tangent
				var m0x:Float = tension*(p1x - pn1x); 
				var m0y:Float = tension*(p1y - pn1y);
				
			//define ending tangent
				var m1x:Float = tension*(p2x - p0x);
				var m1y:Float = tension*(p2y - p0y);
				
			//store
				var _tangents:Object = {};
				_tangents.m0x = m0x;
				_tangents.m0y = m0y;
				_tangents.m1x = m1x;
				_tangents.m1y = m1y;
				tangents[i] = _tangents;
				
		}
		
		if (isClosed) {
			
			//push to end a clone of first vertex
			vertices.push(vertices[0].clone());
			
			//add addtional last point/first point tangents
			var _add_tangents:Object = {};
			
			_add_tangents.m0x = tangents[(vertices.length-3)].m1x;
			_add_tangents.m0y = tangents[(vertices.length-3)].m1y;
			_add_tangents.m1x = tangents[0].m0x;
			_add_tangents.m1y = tangents[0].m0y;
			
			tangents[(vertices.length-2)] = _add_tangents;
			
		}
		
	}
	
	public function getPoints():Array<Point> {
		
		var _points:Array<Point> = new Vector.<Point>();
		
		for (var i:uint=0; i<vertices.length-1; i++) {

			//points coordinates
			//TODO: this is where one would project vectors to screen coordinates
				
				var p0x:Float	= vertices[i].x;
				var p0y:Float	= vertices[i].y;
				var p1x:Float	= vertices[i+1].x;
				var p1y:Float	= vertices[i+1].y;
			
			//retrieve tangents
			
				var m0x:Float	= tangents[i].m0x; 
				var m0y:Float	= tangents[i].m0y;
				var m1x:Float	= tangents[i].m1x;
				var m1y:Float	= tangents[i].m1y;
			
			//set n screen coordinate points as segments of the curves
			
				for (var j:uint=1; j<n; j++) {
					
					var t:Float	= j*t_inc;
					var t2:Float	= t*t;
					var t3:Float	= t2*t;
					var h00:Float	= 2*t3 - 3*t2 +1;
					var h10:Float	= t3 - 2*t2 + t;
					var h01:Float	= -2*t3 + 3*t2;
					var h11:Float	= t3 - t2;
					
					var x:Float	= h00*p0x + h10*m0x + h01*p1x + h11*m1x;
					var y:Float	= h00*p0y + h10*m0y + h01*p1y + h11*m1y;
					
					_points.push(new Point(x, y));
					
				}
				
				_points.push(new Point(p1x, p1y));

		}
		
		return _points;
		
	}

	public function updateVertices(v:Array<Vector3D>):Void {
		
		this.vertices = v;
		computeTangents();
		
	}
	
}
	
