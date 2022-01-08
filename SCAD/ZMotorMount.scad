///////////////////////////////////////////////////////////////////////////////////////////////////////
// ZMotorMount.scad -  can shift the z motor mount up/down
///////////////////////////////////////////////////////////////////////////////////////////////////////
// Created: 8/21/2018
// Last Update: 1/6/22
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// https://creativecommons.org/licenses/by-sa/3.0/
///////////////////////////////////////////////////////////////////////////////////////////////////////
// 8/21/18	- From https://www.thingiverse.com/thing:28876, this file is based on the Z MOTOR MOUNT.stl
// 8/26/18	- Fixed nema17 location
// 5/24/20	- Added arg discription to twomounts()
// 5/25/20	- Made it compatible with MGN.scad, Added ZmotorMount(arg), the arg is quanity
// 8/6/20	- Fixed baseholes() to actually use it's arguments and added Z2 for the mount holes
//			  Renamed and added some modules, renamed variables
// 8/9/20	- Added ZMotorMountExtended() to move motors higher
// 1/6/22	- BOSL2
///////////////////////////////////////////////////////////////////////////////////////////////////////
include <bosl2/std.scad>
include <inc/nema17.scad>
include <inc/screwsizes.scad>
$fn=100;
///////////////////////////////////////////////////////////////////////////////////////////////////////
// vars
BaseWidth = 90;
BaseLength = 100;
Thickness = 5;
BaseThickness=5;
/////////////////////////////////////////////////////////////////////////////////////////

ZMotorMount(2,0,0,47);	// 1st arg:Quanity; 2nd arg: X position
//ZMotorMountExtended(1);	// 1st arg:Quanity)

///////////////////////////////////////////////////////////////////////////////////////////////////////

module ZMotorMount(Qty=1,X=0,Y=0,Z=0) {
	for(x = [0 : Qty-1]) {
		translate([x*100,0,0]) {
			//OldMount();
			OriginalBase(X,Y,-Z-52.75,BaseThickness/10-1); // Z=-52.75 for original position
		}
	}
}
 
///////////////////////////////////////////////////////////////////////////////////////////////////////

module ZMotorMountExtended(Qty=2) {
	for(x = [0 : Qty-1]) translate([x*100,0,0]) base(0,0,-195,BaseThickness/10-1); // Z=-52.75 for original position
}
 
/////////////////////////////////////////////////////////////////////////////////////////////////////

