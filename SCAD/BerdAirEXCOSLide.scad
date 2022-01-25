/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//	BerdAirEXCOSLide.scad
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// created 2/25/2021
// last update 9/16/21
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// https://creativecommons.org/licenses/by-sa/4.0/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 3/4/21	- Added a bltouch with berd air pipe holder
// 3/6/21	- Added pip to show bltouch side
// 3/27/21	- Changed to use BOSL2 library, added a u-turn fitting for the berd inline pump
// 9/16/21	- Added a mount to go on teh top of a E3DV6 heatsink: E3DV6Mount()
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <MMAX_h.scad>
include <inc/screwsizes.scad>
include <inc/brassinserts.scad>
$fn=100;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Use2p5mmInsert=0;
Use3mmInsert=1;
LargeInsert=0;
LayerThickness=0.3;
Clearance=0.9;
E3DV6diameter=16+Clearance; // diameter of section right above heat sink
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//BerdAirBLTouchEXO(2,7,15); // rear mount
//BerdAirEXORear(2,15); // rear mount
E3DV6Mount(2,0);  // moount on the top section of the heatsink

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module E3DV6Mount(PipeSize=2,DoClamp=1) {
	difference() {
		color("cyan") hull() {
			cylinder(h=5,d=E3DV6diameter*2-3);
			translate([-30,-E3DV6diameter/2,0]) cuboid([3,E3DV6diameter,8],rounding=1.5,p1=[0,0]);
		}
		translate([-32,-4,4.5]) color("pink") rotate([0,90,0]) cylinder(h=15,d=Yes3mmInsert(Use3mmInsert,LargeInsert));
		translate([-32,4,4.5]) color("pink") rotate([0,90,0]) cylinder(h=15,d=Yes3mmInsert(Use3mmInsert,LargeInsert));
		translate([0,0,-5]) color("red") cylinder(h=20,d=E3DV6diameter);
		translate([0,0,2.5]) rotate([0,90,0]) color("blue") cylinder(h=20,d=screw3t); // holding screw, tap plastic for M3
	}
	BAClamp(PipeSize);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BAClamp(PipeSize=2) {
	translate([-39,0,32]) rotate([0,-90,0]) {
		difference() { // clamp
			union() {
				translate([-32,-E3DV6diameter/2,0]) color("green") cuboid([3,E3DV6diameter,8],rounding=1.5,p1=[0,0]);
				translate([-32,0,4]) rotate([0,90,0]) cylinder(h=LayerThickness,d=25);
			}
			translate([-33,-4,4.5]) color("blue") rotate([0,90,0]) cylinder(h=15,d=screw3);
			translate([-33,4,4.5]) color("khaki") rotate([0,90,0]) cylinder(h=15,d=screw3);
			translate([-29,0,-8]) color("gray") cylinder(h=20,d=PipeSize);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BerdAirEXORear(TubeDiameter=3,DistanceFromMount=12.5) {
	difference() {
		color("cyan") cuboid([20,35,4], rounding=2);
		translate([0,-10,-3]) {
			color("red") cylinder(h=10,d=screw4);
			translate([0,20,0]) color("blue") cylinder(h=10,d=screw4);
		}
		translate([0,-10,1]) {
			color("blue") cylinder(h=5,d=screw4hd);
			translate([0,20,0]) color("red") cylinder(h=5,d=screw4hd);
		}
	}
	difference() {
		translate([0,-9,17]) translate([0,9.5,0]) color("purple") cuboid([15,15,DistanceFromMount+23],rounding=2);
		translate([0,-10,0]) {
			color("blue") cylinder(h=15,d=screw4hd);
			translate([0,20,0]) color("red") cylinder(h=15,d=screw4hd);
		}
		translate([-10,-13,0]) BerdAirCoverMountHoles(Yes3mmInsert(Use3mmInsert,UseLarge3mmInsert));
	}
	translate([0,15,1]) color("green") sphere(d=screw3); // this side down
	BerdAirBLTouchEXOCover(TubeDiameter);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BerdAirBLTouchEXO(TubeDiameter=3,UpDown=5,DistanceFromMount=12.5) {
	difference() {
		color("cyan") cuboid([20,35,4],rounding=2);
		translate([0,-10,-3]) {
			color("red") cylinder(h=10,d=screw4);
			translate([0,20,0]) color("blue") cylinder(h=10,d=screw4);
		}
		translate([0,-10,1.5]) {
			color("blue") cylinder(h=5,d=screw4hd);
			translate([0,20,0]) color("red") cylinder(h=5,d=screw4hd);
		}
	}
	translate([0,15,1]) color("green") sphere(d=screw3); // this side down
	difference() {
		translate([UpDown-6,0,0]) difference() {
			translate([0,0.5,17]) color("purple") cuboid([15,15,DistanceFromMount+23],rounding=2);
			translate([-3,-16,DistanceFromMount+4]) rotate([90,90,90])	BLTouch_Holes(2);
		}
		translate([0,-10,0]) {
			color("blue") cylinder(h=15,d=screw4hd);
			translate([0,20,0]) color("red") cylinder(h=15,d=screw4hd);
		}
		translate([-10,-13,0]) BerdAirCoverMountHoles(Yes3mmInsert(Use3mmInsert,UseLarge3mmInsert));
	}
	BerdAirBLTouchEXOCover();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BLTouch_Holes(recess=0,Screw=Yes2p5mmInsert(Use2p5mmInsert)) {
	if(recess == 2) {	// mounting screw holes only
		translate([bltouch/2,16,-10]) color("pink") cylinder(h=25,d=Screw);
		translate([-bltouch/2,16,-10]) color("lightgray") cylinder(h=25,d=Screw);
		translate([bltouch/2-9,16,-10]) color("white") cylinder(h=25,d=screw5); // adjuster access
	}
	if(recess == 1) {	// dependent on the hotend, for mounting under the extruder plate
		translate([-bltl/2,bltw/2,bltdepth-6]) color("cyan") { // depression for BLTouch
			// it needs to be deep enough for the retracted pin not to touch bed
			cuboid([bltl,bltw,wall],rounding=2);
		}
		translate([bltouch/2,16,-10]) color("pink") cylinder(h=25,r=screw2/2);
		translate([-bltouch/2,16,-10]) color("black") cylinder(h=25,r=screw2/2);

	}
	if(recess == 0) {	// for mounting on top of the extruder plate
		translate([-bltl/2+8,bltw/2,-5]) color("blue") cuboid([bltd,bltd+2,wall+3],rounding=2); // hole for BLTouch
		translate([bltouch/2,16,-10]) color("pink") cylinder(h=25,r=screw2/2);
		translate([-bltouch/2,16,-10]) color("black") cylinder(h=25,r=screw2/2);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BerdAirBLTouchEXOCover(TubeDiameter=3) {
	translate([0,-20,-9.5]) rotate([90,0,0]) {  // remove translate & rotate to test fit part
		difference() {
			translate([0,10,21]) color("lightgray") cuboid([15,5,30],rounding=2);
			translate([-10,-13,0]) BerdAirCoverMountHoles(screw3);
			translate([-17,13.5-TubeDiameter/2,27]) rotate([90,0,90]) color("blue") hull() {
				cylinder(h=40,d=TubeDiameter);
				translate([3,0,0])  cylinder(h=40,d=TubeDiameter);
			}
			translate([0,10,5]) color("blue") cuboid([5,10,5],rounding=2); // notch the botton
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BerdAirCoverMountHoles(Screw=screw3) {
	translate([10,30,12]) rotate([90,0,0]) color("green") cylinder(h=30,d=screw3);
	translate([10,30,32]) rotate([90,0,0]) color("black") cylinder(h=30,d=screw3);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BerdAirEXCOSLide() {
	difference() {
		union() {
			color("cyan") cuboid([30,20,3.5],rounding=1);
			translate([28,-20,0]) color("plum") cuboid([3,40,10],rounding=1);
			translate([25,-20,0]) color("pink") cuboid([5,10,10],rounding=1);
		}
		translate([5,10,-3]) EXOScrewMounts();
		translate([5,10,3]) EXOScrewMounts(screw4hd);
		translate([7,30,2.5]) rotate([90,0,22]) color("lightgray") hull() {
			cylinder(h=40,d=screw3-0.1);
			translate([0,3,0])  cylinder(h=40,d=screw3-0.1);
		}
	}
	translate([0,25,0]) Clamp();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Clamp() {
	difference() {
		color("green") cuboid([28,20,4],rounding=1);
		translate([5,10,-3]) EXOScrewMounts();
		translate([5,10,3]) EXOScrewMounts(screw4hd);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

 module EXOScrewMounts(Screw=screw4) {
	 color("red") cylinder(h=10,d=Screw);
	 translate([20,0,0]) color("blue") cylinder(h=10,d=Screw);
 }
 
 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////