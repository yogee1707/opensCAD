a = 50;
b = 160;
maxDim = 40;
wallThickness = 7;

for(i=[a:b]){
translate([0,0,i-a])
linear_extrude(height = 1, center = false, convexity = 10, twist = 0)
    
    if(i>(a+wallThickness)){
        difference(){
            circle(maxDim*sin(i));
            circle((maxDim-wallThickness)*sin(i));
        }
    }
    else{
        circle(maxDim*sin(i));
    }
}


for(i=[a:b]){
translate([0,100,i-a])
linear_extrude(height = 1, center = false, convexity = 10, twist = 0)
    
    if(i>(a+wallThickness)){
        difference(){
            circle(maxDim*cos(i));
            circle((maxDim-wallThickness)*cos(i));
        }
    }
    else{
        circle(maxDim*cos(i));
    }
}