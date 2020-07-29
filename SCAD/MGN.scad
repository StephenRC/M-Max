///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MGN.scad - use MGN rails for the Z axis
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Created: 5/21/2020
// Last Update: 7/24/20
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
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//**************************************************
// NOT TESTED
//**************************************************
//==================================================================================
// 2020x460mm with the 400mm MGN12 are to be connected to the middle and upper 2020
// Support included with BeltAttachment(), use a raft to keep the supports from coming off the bed
//==================================================================================
include <mmax_h.scad>
Use3mmInsert=1;
Use5mmInsert=1;
include <brassfunctions.scad>
include <inc/screwsizes.scad>
use <Z-Motor_Leadscrew-Coupler.scad> // coupler(motorShaftDiameter = 5,threadedRodDiameter = 5)
include <inc/NEMA17.scad>
include <inc/cubeX.scad>
use <yBeltClamp.scad>
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
$fn=100;
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
LayerThickness=0.3;
Nozzle=0.4;
//---------------------------------------------
Switch_ht=20;	// height of holder
Switch_thk=5;	// thickness of holder
Switch_thk2=7;	// thickness of spacer
HolderWidth=33;	// width of holder
SwitchShift=6;	// move switch mounting holes along width
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//XEndsAndEndstop(1,1); // 1st arg: TR8=0, MTSS=1; 2nd arg: 0=CN0097, 1=Black microswicth, 2=no endstop
//XEndHorizontalBeltEnds();
BeltAttachment();
//XEndMGNOn2020(1); // 1st arg: TR8=0, MTSS=1
//translate([100,0,0]) mirror([1,0,0]) XEndMGNOn2020(1);
//translate([0,60,0])
//	MotorMount();
//translate([0,-55,0]) XIdler();
//translate([-65,-25,0]) CornerBraces(4); // arg is Quanity, default is 4
//translate([-130,-25,0]) CornerBraces(4); // arg is Quanity, default is 4
//BedMount(2); // default is 2
//XCarriageForMGN();

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module XEndHorizontalBeltEnds() {
	translate([25,30,20]) rotate([-90,0,90]) MotorMountH();
	translate([-12,28,20]) rotate([90,180,0]) XIdlerH();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

module XEndsAndEndstop(Type=0,EndStopType=0) {
	XEnd(1); // 1st arg: TR8=0, MTSS=1
	translate([50,0,0]) XEnd2(1);
	if(EndStopType==0) translate([17,-62,0]) XEndStop(22,10,8,Yes3mmInsert(),8);
	else if(EndStopType==1) translate([17,-62,0]) XEndStop(10,0,8,screw2,8); // black microswitch inline mount
}

///////////////////////////////////////////////////////////////////////////////////////////////////

module XEndStop(Sep,DiagOffset,Offset,ScrewS,Adjust) {
	base(Sep,DiagOffset,Offset,ScrewS,Adjust);
	mount();
}

////////////////////////////////////////////////////////////////////////////////

module mount(Screw=screw5) {
	difference() {
		union() {
			color("cyan") cubeX([22,HolderWidth,Switch_thk2],1);
			translate([3-Screw/2,3,Switch_thk2-1]) color("blue") cubeX([22,6,2],1); // slot align
		}
		translate([10,6,-1])  color("red") cylinder(h=Switch_thk2*2,d=Screw);
	}
}

///////////////////////////////////////////////////////////////////////////////
module base(Sep,DiagOffset,Offset,ScrewT,Adjust) {
	rotate([0,-90,0]) difference() {
		difference() {
			translate([0,0,-4]) color("yellow") cubeX([Switch_thk,HolderWidth,Switch_ht+Offset-Adjust],1);
			// screw holes for switch
			rotate([0,90,0]) {		
				translate([-(Switch_ht-Offset)-0.5, SwitchShift, -1]) {
					color("purple") cylinder(h = 11, r = ScrewT/2, center = false, $fn=100);
				}
			}
			rotate([0,90,0]) {
				translate(v = [-(Switch_ht-Offset)-0.5+DiagOffset, SwitchShift+Sep, -1]) {
					color("black") cylinder(h = 11, r = ScrewT/2, center = false, $fn=100);
				}
			}
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////

module BeltAttachment() { // must print on side with supports from bed only
	//%translate([-50,-70,-23]) cube([200,200,3]);
	CarriageMount();
	BeltMount();
}

//////////////////////////////////////////////////////////////////////////////////////////////////////

module CarriageMount() {
	rotate([180,0,0]) {
		difference() {
			color("cyan") cubeX([55,49.3,20],2);
			translate([8,-2,-1]) color("plum") cubeX([40,53,11],1);
			translate([14,3.5,0]) TopMountBeltHoles(screw3);
			translate([14,45.5,0]) TopMountBeltHoles(screw3);
			translate([14,3.5,14]) TopMountBeltHoles(screw3hd);
			translate([14,45.5,14]) TopMountBeltHoles(screw3hd);
			translate([-35,26,14.5]) color("red") rotate([0,90,0]) cylinder(h=130,d=Yes5mmInsert());
			color("red") hull() { // plastic reduction
				translate([23,24.75,-2]) cylinder(h=25,d=28);
				translate([33,24.75,-2]) cylinder(h=25,d=28);
			}
		}
		translate([8,1,13.7]) color("black") cube([40,10,LayerThickness]);
		translate([8,39,13.7]) color("white") cube([40,10,LayerThickness]);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////

module BeltMount() {
	translate([0,20,14]) rotate([-90,0,0]) {
		difference() {
			translate([0,17,0]) {
				translate([-3,0,0]) Loop1();
				translate([3,0,0]) Loop2();
			}
			translate([-35,26,14.5]) color("red") rotate([0,90,0]) cylinder(h=130,d=screw5);//Yes5mmInsert);
		}
		translate([-22.25,17,20]) color("gray") cubeX([100.25,17,8],2);
		difference() {
			translate([-22.25,17,16]) color("green") cubeX([22,17,8],2);
			translate([-35,26,14.5]) color("red") rotate([0,90,0]) cylinder(h=130,d=screw5);//Yes5mmInsert);
		}
		difference() {
			translate([55,17,16]) color("khaki") cubeX([23,17,8],2);
			translate([-35,26,14.5]) color("red") rotate([0,90,0]) cylinder(h=130,d=screw5);//Yes5mmInsert);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////

module BeltAttachmentV1() { // must print on side with supports from bed only
	translate([0,0,49.3]) rotate([-90,0,0]) {
		difference() {
			color("cyan") cubeX([55,49.3,20],2);
			translate([8,-2,-1]) color("plum") cubeX([40,53,11],1);
			translate([14,3.5,0]) TopMountBeltHoles(screw3);
			translate([14,45.5,0]) TopMountBeltHoles(screw3);
			translate([14,3.5,14]) TopMountBeltHoles(screw3hd);
			translate([14,45.5,14]) TopMountBeltHoles(screw3hd);
			color("red") hull() { // plastic reduction
				translate([23,24.75,-2]) cylinder(h=25,d=28);
				translate([33,24.75,-2]) cylinder(h=25,d=28);
			}
		}
		translate([0,17,0]) {
			Loop1();
			Loop2();
		}
	}
	// Loop1 side support
	translate([-17.5,-7,0]) color("black") cube([Nozzle,25.5,19]); // end support
	translate([-17-Nozzle,-7,0]) color("lightgray") cube([19,Nozzle,19]); // bottom support
	translate([-17.5-Nozzle,5,0]) color("green") cube([19,Nozzle,19]); // bottom support
	translate([-17.5,18.5-Nozzle,0]) color("purple") cube([19,Nozzle,19]); // top support
	translate([1,-7,0]) color("plum") cube([Nozzle,8,19]); // end support
	// Loop2 side support
	translate([73,-4,0]) color("black") cube([Nozzle,23,19]); // end support
	translate([53.5,-4,0]) color("lightgray") cube([20,Nozzle,19]); // bottom support
	translate([53.5,7,0]) color("red") cube([19,Nozzle,19]); // bottom support
	translate([53.5,18+Nozzle,0]) color("purple") cube([20,Nozzle,19]); // top support
	translate([53.5,-4,0]) color("plum") cube([Nozzle,9,19]); // end support
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Loop1() {
	translate([0,0,35]) rotate([-90,0,0]) {
		difference() {
			translate([-19.25,15,0]) color("plum") cubeX([22,28,17],2);
			translate([-20,31,0]) beltLoop();
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////

module Loop2() {
	translate([0,0,35]) rotate([90,0,0]) {
		difference() {
			translate([52,-41,-17]) color("white") cubeX([23,28,17],2);
			translate([75,-27,-12]) rotate([0,0,180]) beltLoop();
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TopMountBeltHoles(Screw=Yes3mmInsert()) {
	color("red") cylinder(h = GetHoleLen3mm(Screw), d = Screw);
	color("blue") hull() {
		translate([26,0,0]) cylinder(h = GetHoleLen3mm(Screw), d = Screw);
		translate([28,0,0]) cylinder(h = GetHoleLen3mm(Screw), d = Screw);
	}
}
//////////////////////////////////////////////////////////////////////////

module MotorMountH(Qty=1) {
	translate([0,20-StepperMountThickness,-3]) difference() {
		color("red") cubeX([55,StepperMountThickness,60],2);
		translate([28,6,28]) color("blue") rotate([90,0,0]) NEMA17_parallel_holes(8,10);
	}
	difference() {
		translate([0,-2,-3]) color("blue") cubeX([StepperMountThickness,22,77],2);
		translate([0,10.5,32+StepperShaftOffset]) 2040ScrewHoles(screw5);
		translate([-3,3,StepperMountThickness+8]) color("gray") cubeX([12,13,26],2);
	}
	translate([1,0,-3]) color("green") rotate([0,0,19]) cubeX([50,StepperMountThickness,StepperMountThickness],2);
	translate([1,0,53]) color("pink") rotate([0,0,19]) cubeX([50,StepperMountThickness,StepperMountThickness],2);
	translate([1,16,69]) color("black") rotate([0,19,0]) cubeX([50,StepperMountThickness,StepperMountThickness],2);
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

module XIdlerH(IdlerScrew=Yes5mmInsert()) {
	difference() {
		union() {
			translate([1,-2,0]) color("cyan") cubeX([47,22,StepperMountThickness],2);
			translate([-24,20-StepperMountThickness,0]) color("plum")
				cubeX([35,StepperMountThickness,20],2);
		}
		translate([30,10.5,0]) rotate([0,-90,0]) 2040ScrewHoles(screw5);
		translate([-14,25,F625ZZ_dia/2+2]) rotate([90,0,0]) color("red") cylinder(h=20,d=IdlerScrew);
	}
	translate([5,20-StepperMountThickness,16.5]) color("green") rotate([0,22,0])
		cubeX([45,StepperMountThickness,StepperMountThickness],2);
	translate([1,StepperMountThickness-3.5,0]) color("black") rotate([43,0,0])
		cubeX([StepperMountThickness,26,StepperMountThickness],2);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module XEnd(MTSS=0) {  // idler side
	mgnbase(0,3,1,1);
	if(MTSS)
		translate([5,-TR8_offset-2,TR8_Height-9]) rotate([0,90,0]) ZNutMTSS8();
	else {	
		translate([39,-TR8_offset-2,TR8_Height-9]) rotate([0,90,180]) ZNutTR8();
	}
	difference() {
		translate([0,-12,0]) color("pink") cubeX([MGN12HLength,15,Thickness],2);
		//translate([45,-TR8_offset-2,TR8_Height-10]) rotate([0,90,0]) TR8_nut();
		if(MTSS)
			translate([-1,-TR8_offset-2,TR8_Height-9]) rotate([0,90,0]) color("blue") cylinder(h=30,d=MTSSR8d);
		else
			translate([5,-TR8_offset-30,TR8_Height-10]) rotate([0,90,0]) TR8_nut();
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module XEnd2(MTSS=0) {// motor side
	mgnbase(0,3,1,1);
	if(MTSS)
		translate([32,-TR8_offset-30,TR8_Height-9]) rotate([180,90,0]) ZNutMTSS8();
	else {	
		translate([-2,-TR8_offset-30,TR8_Height-9]) rotate([0,90,0]) ZNutTR8();
	}
	difference() {
		translate([0,-38.5,0]) color("pink") cubeX([MGN12HLength-12,45,Thickness],2);
		if(MTSS)
			translate([7,-TR8_offset-30,TR8_Height-10]) rotate([0,90,0]) color("blue") cylinder(h=25,d=MTSSR8d);
		else
			translate([5,-TR8_offset-30,TR8_Height-10]) rotate([0,90,0]) TR8_nut();
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module XEndMGNOn2020(MTSS=0) {  // Add the leadscrew mount
	difference() {
		mgnbase(10,1,0,0,9);
		translate([10,14,0]) MountingHoles2020();
	}
	if(MTSS)
		translate([5,-TR8_offset-2,TR8_Height-10]) rotate([0,90,0]) ZNutMTSS8();
	else	
		translate([5,-TR8_offset-2,TR8_Height-10]) rotate([0,90,0]) ZNutTR8();
	difference() {
		translate([0,-5,0]) color("pink") cube([MGN12HLength,5,Thickness]);
		translate([9,-TR8_offset-2,TR8_Height-10]) rotate([0,90,0]) TR8_nut();
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ZNutTR8() {
	difference() {
		ZNutFrame();
		translate([0,0,TR8_flange_thickness]) TR8_nut();
		translate([0,0,GetHoleLen3mm(Yes3mmInsert())-20]) TR8_mounting_holes();
		translate([TR8_flange_dia-11.8,-TR8_flange_dia/2-2,-1]) color("gray") cube([TR8_flange_dia+5,TR8_flange_dia+5,TR8_ht+5]);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ZNutFrame() {
	union() {
		color("red") cylinder(h=TR8_ht,d=TR8_flange_dia+2);
		//translate([5,-TR8_flange_dia/2+4,0]) color("blue") cubeX([TR8_flange_dia-15.5,TR8_flange_dia-3,TR8_ht],2);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ZNutMTSS8() {
	difference() {
		ZNutFrame();
		translate([0,0,-2]) color("cyan") cylinder(h=MTSSR8l+2,d=MTSSR8d);
		translate([0,0,-3]) color("purple") cylinder(h=TR8_ht+5,d=9);
		translate([TR8_flange_dia-11.8,-TR8_flange_dia/2-2,-1]) color("gray") cube([TR8_flange_dia+5,TR8_flange_dia+5,TR8_ht+5]);
		MTSSGrubScrewHole(Yes3mmInsert(),-18,0,TR8_ht/2-2);
	}
	MTSSGrubScrew(Yes3mmInsert(),-18,0,TR8_ht/2-2);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module MTSSGrubScrew(Screw=Yes3mmInsert(),X=0,Y=0,Z=0) {
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

module MTSSGrubScrewHole(Screw=Yes3mmInsert(),X=0,Y=9,Z=0) {
	translate([X-2,Y,Z]) rotate([0,90,0]) cylinder(h=20,d=Screw);
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module mgnbase(X=0,Y=0,Z=0,Two2020=0,AddLength=0) {
	difference() {
		color("cyan") cubeX([MGN12HLength,MGN12HWidth+MountWidth+AddLength,Thickness],2);
		translate([MGN12HLength/4+1,12,-2]) mgnscrewholes();
		translate([MGN12HLength/4+1,12,-Thickness+3]) mgnscountersink();
		translate([X,Y,Z]) MountingHoles2020(Two2020);
		translate([22,22,-1]) color("blue") cylinder(h=10,d=20); // plastic reduction
	}
	difference() {
		translate([5,10,Z+2]) color("black") cube([35,25,LayerThickness]); // countersink support
		translate([22,22,-1]) color("blue") cylinder(h=10,d=20); // plastic reduction
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
	translate([0,TR8_mounting_holes_offset/2,-2]) color("blue") cylinder(h=40,d=Yes3mmInsert(),$fn=100);
	translate([0,-TR8_mounting_holes_offset/2,-2]) color("cyan") cylinder(h=40,d=Yes3mmInsert(),$fn=100);
	translate([TR8_mounting_holes_offset/2,0,-2]) color("gray") cylinder(h=40,d=Yes3mmInsert(),$fn=100);
	translate([-TR8_mounting_holes_offset/2,0,-2]) color("black") cylinder(h=40,d=Yes3mmInsert(),$fn=100);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////

module MotorMount() {
	difference() {
		translate([0,-2.5,0]) color("red") cubeX([55,55,4],2);
		translate([28,25,-1]) color("blue") NEMA17_parallel_holes(6,10);
	}
	difference() {
		translate([0,-2.5,0]) color("yellow") cubeX([4,55,45],2);
		translate([-2,27.5+MotorOffset,10]) MSSideHoles();
	}
	SideSupports();
}

/////////////////////////////////////////////////////////////////////////////////////////////

module XIdler() {
	difference() {
		union() {
			translate([0,-4,0]) color("cyan") cubeX([50,28,Thickness],2);
			translate([-Thickness+4,-TR8_flange_dia/4+1.5,0]) color("blue")
				cubeX([Thickness,28,TR8_flange_dia+Thickness/2],2);
		}
		translate([12,Thickness/2+11.5,9]) rotate([90,90,90]) MSSideHoles();
		translate([-13,Thickness/2+1,Thickness/2+TR8_flange_dia/2]) rotate([0,90,0]) color("red") cylinder(h=20,d=screw5);
		translate([0,Thickness/2+1,Thickness/2+TR8_flange_dia/2]) rotate([0,90,0]) color("purple") cylinder(h=5,d=nut5,$fn=6);
		translate([0,12,1]) mgnscountersink(screw5hd,20);
	}
	difference() {
		IdlerSuppoerts();
		translate([0,12,1]) mgnscountersink(screw5hd,10);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////

module IdlerSuppoerts() {
	difference() {
		translate([-1,-4,22]) color("green") rotate([0,23,0]) cubeX([80,4,5],2);
		translate([48,-8,-2]) color("gray") cube([10,10,10]);
		translate([43,-8,-Thickness*2-1]) color("lightgray") cubeX([35,20,20],2);
	}
	translate([0,23.5,0]) difference() {
		translate([-1,-4,22]) color("green") rotate([0,23,0]) cubeX([80,4,5],2);
		translate([48,-8,-2]) color("gray") cube([10,10,10]);
		translate([43,-8,-Thickness*2-1]) color("lightgray") cubeX([35,20,20],2);
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
		translate([-0.5,-2.5,40]) color("green") rotate([0,39,0]) cubeX([80,4,5],2);
		translate([53,-3,-2]) color("gray") cube([10,10,10]);
		translate([43,-4,-Thickness*2-1]) color("lightgray") cubeX([25,20,20],2);
	}
	translate([0,48.5,0]) difference() {
		translate([0,0,40]) color("green") rotate([0,39,0]) cubeX([80,4,5],2);
		translate([53,-3,-2]) color("gray") cube([10,10,10]);
		translate([45,-4,-Thickness*2-1]) color("lightgray") cubeX([25,20,20],2);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////

module CornerBraces(Qty=4,X=0,Y=0) {
	for(x = [0 : Qty-1]) {
		translate([X,x*65+Y,0]) difference() {
			color("blue") hull() {
				translate([40,0,0]) cubeX([20,60,5],2);
				translate([2,0,0]) cubeX([1,20,5],2);
			}
			translate([10,10,-3]) 2020ScrewHoles(1);
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
			translate([70.5,0,8]) cube([1,40,5]);
			difference() {
				color("cyan") cubeX([140,40,screw4cs*2],2);
				translate([59-10,6,-2]) mgnscrewholes(screw3);
				translate([59-10,6,-screw3cs+2]) mgnscountersink(screw3hd);
				translate([25.5 - 20.5,7.5,0]) BedScrewHoles(Yes3mmInsert());
				translate([41+56.5,7.5,0]) BedScrewHoles(Yes3mmInsert());
			}
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////

module BedScrewHoles(Screw=Yes3mmInsert()) {
	translate([0,0,-2]) color("red") cylinder(h=GetHoleLen3mm(Screw)*2,d=Screw);
	translate([40.2-4,0,-2]) color("blue") cylinder(h=GetHoleLen3mm(Screw)*2,d=Screw);
	translate([0,28.7-4,-2]) color("gray") cylinder(h=GetHoleLen3mm(Screw)*2,d=Screw);
	translate([40.2-4,28.7-4,-2]) color("white") cylinder(h=GetHoleLen3mm(Screw)*2,d=Screw);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////

module XCarriageForMGN() {
	difference() {
		cubeX([HorizontallCarriageWidth,MGN12HWidth,wall],2);
		translate([15,0,0]) {
			mgnscrewholes();
			mgnscountersink();
		}
		translate([37,40,wall/2]) ExtruderMountHolesFn();
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ExtruderMountHolesFn(Screw=Yes3mmInsert(),Length=GetHoleLen3mm(),Fragments=100) {
		// screw holes to mount extruder plate
		translate([0,-20,0]) rotate([90,0,0]) color("blue") cylinder(h = Length, d = Screw, $fn=Fragments);
		translate([HorizontallCarriageWidth/2-5,-20,0]) rotate([90,0,0]) color("red")
			cylinder(h = Length, d = Screw, $fn=Fragments);
		translate([-(HorizontallCarriageWidth/2-5),-20,0]) rotate([90,0,0]) color("black")
			cylinder(h = Length, d = Screw, $fn=Fragments);
		//translate([HorizontallCarriageWidth/4-2,-20,0]) rotate([90,0,0]) color("gray")
		//	cylinder(h = Length, d = Screw, $fn=Fragments);
		//translate([-(HorizontallCarriageWidth/4-2),-20,0]) rotate([90,0,0]) color("cyan")
		//	cylinder(h = Length, d = Screw, $fn=Fragments);
}

///////////////////// end of mgn.scad ////////////////////////////////////////////////////////////////////////////