//////////////////////////////////////////////////////////////////////////////////////////
// ZSupport.scad - modifiy the TMAX Z supports
// created: 2/16/14
// last modified: 4/10/21
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
////////////////////////////////////////////////////////////////////////////////////////
include <inc/configuration.scad>
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

//top(Yes5mmInsert(Use5mmInsert));
//bottom(Yes5mmInsert(Use5mmInsert));
two(1,Yes5mmInsert(Use5mmInsert)); // 0 = bottom; 1 = top

////////////////////////////////////////////////////////////////////////////////////////////

module Clamps(Qty=1,Screw=screw5) {
	for(a=[0:Qty-1]) translate([0,a*(thickness+3),0]) rotate([90,0,0]) clamp(Screw);
}

////////////////////////////////////////////////////////////////////////////////////////

module two(Top=0,Screw=Yes5mmInsert(Use5mmInsert)) {
	if(Top) {
		translate([-35,-2.5,0]) top(Screw);
		translate([35,2.5,0]) rotate([0,0,180]) top();
	} else {
		translate([-45,-2.5,0]) bottom(Screw);
		translate([60,2.5,0]) rotate([0,0,180]) bottom();;
	}

}

///////////////////////////////////////////////////////////////////////////////////////////////
	
module top(Screw=Yes5mmInsert(Use5mmInsert)) { // top z support
	translate([-47,0,0]) {
		difference() {
			OriginalPart();
			translate([45,-26,25]) newrod(); // resize rod notch
			RedoScrewHoles(Screw);
		}
		replace_nuts(Yes5mmInsert(Use5mmInsert));
		topbracket(); // add mount for a brace between left & right tops
		translate([28,-50,25.9]) rotate([90,0,0]) clamp();
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////

module filloldnuts() {
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

module replace_nuts(Screw=Yes5mmInsert(Use5mmInsert)) {
	difference() {
		filloldnuts();
		if(Screw==screw5) {
			translate([35,-18,50]) rotate([90,0,0]) nuts();	// resize nut hole
			translate([55,-18,50]) rotate([90,0,0]) nuts();	// resize nut hole
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

module nuts() { // resize nut holes for 5mm
	translate([0,0,-7]) color("red") nut(nut5,10,horizontal=false);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////

module bottom(Screw=Yes5mmInsert(Use5mmInsert)) { // bottom z support
	translate([45,0,0]) {
		difference() {
			OriginalPart();
			translate([45,-26,25]) newrod(); // resize rod notch
			bottomhole(); // resize hole to allow a coupler to fit through
			do_fillets(1); // round over where the new hole is
			RedoScrewHoles(Screw);
		}
		replace_nuts();
		bottomholeouter();
		translate([28,-50,25.9]) clamp_v2();
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////

module OriginalPart() {
	color("lightgray") import("original stl/Z ROD MOUNT BOTTOM.stl",convexity=3);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////

module bottomhole() {  // resize hole to allow a coupler to fit through
	translate([45,4,20]) color("cyan") cylinder(h=20,d=27);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////

module bottomholeouter() { // new surround were the coupler & z screw goes through
	difference() {
		translate([45,4,26]) color("red") cylinder(h=8,d=35);
		bottomhole();
		do_fillets();
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////

module do_fillets(JustInner=0) { // round over the new hole
	if(JustInner) {
		translate([45,4,34]) color("blue") fillet_r(2,27/2, -1,$fn);		// inner
		translate([45,4,26]) color("gray") rotate([0,180,0]) fillet_r(2,27/2, -1,$fn);		// inner
	} else {
		translate([45,4,34]) color("plum") fillet_r(2,35/2, 1,$fn);		// outer
		translate([45,4,34]) color("blue") fillet_r(2,27/2, -1,$fn);		// inner
		translate([45,4,26]) color("black") rotate([0,180,0]) fillet_r(2,35/2, 1,$fn);		// outer
		translate([45,4,26]) color("gray") rotate([0,180,0]) fillet_r(2,27/2, -1,$fn);		// inner
	}
}

/////////////////////////////////////////////////////////////////////////////////////////

module topbracket()  // for top horizontal brace between left & right sides
{
	difference() {
		translate([30.5,38.5,26]) color("pink") cuboid([extr20+7,extr20,1.5*extr20],rounding=2,p1=[0,0]);
		translate([44.3,52,2*extr20]) color("red") cuboid([extr20,extr20,2.5*extr20]);
		translate([25,49,44]) rotate([0,90,0]) color("black") cylinder(h = 2*extr20, r = screw5/2, $fn = 50);
	}

}

//////////////////////////////////////////////////////////////////////////


module newrod() { // resize the notch for the z rod
	color("white") cylinder(h=40, r = ZRodDiameter/2, $fn = 100);
}


///////////////////////////////////////////////////////////////////////

module clamp(Screw=screw5) { // clamp to z rod
	difference() {
		color("white") cuboid([length,width,thickness],rounding=2,p1=[0,0]);
		// mounting screws
		translate([length/2-screw_dist/2,width/2,-1]) color("red") cylinder(h=thickness+3,d=Screw);
		translate([length/2+screw_dist/2,width/2,-1]) color("blue") cylinder(h=thickness+3,d=Screw);
		// rod
		translate([length/2,width+5,-0.5]) rotate([90,0,0]) color("plum") cylinder(h=width+10,d=ZRodDiameter);
		// countersinks for screws
		if(Screw==screw5) {
			translate([length/2-screw_dist/2,width/2,thickness-2]) color("gray") cylinder(h=thickness+3,d=screw5hd);
			translate([length/2+screw_dist/2,width/2,thickness-2]) color("black") cylinder(h=thickness+3,d=screw5hd);
		}
	}
}

/////////////////////// end of mmax z support.scad ////////////////////////////////////////////////////////////////
