// bread air base mount
//////////////////////////////////////////////////
// C 6/11/22
// LU 6/11/22
///////////////////////////////////////////////////////////////////
include <bosl2/std.scad>
include <screwsizes.scad> // uses this from the scad/inc directory, copy to documents/openscad/libraries
$fn=100;
LayerHeight=0.3;
////////////////////////////////////////////////////////////////////

Base(0,0);

//////////////////////////////////////////////////////////////////////

module Base(MirrorVersion=0,Show=0) {
	if(MirrorVersion) { // doesn't work
		if(Show) %translate([-82/2,-135/2-2,-2]) import("Berd_Air_Floating_Base_v4.stl");
		Base1();
	} else {
		if(Show) translate([225,5,0]) color("lightblue") import("Berd_Air_Floating_Base_v4_mirror.stl");
		Base2();
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Base1() {
	difference() {
		union() {
			color("cyan") cuboid([82,135,4],rounding=2);
			translate([-82/2+7/2,0,39/2-2]) color("red") cuboid([7,135,39],rounding=3);
		}
		translate([-40,-70,-7]) Holes();
		ExtrusionMountHoles();
		translate([0,64,0]) ExtrusionMountHoles();
		translate([3,-40,0]) color("khaki") cyl(h=4.2,d=30,rounding=-2);
		translate([3,35,0]) color("gray") cyl(h=4.2,d=30,rounding=-2);
	}
	translate([-82/2,-135/2-2,-2]) Supports();
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Base2() {
	rotate([0,180,180]) mirror([0,0,1]) Base1();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ExtrusionMountHoles(Screw=screw5,ScrewHD=screw5hd) {
	color("blue") translate([-40,-32,9]) rotate([0,90,0]) cyl(h=20,d=Screw);
	color("pink") translate([-40,-32,29]) rotate([0,90,0]) cyl(h=20,d=Screw);
	color("pink") translate([-32,-32,9]) rotate([0,90,0]) cyl(h=5,d=ScrewHD);
	color("blue") translate([-32,-32,29]) rotate([0,90,0]) cyl(h=5,d=ScrewHD);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Holes() {
	translate([23.5,13,9]) color("red") cyl(d=10,h=10);
	translate([63.5,13,9]) color("purple") cyl(d=10,h=10);
	translate([23.5,49,9]) color("pink") cyl(d=10,h=10);
	translate([63.5,49,9]) color("green") cyl(d=10,h=10);
	translate([23.5,83,9]) color("gray") cyl(d=10,h=10);
	translate([63.5,83,9]) color("lightgray") cyl(d=10,h=10);
	translate([23.5,126,9]) color("white") cyl(d=10,h=10);
	translate([63.5,126,9]) color("khaki") cyl(d=10,h=10);

	translate([23.5,13,1.39]) color("red") cyl(d=15,h=10);
	translate([63.5,13,1.39]) color("purple") cyl(d=15,h=10);
	translate([23.5,49,1.39]) color("pink") cyl(d=15,h=10);
	translate([63.5,49,1.39]) color("green") cyl(d=15,h=10);
	translate([23.5,83,1.39]) color("gray") cyl(d=15,h=10);
	translate([63.5,83,1.39]) color("lightgray") cyl(d=15,h=10);
	translate([23.5,126,1.39]) color("white") cyl(d=15,h=10);
	translate([63.5,126,1.39]) color("khaki") cyl(d=15,h=10);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Supports() {
	translate([23.5,13,1.39]) color("red") cyl(d=15,h=LayerHeight);
	translate([63.5,13,1.39]) color("purple") cyl(d=15,h=LayerHeight);
	translate([23.5,49,1.39]) color("pink") cyl(d=15,h=LayerHeight);
	translate([63.5,49,1.39]) color("green") cyl(d=15,h=LayerHeight);
	translate([23.5,83,1.39]) color("gray") cyl(d=15,h=LayerHeight);
	translate([63.5,83,1.39]) color("lightgray") cyl(d=15,h=LayerHeight);
	translate([23.5,126,1.39]) color("white") cyl(d=15,h=LayerHeight);
	translate([63.5,126,1.39]) color("khaki") cyl(d=15,h=LayerHeight);
}

//////////////////////////////////////////////////////////////////////////////////