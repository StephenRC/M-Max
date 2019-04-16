//////////////////////////////////////////////////////////////////////////////////////////
// MMAX-Z-Support.scad - modifiy the TMAX Z supports
// created: 2/16/14
// last modified: 4/6/19
/////////////////////////////////////////////////////////////////////////////////////////
// 8/29/18	- Added make two top or bottom
// 4/4/19	- Removed notch under connecting extrusion mount, replaced minkowski() with cubeX()
//			- fixed nut holes
// 4/6/19	- Rotated clamps to print on their side, new clamp_v2() using cubeX()
////////////////////////////////////////////////////////////////////////////////////////
include <inc/configuration.scad>
include <inc/screwsizes.scad>
include <inc/corner-tools.scad>
// https://www.myminifactory.com/it/object/3d-print-tools-for-fillets-and-chamfers-on-edges-and-corners-straight-and-or-round-45862
// by Ewald Ikemann
use <inc/cubex.scad>
////////////////////////////////////////////////////////////////////////////////////////
zrod = 10;			// z rod size
extr20 = 20.5;		// size of 2020 plus some clearance
screw_dist = 20;	// distance between the clamp screw holes
length = 33;		// clamp length
width = 12;			// clamp width
thickness = 9;		// z clamp thickness
/////////////////////////////////////////////////////////////////////////////////////////
$fn=100;
/////////////////////////////////////////////////////////////////////////////////////////

//top();
//bottom();
//two(1); // 0 = bottom; 1 = top
Clamps(2);

////////////////////////////////////////////////////////////////////////////////////////////

module Clamps(Qty=1) {
	for(a=[0:Qty-1]) translate([0,a*(thickness+3),0]) rotate([90,0,0]) clamp_v2();
}

////////////////////////////////////////////////////////////////////////////////////////

module two(Top=0) {
	if(Top) {
		if($preview) %translate([-100,-100,20.75]) cube([200,200,5]);
		translate([-35,-2.5,0]) top();
		translate([35,2.5,0]) rotate([0,0,180]) top();
	} else {
		if($preview) %translate([-90,-100,20.75]) cube([200,200,5]);
		translate([-45,-2.5,0]) bottom();
		translate([60,2.5,0]) rotate([0,0,180]) bottom();;
	}

}

///////////////////////////////////////////////////////////////////////////////////////////////
	
module top() // top z support
{
	translate([-47,0,0]) {
		difference() {
			color("white") import("original stl/Z ROD MOUNT BOTTOM.stl");
			translate([45,-26,25]) newrod(); // resize rod notch
		}
		difference() {
			filloldnuts();
			translate([35,-18,50]) rotate([90,0,0]) nuts();	// resize nut hole
			translate([55,-18,50]) rotate([90,0,0]) nuts();	// resize nut hole
			translate([34.8,-18,50]) rotate([90,0,0]) color("gray") cylinder(h=10,d=screw5+0.1);
			translate([54.8,-18,50]) rotate([90,0,0]) color("lightgray") cylinder(h=10,d=screw5+0.1);
		}
		topbracket(); // add mount for a brace between left & right tops
		translate([28,-50,25.9]) rotate([90,0,0]) clamp_v2();
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////

module filloldnuts() {
	color("plum") hull() {
		translate([35,-18,50]) rotate([90,0,0]) cylinder(h=3,r=7);
		translate([35,-22,50]) rotate([90,0,0]) cylinder(h=1,r=5);
	}
	color("cyan") hull() {
		translate([55,-18,50]) rotate([90,0,0]) cylinder(h=3,r=7);
		translate([55,-22,50]) rotate([90,0,0]) cylinder(h=1,r=5);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////

module bottom() { // bottom z support
	translate([45,0,0]) {
		difference() {
			color("white") import("original stl/Z ROD MOUNT BOTTOM.stl");
			translate([45,-26,25]) newrod(); // resize rod notch
			bottomhole(); // resize hole to allow a coupler to fit through
			do_fillets(1); // round over where the new hole is
		}
		difference() {
			translate([35,-18,50]) rotate([90,0,0]) nuts();	// resize nut hole
			translate([45,-26,25]) newrod(); // clear rod notch
		}
		difference() {
			translate([55,-18,50]) rotate([90,0,0]) nuts();	// resize nut hole
			translate([45,-26,25]) newrod(); // clear rod notch
		}
		bottomholeouter();
		translate([28,-50,25.9]) clamp_v2();
	}
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
		translate([30.5,38.5,26]) color("pink") cubeX([extr20+7,extr20,1.5*extr20],2);
		translate([44.3,52,2*extr20]) color("red") cube([extr20,extr20,2.5*extr20],true);
		translate([25,49,44]) rotate([0,90,0]) color("black") cylinder(h = 2*extr20, r = screw5/2, $fn = 50);
	}

}

//////////////////////////////////////////////////////////////////////////

module nuts() { // resize nut holes for 5mm
	translate([0,0,-7]) color("red") nut(nut5,10,horizontal=false);
}

/////////////////////////////////////////////////////////////////////////////

module newrod() { // resize the notch for the z rod
	color("black") cylinder(h=40, r = zrod/2, $fn = 100);
}

///////////////////////////////////////////////////////////////////////

module clamp() { // clamp to z rod
	difference() {
		color("white") minkowski() {
			cube([length,width,thickness]);
			cylinder(h=1,r=3);
		}
		// mounting screws
		translate([length/2-screw_dist/2,width/2,-1]) color("red") cylinder(h=thickness+3,r=screw5/2);
		translate([length/2+screw_dist/2,width/2,-1]) color("blue") cylinder(h=thickness+3,r=screw5/2);
		// rod
		translate([length/2,width+5,-0.5]) rotate([90,0,0]) color("plum") cylinder(h=width+10,r=zrod/2);
		// countersinks for screws
		translate([length/2-screw_dist/2,width/2,thickness-2]) color("gray") cylinder(h=thickness+3,r=screw5hd/2);
		translate([length/2+screw_dist/2,width/2,thickness-2]) color("black") cylinder(h=thickness+3,r=screw5hd/2);
	}
}

///////////////////////////////////////////////////////////////////////

module clamp_v2() { // clamp to z rod
	difference() {
		color("white") cubeX([length,width,thickness],2);
		// mounting screws
		translate([length/2-screw_dist/2,width/2,-1]) color("red") cylinder(h=thickness+3,r=screw5/2);
		translate([length/2+screw_dist/2,width/2,-1]) color("blue") cylinder(h=thickness+3,r=screw5/2);
		// rod
		translate([length/2,width+5,-0.5]) rotate([90,0,0]) color("plum") cylinder(h=width+10,r=zrod/2);
		// countersinks for screws
		translate([length/2-screw_dist/2,width/2,thickness-2]) color("gray") cylinder(h=thickness+3,r=screw5hd/2);
		translate([length/2+screw_dist/2,width/2,thickness-2]) color("black") cylinder(h=thickness+3,r=screw5hd/2);
	}
}

/////////////////////// end of mmax z support.scad ////////////////////////////////////////////////////////////////
