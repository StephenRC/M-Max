////////////////////////////////////////////////////////////////////////////
// powersupplymount.scad - something to mount a 12/24vdc p/s to makerslide
////////////////////////////////////////////////////////////////////////////
// created 5/11/2016
// last update 12/15/18
////////////////////////////////////////////////////////////////////////////
// 5/20/16 - added countersinks for 4mm caphead screws
// 5/21/16 - sloted one of the power supply mounting holes
// 12/15/18	- Added 2020 version and preview colors
////////////////////////////////////////////////////////////////////////////
// Info: After printing drill out the power supply mouning holes
//       power supply mounting holes are 50mm apart
////////////////////////////////////////////////////////////////////////////
include <inc/cubeX.scad> // http://www.thingiverse.com/thing:112008
////////////////////////////////////////////////////////////////////////////
// vars
screw4 = 4.7;
screw4c = 7.7;
screw5 = 5.7;
screw5c = 10.7;
length = 113;
width = 13;
thickness = 10;
layer = 0.2;
///////////////////////////////////////////////////////////////////////////
$fn=60;

bar(0);
translate([0,width+5,0]) bar(0); // two needed to mount p/s

///////////////////////////////////////////////////////////////////////////

module bar(mks=1) {
	difference() {
		color("cyan") cubeX([length,width,thickness]);
		// p/s mounting holes
		translate([31.5,width/2,-2]) rotate([0,0,0]) color("gray") cylinder(h=thickness*2,r=screw4/2);
		color("black") hull() {
			translate([82.5,width/2,-2]) rotate([0,0,0]) cylinder(h=thickness*2,r=screw4/2);
			translate([80.5,width/2,-2]) rotate([0,0,0]) cylinder(h=thickness*2,r=screw4/2);
		}
		// countersink the mounting holes
		translate([31.5,width/2,-14]) rotate([0,0,0]) color("red") cylinder(h=thickness*2,r=screw4c/2);
		color("plum") hull() {
			translate([82.5,width/2,-14]) rotate([0,0,0]) cylinder(h=thickness*2,r=screw4c/2);
			translate([80.5,width/2,-14]) rotate([0,0,0]) cylinder(h=thickness*2,r=screw4c/2);
		}
		makerslide_mount(mks);
		// zip tie holes
		translate([5,width+2,thickness/2]) rotate([90,0,0]) color("salmon") cylinder(h=thickness*2,r=screw5/2);
		translate([length-5,width+2,thickness/2]) rotate([90,0,0]) color("blue") cylinder(h=thickness*2,r=screw5/2);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////

module makerslide_mount(mks) {
	if(mks) {
		// makerslide mounting holes
		translate([length/2+10,width/2,-2]) rotate([0,0,0]) color("gold") cylinder(h=thickness*2,r=screw5/2);
		translate([length/2-10,width/2,-2]) rotate([0,0,0]) color("pink") cylinder(h=thickness*2,r=screw5/2);
		translate([length/2+10,width/2,thickness/2]) rotate([0,0,0]) color("lightgray") cylinder(h=thickness*2,r=screw5c/2);
		translate([length/2-10,width/2,thickness/2]) rotate([0,0,0]) color("black") cylinder(h=thickness*2,r=screw5c/2);
	} else {
		translate([length/2,width/2,-2]) rotate([0,0,0]) color("gold") cylinder(h=thickness*2,r=screw5/2);
		translate([length/2,width/2,thickness/2]) rotate([0,0,0]) color("lightgray") cylinder(h=thickness*2,r=screw5c/2);
	}
}

/////////////////////////////////////////////////////////////////////////////