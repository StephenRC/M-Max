///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// CXY-MSv1 Nameplate - nameplate for the printer
// created: 7/11/2018
// last modified: 9/22/20
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 2/28/19	- Bugfix in printchar()
// 9/6/20	- Changed font
// 9/22/20	- Adjusted size and screw mounting, removed unused inlcudes
//////////////////////////////////////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
use <inc/cubeX.scad>	// http://www.thingiverse.com/thing:112008
$fn=50;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

plate();

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module plate() {
	difference() {
		color("cyan") cubeX([81,20,3]);
		translate([7,10,-5]) color("red") cylinder(h=10,d=screw5,$fn=100);
		translate([7,10,2]) color("blue") cylinder(h=10,d=screw5hd,$fn=100);
		translate([73,10,-5]) color("blue") cylinder(h=10,d=screw5,$fn=100);
		translate([73,10,2]) color("red") cylinder(h=10,d=screw5hd,$fn=100);
	}	
	translate([14,4.5,0]) printchar("M-Max",5,12);
}

/////////////////////////////////////////////////////////////////////////////////////////////////

module printchar(String,TxtHeight=1,TxtSize=3.5) { // print something
	color("darkgray") linear_extrude(height = TxtHeight) text(String, font = "StarTrek Film BT:style=Regular",size=TxtSize);
}


///////////////// end of CXY-MSv1 Nameplate.scad ///////////////////////////////////////////////////////////////////////