//////////////////////////////////////////////////////////////////////////////////////////
// ZSupport.scad - modifiy the TMAX Z supports
// created: 2/16/14
// last modified: 2/10/22
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// https://creativecommons.org/licenses/by-sa/3.0/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 8/29/18	- Added make two top or bottom
// 4/4/19	- Removed notch under connecting extrusion mount, replaced minkowski() with cubeX()
//			- fixed nut holes in top()
// 4/6/19	- Rotated clamps to print on their side, new clamp_v2() using cubeX()
// 4/27/19	- fixed nut holes in bottom()
// 6/29/20	- Can now use 5mm brass inserts
// 4/10/21	- Converted to BOSL2
// 2/1/22	- Beefed up z rod clamp; renamed modules
// 2/10/22	- Added end screw on horizontal support on top bracket
////////////////////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
include <bosl2/std.scad>
include <inc/brassinserts.scad>
////////////////////////////////////////////////////////////////////////////////////////
ZRodDiameter = 10;			// z rod size
extr20 = 20.5;		// size of 2020 plus some clearance
screw_dist = 20;	// distance between the clamp screw holes
length = 33;		// clamp length
width = 12;			// clamp width
thickness = 9;		// z clamp thickness
/////////////////////////////////////////////////////////////////////////////////////////
$fn=100;
Use5mmInsert=1;
/////////////////////////////////////////////////////////////////////////////////////////

TopBracket(2,Yes5mmInsert(Use5mmInsert));
//BottomBracket(2,Yes5mmInsert(Use5mmInsert)); // bottom not need for z belt drive
//two(1,Yes5mmInsert(Use5mmInsert)); // 0 = bottom; 1 = top
//Clamps(2);

////////////////////////////////////////////////////////////////////////////////////////////

module Clamps(Qty=1,Screw=screw5) {
	for(a=[0:Qty-1]) translate([0,a*(thickness+3),0]) rotate([90,0,0]) Clamp(Screw);
}

////////////////////////////////////////////////////////////////////////////////////////

module two(Top=0,Screw=Yes5mmInsert(Use5mmInsert)) {
	if(Top) {
		translate([-35,-2.5,0]) TopBracket(Screw);
		translate([35,2.5,0]) rotate([0,0,180]) TopBracket();
	} else {
		translate([-45,-2.5,0]) BottomBracket(Screw);
		translate([60,2.5,0]) rotate([0,0,180]) BottomBracket();;
	}

}

///////////////////////////////////////////////////////////////////////////////////////////////
	
