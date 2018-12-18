//////////////////////////////////////////////////////////////////////////////////////////////////
// Zip-Tie-Mount.scad
//////////////////////////////////////////////////////////////////////////////////////////////////
// created 9/7/2018
// last update 9/7/18
//////////////////////////////////////////////////////////////////////////////////////////////////
// something to hold the zipties that support the wires and bowden tube going to the hotend on the
// x axis.
//////////////////////////////////////////////////////////////////////////////////////////////////
use <inc/cubeX.scad>	// http://www.thingiverse.com/thing:112008
include <inc/screwsizes.scad>
include <inc/corner-tools.scad>
// https://www.myminifactory.com/it/object/3d-print-tools-for-fillets-and-chamfers-on-edges-and-corners-straight-and-or-round-45862
// by Ewald Ikemann
$fn=100;
//////////////////////////////////////////////////////////////////////////////////////////////////

ZTmount(screw5); // arg is screw3 or screw5

//////////////////////////////////////////////////////////////////////////////////////////////////

module ZTmount(Screw=screw5) {
	translate([0,1.5,0]) clip();
	mount(Screw);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////

module mount(Screw) {
	difference() {
		translate([-10,-8,0]) color("cyan") cubeX([20,4,20],1); // base
		translate([0,-2,13]) rotate([90,0,0]) color("gray") cylinder(h=10,r=Screw/2); 		// mounting hole
		if(Screw == screw3) translate([0,-1.5,13]) rotate([90,0,0]) color("white") cylinder(h=5,r=screw3hd/2);	// countersink
		if(Screw == screw5) translate([0,-1.5,13]) rotate([90,0,0]) color("brown") cylinder(h=5,r=screw5hd/2);	// countersink
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////

module clip() {
	difference() {
		color("red") cylinder(h=7,d=15,$fn=100); // outer
		translate([0,0,-1]) color("blue") cylinder(h=10,d=11,$fn=100);	// hole
		translate([0,0,7]) color("plum") fillet_r(1,7.5, 1,$fn);		// outer
		translate([0,0,7]) color("plum") fillet_r(1,5.5,-1,$fn);		// inner		
		rotate([0,180,0]) color("gold") fillet_r(1,7.5, 1,$fn);		// outer
		rotate([0,180,0]) color("gold") fillet_r(1,5.5,-1,$fn);		// outer
	}
}

//////////////// end of Zip Tie Mount.scad ///////////////////////////////////////////////
