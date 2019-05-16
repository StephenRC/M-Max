//////////////////////////////////////////////////////////////////////////////////////////////////
// Zip-Tie-Mount.scad
//////////////////////////////////////////////////////////////////////////////////////////////////
// created 9/7/2018
// last update 5/15/19
//////////////////////////////////////////////////////////////////////////////////////////////////
// something to hold the zipties that support the wires and bowden tube going to the hotend on the
// x axis.
//////////////////////////////////////////////////////////////////////////////////////////////////
// 5/15/19	- Made resizable, can now use M3, M4 and M5 for the mounting
////////////////////////////////////////////////////////////////////////////////////////////////////
use <inc/cubeX.scad>	// http://www.thingiverse.com/thing:112008
include <inc/screwsizes.scad>
include <inc/corner-tools.scad>
// https://www.myminifactory.com/it/object/3d-print-tools-for-fillets-and-chamfers-on-edges-and-corners-straight-and-or-round-45862
// by Ewald Ikemann
$fn=100;
//////////////////////////////////////////////////////////////////////////////////////////////////

ZTmount(screw5,15); // arg is screw3 or screw5

//////////////////////////////////////////////////////////////////////////////////////////////////

module ZTmount(Screw=screw5,HoleSize) {
	translate([0,1.5,0]) clip(HoleSize);
	mount(Screw);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////

module mount(Screw) {
	difference() {
		translate([-10,-2,0]) color("cyan") cubeX([20,4,20],1); // base
		translate([0,4,13]) rotate([90,0,0]) color("gray") cylinder(h=10,r=Screw/2); // screw mounting hole
		// countersink for screw3, screw4 and screw5
		if(Screw == screw3) translate([0,6,13]) rotate([90,0,0]) color("white") cylinder(h=5,r=screw3hd/2);
		if(Screw == screw4) translate([0,6,13]) rotate([90,0,0]) color("white") cylinder(h=5,r=screw4hd/2);
		if(Screw == screw5) translate([0,6,13]) rotate([90,0,0]) color("brown") cylinder(h=5,r=screw5hd/2);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////

module clip(HoleSize=10) {
	difference() {
		translate([0,HoleSize/2,0]) color("red") cylinder(h=7,d=HoleSize+4,$fn=100);				// outer hole
		translate([0,HoleSize/2,-1]) color("blue") cylinder(h=10,d=HoleSize,$fn=100);				// inner hole
		translate([0,HoleSize/2,7]) color("plum") fillet_r(1,HoleSize/2+2, 1,$fn);					// top outer
		translate([0,HoleSize/2,7]) color("plum") fillet_r(1,HoleSize/2,-1,$fn);					// top inner		
		translate([0,HoleSize/2,0]) rotate([0,180,0]) color("gold") fillet_r(1,HoleSize/2+2, 1,$fn);// lower outer
		translate([0,HoleSize/2,0]) rotate([0,180,0]) color("gold") fillet_r(1,HoleSize/2,-1,$fn);	// lower inner
	}
}

//////////////// end of Zip Tie Mount.scad ///////////////////////////////////////////////
