///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MGN.scad - use MGN rails for the Z axis
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Created: 5/21/2020
// Last Update: 6/18/20
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 5/23/20	- Added X axis motor mount and idler mount that go at the ends of the makerslide
// 5/23/20	- Added abilty to print more that one MotorMount and to print a left, right or both of the ZCarriage
//			  Added support bars to XIdler, ZCarrige can noew use a TR8 or a Musumi MTSS8 nut
// 5/31/20	- Added a mount for the 300x200 bed frame to MGN12
// 6/17/20	- Added mgn mounted XCarriage, added use of 2020 with MGN to hold the x-axis carriage
// 6/18/20	- Beefed up the corner braces
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//**************************************************
// NOT TESTED
//**************************************************
//==================================================================================
// 2020x460mm with the 400mm MGN12 are to be conneted to the middle and upper 2020
//==================================================================================
include <mmax_h.scad>
Use3mmInsert=1;
include <brassfunctions.scad>
include <inc/screwsizes.scad>
use <Z-Motor_Leadscrew-Coupler.scad> // coupler(motorShaftDiameter = 5,threadedRodDiameter = 5)
include <inc/NEMA17.scad>
include <inc/cubeX.scad>
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
TR8_clearance=0.5;
TR8_small_dia=10.1+TR8_clearance;
TR8_flange_dia=21.9+TR8_clearance;
TR8_flange_thickness=4;
TR8_mounting_holes_offset=16;
TR8_offset=(TR8_flange_dia+2)/2;
TR8_Height=20;
//-------------------------------
MTSSR8d = 15.5;	// outside diameter of Misumi MTSSR8
MTSSR8l = 21.5;	// length of MTSSR8
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

