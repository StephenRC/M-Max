//////////////////////////////////////////////////////////////////////////////
// drill guide 2020 for M-Max
//////////////////////////////////////////////////////////////////////////////
// created 4/6/2016
// last update 9/2/2018
//////////////////////////////////////////////////////////////////////////////
// 4/7/16	- began to add a version to use on makerslide
// 4/13/16	- corrected distance between holes
// 6/24/16	- made so that offset determines length
// 9/2/18	- added color for preview
//////////////////////////////////////////////////////////////////////////////
// A drill guide for 2020 to be able to eliminate the lower T-Max plastic brackets
// on the base section.  It's stiffer than using the plastic printed parts.
// Use both holes on the bottom of the corners pieces on two ajoining sides,
// one hole at the top for the front to back 2020.
//////////////////////////////////////////////////////////////////////////////
include <inc/cubex.scad>
$fn=100;
///////////////////////////////////////////////////////////////////////////////
// vars
/////////////////////////////////////////////////////////////////////////////
screw5 = 5.6;
width = 30;
thickness = 5;
w2020 = 20.1;
bottom = 10;
offset = 80;
length = offset + 25;
////////////////////////////////////////////////////////////////////////////////

drillguide();
//test(); // test print for fitting 2020

/////////////////////////////////////////////////////////////////////////////////

module drillguide() { //2020 channel
	difference() {
		color("red") cubeX([length,width,thickness+2],2);
		translate([5,5,3]) color("blue") cube([length,w2020,thickness]);
		translate([bottom+5,w2020/2+5,-5]) color("gray") cylinder(h=20,r=screw5/2,$fn=100);
		translate([offset+bottom+5,w2020/2+5,-5]) color("black") cylinder(h=20,r=screw5/2,$fn=100);
	}
}

/////////////////////////////////////////////////////////////////////////////////

//module drillguideMS() { // to use on makerslide
//	difference() {
//		color("blue") cubeX([length,width-10,thickness+2],2);
//		translate([5,-1,3]) color("red") cube([length,width+2,thickness]);
//		translate([bottom+5,w2020/2,-5]) color("black") cylinder(h=20,r=screw5/2,$fn=100);
//		translate([offset+bottom+5,w2020/2,-5]) color("gray") cylinder(h=20,r=screw5/2,$fn=100);
//	}
//  // needs a notch for using on the rail side
//}

//////////////////////////////////////////////////////////////////////////////////

module test() { // test print for fitting 2020
	difference() {
		drillguide();
		translate([20,-2,-2]) color("gold") cube([length+5,width+5,thickness*2]);
	}
}

//////////////////// end of drillguide.scad //////////////////////////////////////

