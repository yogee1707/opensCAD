//bottom a=50
//top a=56.2

a = 56.5;
wT = 2;
potHeight = 70;

// rotate as per a, v, but around point pt
module rotate_about_pt(a, v, pt) {
    translate(pt)
        rotate(a,v)
            translate(-pt)
                children();   
}

for(i=[0:potHeight]){
  translate([0,0,i]){
    rotate_about_pt(i*0.6, 0,[a/2,a/2,0])
    if(i<wT){ 
      linear_extrude(height = 1, center = true, convexity = 10)
      polygon( [[0,0],[a,0],[a,a],[0,a]] );
    }
    else
       linear_extrude(height = 1, center = true, convexity = 10){
          difference(){
              polygon( [[0,0],[a,0],[a,a],[0,a]] );
              polygon([[wT,wT],[a-wT,wT],[a-wT,a-wT],[wT,a-wT]]);
          } 
        } 
     }
}