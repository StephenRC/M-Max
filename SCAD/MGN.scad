///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MGN.scad - use MGN rails for the Z axis
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Created: 5/21/2020
// Last Update: 5/31/20
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 5/23/20	- Added X axis motor mount and idler mount that go at the ends of the makerslide
// 5/23/20	- Added abilty to print more that one MotorMount and to print a left, right or both of the ZCarriage
//			  Added support bars to XIdler, ZCarrige can noew use a TR8 or a Musumi MTSS8 nut
// 5/31/20	- Added a mount for the 300x200 bed frame to MGN12
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//**************************************************
// NOT TESTED
//**************************************************
//==================================================================================
// 2020 with the MGN12 400mm long are to be conneted to the middle and upper 2020
//==================================================================================
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

//ZCarriage(1,0); // 1st arg: TR8=0, MTSS=1; arg2: One=0-Left, 1-Right, 2-Left & Right
//translate([0,60,0]) MotorMount(1); // arg is quanity, defaulte is 2
//translate([0,-55,0]) XIdler();
//translate([-50,-25,0]) 2020Brackets(1); // arg is Quanity, default is 8
BedMount(2); // default is 2

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ZCarriage(MTSS=0,Two=0) {  // Add the leadscrew mount
	if(Two==0) {
		mgnbase();
		if(MTSS)
			translate([5,-TR8_offset-2,TR8_Height+1]) rotate([0,90,0]) ZNutMTSS8();
		else	
			translate([5,-TR8_offset-2,TR8_Height+1]) rotate([0,90,0]) ZNutTR8();
		translate([0,-5,0]) color("pink") cube([MGN12HLength,5,Thickness]);
	} else if(Two==1) {
		translate([100,0,0]) mirror([1,0,0]) ZCarriage(MTSS,0);
	} else if(Two==2) {
		mgnbase();
		if(MTSS)
			translate([5,-TR8_offset-2,TR8_Height+1]) rotate([0,90,0]) ZNutMTSS8();
		else	
			translate([5,-TR8_offset-2,TR8_Height+1]) rotate([0,90,0]) ZNutTR8();
		translate([0,-5,0]) color("pink") cube([MGN12HLength,5,Thickness]);
		if(Two) translate([100,0,0]) mirror([1,0,0]) ZCarriage(MTSS,0);
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
		MTSSGrubScrewHole(YesInsert3mm(),-18,0,TR8_ht/2-2);
	}
	MTSSGrubScrew(YesInsert3mm(),-18,0,TR8_ht/2-2);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module MTSSGrubScrew(Screw=YesInsert3mm(),X=0,Y=0,Z=0) {
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

module MTSSGrubScrewHole(Screw=YesInsert3mm(),X=0,Y=9,Z=0) {
	translate([X-2,Y,Z]) rotate([0,90,0]) cylinder(h=20,d=Screw);
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module mgnbase() {
	difference() {
		color("cyan") cube([MGN12HLength,MGN12HWidth+MountWidth,Thickness]);
		mgnscrewholes();
		mgnscountersink();
		MountingHoles2020();
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

module MountingHoles2020() {
	translate([MGN12HLength/4+1,MGN12HWidth+MountWidth/2,0]) {
		translate([0,0,-2]) color("yellow") cylinder(h=Thickness*2,d=screw5,$fn=100);
		translate([20,0,-2]) color("yellow") cylinder(h=Thickness*2,d=screw5,$fn=100);
	}
	translate([MGN12HLength/4+1,MGN12HWidth+MountWidth/2,0]) {
		translate([0,0,Thickness-2]) color("yellow") cylinder(h=Thickness*2,d=screw5hd,$fn=100);
		translate([20,0,Thickness-2]) color("yellow") cylinder(h=Thickness*2,d=screw5hd,$fn=100);
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

module 2020Brackets(Qty=8) {
	for(x = [0 : Qty-1]) {
		translate([0,x*25,0]) difference() {
			color("blue") cubeX([40,20,5],1);
			translate([10,10,-3]) {
				color("black") cylinder(h=10,d=screw5);
				translate([20,0,0]) color("gray") cylinder(h=10,d=screw5);
				translate([0,0,6.5]) color("white") cylinder(h=5,d=screw5hd);
				translate([20,0,6.5]) color("lightgray") cylinder(h=5,d=screw5hd);
			}
		}
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

///////////////////// end of mgn.scad ////////////////////////////////////////////////////////////////////////////