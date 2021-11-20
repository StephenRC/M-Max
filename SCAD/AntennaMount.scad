///////////////////////////////////////////////////////////////////////////////////////////
// AntennaMount.scad
///////////////////////////////////////////////////////////////////////////////////////////
// C:4/19/21
// L: 4/19/21
//////////////////////////////////////////////////////////////////////////////////////////
include <bosl2/std.scad>
include <inc/brassinserts.scad>
////////////////////////////////////////////////////////////////////////////////////////////
$fn=100;
///////////////////////////////////////////////////////////////////////////////////////////

AntMount();

///////////////////////////////////////////////////////////////////////////////////////////////////////

module AntMount(HoleSize=7) {
	difference() {
		union() {
			color("cyan") cuboid([16,20,2.5],rounding=0.5);//,p1=[0,0]);
			translate([0,10,8.8]) color("red") cuboid([16,5,20],rounding=0.5);
		}
		translate([0,-2,-4]) color("blue") cylinder(h=10,d=HoleSize);
		translate([0,15,12]) color("green") rotate([90,0,0]) cylinder(h=10,d=screw5);
		translate([0,9,12]) color("purple") rotate([90,0,0]) cylinder(h=5,d=screw5hd);
	}
	translate([-7,0,9]) color("plum") rotate([45,0,0])  cuboid([2,25,2],rounding=0.5);
	translate([7,0,9]) color("gray") rotate([45,0,0])  cuboid([2,25,2],rounding=0.5);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////