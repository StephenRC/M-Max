//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// E3DV6 Blower 5150 Adpater.scad - mount a 5015 blower to a 40mm axial fan mount
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// created 8/26/2016
// last update 6/29/2020
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 8/26/16	- modified version from duet2020.v0.2.scad
//			  Made base large enough to cover where 40mm fan was and added a second piller to hold blower
// 9/10/16	- shifted fan closer to bottom of heatsink
// 1/1/17	- changed to 30mm fan and added colors to preview
// 6/1/19	- Made the base as thick as the supplied 30mm fan to be able to use the original screws
//			  Added abiltiy to ajsut fan position to be adjusted left/right
// 6/29/20	- Added use of 4mm brass insert
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// includes
include <bosl2/std.scad>
include <inc/screwsizes.scad>
//Use4mmInsert=1;
include <inc/BrassInserts.scad>
$fn=50;		// 100 takes a long, long time to render
////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Tap smaller blower pillar hole with a M4 tap.  Print more than one or with something else for better quality
////////////////////////////////////////////////////////////////////////////////////////////////////////////
// vars
////////////////////////////////////////////////////////////////////////////////////////////////////////////
countersink=2;
bthick = 10+countersink; // thickness of platform
fan_support = 24; // 30mm fan=24
fan_adjustLR=0.5;
adjust_bevel=4;
///////////////////////////////////////////////////////////////////////////////////////////////////////

blower_adapter(20,15,48); // 20,14,48 is for a 5015 blower fan

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module cubeX(size,Rounding) { // temp module
	cuboid(size,rounding=Rounding,p1=[0,0]);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module blower_adapter(blower_h,blower_w,blower_m_dist) { // to use a 50mm 10x15 blower instead of a 40mm axial
	if($preview) %blowertest(blower_h,blower_w,blower_m_dist); // show blower in preview
	difference() {
		translate([-0.5+fan_adjustLR,-0.5,0]) color("red") cubeX([fan_support+9,fan_support+9,bthick+1],2);
		translate([fan_support/2-blower_w/4+fan_adjustLR,fan_support/2-blower_h/2-0.1,-2]) color("black")
			cube([blower_w,blower_h,bthick+5]);
		translate([4+fan_adjustLR,4,-2]) color("white") cylinder(h=bthick*2,r=screw3/2);
		translate([fan_support+4+fan_adjustLR,4,-2]) color("black") cylinder(h=bthick*2,r=screw3/2);
		translate([4+fan_adjustLR,6,bthick-countersink]) color("white") cylinder(h=bthick*2,r=screw3hd/2);
		translate([fan_support+4+fan_adjustLR,4,bthick-countersink]) color("black") cylinder(h=bthick*2,r=screw3hd/2);
		translate([4+fan_adjustLR,fan_support+4,-2]) color("yellow") cylinder(h=bthick*2,r=screw3/2);
		translate([fan_support+4+fan_adjustLR,fan_support+4,-2]) color("pink") cylinder(h=bthick*2,r=screw3/2);
		translate([4,fan_support+4+fan_adjustLR,bthick-countersink]) color("yellow") cylinder(h=bthick*2,r=screw3hd/2);
		translate([fan_support+4+fan_adjustLR,fan_support+4,bthick-countersink]) color("pink") cylinder(h=bthick*2,r=screw3hd/2);
		translate ([fan_support/2-blower_w/4+fan_adjustLR,fan_support/2-blower_h/2+18+adjust_bevel,-8]) rotate([45,0,0])
			color("white") cube([blower_w,10,15]);
	}
	difference() {
		translate([23.3+fan_adjustLR,blower_h-12.5,0]) color("plum") cubeX([screw4+1,screw4+4,blower_m_dist+screw4+1+bthick],2);
		translate([screw4/2+20+fan_adjustLR,screw4+blower_w-12.9,blower_m_dist+bthick-4.3]) rotate([90,0,90])
			cylinder(h=10,d=screw4);
		translate([fan_support+4+fan_adjustLR,4,3]) color("black") cylinder(h=bthick*2,r=screw3hd/2);
	}
	difference() {
		translate([23.3+fan_adjustLR,blower_h-9.5,blower_m_dist-18+bthick]) rotate([30,0,0]) color("blue")
			cubeX([screw4+1,screw4+6,20],2);
		translate([22.3+fan_adjustLR,blower_h-8.5,blower_m_dist-20+bthick]) color("pink") cube([screw4+3,screw4+4,20],2);
		translate([screw4/2+20+fan_adjustLR,screw4+blower_w-13,blower_m_dist+bthick-4.3]) rotate([90,0,90]) cylinder(h=10,d=screw4);
	}
	difference() {
		translate([17.7-blower_w+fan_adjustLR,blower_h-12,0]) color("gray")
			cubeX([screw4+1,screw4+4,blower_m_dist+screw4+1+bthick],2);
		translate([screw4/2+15-blower_w+fan_adjustLR,screw4+blower_w-13.2,blower_m_dist+7.75]) rotate([90,0,90])
			cylinder(h=10,d=Yes4mmInsert());//screw4t);
		translate([4+fan_adjustLR,4,3]) color("white") cylinder(h=bthick*2,r=screw3hd/2);
	}
	difference() {
		translate([17.7-blower_w+fan_adjustLR,blower_h-12,blower_m_dist-18+bthick]) rotate([30,0,0]) color("cyan")
		cubeX([screw4+1,screw4+10,19],2);
		translate([16.7-blower_w+fan_adjustLR,blower_h-8,blower_m_dist-20+bthick]) color("pink") cube([screw4+3,screw4+4,20],2);
		translate([screw4/2+15-blower_w+fan_adjustLR,screw4+blower_w-13.3,blower_m_dist+7.75]) rotate([90,0,90])
			cylinder(h=10,d=Yes4mmInsert());//screw4t);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module blowertest(blower_h,blower_w,blower_m_dist) {
	translate([fan_support-blower_w/4+3,fan_support/2-blower_h/2,bthick-1]) rotate([90,0,90]) blower();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module blower() {
	import("5015_Blower_Fan.stl"); // http://www.thingiverse.com/thing:1576438
}

//////////////////// end of duet2020.scad ////////////////////////////////////////////////////////////
