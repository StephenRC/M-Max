//////////////////////////////////////////////////////////////////////////////
// DrillGuides.scad
//////////////////////////////////////////////////////////////////////////////
// created 4/6/2016
// last update 9/15/20
//////////////////////////////////////////////////////////////////////////////
// 4/7/16	- began to add a version to use on makerslide
// 4/13/16	- corrected distance between holes
// 6/24/16	- made so that offset determines length
// 9/2/18	- added color for preview
// 6/4/20	- Remosed test() and renamed from drillguide() to ExtruderPlateDrillGuide()
// 9/15/20	- Added use of brass inserts to make the 2020DrillGuide() last longer, if used, they need to drill to M5
//////////////////////////////////////////////////////////////////////////////
// A drill guide for 2020 to be able to eliminate the lower T-Max plastic brackets
// on the base section.  It's stiffer than using the plastic printed parts.
// Use both holes on the bottom of the corners pieces on two ajoining sides,
// one hole at the top for the front to back 2020.
// ** The 5mm brass inserts will need to be drilled out to 5mm **
//////////////////////////////////////////////////////////////////////////////
include <bosl2/std.scad>
include <inc/screwsizes.scad>
use <inc/brassinserts.scad>
$fn=100;
///////////////////////////////////////////////////////////////////////////////
// vars
/////////////////////////////////////////////////////////////////////////////
Use3mmInsert=1;
Use5mmInsert=1;
UseLarge3mmInsert=1;
thickness = 5;			// total thickness
w2020 = 20.1;			// width of the 2020 with some clearance
bottom = 10;			// location of bottom 2020 access hole
offset = 80;			// offset between bottom 2020 and the Y axis 2020
length = offset+bottom+15;	// total length of drill guide
width = w2020+ 10;		// total width of drill guide
///////////////////////////////////////////////////////////////////////////////

//2020DrillGuide(screw5);
BedDrillClips(4); // used to hold the bed onto the 2020 to drill the adjusting mount holes
			   // use #39 drill bit for all three holes, M3 tap the 2020, drill the bed holes 3mm and countersink

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module cubeX(size,Rounding) { // temp module
	cuboid(size,rounding=Rounding,p1=[0,0]);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BedDrillClips(Quanity=1) { // used to hold bed onto the 2020 to drill the adjusting mount holes
	for(x=[0:Quanity-1]) {
		translate([x*23,0,0]) difference() {
			union() {
				color("cyan") cubeX([20,45,4],2);
				color("blue") cubeX([20,4,20],2);
			}
			translate([10,35,-3]) color("red") cylinder(h=10,d=screw5);
			translate([10,8,12]) rotate([90,0,0]) color("gray") cylinder(h=10,d=Yes3mmInsert(Use3mmInsert,UseLarge3mmInsert));
		}
	}
}
/////////////////////////////////////////////////////////////////////////////////

module 2020DrillGuide(Screw=Yes5mmInsert(Use5mmInsert)) { //2020 channel
	
	difference() {
		color("red") cubeX([length,width,thickness+2],2);
		translate([5,5,3]) color("blue") cube([length,w2020,thickness]);
		translate([bottom+5,w2020/2+5,-5]) color("red") cylinder(h=20,d=Screw);
		translate([offset+bottom+5,w2020/2+5,-5]) color("cyan") cylinder(h=20,d=Screw);
	}
}

//////////////////// end of drillguide.scad //////////////////////////////////////

