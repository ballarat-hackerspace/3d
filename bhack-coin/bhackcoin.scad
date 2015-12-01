$fn=64;

difference(){
    cylinder(r=28, h=5);
    translate([-20, 0, 0]) linear_extrude(height=5)
        import(file = "bhacklogo.dxf");
}