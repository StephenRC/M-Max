/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// YEndMounts - mounts the Y axis to the frame
// created: 10/13/2016
// last modified: 1/23/22
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// https://creativecommons.org/licenses/by-sa/4.0/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 9/2/18	- Added a flat version of the ms_ends()
// 1/15/22	- BOSL2; now uses for loops
// 1/22/22	- adjusted size and holes
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <bosl2/std.scad>
include <inc/screwsizes.scad>
$fn=100;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// variables
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Width = 170;
Height = 120;
Thickness = 7;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

YEndMount(4,0); // 2040 or Makerslide

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module YEndMount(Quanity=1,Flat=0) {
	for(i=[0:Quanity-1]) translate([i*24,0,0]) {
		if(!Flat) {
			difference() {
				union() {
					color("cyan") cuboid([22,40,Thickness-1],rounding=2,p1=([0,0]));
					color("salmon") cuboid([Thickness-1,40,22],rounding=2,p1=[0,0]);
				}
				ScrewHoles(0);
				ScrewHoles(1);
			}
			Support(2,36);
		} else {
			difference() {
				color("cyan") cuboid([40,40,Thickness-1],rounding=2,p1=[0,0]);
				translate([10,10,-1]) color("red") cylinder(h=Thickness*2,d=screw5);
				translate([10,10,Thickness-1.5]) color("white") cylinder(h=Thickness*2,d=screw5hd);
				translate([30,10,-1]) color("blue") cylinder(h=Thickness*2,d=screw5);
				translate([30,10,Thickness-1.5]) color("gray") cylinder(h=Thickness*2,d=screw5hd);
				translate([10,30,-1]) color("gray") cylinder(h=Thickness*2,d=screw5);
				translate([10,30,Thickness-1.5]) color("black") cylinder(h=Thickness*2,d=screw5hd);
				translate([30,30,-1]) color("black") cylinder(h=Thickness*2,d=screw5);
				translate([30,30,Thickness-1.5]) color("plum") cylinder(h=Thickness*2,d=screw5hd);
			}
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ScrewHoles(Vertical=0) {
	if(Vertical) {
		translate([-3,10,12]) rotate([0,90,0]) color("red") cylinder(h=Thickness*3,d=screw5);
		translate([Thickness-2,10,12]) rotate([0,90,0]) color("white") cylinder(h=Thickness*3,d=screw5hd);
		translate([-3,30,12]) rotate([0,90,0]) color("blue") cylinder(h=Thickness*3,d=screw5);
		translate([Thickness-2,30,12]) rotate([0,90,0]) color("gray") cylinder(h=Thickness*3,d=screw5hd);
	} else {
		translate([12,10,-4]) color("red") cylinder(h=Thickness*3,d=screw5);
		translate([12,10,Thickness-1.5]) color("white") cylinder(h=Thickness*2.5,d=screw5hd);
		translate([12,30,-4]) color("blue") cylinder(h=Thickness*3,d=screw5);
		translate([12,30,Thickness-1.5]) color("gray") cylinder(h=Thickness*2.5,d=screw5hd);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Support(Quanity=1,Spacing=18) {
	for(i=[0:Quanity-1]) translate([0,i*Spacing,0]) {
		difference() {
			translate([5,2,5]) rotate([0,90,90]) color("green") cyl(h=Thickness-3,d=34,rounding=2);
			translate([-15,-0.5,-18]) color("gray") cube([40,Thickness+1,20]);
			translate([-18,-0.5,-15]) color("yellow") cube([20,Thickness+1,40]);
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
