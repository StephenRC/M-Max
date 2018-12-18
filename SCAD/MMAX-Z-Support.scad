//////////////////////////////////////////////////////////////////////////////////////////
// MMAX-Z-Support.scad - modifiy the TMAX Z supports
// created: 2/16/14
// last modified: 8/29/18
/////////////////////////////////////////////////////////////////////////////////////////
// 8/29/18	- Added make two top or bottom
////////////////////////////////////////////////////////////////////////////////////////
include <inc/configuration.scad>
include <inc/screwsizes.scad>
include <inc/corner-tools.scad>
// https://www.myminifactory.com/it/object/3d-print-tools-for-fillets-and-chamfers-on-edges-and-corners-straight-and-or-round-45862
// by Ewald Ikemann
////////////////////////////////////////////////////////////////////////////////////////
zrod = 10;			// z rod size
extr20 = 21;		// size of 2020 plus some clearance
screw_dist = 20;	// distance between the clamp screw holes
length = 30;		// clamp length
width = 9;			// clamp width
thickness = 8;		// z clamp thickness
/////////////////////////////////////////////////////////////////////////////////////////
$fn=100;
/////////////////////////////////////////////////////////////////////////////////////////

//top();
//bottom();
two(0); // 0 = bottom; 1 = top
//clamp();

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
			translate([35,-18,50]) rotate([90,0,0]) nuts();	// resize nut hole
			translate([45,-26,25]) newrod(); // resize rod notch
		}
		difference() {
			translate([55,-18,50]) rotate([90,0,0]) nuts();	// resize nut hole
			translate([45,-26,25]) newrod(); // clear rod notch
		}
		topbracket(); // add mount for a brace between left & right tops
		translate([28,-50,25.9]) clamp();
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////

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
		translate([28,-50,25.9]) clamp();
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
		translate([45,46.5,41.75]) minkowski() {
			cube([1.25*extr20,extr20,1.5*extr20],true);
			cylinder(r=2,h=1,$fn=100);
		}
		translate([45,49,30]) cube([extr20,extr20,3*extr20],true);
		translate([25,48.5,49]) rotate([0,90,0]) cylinder(h = 2*extr20, r = screw5/2, $fn = 50);
	}

}

//////////////////////////////////////////////////////////////////////////

module nuts() { // resize nut holes for 5mm
	difference() {
		color("plum") cylinder(h=5,r=7,$fn=100);
		translate([0,0,0]) color("blue") cylinder(h=10,d=screw5);
		translate([0,0,-7]) color("red") nut(nut5,10,horizontal=false);
	}
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
			cylinder(h=1,r=3,$fn=100);
		}
		// mounting screws
		translate([length/2-screw_dist/2,width/2,-1]) color("red") cylinder(h=thickness+3,r=screw5/2,$fn=100);
		translate([length/2+screw_dist/2,width/2,-1]) color("blue") cylinder(h=thickness+3,r=screw5/2,$fn=100);
		// rod
		translate([length/2,width+5,-0.5]) rotate([90,0,0]) color("plum") cylinder(h=width+10,r=zrod/2,$fn=100);
		// countersinks for screws
		translate([length/2-screw_dist/2,width/2,thickness-2]) color("gray") cylinder(h=thickness+3,r=screw5hd/2,$fn=100);
		translate([length/2+screw_dist/2,width/2,thickness-2]) color("black") cylinder(h=thickness+3,r=screw5hd/2,$fn=100);
	}
}


/////////////////////// end of mmax z support.scad ////////////////////////////////////////////////////////////////
