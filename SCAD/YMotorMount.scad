///////////////////////////////////////////////////////////////////////////////////////////////////////////
// YMotorMount.scad - y motor mount and bed belt mount
///////////////////////////////////////////////////////////////////////////////////////////////////////////
// Created: 8/28/2018
// Last Update: 1/22/22
///////////////////////////////////////////////////////////////////////////////////////////////////////////
// https://creativecommons.org/licenses/by-sa/3.0/
///////////////////////////////////////////////////////////////////////////////////////////////////////////
// 12/27/21	- Added a belt holder for the bed, uses two electrical crimp connectors with a 5mm screw hole
// 1/2022	- BOSL2
// 1/22/22	- Added center stiffner
///////////////////////////////////////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
include <inc/brassinserts.scad>
include <bosl2/std.scad>
///////////////////////////////////////////////////////////////////////////////////////////////////////////
$fn=100;
Use5mmInsert=1;
LayerThickness=0.3;
//////////////////////////////////////////////////////////////////////////////////////////////////////////


//YMotor();
//translate([35,110,0])
	BeltBed(58);

//////////////////////////////////////////////////////////////////////////////////////////////////////////

module BeltBed(Height=40,MountScrew=screw5,DoTab=1) {
	difference(){
		color("cyan") hull() {
			cuboid([60,5,20],rounding=2);
			translate([0,Height-5,0]) cuboid([30,5,20],rounding=2);
		}
		translate([-11,5,5]) color("lightgray") hull() { // reduce plastic
			cuboid([20,5,20],rounding=2);
			translate([5,Height-18]) cuboid([10,5,20],rounding=2);
		}
		translate([11,5,5]) color("gray") hull() { // reduce plastic
			cuboid([20,5,20],rounding=2);
			translate([-5,Height-18]) cuboid([10,5,20],rounding=2);
		}
		MountScrewHoles(MountScrew,Height);
		BeltMountScrewHoles(Height);
	}
	if(Height>50) difference() {
		translate([0,Height/2-5,0]) color("green") cuboid([40,2,20],rounding=1);
		MountScrewHoles(MountScrew,Height);
	}
	if(DoTab) {
		translate([-28,0,-10]) color("red") cylinder(h=LayerThickness,d=15); // brim tabs
		translate([28,0,-10]) color("blue") cylinder(h=LayerThickness,d=15);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BeltMountScrewHoles(Height=40) {
	translate([-8,Height-20,0]) rotate([-90,0,0]) color("red") cylinder(h=30, d=Yes5mmInsert(Use5mmInsert));
	translate([8,Height-20,0]) rotate([-90,0,0]) color("blue") cylinder(h=30, d=Yes5mmInsert(Use5mmInsert));
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module MountScrewHoles(MountScrew=screw5,Height=40) {
	translate([-22,-4,0]) rotate([-90,0,0]) color("red") cylinder(h=30, d=MountScrew);
	translate([22,-4,0]) rotate([-90,0,0]) color("blue") cylinder(h=30, d=MountScrew);
	translate([-22,1,0]) rotate([-90,0,0]) color("blue") cylinder(h=Height+10, d=screw5hd);
	translate([22,1,0]) rotate([-90,0,0]) color("red") cylinder(h=Height+10, d=screw5hd);
}

////////////////////////////////////////////////////////////////////////////////////////////////

module YMotor() {
	color("blue") import("original stl/Y MOTOR MOUNT.stl");
	translate([30,0,0]) color("red") import("original stl/Y MOTOR MOUNT.stl");
}

///////////////////// end of Y Motor Mounts.scad ////////////////////////////////////////////////////