ZCarriage(1,0); // 1st arg: TR8=0, MTSS=1; arg2: One=0-Left, 1-Right, 2-Left & Right
//ZCarriageMGNOn2020(1,2); // 1st arg: TR8=0, MTSS=1; arg2: One=0-Left, 1-Right, 2-Left & Right
translate([0,60,0]) MotorMount(1); // arg is quanity, defaulte is 2
translate([0,-55,0]) XIdler();
//translate([-65,-25,0]) CornerBraces(4); // arg is Quanity, default is 4
//translate([-130,-25,0]) CornerBraces(4); // arg is Quanity, default is 4
//BedMount(2); // default is 2
//XCarriageForMGN();

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ZCarriage(MTSS=0,Two=0) {  // Add the leadscrew mount
	if(Two==0) {
		mgnbase(0,0,0,1);
		if(MTSS)
			translate([5,-TR8_offset-2,TR8_Height+1]) rotate([0,90,0]) ZNutMTSS8();
		else	
			translate([5,-TR8_offset-2,TR8_Height+1]) rotate([0,90,0]) ZNutTR8();
		translate([0,-5,0]) color("pink") cube([MGN12HLength,5,Thickness]);
	} else if(Two==1) {
		translate([100,0,0]) mirror([1,0,0]) ZCarriage(MTSS,0);
	} else if(Two==2) {
		mgnbase(0,0,0,1);
		if(MTSS)
			translate([5,-TR8_offset-2,TR8_Height+1]) rotate([0,90,0]) ZNutMTSS8();
		else	
			translate([5,-TR8_offset-2,TR8_Height+1]) rotate([0,90,0]) ZNutTR8();
		translate([0,-5,0]) color("pink") cube([MGN12HLength,5,Thickness]);
		if(Two) translate([100,0,0]) mirror([1,0,0]) ZCarriage(MTSS,0);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ZCarriageMGNOn2020(MTSS=0,Two=0) {  // Add the leadscrew mount
	if(Two==0) {
		difference() {
			mgnbase(10,-3,0,0,9);
			translate([10,13,0]) MountingHoles2020();
		}
		if(MTSS)
			translate([5,-TR8_offset-2,TR8_Height+1]) rotate([0,90,0]) ZNutMTSS8();
		else	
			translate([5,-TR8_offset-2,TR8_Height+1]) rotate([0,90,0]) ZNutTR8();
		translate([0,-5,0]) color("pink") cube([MGN12HLength,5,Thickness]);
	} else if(Two==1) {
		translate([100,0,0]) mirror([1,0,0]) ZCarriageMGNOn2020(MTSS,0);
	} else if(Two==2) {
		difference() {
			mgnbase(10,-3,0,0,9);
			translate([10,13,0]) MountingHoles2020();
		}
		if(MTSS)
			translate([5,-TR8_offset-2,TR8_Height+1]) rotate([0,90,0]) ZNutMTSS8();
		else	
			translate([5,-TR8_offset-2,TR8_Height+1]) rotate([0,90,0]) ZNutTR8();
		translate([0,-5,0]) color("pink") cube([MGN12HLength,5,Thickness]);
		if(Two) translate([100,0,0]) mirror([1,0,0]) ZCarriageMGNOn2020(MTSS,0);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ZNutTR8() {
	difference() {
		ZNutFrame();
		translate([0,0,TR8_flange_thickness]) TR8_nut();
		translate([0,0,GetHoleLen3mm(Yes3mmInsert())]) TR8_mounting_holes();
		translate([TR8_flange_dia-1.5,-TR8_flange_dia/2-2,-1]) color("gray") cube([TR8_flange_dia+5,TR8_flange_dia+5,TR8_ht+5]);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ZNutFrame() {
	union() {
		color("red") cylinder(h=TR8_ht,d=TR8_flange_dia+2);
		translate([0,-(TR8_flange_dia+2)/2,0]) color("blue") cube([TR8_flange_dia+2,TR8_flange_dia+2,TR8_ht]);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ZNutMTSS8() {
	difference() {
		ZNutFrame();
		translate([0,0,-2]) color("cyan") cylinder(h=MTSSR8l+2,d=MTSSR8d);
		translate([0,0,-2]) color("purple") cylinder(h=TR8_ht+5,d=9);
		//translate([0,0,GetHoleLen3mm(Yes3mmInsert())]) TR8_mounting_holes();
		translate([TR8_flange_dia-1.5,-TR8_flange_dia/2-2,-1]) color("gray") cube([TR8_flange_dia+5,TR8_flange_dia+5,TR8_ht+5]);
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
		color("cyan") cube([MGN12HLength,MGN12HWidth+MountWidth+AddLength,Thickness]);
		mgnscrewholes();
		mgnscountersink();
		translate([X,Y,Z]) MountingHoles2020(Two2020);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module mgnscrewholes(Screw=screw3,Len=Thickness*2) {
	translate([MGN12HLength/4+1,3.5,-2]) {
		color("red") cylinder(h=Len,d=Screw,$fn=100);
		translate([20,0,0]) color("black") cylinder(h=Len,d=Screw,$fn=100);
		translate([0,20,0]) color("blue") cylinder(h=Len,d=Screw,$fn=100);
		translate([20,20,0]) color("gray") cylinder(h=Len,d=Screw,$fn=100);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module mgnscountersink(Screw=screw3hd,Len=Thickness) {
	translate([MGN12HLength/4+1,3.5,Thickness-3]) {
		color("black") cylinder(h=Len,d=Screw,$fn=100);
		translate([20,0,0]) color("blue") cylinder(h=Len,d=Screw,$fn=100);
		translate([0,20,0]) color("gray") cylinder(h=Len,d=Screw,$fn=100);
		translate([20,20,0]) color("red") cylinder(h=Len,d=Screw,$fn=100);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module MountingHoles2020(Two=0) {
	translate([MGN12HLength/4+1,MGN12HWidth+MountWidth/2,0]) {
		translate([0,0,-2]) color("yellow") cylinder(h=Thickness*2,d=screw5,$fn=100);
		if(Two)	translate([20,0,-2]) color("yellow") cylinder(h=Thickness*2,d=screw5,$fn=100);
	}
	translate([MGN12HLength/4+1,MGN12HWidth+MountWidth/2,0]) {
		translate([0,0,Thickness-2]) color("yellow") cylinder(h=Thickness*2,d=screw5hd,$fn=100);
		if(Two)	translate([20,0,Thickness-2]) color("yellow") cylinder(h=Thickness*2,d=screw5hd,$fn=100);
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
	translate([0,TR8_mounting_holes_offset/2,-2]) color("blue") cylinder(h=GetHoleLen3mm(Yes3mmInsert()),d=Yes3mmInsert(),$fn=100);
	translate([0,-TR8_mounting_holes_offset/2,-2]) color("cyan") cylinder(h=GetHoleLen3mm(Yes3mmInsert()),d=Yes3mmInsert(),$fn=100);
	translate([TR8_mounting_holes_offset/2,0,-2]) color("gray") cylinder(h=GetHoleLen3mm(Yes3mmInsert()),d=Yes3mmInsert(),$fn=100);
	translate([-TR8_mounting_holes_offset/2,0,-2]) color("black") cylinder(h=GetHoleLen3mm(Yes3mmInsert()),d=Yes3mmInsert(),$fn=100);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////

module MotorMount(Qty=2) {
	for(x = [0 : Qty-1]) {
		translate([x*60,0,0]) {
			difference() {
				color("red") cubeX([55,50,4],2);
				translate([28,25,-1]) color("blue") NEMA17_parallel_holes(6,10);
			}
			difference() {
				translate([0,0,0]) color("yellow") cubeX([4,50,45],2);
				translate([-2,25+MotorOffset,10]) MSSideHoles();
			}
			SideSupports();
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////

module XIdler() {
	difference() {
		union() {
			translate([0,-4,0]) color("cyan") cubeX([50,28,Thickness],2);
			translate([-Thickness-2,-TR8_flange_dia/4+1,0]) color("blue")
				cubeX([Thickness+5,28,TR8_flange_dia+Thickness/2],2);
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
		translate([-0.5,0,40]) color("green") rotate([0,39,0]) cubeX([80,4,5],2);
		translate([53,-3,-2]) color("gray") cube([10,10,10]);
		translate([43,-4,-Thickness*2-1]) color("lightgray") cubeX([25,20,20],2);
	}
	translate([0,46,0]) difference() {
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