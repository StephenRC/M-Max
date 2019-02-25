///////////////////////////////////////////////////////////////////////////////////////////////////////////
// M-MAX-LED-Strip-Holder.scad -  hold a led strip
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Created: 8/23/2018
// Last Update: 1/31/18
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 8/27/18	- Added a 45 degree floor for the led strip
// 1/31/18	- stripclip() to hold the led strip, since the sticky tape isn't sticky on mine
// 2/1/19	- Adjusted ziptie hole
// 2/20/19	- Adjusted ziptie hole some more
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <inc/cubeX.scad>
include <inc/screwsizes.scad>
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
$fn=100;
////////////////////////////////////////////////////////////////////////////////////////////////////////////

strip(200,screw5);

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module strip(Length=200,Screw=screw5) {
	difference() {
		color("blue") cubeX([4,Length+40,20],2);
		ziptiehole(3,Length*0.45);
	}
	difference() {
		color("red") cubeX([20,Length+40,4],2);
		translate([10,10,-2]) color("cyan") cylinder(h=10,d=Screw);
		translate([10,10,3]) color("plum") cylinder(h=10,d=screw5hd);
		translate([10,Length+30,-2]) color("pink") cylinder(h=10,d=Screw);
		translate([10,Length+30,3]) color("gold") cylinder(h=10,d=screw5hd);
		ziptiehole(3,Length*0.45);
	}
	translate([0,20,10]) rotate([0,45,0]) color("white") cubeX([15,Length,4],2); // 45 degree surface for led
	stripclip(3,Length*0.45); // something to hold the led strip, since the sticky tape isn't sticky on mine
}

/////////////////////////////////////////////////////////////////////////////////////////

module stripclip(Qty,Offset,ZipTieHole=screw3) {
	for(a=[0:Qty-1]) {
		difference() {
			translate([0,30+Offset*a,0]) color("yellow") cubeX([20,5,20],2);
			translate([8,35+Offset*a,8]) rotate([90,0,0]) color("plum") cylinder(h=10,d=11);
			ziptiehole(Qty,Offset);
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////

module ziptiehole(Qty,Offset,ZipTieHole=screw3) { // parallel to led surface
	for(a=[0:Qty-1]) translate([26,32.5+Offset*a,-3]) rotate([0,-45,0]) color("gray") cylinder(h=40,d=ZipTieHole);
}

//module ziptiehole(Qty,Offset,ZipTieHole=screw3t) { // perpendicular to led surface
//	for(a=[0:Qty-1]) translate([-3,32.5+Offset*a,-3]) rotate([0,45,0]) color("gray") cylinder(h=40,d=ZipTieHole);
//}

///////////////////// end of LEDStripHolder.scad ///////////////////////////////////////////////////////////////