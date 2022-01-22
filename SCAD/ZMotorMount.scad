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
// 1/11/22	- Belt drive with builtin Z rod holder
///////////////////////////////////////////////////////////////////////////////////////////////////////
include <bosl2/std.scad>
include <inc/nema17.scad>
include <inc/screwsizes.scad>
include <inc/brassinserts.scad>
$fn=100;
///////////////////////////////////////////////////////////////////////////////////////////////////////
Use5mmInsert=1;
Clearance = 0.7;		// allow threaded rod to slide without problem
BaseWidth = 90;
BaseLength = 100;
Thickness = 5;
BaseThickness=5;
Diameter608 = 22+Clearance;		// outside diameter of a 608
Height608 = 7; 					// thickness of a 608
LayerThickness=0.3;
BearingHoleClearance = 17;			// Clearance for a 8mm nut
//----------------------------------------------------------------------------
Show=0;		// show original steeper mount
PrintPos=1;	// put Z rod clamp to print positon
TwoZRodBaseSupports=1;  // have two supports on the Z Rod mount, if 0, you'll need to print supports
/////////////////////////////////////////////////////////////////////////////////////////

ZMotorMount(1,1,0,0,0,47);	// 1st arg:Quanity; 2nd arg: X position
//ZMotorMountExtended(1);	// 1st arg:Quanity)

///////////////////////////////////////////////////////////////////////////////////////////////////////

module ZMotorMount(Qty=1,Bearing=0,RodAdjust=0,X=0,Y=0,Z=0) {
	for(x = [0 : Qty-1]) {
		translate([x*100,0,0]) {
			if(Show) OldMount();
			union() {
				if(!Bearing) OriginalBase(X,Y,-Z-52.75,BaseThickness/10-1); // Z=-52.75 for original position
				else BearingBase(X,Y,-Z-52.75,BaseThickness/10-1);
				ZRodMount(RodAdjust,PrintPos);
			}
		}
		if(Bearing) ZBeltDrive(X,Y,-Z-52.75,RodAdjust);
	}
}
 
////////////////////////////////////////////////////////////////////////////////////////////////////////

