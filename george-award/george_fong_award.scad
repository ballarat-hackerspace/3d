// Mobius strip
$fn=16;
//Radius of strip
Radius = 40;
//Width of Strip
Width = 25;
//Thickness of strip
Thickness=3;
//Half twists 0 is a collar, 1 is the mobius strip, 2 = fulll twist
Halftwist=3; 
//Start Angle - important if Halftwist = 0
Start=90;
//Step size in degrees
Step = 2;

module mobius_strip(radius,width,thickness,step=1, halftwist=3,start=90) {
  for (i = [0:step:360])
    hull() {
       rotate([0,0,i])
          translate([radius,0,0])
             rotate([0,start+i * halftwist * 0.5, 0]) 
               cube([width,Delta,thickness], center=true);
       rotate([0,0,i+step])
          translate([radius,0,0])
             rotate([0,start+(i+step)* halftwist * 0.5 , 0]) 
               cube([width,Delta,thickness], center=true);
       }
}

Delta= 0.1;

difference() {
    mobius_strip(Radius, Width, Thickness, Step, Halftwist,Start);
    translate([30, 0, 0]) rotate([0, 90, 0]) cylinder(d=3, h=25);
}