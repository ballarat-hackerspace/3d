$fn=75;
$m3_hole=3.2;

module air_holes() {
  for (s = [0 : 22.5 : 360])
    rotate([0, 0, s]) translate([0, 0, -8]) rotate([75, 0, 0])
      cylinder(d=2.2, h=26);
}

module shroud_torus() {
  // inner inverted circle ring cutout
  difference() {
    rotate_extrude() translate([16, -3, 0]) square([10, 3]);
    rotate_extrude() translate([17, 0, 0]) circle(d=6.6);
  }
  // Outer ring
  rotate_extrude() translate([26, 0, 0]) hull() {
    circle(d=6); translate([-3, 0, 0]) circle(d=6);
  }
}

module fan_attachment() {
  // inner bit
  $h=12;
  translate([0, 0.7, $h/2-1]) hull() {
    cylinder(d=2, h=$h, center=true);
    translate([15, 11, 0]) cylinder(d=2, h=$h, center=true);
    translate([15, 0, 0]) cylinder(d=2, h=$h, center=true);
    translate([0, 11, 0]) cylinder(d=2, h=$h, center=true);
  }
  // outer bit
  translate([0, 0.7, $h/2-8]) hull() {
    cylinder(d=6, h=$h, center=true);
    translate([16, 11, 0]) cube([6, 6, $h], center=true);
    translate([16, 0, 0]) cube([6, 6, $h], center=true);
    translate([0, 11, 0]) cylinder(d=6, h=$h, center=true);
  }
  // base joint to shroud
  translate([0, -8.7, -8.0]) hull() {
    translate([0, -1, 0]) sphere(d=6, center=true);
    translate([25, 20.4, 0]) sphere(d=6, center=true);
    translate([25, 5, 0]) sphere(d=6, center=true);
    translate([0, 20.4, 0]) sphere(d=6, center=true);
  }
}


module shroud_attachment($diff) {
  if ($diff) {
    difference() {
      hull() {
        cube([6.5, 6.5, 18], center=true);
        translate([0, 0, 12]) rotate([0, 90, 0]) cylinder(d=6.5, h=6.5, center=true);
      }
      translate([0, 0, -3]) rotate([0, 90, 0]) cylinder(d=$m3_hole, h=40, center=true);
      translate([0, 0, 12]) rotate([0, 90, 0]) cylinder(d=$m3_hole, h=40, center=true);
    }
  }
  else {
    hull() {
      cube([7, 7, 18], center=true);
      translate([0, 0, 15]) cube([7, 7, 7], center=true);
    }
    translate([0, 0, -3]) rotate([0, 90, 0]) cylinder(d=$m3_hole, h=40, center=true);
    translate([0, 0, 12]) rotate([0, 90, 0]) cylinder(d=$m3_hole, h=40, center=true);
  }
}

module shroud() {
  shroud_torus();

  // scaffolding attachment
  translate([0, 24, 9])
    shroud_attachment(true);


  translate([-17, 29.5, 8]) {
    fan_attachment();
  }

  // zprobe
  translate([2, 27.2, -3]) z_probe_attachment();
}

module z_probe_attachment() {
  difference() {
    cube([21.4, 25, 15]);
    // m3 clamp holes
    translate([0, 21.5, 3]) rotate([0, 90, 0]) cylinder(d=$m3_hole, h=22);
    translate([0, 21.5, 11]) rotate([0, 90, 0]) cylinder(d=$m3_hole, h=22);
    translate([2, 2, -1]) cube([17.4, 25, 17]);
  }
}

module hotend_shroud() {
  difference() {
    shroud();

    // internal ring void
    rotate_extrude() translate([26, 0, 0]) hull() {
      circle(d=4.8); translate([-3, 0, 0]) circle(d=4.8);
    }

    air_holes();

    // fan attachment joint void
    translate([-17, 22.5, 0]) hull() {
      rotate([0, 90, 0]) cylinder(d=4, h=15);
      translate([0, 10, 0]) rotate([0, 90, 0]) cylinder(d=4, h=15);
    }

    // fan inlet void
    translate([-17, 30.2, -2]) cube([15, 11, 60]);

    // cleanup excess shroud void for z probe
    translate([4, 29, -3]) cube([17.4, 25, 30]);
  }

  // air fins
  translate([-4, 26.5, -3]) rotate([0, 0, 30]) cube([.8, 4, 5.8]);
  translate([-8.5, 25.3, -3]) rotate([0, 0, 15]) cube([.8, 5, 5.8]);
  translate([-14.5, 23.4, -3]) rotate([0, 0, -10]) cube([.8, 7, 5.8]);
}

module hotend_attachment() {
  // scaffolding attachment
  translate([0, 24, 9]) {
    difference() {
      difference() {
        translate([0, 0, 26]) {
          // main body
          difference() {
            translate([0, 0, 8])
              cube([40, 6.5, 60], center=true);

            // head attachment slits
            translate([-16, 0, 15]) hull() {
              rotate([90, 0, 0]) cylinder(d=$m3_hole, h=10, center=true);
              translate([0, 0, 15])
                rotate([90, 0, 0]) cylinder(d=$m3_hole, h=10, center=true);
            }
            translate([16, 0, 15]) hull() {
              rotate([90, 0, 0]) cylinder(d=$m3_hole, h=10, center=true);
              translate([0, 0, 15])
                rotate([90, 0, 0]) cylinder(d=$m3_hole, h=10, center=true);
            }
          }
        }

        shroud_attachment(false);
      }
      translate([15, 0, 11])
        cube([10, 10, 40], center=true);
      translate([-15, 0, 11])
        cube([10, 10, 40], center=true);
    }
  }

}

hotend_shroud();
hotend_attachment();
