///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MGNMS2040XEndsAndBedMount.scad - use MGN rails for the Z axis and 2040 XEnds
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Created: 5/21/2020
// Last Update: 1/6/22
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 5/23/20	- Added X axis motor mount and idler mount that go at the ends of the makerslide
// 5/23/20	- Added abilty to print more that one MotorMount and to print a left, right or both of the ZCarriage
//			  Added support bars to XIdler, ZCarrige can now use a TR8 or a Musumi MTSS8 nut
// 5/31/20	- Added a mount for the 300x200 bed frame to MGN12
// 6/17/20	- Added mgn mounted XCarriage, added use of 2020 with MGN to hold the x-axis carriage
// 6/18/20	- Beefed up the corner braces
// 7/2/20	- Added a horzintal stepper motor mount and idler
// 7/9/20	- Added a belt clamp for the x-carriage
// 7/18/20	- Added an endstop holder for the X axis, copied from the X axis one for CXY-MSv1
// 7/24/20	- Fixed the MTSS version
// 8/1/20	- Added X endstop that mounts on the rail side of makerslide
// 8/2/20	- Added a 2020 to MGN bed mount for a 12"x12" bed
// 8/5/20	- Changed location of extrusion mount holes
// 8/6/20	- BedMount2020() added tabs on the ends
// 8/9/20	- Added Y axis braces
// 8/22/20	- MGN X carraige with optional single e3dv6 extruder mount
// 9/8/20	- Renamed to MGNMS2040XEndsEndstops.scad, added my green microswitch
// 9/16/20	- Added var for no mounting screw holes in BeltAttachment()
// 9/19/20	- Added holes in BedMount2020()
// 9/24/20	- Moved the belt attachment and enstops to HorizontalXBeltDrive.scad
// 11/7/20	- Stiffened up BedMount2020()
// 1/6/22	- BOSL2
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//=====================================================================================================
// 2020x460mm with the 400mm MGN12 are to be connected to the middle and upper 2020 on the M-Max
// Don't recommend the printable bed mount, it flexes and 20% fill, 3/16" aluminum doesn't
//=====================================================================================================
include <mmax_h.scad>
include <inc/brassinserts.scad>
include <inc/screwsizes.scad>
include <inc/NEMA17.scad>
use <Single-Titan-E3DV6.scad>
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
$fn=100;
Use3mmInsert=1;
Use5mmInsert=1;
UseLarge3mmInsert=1; // got new inserts and the 3mm inserts are larger
//-------------------------------
MGN12HHoleOffset=20;
MGN12HLength=44;
MGN12HWidth=26.8;
Thickness=8;
MountWidth=25;
MotorOffset=9;
//--------------------------------
TR8_ht=34;
TR8_clearance=0.9;
TR8_small_dia=10.1+TR8_clearance;
TR8_flange_dia=21.9+TR8_clearance;
TR8_flange_thickness=4;
TR8_mounting_holes_offset=16;
TR8_offset=(TR8_flange_dia+2)/2;
TR8_Height=20;
//-------------------------------
MTSSR8d = 15.5;	// outside diameter of Misumi MTSSR8
MTSSR8l = 21.5;	// length of MTSSR8
//------------------------------------------------------------
StepperShaftOffset=15;
StepperMountThickness=4;
F625ZZ_dia=16;
LayerThickness=0.4;
Nozzle=0.4;
//---------------------------------------------
Switch_ht=20;	// height of holder
Switch_thk=5;	// thickness of holder
Switch_thk2=7;	// thickness of spacer
HolderWidth=33;	// width of holder
SwitchShift=6;	// move switch mounting holes along width
//------------------------------------------------------------
Bed1212Height=310; // 12" bed
Bed1212Width=310;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//XEnd(1);
//translate([100,0,0]) mirror([1,0,0]) XEnd(1);
//XEndMGNOn2020(1); // 1st arg: TR8=0, MTSS=1
//translate([100,0,0]) mirror([1,0,0]) XEndMGNOn2020(1);
//AxisBrace(4); // arg is Quanity
//translate([65,0,0])
//AxisBrace(4,65,0); // arg is Quanity; args 2&3 are X,Y
//XCarriageForMGN(1);  // changed to 1 for Single E3DV6 extruder setup
//Spacer(8,10,screw5);
//FatSpacer(8,20,screw3+0.5);
BedMount2020(1,0);
//BedMount(2);