module ZBeltDrive(X=0,Y=0,Z=0,Adjust=0) {
	if(Show) %translate([X-26,-Z-1.5,25]) cube([70.6,10,10]);
	difference() {
		union() {
			translate([X-28,BaseLength/2,2.5]) color("green") cuboid([64,BaseLength,BaseThickness],rounding=2);
			translate([X-20,-Z-1.5,30]) color("lightblue") cuboid([80,BaseThickness,60],rounding=2);
		}
		MountingHoles(X,Y,0);
		translate([X-25,-Z+2,35]) rotate([90,0,0]) color("white") NEMA17_parallel_holes(10,8);
		translate([X-70,Z/4+25,BaseThickness/2-BaseThickness/2]) InnerHoleBearingSide();
		translate([-49,10,0]) color("green") cyl(h=20,d=screw5);
		translate([-49,90,0]) color("blue") cyl(h=20,d=screw5);
		translate([-49,10,6]) color("lightgray") cyl(h=5,d=screw5hd);
		translate([-49,90,6]) color("red") cyl(h=5,d=screw5hd);
	}
	SingleSideBaseSupport(X,Y,Z,0,BaseLength);
	union() {
		OriginalSupportSingle(X,Y,Z);
		difference() {
			color("green") hull() {
				translate([X+60,-Z-9,0]) cuboid([Thickness,10,5],rounding=2,p1=[0,0]);
				translate([X+60,-Z+36.25,58+Adjust]) cuboid([Thickness,10,5],rounding=2,p1=[0,0]);
			}
			translate([X+55,-Z-10.25,0]) color("gray") cuboid([10,10,10],p1=[0,0]);
		}
		if(TwoZRodBaseSupports) {
			translate([-54,0,0]) color("khaki") hull() {
				translate([X+79,-Z+15,0]) cuboid([Thickness,10,5],rounding=2,p1=[0,0]);
				translate([X+79,-Z+36.25,58+Adjust]) cuboid([Thickness,10,6],rounding=2,p1=[0,0]);
			}
			translate([X+25,-Z-3,0]) color("blue") cuboid([Thickness,25,10],rounding=2,p1=[0,0]);
			translate([X+27,-Z+20,0]) color("red") cylinder(h=LayerThickness,d=20);  // corner brim
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
module ZRodMount(Adjust=0,Print=0,ZRodSize=10,UpDown=0) {
	if(Show) %translate([45,BaseLength+20,33]) rotate([90,0,0]) cylinder(h=19,d=28);
	translate([0,44,0]) {
		difference() {
			translate([BaseWidth/2,77+UpDown,62+Adjust]) color("blue") cuboid([40,50+UpDown,8],rounding=2);
			ZRodMountHoles();
			ZRod(Adjust,ZRodSize,UpDown);
		}
		ClampScrewHoleSupport();
		translate([BaseWidth/2-10,93,58.15]) color("gray") cyl(h=LayerThickness,d=screw5hd); // hole support
		translate([BaseWidth/2+10,93,58.15]) color("green") cyl(h=LayerThickness,d=screw5hd); // hole support
		translate([27,BaseLength-26,60]) color("gold") cuboid([4,42+UpDown,10],rounding=2);
		translate([63,BaseLength-26,60]) color("salmon") cuboid([4,46+UpDown,10],rounding=2);
		if(Print) translate([15,-15,-66.2]) ZRodClamp(Adjust,ZRodSize);
		else ZRodClamp(Adjust,ZRodSize);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////

module ZRodClamp(Adjust=0,ZRodSize=10,Updown=0) {
	union() {
		difference() {
			union() {
				translate([BaseWidth/2,93+Updown,70.2]) color("gray") cuboid([40,15,7.8],rounding=2);
				difference() {
					translate([BaseWidth/2,93+Updown,70]) color("green")
						rotate([90,0,0]) cyl(h=15,d=ZRodSize*2,rounding=2);
					translate([BaseWidth/2,93+Updown,64]) color("purple") cuboid([ZRodSize*3,20,15]);
				}
			}
			ZRodMountHoles(Screw=screw5);
			ZRod(Adjust,ZRodSize);
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////

module ZRod(Adjust=0,Size=10,UpDown=0) {
	translate([BaseWidth/2,100+UpDown,66+Adjust]) color("cyan") rotate([90,0,0]) cyl(h=50+UpDown,d=Size); // Z Rod hole
}

//////////////////////////////////////////////////////////////////////////////////////////////////////

module ZRodMountHoles(Screw=Yes5mmInsert(Use5mmInsert)) {
	translate([BaseWidth/2-12,93,70]) color("white") cyl(h=50,d=Screw);
	translate([BaseWidth/2+12,93,70]) color("lightgray") cyl(h=50,d=Screw);
	if(Screw==screw5) {
		translate([BaseWidth/2-12,93,76]) color("lightgray") cyl(h=5,d=screw5hd);
		translate([BaseWidth/2+12,93,76]) color("white") cyl(h=5,d=screw5hd);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ClampScrewHoleSupport() {
	translate([BaseWidth/2-12,93,58.15]) color("gray") cyl(h=LayerThickness,d=screw5hd); // hole support
	translate([BaseWidth/2+12,93,58.15]) color("green") cyl(h=LayerThickness,d=screw5hd); // hole support
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

module OriginalBase(X=0,Y=0,Z=0,Z2=0,Length=BaseLength) { // makes the motor mount holder
	difference() {
		union() {
			color("skyblue") cuboid([BaseWidth,Length,BaseThickness],rounding=2,p1=[0,0]);
			SideBaseSupports(X,Y,Z,0,BaseLength);
		}
		BaseHoles();
		//translate([0,95,-2]) InnerHole();
	}
	union() {
		NEMA_Holder(X,Y,Z);
		OriginalSupports(X,Y,Z);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BearingBase(X=0,Y=0,Z=0,Z2=0,Length=BaseLength,Adjust) { // makes the motor mount holder
	difference() {
		union() {
			color("skyblue") cuboid([BaseWidth,Length,BaseThickness],rounding=2,p1=[0,0]);
			SideBaseSupports(X,Y,Z,0,BaseLength);
		}
		BaseHoles();
	}
	union() {
		BearingMount(X,Y,Z);
		OriginalSupports(X,Y,Z);
	}
	BearingSupport(X,Y,Z);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////

module BearingSupport(X=0,Y=0,Z=0) {
	translate([X+39,Y+BaseLength-11.5,Z+100]) color("green") cuboid([Diameter608/2,4,25],rounding=2,p1=[0,0]);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BearingMount(X=0,Y=0,Z=0) {
	difference() {
		translate([X+14.6,-Z-4,0]) color("red") cuboid([BaseWidth-30.7,Thickness,BaseLength-39],rounding=2,p1=[0,0]);
		ZRod();
		ZLeadScrew();
	}
	translate([X+44.6,-Z-2,35]) rotate([-90,0,0]) BearingHole();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ZLeadScrew(X=0,Y=0,Z=0,Size=Diameter608) {
	translate([X+44.6,Z+BaseLength,35]) rotate([90,0,0]) color("blue") cyl(h=50,d=Size);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BearingHole() {	// holds the bearing
	translate([0,0,-6.5]) difference() {
		translate([0,0,Thickness/3-1]) color("red") cylinder(h=Height608+1,d=Diameter608+10);
		translate([0,0,0]) color("red") cylinder(h=15,d=Diameter608);
	}
	difference() {
		translate([0,0,-Height608-0.3]) color("white") cyl(h=Height608-2,d=Diameter608+10,rounding1=1);
		translate([0,0,-Height608]) color("black") cyl(h=15,d=BearingHoleClearance);
	}
	//BearingHole_support();
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////

module BearingHole_support(LDAdjust=0) { // print support for bearing hole
	translate([0,0,-5.05]) color("pink") cylinder(h=LayerThickness,d=Diameter608+5);
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

module SideBaseSupports(X=0,Y=0,Z=0,Add=0,BaseLength) { // prevent the base from flexing in between the 2020 pieces
	translate([X+14.5,Y,0]) color("firebrick") cuboid([Thickness,BaseLength+Add,12],rounding=2,p1=[0,0]);
	translate([X+BaseWidth-21.5,Y,0]) color("seashell") cuboid([Thickness,BaseLength+Add,12],rounding=2,p1=[0,0]);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module SingleSideBaseSupport(X=0,Y=0,Z=0,Add=0,BaseLength) { // prevent the base from flexing in between the 2020 pieces
	translate([X-60,Y,0]) color("khaki") cuboid([Thickness,BaseLength+Add,12],rounding=2,p1=[0,0]);
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
	translate([-54.5,-41,0]) color("gold") hull() {
		translate([X+69,-Z-17,0]) cuboid([Thickness,10,5],rounding=2,p1=[0,0]);
		translate([X+69,-Z+31.75,56]) cuboid([Thickness,10,5],rounding=2,p1=[0,0]);
	}
	translate([-90.5+BaseWidth,-41,0]) color("lightcoral") hull() {
		translate([X+69,-Z-17,0]) cuboid([Thickness,10,5],rounding=2,p1=[0,0]);
		translate([X+69,-Z+31.75,56]) cuboid([Thickness,10,5],rounding=2,p1=[0,0]);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module OriginalSupportSingle(X=0,Y=0,Z=0) { // the angled supports for the Nema17
	translate([-129,-41,0]) color("purple") hull() {
		translate([X+69,-Z-17,0]) cuboid([Thickness,10,5],rounding=2,p1=[0,0]);
		translate([X+69,-Z+31.75,55]) cuboid([Thickness,10,5],rounding=2,p1=[0,0]);
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
	translate([BaseWidth/2,BaseLength/2+20,Thickness/2]) color("hotpink") cyl(h=Thickness+0.2,d=34,rounding=-2);
	translate([BaseWidth/2-1,BaseLength/2-23,Thickness/2]) color("pink") cyl(h=Thickness+0.2,d=44,rounding=-2);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module InnerHoleBearingSide(X=0,Y=0,Z=0) { // the big hole in the middle of the base
	translate([BaseWidth/2,BaseLength/2+22,Thickness/2]) color("hotpink") cyl(h=Thickness+0.2,d=40,rounding=-2);
	translate([BaseWidth/2-1,BaseLength/2-23,Thickness/2]) color("pink") cyl(h=Thickness+0.2,d=40,rounding=-2);
}

//////////////// end of msmax_shift_z_motor_mount.scad //////////////////////////////////////////////