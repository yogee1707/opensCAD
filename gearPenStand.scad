height = 5;
type = "Cog"; // [Spur,Cog,Double Helix(beta), Single Helix]
teeth = 30;	//	[5:56]
scale = 100;//[3:100]
hole = "Yes"; //[Yes,No]
//don't make too big or your gear will disappear
holeSize = 0;

module gear(number_of_teeth,
		circular_pitch=false, diametral_pitch=false,
		pressure_angle=20, clearance = 0)
{

	//Convert diametrial pitch to our native circular pitch
	circular_pitch = (circular_pitch!=false?circular_pitch:180/diametral_pitch);

	// Pitch diameter: Diameter of pitch circle.
	pitch_diameter  =  number_of_teeth * circular_pitch / 180;
	pitch_radius = pitch_diameter/2;

	// Base Circle
	base_diameter = pitch_diameter*cos(pressure_angle);
	base_radius = base_diameter/2;
    temp = base_diameter;

	// Diametrial pitch: Number of teeth per unit length.
	pitch_diametrial = number_of_teeth / pitch_diameter;

	// Addendum: Radial distance from pitch circle to outside circle.
	addendum = 1/pitch_diametrial;

	//Outer Circle
	outer_radius = pitch_radius+addendum;
	outer_diameter = outer_radius*2;

	// Dedendum: Radial distance from pitch circle to root diameter
	dedendum = addendum + clearance;

	// Root diameter: Diameter of bottom of tooth spaces.
	root_radius = pitch_radius-dedendum;
	root_diameter = root_radius * 2;

	half_thick_angle = 360 / (4 * number_of_teeth);

	union()
	{
		rotate(half_thick_angle) circle($fn=number_of_teeth*2, r=root_radius*1.001);

		for (i= [1:number_of_teeth])
		//for (i = [0])
		{
			rotate([0,0,i*360/number_of_teeth])
			{
				involute_gear_tooth(
					pitch_radius = pitch_radius,
					root_radius = root_radius,
					base_radius = base_radius,
					outer_radius = outer_radius,
					half_thick_angle = half_thick_angle);
			}
		}
	}
}

module involute_gear_tooth(
					pitch_radius,
					root_radius,
					base_radius,
					outer_radius,
					half_thick_angle
					)
{
	pitch_to_base_angle  = involute_intersect_angle( base_radius, pitch_radius );

	outer_to_base_angle = involute_intersect_angle( base_radius/2, outer_radius*1);

	base1 = 0 - pitch_to_base_angle - half_thick_angle;
	pitch1 = 0 - half_thick_angle;
	outer1 = outer_to_base_angle - pitch_to_base_angle - half_thick_angle;

	b1 = polar_to_cartesian([ base1, base_radius ]);
	p1 = polar_to_cartesian([ pitch1, pitch_radius ]);
	o1 = polar_to_cartesian([ outer1, outer_radius ]);

	b2 = polar_to_cartesian([ -base1, base_radius ]);
	p2 = polar_to_cartesian([ -pitch1, pitch_radius ]);
	o2 = polar_to_cartesian([ -outer1, outer_radius ]);

	// ( root_radius > base_radius variables )
		pitch_to_root_angle = pitch_to_base_angle - involute_intersect_angle(base_radius, root_radius );
		root1 = pitch1 - pitch_to_root_angle;
		root2 = -pitch1 + pitch_to_root_angle;
		r1_t =  polar_to_cartesian([ root1, root_radius ]);
		r2_t =  polar_to_cartesian([ -root1, root_radius ]);

	// ( else )
		r1_f =  polar_to_cartesian([ base1, root_radius ]);
		r2_f =  polar_to_cartesian([ -base1, root_radius ]);

	if (root_radius > base_radius)
	{
		//echo("true");
		polygon( points = [
			r1_t,p1,o1,o2,p2,r2_t
		], convexity = 3);
	}
	else
	{
		polygon( points = [
			r1_f, b1,p1,o1,o2,p2,b2,r2_f
		], convexity = 3);
	}

}

// Polar coord [angle, radius] to cartesian coord [x,y]

function polar_to_cartesian(polar) = [
	polar[1]*cos(polar[0]),
	polar[1]*sin(polar[0])
];

function involute_intersect_angle(base_radius, radius) = sqrt( pow(radius/base_radius,2) - 1);

for(i=[0:1:10]){
  rotate(i*0.7){
    translate([0,0,i]){
      linear_extrude(height=1,center=false,convexity=10)
      difference(){
          gear(number_of_teeth=teeth,diametral_pitch=scale/100);
          circle(teeth/2.25);
      }
    }
  }
}