///////////////////////////////////////////////////////////////////////////////////////////////////////////
// M-MAX-LED-Strip-Holder.scad -  hold a led strip
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Created: 8/23/2018
// Last Update: 1/6/22
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 8/27/18	- Added a 45 degree floor for the led strip
// 1/31/18	- stripclip() to hold the led strip, since the sticky tape isn't sticky on mine
// 2/1/19	- Adjusted ziptie hole
// 2/20/19	- Adjusted ziptie hole some more
// 4/6/19	- Changed ziptie hole to a M3 tapable hole
// 3/9/20	- Added ability to have or not the led holders
// 1/6/22	- BOSL2
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <bosl2/std.scad>
include <inc/screwsizes.scad>
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
$fn=100;
////////////////////////////////////////////////////////////////////////////////////////////////////////////

strip(200,screw5);

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module strip(Length=200,Screw=screw5,Holders=1) {
	color("blue") cuboid([4,Length+40,20],rounding=2,p1=[0,0]);
	difference() {
		color("red") cuboid([20,Length+40,4],rounding=2,p1=[0,0]);
		translate([10,10,-2]) color("black") cylinder(h=10,d=Screw);
		translate([10,10,3]) color("plum") cylinder(h=10,d=screw5hd);
		translate([10,Length+30,-2]) color("pink") cylinder(h=10,d=Screw);
		translate([10,Length+30,3]) color("gold") cylinder(h=10,d=screw5hd);
	}
	translate([0,20,10]) rotate([0,45,0]) color("white") cuboid([15,Length,4],rounding=2,p1=[0,0]); // 45 degree surface for led
	if(Holders) stripclip(3,Length*0.45,screw3t); // something to hold the led strip, since the sticky tape doesn't last on mine
}

/////////////////////////////////////////////////////////////////////////////////////////

module stripclip(Qty,Offset,ScrewHole) {
	for(a=[0:Qty-1]) {
		difference() {
			translate([0,30+Offset*a,0]) color("yellow") cuboid([20,5,20],rounding=2,p1=[0,0]);
			translate([8,35+Offset*a,8]) rotate([90,0,0]) color("lime") cylinder(h=10,d=11);
			clamphole(Qty,Offset,ScrewHole);
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////

module clamphole(Qty,Offset,ScrewHole) { // parallel to led surface
	for(a=[0:Qty-1])
		translate([9,32.5+Offset*a,10]) rotate([0,0,0]) color("cyan") cylinder(h=15,d=ScrewHole);
}

///////////////////// end of LEDStripHolder.scad ///////////////////////////////////////////////////////////////