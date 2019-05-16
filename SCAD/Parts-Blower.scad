////////////////////////////////////////////////////////////////////////////
// Parts-Blower.scad - adapter for blower fan to an AL plate
//////////////////////////////////////////////////////////////////////////
// created 5/21/2016
// last update 3/1/19
//////////////////////////////////////////////////////////////////////////
// 6/29/16 Made fan mount a bit thicker
// 7/19/16 Added adapter3() for corexy x-carriage extruder plate
// 8/26/16 Uses fanduct.scad see http://www.thingiverse.com/thing:387301
//		   Have it in the same folder as this file
// 9/30/16 Added adapter for the titan extruder setup, some vars and modules are from
//		   corexy-x-carriage.scad
// 7/13/18 Added color to preview
// 8/20/18 Removed unused code
// 2/13/19 Changed to current extruder with titan
// 2/14/19 Removed and renamed variables used.
// 3/1/19  Fixed Long_Motor_version() for the spacer
//////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
use <inc/cubeX.scad>
use <fanduct.scad> // http://www.thingiverse.com/thing:387301
$fn=100;
//////////////////////////////////////////////////////////////////////////
// vars
//////////////////////////////////////////////////////////////////////////
Thickness = 6.5;
MHeight = 6;
MWidth = 60;
FHeight = 10;
MountingHoleHeight = 60; 	// screw holes may need adjusting when changing the front to back size
ExtruderOffset = 18;		// adjusts extruder mounting holes from front edge
FanSpacing = 32;			// hole spacing for a 40mm fan
//////////////////////////////////////////////////////////////////////////

Long_Motor_version(0,6,25,6,0);
//Short_Motor_version(0,6,25,6); // 1st arg: fan duct;
								// 2nd arg is side offset
								// 3rd arg: move up/down M4 blower mounting hole
								// 4th arg: move front/rear M4 blower mounting hole
///////////////////////////////////////////////////////////////////////////////////////////////////

module Short_Motor_version(Duct=0,Move=0,Raise=0,Back=0,Offset=0) {
	difference() {
		color("cyan") cubeX([FanSpacing+Move/2+4,MHeight,Thickness],1);
		BracketMount();
	}
	difference() {
		FanBlowerMount(Move,Raise,Back);
		BracketMount();
	}
	if(Duct) translate([-5,-12,1.5]) color("red") FanDuct();
}

///////////////////////////////////////////////////////////////////////////

module Long_Motor_version(Duct=0,Move=0,Raise=0,Back=0,Offset=0) { // stepper side
	difference() {
		color("cyan") cubeX([FanSpacing+7,MHeight,Thickness],1);
		translate([0,0,0.5]) BracketMount();
//		translate([Move+9,-7,-14]) rotate([35,0,0]) color("lightblue") cubeX([15,15,15],1);
	}
	difference() {
		translate([0,Offset+10,0]) FanBlowerMount(Move,Raise,6,0,0,4,1,Offset);
		translate([0,0,0.5]) BracketMount();
	}
	if(Duct) translate([-5,-15,1.5]) color("red") FanDuct();
}

//////////////////////////////////////////////////////////////////////////////////////////////////////

module FanBlowerMount(Move=0,Raise=0,Back=0,X=0,Y=0,Z=0,Spacer=0,Offset=0) {
	if(Spacer) {
		difference() {
			translate([Move+6,-30+Back,0]) color("gray") cubeX([21,21-Back,Raise+Z+5],1);
			RemoveForBlower(Move+6,Raise,Spacer);
			translate([Move+X,-14-Back+Y,Raise+Z]) rotate([0,90,0]) color("purple") cylinder(h=42,r=screw4/2,$fn=50);
			translate([Move+2,-40+Back,9]) rotate([-45,0,0]) color("black") cube([30,30,10]);
		}
		difference() {
			translate([Move+6,Offset+2,0]) color("lightgray") cubeX([21,Offset,Thickness],1);
			translate([0,0,0.5]) BracketMount(Move);
			translate([5,-5-Offset,0]) color("plum") cube([30,20,20]);
		}
	} else {
		difference() {
			translate([Move,-16+Back,0]) color("gray") cubeX([21,21-Back,Raise+4],1);
			RemoveForBlower(Move,Raise);
			translate([Move+X,-Back+Y,Raise+Z]) rotate([0,90,0]) color("purple") cylinder(h=42,r=screw4/2,$fn=50);
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BracketMount(Move=0) {
	translate([3,10,FHeight/4+0.3]) rotate([90,0,0]) color("red") cylinder(h = 18,r = screw3/2,$fn=50);
	translate([3,1,FHeight/4+0.3]) rotate([90,0,0]) color("gray") cylinder(h = 18,r = screw3hd/2,$fn=50);
	translate([3+FanSpacing,10,FHeight/4+0.3]) rotate([90,0,0]) color("blue") cylinder(h = 18,r = screw3/2,$fn=50);
	translate([3+FanSpacing,1,FHeight/4+0.3]) rotate([90,0,0]) color("plum") cylinder(h = 18,r = screw3hd/2,$fn=50);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module RemoveForBlower(Move=0,Raise=0,Spacer=0) {
	if(Spacer) {
		translate([Move+3,-57,-10]) color("yellow") cubeX([15,45,Raise*2],1);
		//translate([Move+3,-15.5,-17]) rotate([35,0,0]) color("lightgreen") cubeX([15,15,15],1);
	} else {
		translate([Move+3,-45,-10]) color("yellow") cubeX([15,45,Raise*2],1);
	}
}


//////////////////////////////end of parts-blower.scad///////////////////////////////////////////////////////////////////////