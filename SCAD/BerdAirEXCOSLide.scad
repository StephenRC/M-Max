/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//	BerdAirEXCOSLide.scad
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// created 2/25/2021
// last update 3/6/21
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 3/4/21	- Added a bltouch with berd air pipe holder
// 3/6/21	- Added pip to show bltouch side
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <MMAX_h.scad>
include <inc/screwsizes.scad>
include <inc/brassinserts.scad>
include <inc/cubex.scad>
$fn=100;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Use2p5mmInsert=0;
Use3mmInsert=1;
UseLarge3mmInsert=0;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//BerdAirEXCOSLide(); // botton mount
//BerdAirBLTouchEXO(3,8.5,15); // rear mount
//BerdAirEXORear(3,8.5,15); // rear mount
BerdAirBLTouchEXO(2,8.5,15); // rear mount
//BerdAirEXORear(2,8.5,15); // rear mount

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BerdAirEXORear(TDia=3,UpDown=5,DistanceFromMount=12.5) {
	difference() {
		color("cyan") cubeX([20,35,4],2);
		translate([10,7,-3]) {
			color("red") cylinder(h=10,d=screw4);
			translate([0,20,0]) color("blue") cylinder(h=10,d=screw4);
		}
		translate([10,7,1.5]) {
			color("blue") cylinder(h=5,d=screw4hd);
			translate([0,20,0]) color("red") cylinder(h=5,d=screw4hd);
		}
	}
	difference() {
		translate([UpDown-6,0,0]) translate([0,9.5,0]) color("purple") cubeX([15,15,DistanceFromMount+17],2);
		translate([10,7,0]) {
			color("blue") cylinder(h=15,d=screw4hd);
			translate([0,20,0]) color("red") cylinder(h=15,d=screw4hd);
		}
		translate([10,30,15]) rotate([90,0,0]) color("green") cylinder(h=30,d=Yes3mmInsert(Use3mmInsert,UseLarge3mmInsert));
		translate([10,30,28]) rotate([90,0,0]) color("white") cylinder(h=30,d=Yes3mmInsert(Use3mmInsert,UseLarge3mmInsert));
	}
	BerdAirBLTouchEXOCover(TDia);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BerdAirBLTouchEXO(TDia=3,UpDown=5,DistanceFromMount=12.5) {
	difference() {
		color("cyan") cubeX([20,35,4],2);
		translate([10,7,-3]) {
			color("red") cylinder(h=10,d=screw4);
			translate([0,20,0]) color("blue") cylinder(h=10,d=screw4);
		}
		translate([10,7,1.5]) {
			color("blue") cylinder(h=5,d=screw4hd);
			translate([0,20,0]) color("red") cylinder(h=5,d=screw4hd);
		}
	}
	translate([3,17,4]) color("green") sphere(d=screw3); // this side down
	difference() {
		translate([UpDown-6,0,0]) difference() {
			translate([0,9.5,0]) color("purple") cubeX([15,15,DistanceFromMount+17],2);
			translate([0,1,DistanceFromMount+4]) rotate([90,90,90]) BLTouch_Holes(2);
		}
		translate([10,7,0]) {
			color("blue") cylinder(h=15,d=screw4hd);
			translate([0,20,0]) color("red") cylinder(h=15,d=screw4hd);
		}
		translate([10,30,15]) rotate([90,0,0]) color("green") cylinder(h=30,d=Yes3mmInsert(Use3mmInsert,UseLarge3mmInsert));
		translate([10,30,28]) rotate([90,0,0]) color("white") cylinder(h=30,d=Yes3mmInsert(Use3mmInsert,UseLarge3mmInsert));
	}
	BerdAirBLTouchEXOCover();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BLTouch_Holes(recess=0,Screw=Yes2p5mmInsert(Use2p5mmInsert)) {
	if(recess == 2) {	// mounting screw holes only
		translate([bltouch/2,16,-10]) color("pink") cylinder(h=25,d=Screw);
		translate([-bltouch/2,16,-10]) color("black") cylinder(h=25,d=Screw);
		translate([bltouch/2-9,16,-10]) color("white") cylinder(h=25,d=screw5); // adjuster access
	}
	if(recess == 1) {	// dependent on the hotend, for mounting under the extruder plate
		translate([-bltl/2,bltw/2,bltdepth-6]) color("cyan") { // depression for BLTouch
			// it needs to be deep enough for the retracted pin not to touch bed
			cubeX([bltl,bltw,wall],2);
		}
		translate([bltouch/2,16,-10]) color("pink") cylinder(h=25,r=screw2/2);
		translate([-bltouch/2,16,-10]) color("black") cylinder(h=25,r=screw2/2);

	}
	if(recess == 0) {	// for mounting on top of the extruder plate
		translate([-bltl/2+8,bltw/2,-5]) color("blue") cubeX([bltd,bltd+2,wall+3],2); // hole for BLTouch
		translate([bltouch/2,16,-10]) color("pink") cylinder(h=25,r=screw2/2);
		translate([-bltouch/2,16,-10]) color("black") cylinder(h=25,r=screw2/2);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BerdAirBLTouchEXOCover(TDia=3) {
	translate([-1,5,-4.5]) rotate([90,0,0]) {  // remove translate & rotate to test fit part
		difference() {
			translate([2.5,4.5,9]) color("lightgray") cubeX([15,5,25],2);
			translate([10,30,15]) rotate([90,0,0]) color("green") cylinder(h=30,d=screw3);
			translate([10,30,28]) rotate([90,0,0]) color("black") cylinder(h=30,d=screw3);
			translate([-7,9,20]) rotate([90,0,90]) color("gray") hull() {
				cylinder(h=40,d=TDia);
				translate([3,0,0])  cylinder(h=40,d=TDia);
			}
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BerdAirEXCOSLide() {
	difference() {
		union() {
			color("cyan") cubeX([30,20,3.5],1);
			translate([28,-20,0]) color("plum") cubeX([3,40,10],1);
			translate([25,-20,0]) color("pink") cubeX([5,10,10],1);
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
		color("green") cubeX([28,20,4],1);
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