///////////////////////////////////////////////////////////////////////

module Show2020() {
	%cuboid([20,60,20],rounding=2,p1=[0,0]);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Spacer(Quanity=1,Thickness,Screw=screw3,) { // spacer to move pc board off platform, use translate() when you call it
	for(a=[0:Quanity-1]) {
		difference() {
			translate([0,a*15,0]) color("gray") cylinder(h=Thickness,d = Screw*2);
			translate([0,a*15,-1]) color("white") cylinder(h=Thickness*2,d = Screw);
		}
		difference() {
			translate([screw3-3.5,-(screw3-3.5)+a*15,0]) color("cyan") cylinder(h=4,d=Screw*3);
			translate([0,a*15,-1]) color("white") cylinder(h=Thickness*2,d = Screw);
		}
	}
}

///////////////////////////////////////////////////////////////////////

module FatSpacer(Quanity=1,Thickness,Screw=screw3,) { // spacer to move pc board off platform, use translate() when you call it
	for(a=[0:Quanity-1]) {
		difference() {
			translate([0,a*25,0]) color("gray") cylinder(h=Thickness,d = Screw*4);
			translate([0,a*25,-1]) color("white") cylinder(h=Thickness*2,d = Screw);
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module XEndHorizontalBeltEnds() {
	translate([25,30,20]) rotate([-90,0,90]) MotorMountH();
	translate([-12,28,20]) rotate([90,180,0]) XIdlerH();
}

////////////////////////////////////////////////////////////////////////////////

module mount(Screw=screw5,Side=0) {
	difference() {
		union() {
			color("cyan") cuboid([22,HolderWidth,Switch_thk2],rounding=1,p1=[0,0]);
			if(Side==0) translate([Screw/2-3,23,Switch_thk2-1]) color("red")
				cuboid([22,6,2],rounding=1,p1=[0,0]); // slot align
			if(Side==1) translate([Screw/2-3,3,Switch_thk2-1]) color("blue") 
				cuboid([22,6,2],rounding=1,p1=[0,0]); // slot align
		}
		translate([10,6,-1])  color("red") cylinder(h=Switch_thk2*2,d=Screw);
		translate([10,26,-1])  color("green") cylinder(h=Switch_thk2*2,d=Screw);
	}
}

///////////////////////////////////////////////////////////////////////////////
module base(Sep,DiagOffset,Offset,ScrewT,Adjust) {
	rotate([0,-90,0]) difference() {
		difference() {
			translate([0,0,-4]) color("yellow") cuboid([Switch_thk,HolderWidth,Switch_ht+Offset-Adjust],rounding=1,p1=[0,0]);
			// screw holes for switch
			rotate([0,90,0]) {		
				translate([-(Switch_ht-Offset)-0.5, SwitchShift, -1]) {
					color("purple") cylinder(h = 11, d=ScrewT);
				}
			}
			rotate([0,90,0]) {
				translate(v = [-(Switch_ht-Offset)-0.5+DiagOffset, SwitchShift+Sep, -1]) {
					color("black") cylinder(h = 11, d=ScrewT);
				}
			}
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TopMountBeltHoles(Screw=Yes3mmInsert(Use3mmInsert,UseLarge3mmInsert),UseHull=1) {
	if(UseHull) {
		color("blue") hull() {
			translate([26,0,0]) cylinder(h=20,d= Screw);
			translate([29,0,0]) cylinder(h = 20, d = Screw);
		}
		color("red") hull() {
			translate([-1,0,0])	cylinder(h = 20, d = Screw);
			translate([2,0,0])	cylinder(h = 20, d = Screw);
		}
	} else {
	color("red") cylinder(h = 20, d = Screw);
		translate([27,0,0]) cylinder(h=20,d= Screw);
	}
}
//////////////////////////////////////////////////////////////////////////

module MotorMountH(Qty=1) {
	translate([0,20-StepperMountThickness,-3]) difference() {
		color("red") cuboid([55,StepperMountThickness,60],rounding=2,p1=[0,0]);
		translate([28,6,28]) color("blue") rotate([90,0,0]) NEMA17_parallel_holes(8,10);
	}
	difference() {
		translate([0,-2,-3]) color("blue") cuboid([StepperMountThickness,22,77],rounding=2,p1=[0,0]);
		translate([0,10.5,32+StepperShaftOffset]) 2040ScrewHoles(screw5);
		translate([-3,3,StepperMountThickness+8]) color("gray") cuboid([12,13,26],rounding=2,p1=[0,0]);
	}
	translate([1,0,-3]) color("green") rotate([0,0,19]) 
		cuboid([50,StepperMountThickness,StepperMountThickness],rounding=2,p1=[0,0]);
	translate([1,0,53]) color("pink") rotate([0,0,19])
		cuboid([50,StepperMountThickness,StepperMountThickness],rounding=2,p1=[0,0]);
	translate([1,16,69]) color("black") rotate([0,19,0]) 
		cuboid([50,StepperMountThickness,StepperMountThickness],rounding=2,p1=[0,0]);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////

module 2040ScrewHoles(Screw=screw5) {
	translate([-5,0,0]) color("cyan") rotate([0,90,0]) cylinder(h=15,d=Screw);
	translate([-5,0,20]) color("plum") rotate([0,90,0]) cylinder(h=15,d=Screw);
	if(Screw==screw5) {
		translate([3,0,0]) color("plum") rotate([0,90,0]) cylinder(h=5,d=screw5hd);
		translate([3,0,20]) color("cyan") rotate([0,90,0]) cylinder(h=5,d=screw5hd);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////

module XIdlerH(IdlerScrew=Yes5mmInsert(Use5mmInsert)) {
	difference() {
		union() {
			translate([1,-2,0]) color("cyan") cuboid([47,22,StepperMountThickness],rounding=2,p1=[0,0]);
			translate([-24,20-StepperMountThickness,0]) color("plum")
				cuboid([35,StepperMountThickness,20],rounding=2,p1=[0,0]);
		}
		translate([30,10.5,0]) rotate([0,-90,0]) 2040ScrewHoles(screw5);
		translate([-14,25,F625ZZ_dia/2+2]) rotate([90,0,0]) color("red") cylinder(h=20,d=IdlerScrew);
	}
	translate([5,20-StepperMountThickness,16.5]) color("green") rotate([0,22,0])
		cuboid([45,StepperMountThickness,StepperMountThickness],rounding=2,p1=[0,0]);
	translate([1,StepperMountThickness-3.5,0]) color("black") rotate([43,0,0])
		cuboid([StepperMountThickness,26,StepperMountThickness],rounding=2,p1=[0,0]);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module XEnd(MTSS=0) {  // idler side
	difference() {
		mgnbase(0,-22,1,1);
		if(MTSS)
			translate([-1,-TR8_offset+8,TR8_Height-9]) rotate([0,90,0]) color("blue") cylinder(h=30,d=MTSSR8d);
		else
			translate([25,-TR8_offset+8,TR8_Height-9]) rotate([0,270,0]) TR8_nut();
	}
	if(MTSS)
		translate([5,-TR8_offset+8,TR8_Height-9]) rotate([0,90,0]) ZNutMTSS8();
	else {	
		translate([39,-TR8_offset+8,TR8_Height-9]) rotate([0,90,180]) ZNutTR8();
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module XEndMGNOn2020(MTSS=0) {  // Add the leadscrew mount
	difference() {
		mgnbase(10,-22,0,0,9);
		translate([10,20,0]) MountingHoles2020();
		if(MTSS)
			translate([-1,-TR8_offset+8,TR8_Height-10]) rotate([0,90,0]) color("blue") cylinder(h=30,d=MTSSR8d);
		else
			translate([25,-TR8_offset+8,TR8_Height-9]) rotate([0,90,0]) TR8_nut();
	}
	if(MTSS)
		translate([5,-TR8_offset+8,TR8_Height-10]) rotate([0,90,0]) ZNutMTSS8();
	else	
		translate([5,-TR8_offset+8,TR8_Height-10]) rotate([0,90,0]) ZNutTR8();
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ZNutTR8() {
	difference() {
		ZNutFrame();
		translate([0,0,TR8_flange_thickness]) TR8_nut();
		translate([0,0,25]) TR8_mounting_holes();
		translate([TR8_flange_dia-11.8,-TR8_flange_dia/2-2,-1]) color("gray") cube([TR8_flange_dia+5,TR8_flange_dia+5,TR8_ht+5]);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ZNutFrame() {
	union() {
		color("red") cylinder(h=TR8_ht,d=TR8_flange_dia+2);
		//translate([5,-TR8_flange_dia/2+4,0]) color("blue")
		//	cuboid([TR8_flange_dia-15.5,TR8_flange_dia-3,TR8_ht],rounding=2,p1=[0,0]);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ZNutMTSS8() {
	difference() {
		ZNutFrame();
		translate([0,0,-2]) color("cyan") cylinder(h=MTSSR8l+2,d=MTSSR8d);
		translate([0,0,-3]) color("purple") cylinder(h=TR8_ht+5,d=9);
		translate([TR8_flange_dia-11.8,-TR8_flange_dia/2-2,-1]) color("gray") cube([TR8_flange_dia+5,TR8_flange_dia+5,TR8_ht+5]);
		MTSSGrubScrewHole(Yes3mmInsert(Use3mmInsert,UseLarge3mmInsert),-18,0,TR8_ht/2-2);
	}
	MTSSGrubScrew(Yes3mmInsert(Use3mmInsert,UseLarge3mmInsert),-18,0,TR8_ht/2-2);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module MTSSGrubScrew(Screw=Yes3mmInsert(Use3mmInsert,UseLarge3mmInsert),X=0,Y=0,Z=0) {
	difference() {
		hull() {
			translate([X,Y,Z]) rotate([0,90,0]) cylinder(h=5,d=Screw+2);
			translate([X+6,Y,Z]) rotate([0,90,0]) cylinder(h=1.5,d=Screw*2.5);
		}
		MTSSGrubScrewHole(Screw,X,Y,Z);
		translate([X-2,Y,Z]) rotate([0,90,0]) cylinder(h=20,d=Screw);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module MTSSGrubScrewHole(Screw=Yes3mmInsert(Use3mmInsert,UseLarge3mmInsert),X=0,Y=9,Z=0) {
	translate([X-2,Y,Z]) rotate([0,90,0]) cylinder(h=20,d=Screw);
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module mgnbase(X=0,Y=0,Z=0,Two2020=0,AddLength=0) {
	difference() {
		color("cyan") cuboid([MGN12HLength,MGN12HWidth+MountWidth+AddLength+5,Thickness],rounding=2,p1=[0,0]);
		translate([MGN12HLength/4+1,32,-2]) mgnscrewholes();
		translate([MGN12HLength/4+1,32,-Thickness+4]) mgnscountersink();
		translate([X,Y,Z]) MountingHoles2020(Two2020);
		translate([22,42,-1]) color("blue") cylinder(h=10,d=20); // plastic reduction
	}
	difference() {
		translate([5,30,4]) color("black") cube([35,25,LayerThickness]); // countersink support
		translate([22,42,-1]) color("blue") cylinder(h=10,d=20); // plastic reduction
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module mgnscrewholes(Screw=screw3,Len=Thickness*2) {
	color("red") cylinder(h=Len,d=Screw,$fn=100);
	translate([20,0,0]) color("black") cylinder(h=Len,d=Screw,$fn=100);
	translate([0,20,0]) color("blue") cylinder(h=Len,d=Screw,$fn=100);
	translate([20,20,0]) color("gray") cylinder(h=Len,d=Screw,$fn=100);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module mgnscountersink(Screw=screw3hd,Len=Thickness) {
	color("black") cylinder(h=Len,d=Screw,$fn=100);
	translate([20,0,0]) color("blue") cylinder(h=Len,d=Screw,$fn=100);
	translate([0,20,0]) color("gray") cylinder(h=Len,d=Screw,$fn=100);
	translate([20,20,0]) color("red") cylinder(h=Len,d=Screw,$fn=100);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module MountingHoles2020(Two=0) {
	translate([MGN12HLength/4+1,MGN12HWidth+MountWidth/2,0]) {
		translate([0,0,-2]) color("plum") cylinder(h=Thickness*2,d=screw5,$fn=100);
		if(Two)	translate([20,0,-2]) color("red") cylinder(h=Thickness*2,d=screw5,$fn=100);
	}
	translate([MGN12HLength/4+1,MGN12HWidth+MountWidth/2,Thickness*2-4]) {
		translate([0,0,-Thickness+1]) color("gray") cylinder(h=Thickness,d=screw5hd,$fn=100);
		if(Two)	translate([20,0,-Thickness+1]) color("blue") cylinder(h=Thickness,d=screw5hd,$fn=100);
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////////

module TR8_nut() {
	color("cyan") cylinder(h=TR8_ht,d=TR8_small_dia,$fn=100); // center nut
	color("pink") cylinder(h=TR8_flange_thickness,d=TR8_flange_dia,$fn=100);
	translate([0,0,-28]) color("plum") cylinder(h=30,d=TR8_flange_dia,$fn=100);
}

////////////////////////////////////////////////////////////////////////////////////////////////////

module TR8_mounting_holes() {
	translate([0,TR8_mounting_holes_offset/2,-2]) color("blue")
		cylinder(h=40,d=Yes3mmInsert(Use3mmInsert,UseLarge3mmInsert),$fn=100);
	translate([0,-TR8_mounting_holes_offset/2,-2]) color("cyan")
		cylinder(h=40,d=Yes3mmInsert(Use3mmInsert,UseLarge3mmInsert),$fn=100);
	translate([TR8_mounting_holes_offset/2,0,-2]) color("gray")
		cylinder(h=40,d=Yes3mmInsert(Use3mmInsert,UseLarge3mmInsert),$fn=100);
	translate([-TR8_mounting_holes_offset/2,0,-2]) color("black")
		cylinder(h=40,d=Yes3mmInsert(Use3mmInsert,UseLarge3mmInsert),$fn=100);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////

module IdlerSuppoerts() {
	difference() {
		translate([-1,-4,22]) color("green") rotate([0,23,0]) cuboid([80,4,5],rounding=2,p1=[0,0]);
		translate([48,-8,-2]) color("gray") cube([10,10,10]);
		translate([43,-8,-Thickness*2-1]) color("lightgray") cuboid([35,20,20],rounding=2,p1=[0,0]);
	}
	translate([0,23.5,0]) difference() {
		translate([-1,-4,22]) color("green") rotate([0,23,0]) cuboid([80,4,5],rounding=2,p1=[0,0]);
		translate([48,-8,-2]) color("gray") cube([10,10,10]);
		translate([43,-8,-Thickness*2-1]) color("lightgray") cuboid([35,20,20],rounding=2,p1=[0,0]);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////

module MSSideHoles() {
	color("cyan") rotate([0,90,0]) cylinder(h=10,d=screw5);
	translate([0,0,20]) color("gray") rotate([0,90,0]) cylinder(h=10,d=screw5);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////

module SideSupports() {
	difference() {
		translate([-0.5,-2.5,40]) color("green") rotate([0,39,0]) cuboid([80,4,5],rounding=2,p1=[0,0]);
		translate([53,-3,-2]) color("gray") cube([10,10,10]);
		translate([43,-4,-Thickness*2-1]) color("lightgray") cuboid([25,20,20],rounding=2,p1=[0,0]);
	}
	translate([0,48.5,0]) difference() {
		translate([0,0,40]) color("green") rotate([0,39,0]) cuboid([80,4,5],rounding=2,p1=[0,0]);
		translate([53,-3,-2]) color("gray") cube([10,10,10]);
		translate([45,-4,-Thickness*2-1]) color("lightgray") cuboid([25,20,20],rounding=2,p1=[0,0]);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////

module AxisBrace(Qty=1,X=0,Y=0) {
	for(x = [0 : Qty-1]) {
		translate([X,x*65+Y,0]) difference() {
			color("blue") hull() {
				translate([40,0,0]) cuboid([20,60,5],rounding=2,p1=[0,0]);
				translate([2,20,0]) cuboid([1,20,5],rounding=2,p1=[0,0]);
			}
			translate([10,30,-3]) 2020ScrewHoles(1);
			translate([50,10,-3]) 2020ScrewHoles();
			translate([50,30,-3]) rotate([0,0,90]) 2020ScrewHoles(1);
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////

module 2020ScrewHoles(Two=0) {
	color("black") cylinder(h=10,d=screw5);
	translate([0,0,6.5]) color("white") cylinder(h=5,d=screw5hd);
	if(Two) {
		translate([0,0,6.5]) color("white") cylinder(h=5,d=screw5hd);
		translate([20,0,0]) color("gray") cylinder(h=10,d=screw5);
		translate([20,0,6.5]) color("lightgray") cylinder(h=5,d=screw5hd);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BedMount(Qty=2) {
	for(x = [0 : Qty-1]) {
		translate([0,x*45,0]) {
			difference() {
				translate([-55,0,0]) color("cyan") cuboid([250,40,screw4cs*2],rounding=2,p1=[0,0]);
				translate([59,10,-2]) mgnscrewholes(screw3);
				translate([59,10,-screw4cs*2+screw3cs*1.5]) mgnscountersink(screw3hd);
				translate([6.5,7.5,0]) BedScrewHoles(Yes3mmInsert(Use3mmInsert,UseLarge3mmInsert));
				translate([96,7.5,0]) BedScrewHoles(Yes3mmInsert(Use3mmInsert,UseLarge3mmInsert));
			}
			translate([54,7,screw3cs*1.5]) color("black") cube([30,30,LayerThickness]);
			difference() {
				translate([-55,0,1]) color("green") cuboid([4,40,screw4cs*2+3],rounding=1.5,p1=[0,0]);
				translate([25.5 - 20.5,7.5,0]) BedScrewHoles(Yes3mmInsert(Use3mmInsert,UseLarge3mmInsert));
				translate([-58,15,screw4cs*2+2]) color("black") 
					cuboid([10,10,10],rounding=2,p1=[0,0]); // notch for the bumper at the end of the mgn
			}
			difference() {
				translate([191,0,1]) color("purple") cuboid([4,40,screw4cs*2+3],rounding=1.5,p1=[0,0]);
				translate([25.5 - 20.5,7.5,0]) BedScrewHoles(Yes3mmInsert(Use3mmInsert,UseLarge3mmInsert));
				translate([188,15,screw4cs*2+2]) color("white")
					cuboid([10,10,10],rounding=2,p1=[0,0]); // notch for the bumper at the end of the mgn
			}
			translate([-55,0,1]) color("gray") cuboid([250,3,screw4cs*2+3],rounding=1.5,p1=[0,0]);
			translate([-55,36.99,1]) color("white") cuboid([250,3,screw4cs*2+3],rounding=1.5,p1=[0,0]);
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BedMount2020(Qty=2,Show=0) {
	for(x = [0 : Qty-1]) {
		translate([0,x*75,0]) {
			difference() {
				union() {
					color("cyan") cuboid([Bed1212Height,55,6],rounding=2,p1=[0,0]);
					translate([21.5,20,0]) color("green") cuboid([Bed1212Height-44,35,10],rounding=2,p1=[0,0]);
					translate([21,50,5]) color("red") cuboid([Bed1212Height-44,5,10],rounding=2,p1=[0,0]);
				}
				translate([Bed1212Height/2-10,25,-2]) mgnscrewholes(screw3);
				translate([Bed1212Height/2-10,25,4]) mgnscountersink(screw3hd);
				AllBedScrewHoles2020(screw5);
				BedScrewClearanceHoles(screw5);
				translate([35,5,0]) Holes(4);
				translate([185,5,0]) Holes(4);
			}
			difference() {
				AllBedCounterSink2020(Screw=screw5);
				BedScrewClearanceHoles(screw5);
			}
			if(Show) {
				Show2020();
				translate([Bed1212Height-21,0,0]) Show2020();
				translate([180,0,0]) rotate([0,0,90]) Show2020();
			}
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BedScrewClearanceHoles(Screw) {
	translate([10,14.5,-2]) color("pink") hull() {
		cylinder(h=10,d=Screw);
		translate([0,24,0]) cylinder(h=10,d=Screw);	
	}
	translate([298,14.5,-2]) color("purple") hull() {
		cylinder(h=10,d=Screw);
		translate([0,24,0]) cylinder(h=10,d=Screw);	
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module MGNHoleSupport() {
	color("red") cube([screw5hd,screw5hd,LayerThickness]);
	translate([20,0,0]) color("gray") cube([screw5hd,screw5hd,LayerThickness]);
	translate([0,20,0]) color("blue") cube([screw5hd,screw5hd,LayerThickness]);
	translate([20,20,0]) color("black") cube([screw5hd,screw5hd,LayerThickness]);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module AllBedScrewHoles2020(Screw=screw5) {
	translate([10,45,0]) color("red") BedScrewHoles2020(Screw,0); // side left end
	translate([10,7,0]) color("black") BedScrewHoles2020(Screw,0); // side end lft
	translate([Bed1212Height/2-50,7,0]) color("blue") BedScrewHoles2020(Screw,0); // side
	translate([Bed1212Height/2,7,0]) color("gray") BedScrewHoles2020(Screw,0); // side center
	translate([Bed1212Height/2-100,7,0]) color("white") BedScrewHoles2020(Screw,0); // side
	translate([Bed1212Height-12,45.5,0]) color("lightgray") BedScrewHoles2020(Screw,0); // side right end
	translate([Bed1212Height-12,7.5,0]) color("purple") BedScrewHoles2020(Screw,0); // side end right
	translate([Bed1212Height/2+50,7,0]) color("pink") BedScrewHoles2020(Screw,0); // side
	translate([Bed1212Height/2+100,7,0]) color("plum") BedScrewHoles2020(Screw,0); // side
	translate([10,45,0]) color("red") BedScrewHoles2020(Screw,0); // side left end
	translate([10,7,0]) color("black") BedScrewHoles2020(Screw,0); // side end lft
	translate([Bed1212Height/2-50,7,0]) color("blue") BedScrewHoles2020(Screw,0); // side
	translate([Bed1212Height/2,7,0]) color("gray") BedScrewHoles2020(Screw,0); // side center
	translate([Bed1212Height/2-100,7,0]) color("white") BedScrewHoles2020(Screw,0); // side
	translate([Bed1212Height-12,45.5,0]) color("lightgray") BedScrewHoles2020(Screw,0); // side right end
	translate([Bed1212Height-12,7.5,0]) color("purple") BedScrewHoles2020(Screw,0); // side end right
	translate([Bed1212Height/2+50,7,0]) color("pink") BedScrewHoles2020(Screw,0); // side
	translate([Bed1212Height/2+100,7,0]) color("plum") BedScrewHoles2020(Screw,0); // side
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module AllBedCounterSink2020(Screw=screw5) {
	if(Screw==screw5) {
		translate([10,45,0]) BedCounterSinkSupport(); // side left end
		translate([10,7,0]) BedCounterSinkSupport(); // side end lft
		translate([Bed1212Height/2-50,7,0]) BedCounterSinkSupport(); // side
		translate([Bed1212Height/2,7,0])  BedCounterSinkSupport(); // side center
		translate([Bed1212Height/2-100,7,0]) BedCounterSinkSupport(); // side
		translate([Bed1212Height-12,45.5,0]) BedCounterSinkSupport(); // side right end
		translate([Bed1212Height-12,7.5,0]) BedCounterSinkSupport(); // side end right
		translate([Bed1212Height/2+50,7,0]) BedCounterSinkSupport(); // side
		translate([Bed1212Height/2+100,7,0]) BedCounterSinkSupport(); // side
		translate([10,45,0]) BedCounterSinkSupport(); // side left end
		translate([10,7,0]) BedCounterSinkSupport(); // side end lft
		translate([Bed1212Height/2-50,7,0]) BedCounterSinkSupport(); // side
		translate([Bed1212Height/2,7,0])  BedCounterSinkSupport(); // side center
		translate([Bed1212Height/2-100,7,0]) BedCounterSinkSupport(); // side
		translate([Bed1212Height-12,45.5,0])  BedCounterSinkSupport(); // side right end
		translate([Bed1212Height-12,7.5,0]) BedCounterSinkSupport(); // side end right
		translate([Bed1212Height/2+50,7,0]) BedCounterSinkSupport(); // side
		translate([Bed1212Height/2+100,7,0])  BedCounterSinkSupport(); // side
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Holes(Quanity) {
	for(x = [0 : Quanity-1]) {
		translate([30*x,30,-2]) cylinder(h=20,d=20);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////

module BedScrewHoles(Screw=Yes3mmInsert(Use3mmInsert,UseLarge3mmInsert)) {
	translate([0,0,-2]) color("red") cylinder(h=10,d=Screw);
	translate([40.2-4,0,-2]) color("blue") cylinder(h=10,d=Screw);
	translate([0,28.7-4,-2]) color("gray") cylinder(h=10,d=Screw);
	translate([40.2-4,28.7-4,-2]) color("white") cylinder(h=10,d=Screw);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////

module BedScrewHoles2020(Screw=Yes5mmInsert(Use5mmInsert),Triple=1) {
	translate([0,0,-2]) color("red") cylinder(h=20,d=Screw);
	if(Screw==screw5) translate([0,0,-4]) color("blue") cylinder(h=5,d=screw5hd);
	if(Triple) {
		translate([0,28.7-4,-2]) color("gray") cylinder(h=20,d=Screw);
		translate([0,55,-2]) color("white") cylinder(h=20,d=Screw);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////

module BedCounterSinkSupport() {
	translate([0,0,1]) color("khaki") cylinder(h=LayerThickness,d=screw5hd);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////

module XCarriageForMGN(AddExtruder=0) {
	difference() {
		color("cyan") cuboid([HorizontallCarriageWidth,MGN12HWidth+5,wall],rounding=2,p1=[0,0]);
		translate([27,6,0]) mgnscrewholes();
		translate([27,6,5])  mgnscountersink();
		translate([37,30,wall/2])
		ExtruderMountHolesFn();
	}
	difference() { // belt mount
		translate([HorizontallCarriageWidth/2-20,MGN12HWidth,0]) color("red") cuboid([40,40,wall],rounding=2,p1=[0,0]);
		translate([27,6,0]) mgnscrewholes();
		translate([27,6,5])  mgnscountersink();
		translate([HorizontallCarriageWidth/2-14,70,4]) rotate([90,0,0])
			TopMountBeltHoles(Yes3mmInsert(Use3mmInsert,UseLarge3mmInsert),0);
	}
	if(AddExtruder) {
		difference() {
			translate([37,0,32]) rotate([-90,0,0]) Extruder(1,5,1);
			translate([27,6,0]) mgnscrewholes();
			translate([27,6,5])  mgnscountersink();
		}
		translate([47.5,41,wall-2]) color("blue") cuboid([10,10,8],rounding=2,p1=[0,0]);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ExtruderMountHolesFn(Screw=Yes3mmInsert(UseLarge3mmInsert),Length=25,Fragments=100) {
	// screw holes to mount extruder plate
	translate([0,-20,0]) rotate([90,0,0]) color("blue") cylinder(h = Length, d = Screw, $fn=Fragments);
	translate([HorizontallCarriageWidth/2-5,-20,0]) rotate([90,0,0]) color("red")
		cylinder(h = Length, d = Screw, $fn=Fragments);
	translate([-(HorizontallCarriageWidth/2-5),-20,0]) rotate([90,0,0]) color("black")
		cylinder(h = Length, d = Screw, $fn=Fragments);
	translate([HorizontallCarriageWidth/4-2,-20,0]) rotate([90,0,0]) color("gray")
		cylinder(h = Length, d = Screw, $fn=Fragments);
	translate([-(HorizontallCarriageWidth/4-2),-20,0]) rotate([90,0,0]) color("cyan")
		cylinder(h = Length, d = Screw, $fn=Fragments);
}

//////////////////////////////////////////////////////////////////////////////////////////////////

module printchar(String,Height=1.5,Size=4,Font="Liberation Sans",Color="coral") { // print something
	color(Color) linear_extrude(height = Height) text(String, font = Font,size=Size);
}

///////////////////// end of mgn.scad ////////////////////////////////////////////////////////////////////////////