a = 7;
b = 12;
base_diameter=70;
no_teeth = 20;
height=70;
bearing_od = 15;
step_size=0.5;
base_height=5; //should be equal to the bearing thickness
top_ring_height=20;
rotate_step=0.3;

for(j=[0:step_size:height]){
  translate([0,0,j])
  rotate(j*rotate_step)
  for(i=[0:no_teeth]){
      rotate([0,0,i*360/no_teeth])
      linear_extrude(height=step_size,convexity=10,twist=0)
      translate([0,base_diameter-(b/2.5),0])
      polygon([[-a/2,0],[a/2,0],[a/2,b],[-a/2,b]]);
      if(j==height-top_ring_height){
        linear_extrude(height=top_ring_height,convexity=10,twist=0,center=false)
        difference(){
            circle(base_diameter);
            circle(base_diameter/1.2);
        }
      }
      else if(j<=base_height){
        linear_extrude(height=step_size,convexity=10,twist=0,center=false)
        difference(){
            circle(base_diameter);
            circle(bearing_od);
        }
      }
      else if((j>=base_height)&&(j<=(2*base_height))){
        circle(base_diameter);
      }
    }
}

translate([0,0,0])
    linear_extrude(height=5,convexity=10,twist=0,center=false)
    difference(){
        circle(base_diameter);
        circle(bearing_od);
    }