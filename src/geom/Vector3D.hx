package geom;
/**
 * ...
 * @author Vanja Jelic
 */

class Vector3D 
{
	public function new(x:Float=0, y:Float=0, z:Float=0, w:Float=0) 
	{
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;
	}
	
	public var w : Float;

	/**
	 * The first element of a Vector3D object, such as
	 * the x coordinate of a point in the three-dimensional space. The default value is 0.
	 * @langversion	3.0
	 * @playerversion	Flash 10
	 * @playerversion	AIR 1.5
	 */
	public var x : Float;

	/**
	 * The x axis defined as a Vector3D object with coordinates (1,0,0).
	 * @langversion	3.0
	 * @playerversion	Flash 10
	 * @playerversion	AIR 1.5
	 */
	public var X_AXIS : Vector3D;

	/**
	 * The second element of a Vector3D object, such as
	 * the y coordinate of a point in the three-dimensional space. The default value is 0.
	 * @langversion	3.0
	 * @playerversion	Flash 10
	 * @playerversion	AIR 1.5
	 */
	public var y : Float;

	/**
	 * The y axis defined as a Vector3D object with coordinates (0,1,0).
	 * @langversion	3.0
	 * @playerversion	Flash 10
	 * @playerversion	AIR 1.5
	 */
	public var Y_AXIS : Vector3D;

	/**
	 * The third element of a Vector3D object, such as
	 * the z coordinate of a point in three-dimensional space. The default value is 0.
	 * @langversion	3.0
	 * @playerversion	Flash 10
	 * @playerversion	AIR 1.5
	 */
	public var z : Float;

	/**
	 * The z axis defined as a Vector3D object with coordinates (0,0,1).
	 * @langversion	3.0
	 * @playerversion	Flash 10
	 * @playerversion	AIR 1.5
	 */
	public var Z_AXIS : Vector3D;

	/**
	 * The length, magnitude, of the current Vector3D object from the origin (0,0,0) to 
	 * the object's x, y, and z coordinates. The w
	 * property is ignored. A unit vector has a length or magnitude of one.
	 * @langversion	3.0
	 * @playerversion	Flash 10
	 * @playerversion	AIR 1.5
	 */
	
	public static function distance(p1:Vector3D, p2:Vector3D):Float
	{
		var	xd = p2.x - p1.x;
		var	yd = p2.y - p1.y;
		var	zd = p2.z - p1.z;
		return Math.sqrt(xd * xd + yd * yd + zd * zd);		
	}
	
	public function add(p2:Vector3D):Vector3D
	{		
		return new Vector3D(p2.x + this.x, p2.y + this.y, p2.z + this.z, p2.w + this.w);
	}
	
	public function subtract(p2:Vector3D):Vector3D
	{
		return new Vector3D(p2.x - this.x, p2.y - this.y, p2.z - this.z, p2.w - this.w);
	}
	
	public function clone():Vector3D
	{
		return new Vector3D(this.x, this.y, this.z, this.w);
	}
	
	public function scaleBy(s:Float):Void
	{
		this.x *= s;
		this.y *= s;
		this.z *= s;
		this.w *= s;	
	}
}