module OldMount() {  // overlay old one to get the positions and sizes right
	%import("original stl/Z MOTOR MOUNT.stl");
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module OriginalBase(X=0,Y=0,Z=0,Z2=0,BaseLength=100) { // makes the motor mount holder
	difference() {
		union() {
			color("skyblue") cuboid([BaseWidth,BaseLength,BaseThickness],rounding=2,p1=[0,0]);
			OriginalSideBase(X,Y,Z,0,BaseLength);
		}
		BaseHoles();
		translate([0,95,-2]) InnerHole();
	}
	union() {
		NEMA_Holder(X,Y,Z);
		OriginalSupports(X,Y,Z);
	}
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module base(X=0,Y=0,Z=0,Z2=0,BaseLength=50) { // makes the motor mount holder
	difference() {
		union() {
			color("skyblue") cuboid([BaseWidth,BaseLength,Thickness-2],rounding=2,p1=[0,0]);
			SideBase(X,Y,Z);
			SideBase(X,Y+90,Z,5);
			translate([14,95,0]) color("blue") cuboid([60,100,BaseThickness],rounding=2,p1=[0,0]);
		}
		BaseHoles();
		translate([0,95,-2]) InnerHole();
		//translate([43.5,125,-2]) color("red") hull() {
		//	cylinder(h=10,d=35);
		//	translate([0,43,0]) cylinder(h=10,d=35);
		//}	
	}
	union() {
		NEMA_Holder(X,Y,Z);
		Supports(X,Y,Z);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module OriginalSideBase(X=0,Y=0,Z=0,Add=0,BaseLength) { // prevent the base from flexing in between the 2020 pieces
	translate([X+14.5,Y+5,0]) color("firebrick") cuboid([Thickness,BaseLength-6+Add,21],rounding=2,p1=[0,0]);
	translate([X+BaseWidth-21.5,Y+5,0]) color("seashell") cuboid([Thickness,BaseLength-6+Add,21],rounding=2,p1=[0,0]);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module SideBase(X=0,Y=0,Z=0,Add=0) { // prevent the base from flexing in between the 2020 pieces
	translate([X+14.5,Y+5,0]) color("firebrick") cuboid([Thickness,BaseLength-6+Add,21],rounding=2,p1=[0,0]);
	translate([X+BaseWidth-21.5,Y+5,0]) color("seashell") cuboid([Thickness,BaseLength-6+Add,21],rounding=2,p1=[0,0]);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BaseHoles(X=0,Y=0,Z=0) { // moke the holes in the base
	MountingHoles(X,Y,Z);
	InnerHole(X,Y,Z); // inner hole
	SideSlots();
	MountSlots();
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module MountingHoles(X,Y,Z){ // mounting screw hole to frame
	color("red") translate([X+8,Y+10,-Thickness/2+Z]) cylinder(h=Thickness*2,d=screw5);
	color("blue") translate([X+8,Y+10,Thickness-1.5+Z]) cylinder(h=Thickness*2,d=screw5hd);
	color("blue") translate([X+BaseWidth-8,Y+10,-Thickness/2+Z]) cylinder(h=Thickness*2,d=screw5);
	color("red") translate([X+BaseWidth-8,Y+10,Thickness-1.5+Z]) cylinder(h=Thickness*2,d=screw5hd);
	color("black") translate([X+BaseWidth-8,Y+BaseLength-10,-Thickness/2+Z])
		cylinder(h=Thickness*2,d=screw5); // mounting screw hole to frame
	color("white") translate([X+BaseWidth-8,Y+BaseLength-10,Thickness-1.5+Z]) cylinder(h=Thickness*2,d=screw5hd);
	color("lightgray") translate([X+8,Y+BaseLength-10,-Thickness/2+Z])
		cylinder(h=Thickness*2,d=screw5); // mounting screw hole to frame
	color("gray") translate([X+8,BaseLength-10,Y+Thickness-1.5+Z]) cylinder(h=Thickness*2,d=screw5hd);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module MountSlots() {  // slots between the horizontal mounting holes
	color("cyan") hull() { // bottom slot
		translate([30,10,-Thickness/2]) cylinder(h=Thickness*2,d=10);
		translate([BaseWidth-30,10,-Thickness/2]) cylinder(h=Thickness*2,d=10);
	}
	color("pink") hull() { // top slot
		translate([30,BaseLength-10,-Thickness/2]) cylinder(h=Thickness*2,d=10);
		translate([BaseWidth-30,BaseLength-10,-Thickness/2]) cylinder(h=Thickness*2,d=10);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////

module SideSlots() { // notches left & right of mounting base
	color("powderblue") hull() { // left side notch
		color("cyan") hull() {
			translate([9,24,-Thickness/2]) cylinder(h=Thickness*2,d=10);
			translate([-5,24,-Thickness/2]) cylinder(h=Thickness*2,d=10);
		}
		color("turquoise") hull() {
			translate([-5,BaseLength-25,-Thickness/2]) cylinder(h=Thickness*2,d=10);
			translate([9,BaseLength-25,-Thickness/2]) cylinder(h=Thickness*2,d=10);
		}
	}
	color("plum") hull() { // right side notch
		color("turquoise") hull() {
			translate([BaseWidth+2,25,-Thickness/2]) cylinder(h=Thickness*2,d=10);
			translate([BaseWidth-9,25,-Thickness/2]) cylinder(h=Thickness*2,d=10);
		}
		color("yellowgreen") hull() {
			translate([BaseWidth+2,BaseLength-25,-Thickness/2]) cylinder(h=Thickness*2,d=10);
			translate([BaseWidth-9,BaseLength-25,-Thickness/2]) cylinder(h=Thickness*2,d=10);
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module OriginalSupports(X=0,Y=0,Z=0) { // the angled supports for the Nema17
	difference() {
		translate([14.5,-Z-55,-10]) rotate([45,0,0]) color("gold") cuboid([Thickness,90,10],rounding=2,p1=[0,0]);
		translate([13,-Z-70,-25]) color("ivory") cube([Thickness*2,40,40]);
		translate([12,-Z-3,26]) color("gray") cube([Thickness*2,20,40]);
		
	}
	translate([BaseWidth-38,0,0]) difference() {
		translate([16.5,-Z-55,-10]) rotate([45,0,0]) color("lightcoral") cuboid([Thickness,90,10],rounding=2,p1=[0,0]);
		translate([13.5,-Z-70,-25]) color("cyan") cube([Thickness*2,40,40]);
		translate([12.5,-Z-3,26]) color("pink") cube([Thickness*2,20,40]);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Supports(X=0,Y=0,Z=0) { // the angled supports for the Nema17
	difference() {
		translate([14.5,-Z-55,-10]) rotate([45,0,0]) color("gold") cuboid([Thickness,90,10],rounding=2,p1=[0,0]);
		translate([13,-Z-70,-25]) color("ivory") cube([Thickness*2,40,40]);
		translate([12,-Z-3,26]) color("gray") cube([Thickness*2,20,40]);
		
	}
	translate([BaseWidth-38,0,0]) difference() {
		translate([16.5,-Z-55,-10]) rotate([45,0,0]) color("lightcoral") cuboid([Thickness,90,10],rounding=2,p1=[0,0]);
		translate([13.5,-Z-70,-25]) color("cyan") cube([Thickness*2,40,40]);
		translate([12.5,-Z-3,26]) color("pink") cube([Thickness*2,20,40]);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module NEMA_Holder(X=0,Y=0,Z=0) { // part that the motor mounts to
	rotate([90,0,0]) difference() {
		translate([X+14.6,Y+0.5,Z]) color("red") cuboid([BaseWidth-30.7,BaseLength-39,Thickness],rounding=2,p1=[0,0]);
		translate([X+45,Y+33.5,Z-1]) rotate([0,0,90]) color("white") NEMA17_parallel_holes(10,8);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module InnerHole(X=0,Y=0,Z=0) { // the big hole in the middle of the base
	color("hotpink") hull() { // inner hole
		hull() {
			translate([BaseWidth/2-8,BaseLength/2+15,-Thickness/2]) cylinder(h=Thickness*2,d=30);
			translate([BaseWidth/2-8,BaseLength/2-15,-Thickness/2]) cylinder(h=Thickness*2,d=30);
		}
		hull() {
			translate([BaseWidth/2+7,Y+BaseLength/2+15,-Thickness/2]) cylinder(h=Thickness*2,d=30);
			translate([BaseWidth/2+7,Y+BaseLength/2-15,-Thickness/2]) cylinder(h=Thickness*2,d=30);
		}
	}
}

///////////////// end of msmax_shift_z_motor_mount.scad //////////////////////////////////////////////