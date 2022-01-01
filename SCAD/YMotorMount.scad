//////////////////////////////////////////////////////////////////////////////////////////////////
// Y-Motor-Mounts.scad - two to hold the y motor to prevent tilting
//////////////////////////////////////////////////////////////////////////////////////////////////
// Created: 8/28/2018
// Last Update: 12/27/21
//////////////////////////////////////////////////////////////////////////////////////////////////////
//12/27/21	- Added a belt holder for the bed, uses two electrical crimp com=nnectors with a 5mm hole
//////////////////////////////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
include <inc/brassinserts.scad>
include <bosl2/std.scad>
///////////////////////////////////////////////////////////////////////////////////////////////////
$fn=100;
PlatFormHeight = 42.3; //clearance between y carriage and belt.
Use5mmInsert=1;
LayerThickness=0.3;
////////////////////////////////////////////////////////////////////////////////////////////////////////


//YMotor();
BeltBed(PlatFormHeight);

///////////////////////////////////////////////////////////////////////////////////////////////////

module BeltBed(Height=PlatFormHeight,MountScrew=screw5) {
	difference(){
		color("cyan") hull() {
			cuboid([60,5,20],rounding=2);
			translate([0,Height-5,0]) cuboid([30,5,20],rounding=2);
		}
		translate([0,5,5]) color("lightgray") hull() { // reduce plastic
			cuboid([45,5,20],rounding=2);
			translate([0,Height-18]) cuboid([25,5,20],rounding=2);
		}
		translate([-22,-4,0]) rotate([-90,0,0]) color("red") cylinder(h=30, d=MountScrew);
		translate([22,-4,0]) rotate([-90,0,0]) color("blue") cylinder(h=30, d=MountScrew);
		translate([-22,1,0]) rotate([-90,0,0]) color("blue") cylinder(h=Height+10, d=screw5hd);
		translate([22,1,0]) rotate([-90,0,0]) color("red") cylinder(h=Height+10, d=screw5hd);
		translate([-8,10,0]) rotate([-90,0,0]) color("red") cylinder(h=30, d=Yes5mmInsert(Use5mmInsert));
		translate([8,10,0]) rotate([-90,0,0]) color("blue") cylinder(h=30, d=Yes5mmInsert(Use5mmInsert));
	}
	translate([-28,0,-10]) color("red") cylinder(h=LayerThickness,d=15); // brim tabs
	translate([28,0,-10]) color("blue") cylinder(h=LayerThickness,d=15);
}


/////////////////////////////////////////////////////////////////////////////////////////////////

module YMotor() {
	color("blue") import("original stl/Y MOTOR MOUNT.stl");
	translate([30,0,0]) color("red") import("original stl/Y MOTOR MOUNT.stl");
}

///////////////////// end of Y Motor Mounts.scad ////////////////////////////////////////////////////