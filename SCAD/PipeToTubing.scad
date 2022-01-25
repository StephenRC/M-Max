///////////////////////////////////////////////////////////////////////////////////////////////////
// PipeToTubing.scad -- mount a silencer on the brad air pump inlet
//////////////////////////////////////////////////////////////////////////////////////////////////
// C:4/18/21
// L:1/7/22
/////////////////////////////////////////////////////////////////////////////////////////////////
// https://creativecommons.org/licenses/by-sa/4.0/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <BOSL2/std.scad>
include <BOSL2/threading.scad>
//////////////////////////////////////////////////////////////////////////////////////////////////////
$fn=100;
LayerThickness=0.3;
//////////////////////////////////////////////////////////////////////////////////////////////////////

PipeToTubing(3/8,0); // 3/8" pipe thread
//Hose6mmUTurn();

///////////////////////////////////////////////////////////////////////////////////////////////////////////

module PipeToTubing(Size=3/8,ShowCrossSection=0) {
	difference() {
		NutBase();
		if(ShowCrossSection) translate([-12,0,-12]) color("gray") cube([25,25,25]);   // to see cross section
		translate([0,0,-3]) color("cyan") npt_threaded_rod(size=Size,$fn=72);
	}
	translate([0,0,4.6276]) color("white") cylinder(h=LayerThickness,d=18);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module NutBase() {
	difference() {
		union() {
			translate([0,0,0]) color("blue") cyl(h=20,d=25,chamfer=2,$fn=6);
			color("plum") cylinder(h=25,d=6,$fn=100);
		}
		translate([0,0,-12]) cylinder(h=10,r1=10,r2=3,$fn=100); // bevel thread start
		translate([0,0,0]) color("red") cylinder(h=30,d=4.5,$fn=100);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Hose6mmUTurn() {
	difference() {
		union() {
			color("cyan") cylinder(h=15,d=6);
			color("gray") cylinder(h=LayerThickness,d=15);
		}
		translate([0,0,-5]) color("red") cylinder(h=20,d=3);
		translate([-5,3,8]) color("gray") rotate([45,0,0]) cube([10,10,10]);
	}
	translate([0,43,0]) difference() {
		union() {
			color("blue") cylinder(h=15,d=6);
			color("lightgray") cylinder(h=LayerThickness,d=15);
		}
		translate([0,0,-5]) color("gray") cylinder(h=20,d=3);
		translate([-5,-3,8]) color("red") rotate([45,0,0]) cube([10,10,10]);
	}
	translate([0,0,11]) rotate([90,0,0]) difference() {
		translate([0,0,-50])color("green") cylinder(h=55,d=6);
		translate([0,0,-55]) color("pink") cylinder(h=65,d=3);
		translate([-5,-3,-3]) color("gray") rotate([45,0,0]) cube([10,15,10]);
		translate([-5,-10.15,-47]) color("lightgray") rotate([-45,0,0]) cube([10,15,10]);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
