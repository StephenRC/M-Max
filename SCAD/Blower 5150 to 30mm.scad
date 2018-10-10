//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// blowerto30mm.scad - mount a 5015 blower to a 40mm axial fan mount
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// created 8/26/2016
// last update 1/1/2017
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 8/26/16 - modified version from duet2020.v0.2.scad
//			 Made base large enough to cover where 40mm fan was and added a second piller to hold blower
// 9/10/16 - shifted fan closer to bottom of heatsink
// 1/1/17 - changed to 30mm fan and added colors to preview
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// includes
include <inc/screwsizes.scad>
use <inc/cubeX.scad> // http://www.thingiverse.com/thing:112008
$fn=50;		// 100 takes a long, long time to render
////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Tap smaller blower pillar hole with a M4 tap.
////////////////////////////////////////////////////////////////////////////////////////////////////////////
// vars
////////////////////////////////////////////////////////////////////////////////////////////////////////////
bthick = 4; // thickness of platform
fan_support = 24; // 30mm fan
///////////////////////////////////////////////////////////////////////////////////////////////////////

blower_adapter(20,15,48); // 20,14,48 is for a 5015 blower fan
%blowertest(20,15,48);

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module blower_adapter(blower_h,blower_w,blower_m_dist) { // to use a 50mm 10x15 blower instead of a 40mm axial
	difference() {
		color("red") cubeX([fan_support+9,fan_support+9,bthick+1],2);
		translate([fan_support/2-blower_w/4,fan_support/2-blower_h/2-0.1,-2]) color("black") cube([blower_w,blower_h,10]);
		translate([4,4,-2]) color("white") cylinder(h=bthick*2,r=screw3/2);
		translate([fan_support+4,4,-2]) color("black") cylinder(h=bthick*2,r=screw3/2);
		translate([4,4,3]) color("white") cylinder(h=bthick*2,r=screw3hd/2);
		translate([fan_support+4,4,3]) color("black") cylinder(h=bthick*2,r=screw3hd/2);
		translate([4,fan_support+4,-2]) color("yellow") cylinder(h=bthick*2,r=screw3/2);
		translate([fan_support+4,fan_support+4,-2]) color("pink") cylinder(h=bthick*2,r=screw3/2);
		translate([4,fan_support+4,3]) color("yellow") cylinder(h=bthick*2,r=screw3hd/2);
		translate([fan_support+4,fan_support+4,3]) color("pink") cylinder(h=bthick*2,r=screw3hd/2);
	translate ([fan_support/2-blower_w/4,fan_support/2-blower_h/2+16,-8]) rotate([45,0,0]) cube([blower_w,10,10]);
	}
	difference() {
		translate([23.3,blower_h-12.5,0]) color("cyan") cubeX([screw4+1,screw4+4,blower_m_dist+screw4+1],2);
		translate([screw4/2+20,screw4+blower_w-12.9,blower_m_dist-0.3]) rotate([90,0,90]) cylinder(h=10,d=screw4);
		translate([fan_support+4,4,3]) color("black") cylinder(h=bthick*2,r=screw3hd/2);
	}
	difference() {
		translate([23.3,blower_h-9.5,blower_m_dist-16]) rotate([30,0,0]) color("cyan") cubeX([screw4+1,screw4+6,20],2);
		translate([22.3,blower_h-8.5,blower_m_dist-16]) color("pink") cube([screw4+3,screw4+4,20],2);
		translate([screw4/2+20,screw4+blower_w-13,blower_m_dist-0.3]) rotate([90,0,90]) cylinder(h=10,d=screw4);
	}
	difference() {
		translate([17.7-blower_w,blower_h-12,0]) color("blue") cubeX([screw4+1,screw4+4,blower_m_dist+screw4+1],2);
		translate([screw4/2+15-blower_w,screw4+blower_w-13.2,blower_m_dist-1]) rotate([90,0,90]) cylinder(h=10,d=screw4t);
		translate([4,4,3]) color("white") cylinder(h=bthick*2,r=screw3hd/2);
	}
	difference() {
	 translate([17.7-blower_w,blower_h-9.5,blower_m_dist-16]) rotate([30,0,0]) color("cyan") cubeX([screw4+1,screw4+6,20],2);
	 translate([16.7-blower_w,blower_h-8,blower_m_dist-16]) color("pink") cube([screw4+3,screw4+4,20],2);
	 translate([screw4/2+15-blower_w,screw4+blower_w-13.3,blower_m_dist-0.3]) rotate([90,0,90]) cylinder(h=10,d=screw4t);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module blowertest(blower_h,blower_w,blower_m_dist) {
	translate([fan_support-blower_w/4+3,fan_support/2-blower_h/2,3]) rotate([90,0,90]) blower();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module blower() {
	import("5015_Blower_Fan.stl"); // http://www.thingiverse.com/thing:1576438
}

//////////////////// end of duet2020.scad ////////////////////////////////////////////////////////////