module TopBracket(Quanity=1,Screw=Yes5mmInsert(Use5mmInsert),AllHoles=0) { // top z support
	for(x=[0:Quanity-1]) translate([x*95,0,0]) {
		difference() {
			OriginalPart();
			translate([45,-26,25]) NewZRod(); // resize rod notch
			RedoScrewHoles(Screw);
			translate([44,-30,44]) rotate([90,0,0]) color("green") cyl(h=50,d=screw5); // acess hole for end screw
		}
		NewNutHole(Yes5mmInsert(Use5mmInsert));
		Top2020Mount(AllHoles); // add mount for a brace between left & right tops
		translate([45,-35,32]) rotate([90,0,0]) Clamp();
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////

module FillOldNutHoles() {
	color("plum") hull() {
		translate([35,-18,50]) rotate([90,0,0]) cylinder(h=3,r=7);
		translate([35,-23,50]) rotate([90,0,0]) cylinder(h=1,r=5);
	}
	color("cyan") hull() {
		translate([55,-18,50]) rotate([90,0,0]) cylinder(h=3,r=7);
		translate([55,-23,50]) rotate([90,0,0]) cylinder(h=1,r=5);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////

module NewNutHole(Screw=Yes5mmInsert(Use5mmInsert)) {
	difference() {
		FillOldNutHoles();
		if(Screw==screw5) {
			translate([35,-18,50]) rotate([90,0,0]) NutHole();	// resize nut hole
			translate([55,-18,50]) rotate([90,0,0]) NutHole();	// resize nut hole
		}
		RedoScrewHoles(Screw);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////

module RedoScrewHoles(Screw=Yes5mmInsert(Use5mmInsert)) {
		translate([34.8,-17,50]) rotate([90,0,0]) color("gray") cylinder(h=10,d=Screw);
		translate([54.8,-17,50]) rotate([90,0,0]) color("lightgray") cylinder(h=10,d=Screw);
}

/////////////////////////////////////////////////////////////////////////////

module NutHole() { // resize nut holes for 5mm
	translate([0,0,-7]) color("red") nut(nut5,10,horizontal=false);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////

module BottomBracket(Quanity=1,Screw=Yes5mmInsert(Use5mmInsert)) { // bottom z support
	for(x=[0:Quanity-1]) translate([x*95,0,0]) {
		difference() {
			OriginalPart();
			translate([45,-26,25]) NewZRod(); // resize rod notch
			OldCouplerHole(); // resize hole to allow a coupler to fit through
			RedoScrewHoles(Screw);
		}
		NewNutHole();
		NewCouplerHole();
		translate([45,-35,30.5]) Clamp();
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////

module OriginalPart() {
	color("lightgray") import("original stl/Z ROD MOUNT BOTTOM.stl",convexity=3);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////

module OldCouplerHole() {  // resize hole to allow a coupler to fit through
	translate([45,4,30]) color("cyan") cyl(h=10.1,d=27,rounding=-2);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////

module NewCouplerHole() { // new surround were the coupler & z screw goes through
	difference() {
		translate([45,4,30.5]) color("red") cyl(h=9,d=35,rounding=2);
		OldCouplerHole();
	}
}

/////////////////////////////////////////////////////////////////////////////////////////

module Top2020Mount(AllHoles=0)  // for top horizontal brace between left & right sides
{
	difference() {
		translate([30.5,35,26]) color("pink") cuboid([extr20+7,extr20+3,1.5*extr20],rounding=2,p1=[0,0]);
		translate([44.3,49,2*extr20]) color("red") cuboid([extr20,extr20,2.5*extr20]);
		if(AllHoles) {
            translate([25,49,44]) rotate([0,90,0]) color("black") cylinder(h = 2*extr20,d=screw5);
            translate([29,49,44]) rotate([0,90,0]) color("white") cyl(h=5,d=screw5hd);
            translate([60,49,44]) rotate([0,90,0]) color("gray") cyl(h=5,d=screw5hd);
		}
        translate([44,30,44]) rotate([90,0,0]) color("green") cyl(h=50,d=screw5); // end hole
		translate([44,33,44]) rotate([90,0,0]) color("gold") cyl(h=5,d=screw5hd);
	}
}

//////////////////////////////////////////////////////////////////////////


module NewZRod() { // resize the notch for the z rod
	color("white") cylinder(h=40,d=ZRodDiameter);
}


///////////////////////////////////////////////////////////////////////

module Clamp(Screw=screw5) { // clamp to z rod
	difference() {
		union() {
			color("white") cuboid([length,width,thickness],rounding=2);
			translate([0,0,2]) color("blue") rotate([90,0,0]) cyl(h=width,d=ZRodDiameter*1.25,rounding=2);
		}
		translate([0,width,-ZRodDiameter/3-0.5]) rotate([90,0,0]) color("plum") cylinder(h=width+10,d=ZRodDiameter);
		translate([0,0,0]) ClampMountingHoles(Screw);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ClampMountingHoles(Screw=screw5) {
	translate([-screw_dist/2,0,0]) color("red") cyl(h=thickness+3,d=Screw);
	translate([screw_dist/2,0,0]) color("blue") cyl(h=thickness+3,d=Screw);
	translate([-screw_dist/2,0,thickness-1]) color("gray") cyl(h=thickness,d=screw5hd);
	translate([+screw_dist/2,0,thickness-1]) color("black") cyl(h=thickness,d=screw5hd);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
