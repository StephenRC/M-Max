///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// HorizontalXBeltDrive.scad - belt drive on top of the 2040
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Created: 9/23/2020
// Last Update: 4/10/22
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// https://creativecommons.org/licenses/by-sa/4.0/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 5/23/20	- Added X axis motor mount and idler mount that go at the ends of the makerslide
// 5/23/20	- Added abilty to print more that one MotorMount and to print a left, right or both of the ZCarriage
//			  Added support bars to XIdler, ZCarrige can now use a TR8 or a Musumi MTSS8 nut
// 7/2/20	- Added a horzintal stepper motor mount and idler
// 7/9/20	- Added a belt clamp for the x-carriage
// 7/18/20	- Added an endstop holder for the X axis, copied from the X axis one for CXY-MSv1
// 8/1/20	- Added X endstop that mounts on the rail side of makerslide
// 9/16/20	- Added var for no mounting screw holes in BeltAttachment()
// 9/23/20	- Split from MGNMS2040XEndsEndstops.scad
// 11/3/20	- Adjust the belt loops to fit better
// 2/15/21	- Added X belt ends for 2020 and EXOSlide belt mount
// 3/1/21	- Tweaked the MotorMountExo2020()
// 4/6/21	- Began BOSL2 conversion
// 5/20/21	- Added an adjustable idler mount
// 10/16/21	- Adjusted distance bearing can move for tension on TensionIdler()
// 4/10/22	- Tweaked rounding for ajustabl4e idler
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <mmax_h.scad>
use <yBeltClamp.scad>
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
$fn=100;
Use2mmInsert=1;
Use3mmInsert=1;
Use5mmInsert=1;
UseLarge3mmInsert=1; // got new inserts and the 3mm inserts are larger
//-------------------------------
//MGN12HHoleOffset=20;
//MGN12HLength=44;
//MGN12HWidth=26.8;
//Thickness=8;
//MountWidth=25;
//MotorOffset=9;
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
ExoSlideThickness=12.8;
Clearance=0.2;
IdlerBearingThickess=11.7+Clearance;
StepperBossDiameter=23;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//XEndHorizontalBeltEnds();		// makerslide
//BeltCarriageMount(1);			// arg 1: 0 no mounting holes; 1 mounting holes
BeltEndsExo2020(1);				// exoslide
translate([0,100,0])
	BeltMountEXOSlideScrew();	// with EXOSlide adapter
//translate([0,100,17])
//	BeltMountEXOSlide();		// with EXOSlide adapter
//XIdlerExo2020();  			// fixed in place idler
//MotorMountExo2020(1);			// motor mount
//TensionIdler();				// tensionable idler
//AxisBrace(4);					// arg is Quanity
//AxisBrace(4,65,0);			// arg is Quanity; args 2&3 are X,Y

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TensionIdler(IdlerScrew=Yes5mmInsert(Use5mmInsert),DoTab=1) {
	%translate([0,-2,-20]) cuboid([20,20,20],rounding=2,p1=[0,0]); // show 2020
	difference() {
		union() {
			translate([-5,-2,0]) color("blue") cuboid([29,22,StepperMountThickness],rounding=2,p1=[0,0]);
			translate([-5,StepperMountThickness-3.5,0]) color("darkgray") rotate([46,0,0])
				cuboid([StepperMountThickness,28,StepperMountThickness],rounding=2,p1=[0,0]);
			translate([20,StepperMountThickness-3.5,0]) color("white") rotate([46,0,0])
				cuboid([StepperMountThickness,28,StepperMountThickness],rounding=2,p1=[0,0]);
			translate([-38,24-(StepperMountThickness*2),0]) color("purple")
				cuboid([62,StepperMountThickness,30],rounding=2,p1=[0,0]);
			translate([20,-2,-19]) color("gray") cuboid([StepperMountThickness,22,23],rounding=2,p1=[0,0]);
			translate([-StepperMountThickness-1,-2,-19]) color("lightgray") 
				cuboid([StepperMountThickness,22,23],rounding=2,p1=[0,0]);
			translate([-3,StepperMountThickness-1,-18]) color("pink") rotate([90,-60,0])
				cuboid([StepperMountThickness,39,StepperMountThickness],rounding=2,p1=[0,0]);
			translate([-3,StepperMountThickness+16,-18]) color("white") rotate([90,-60,0])
				cuboid([StepperMountThickness,39,StepperMountThickness],rounding=2,p1=[0,0]);
			translate([-14.51,-1,0]) color("lightblue")
				cuboid([13+StepperMountThickness,IdlerBearingThickess+(StepperMountThickness*2),StepperMountThickness]
					,rounding=2,p1=[0,0]);
			translate([-37.5,-1.1,19]) color("blue")
				cuboid([24+StepperMountThickness,
					1.1+IdlerBearingThickess+(StepperMountThickness*2+0.1),StepperMountThickness+8]
					,rounding=3,p1=[0,0]);
			translate([-37.5,-13+IdlerBearingThickess,0]) color("plum")
				cuboid([28,StepperMountThickness,30],rounding=2,p1=[0,0]);
			translate([-14,-12+IdlerBearingThickess,0]) color("green")
				cuboid([StepperMountThickness,20,23],rounding=2,p1=[0,0]);
			translate([-36,19,1.5]) rotate([90,0,0]) color("red") cylinder(h=17,d=2);
		}
		translate([-25,StepperMountThickness+12,20]) rotate([90,0,0]) color("khaki") 
			cylinder(h=IdlerBearingThickess+1.2,d=IdlerBearingThickess+7); // fit idler
		translate([10,10.5,0]) rotate([0,-90,0]) 2040ScrewHolesExo(screw5,1);
		color("red") hull() {
			translate([-(ExoSlideThickness+4+F625ZZ_dia/2),25,F625ZZ_dia/2+10]) rotate([90,0,0])
				cylinder(h=30,d=screw5);
			translate([-(ExoSlideThickness+4+F625ZZ_dia/2),25,F625ZZ_dia/2-1]) rotate([90,0,0])
				cylinder(h=30,d=screw5);
		}
		translate([-10,10,-8]) rotate([0,90,0]) color("gray") cylinder(h=20,d=screw5);
		translate([22,10,-8]) rotate([0,90,0]) color("darkgray") cylinder(h=5,d=screw5hd);
		translate([12,10,-8]) rotate([0,90,0]) color("plum") cylinder(h=20,d=screw5);
		translate([-8,10,-8]) color("green") rotate([0,90,0]) cylinder(h=5,d=screw5hd);
	}
	translate([0,-1,0]) color("gray") hull() {
		translate([-(ExoSlideThickness+4+F625ZZ_dia/2),StepperMountThickness-0.1,F625ZZ_dia/2+10]) rotate([90,0,0])
			cylinder(h=LayerThickness*2,d=screw5hd);
		translate([-(ExoSlideThickness+4+F625ZZ_dia/2),StepperMountThickness-0.1,F625ZZ_dia/2+1]) rotate([90,0,0])
			cylinder(h=LayerThickness*2,d=screw5hd);
	}
	translate([80,20,-30]) rotate([90,0,0]) AdjustingBracket(DoTab);
	if(DoTab) {
		translate([23,20,-19]) color("green") rotate([90,0,0]) cylinder(h=LayerThickness,d=15); // tab
		translate([-3,20,-19]) color("plum") rotate([90,0,0]) cylinder(h=LayerThickness,d=15); // tab
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module AdjustingBracket(DoTab) {
	%translate([-100,StepperMountThickness+35,10.5]) rotate([0,0,0])
		cyl(h=IdlerBearingThickess+1,d=IdlerBearingThickess); // show idler
	difference() {
		union() {
			translate([-47,IdlerBearingThickess-2,0]) color("cyan")
				cuboid([StepperMountThickness+2,23+StepperMountThickness*2,22],rounding=2.3,p1=[0,0]);
			translate([-47,IdlerBearingThickess-3.1,0]) color("blue")
			cuboid([27+StepperMountThickness*2+2,StepperMountThickness+2,22],rounding=3,p1=[0,0]);
			translate([-47,24.4+IdlerBearingThickess,0]) color("gray")
				cuboid([27+StepperMountThickness*2+2,StepperMountThickness+2,22],rounding=3,p1=[0,0]);
		}
		translate([-52,26,12]) color("blue") rotate([0,90,0]) cylinder(h=15,d=Yes5mmInsert(Use5mmInsert));
		translate([-19,19,12]) color("white") rotate([90,0,0]) cylinder(h=15,d=screw5);
		translate([-19,11,12]) color("cyan") rotate([90,0,0]) cylinder(h=5,d=screw5hd);
		translate([-19,46,12]) color("green") rotate([90,0,0]) cylinder(h=15,d=Yes5mmInsert(Use5mmInsert));
	}
	if(DoTab) {
		translate([-14,11,0]) color("darkgray") rotate([0,0,0]) cylinder(h=LayerThickness,d=15); // tab
		translate([-14,39,0]) color("white") rotate([0,0,0]) cylinder(h=LayerThickness,d=15); // tab
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BeltEndsExo2020(Tensioner=0,Screw=Yes5mmInsert(Use5mmInsert)) {
	translate([61,30,20]) rotate([-90,0,90])
		MotorMountExo2020(1);
	translate([26,-30,20]) rotate([90,180,0])
		if(Tensioner) TensionIdler();
		else XIdlerExo2020(Screw,0);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BeltMountEXOSlide() {
	rotate([-90,0,0]) difference() {
		BeltMountEXO();
		translate([9,8.5,-10]) EXOSlideMountHoles(screw4,1);
		translate([23,-5,-2]) color("green") cuboid([31,30,10],rounding=2,p1=[0,0]);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BeltMountEXOSlideScrew(Screw=Yes5mmInsert(Use5mmInsert)) {
	difference() {
		BeltMountEXOScrew(Screw);
		translate([9,8.5,-10]) EXOSlideMountHoles(screw4,1);
		translate([23,-5,-2]) color("green") cuboid([31,30,10],rounding=2,p1=[0,0]);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module EXOSlideMountHoles(Screw=screw4,AdjustableInner=0) {
	if(AdjustableInner) {
		translate([0,-1,0]) color("blue") hull() {
			translate([20,-3,0]) cylinder(h=50,d=Screw);
			translate([20,4,0]) cylinder(h=50,d=Screw);
		}
		translate([0,-1,0]) color("lightgray") hull() {
			translate([40,-3,0]) color("lightgray") cylinder(h=50,d=Screw);
			translate([40,4,0]) color("lightgray") cylinder(h=50,d=Screw);
		}
	} else {
		color("red") cylinder(h=50,d=Screw);
		translate([20,0,0]) cylinder(h=50,d=Screw);
		translate([40,0,0]) color("lightgray") cylinder(h=50,d=Screw);
		translate([60,0,0]) color("darkgray") cylinder(h=50,d=Screw);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////

module BeltMountEXO() { // may need to rotate outlet down
	Loop1EXO();
	Loop2EXO();
	difference() {
		translate([18,0,0])  color("gray") cuboid([43,17,17],rounding=2,p1=[0,0]);
		beltLoopsEXO();
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////

module BeltMountEXOScrew(Screw=Yes5mmInsert(Use5mmInsert)) {
	difference() {
		color("plum") cuboid([22,17,11],rounding=2,p1=[0,0]);
		translate([7,7,8]) color("red") cyl(h=30,d=Screw);
	}
	difference() {
		translate([57,0,0]) color("white") cuboid([23,17,11],rounding=2,p1=[0,0]);
		translate([74,7,8]) color("blue") cyl(h=30,d=Screw);
	}
	difference() {
		translate([18,0,0])  color("gray") cuboid([43,17,17],rounding=2,p1=[0,0]);
		beltLoopsEXO();
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Loop1EXO() { // motor side
	difference() {
		color("plum") cuboid([22,17,17],rounding=2,p1=[0,0]);
		translate([-0.5,-1,13]) {
			translate([0,0,0]) rotate([-90,0,0]) beltLoop();
			translate([0,2,0]) rotate([-90,0,0]) color("blue") beltLoop();
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module beltLoopsEXO() {
	translate([-0.5,-1,13]) {
		translate([0,0,0]) rotate([-90,0,0]) beltLoop();
		translate([0,2,0]) rotate([-90,0,0]) color("blue") beltLoop();
	}
	translate([81,-1,13]) rotate([-90,0,180]) {
		translate([0,0,-11]) beltLoop(); // external module
		translate([0,0,-14]) color("blue") beltLoop();
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////

module Loop2EXO() { // idler side
	difference() {
		translate([57,0,0]) color("white") cuboid([23,17,17],rounding=2,p1=[0,0]);
		translate([81,-1,13]) rotate([-90,0,180]) {
			translate([0,0,-11]) beltLoop(); // external module
			translate([0,0,-14]) color("blue") beltLoop();
		}
	}
}

//////////////////////////////////////////////////////////////////////////

module MotorMountExo2020(DoTab=1) {
	translate([0,20-StepperMountThickness,-3]) difference() {
		union() {
			translate([0,0,-12]) color("red") cuboid([65,StepperMountThickness,74],rounding=2,p1=[0,0]);
			translate([0,-21,-12]) color("blue") cuboid([StepperMountThickness,25,74],rounding=2,p1=[0,0]);
			%translate([-20,-21,38]) cuboid([20,20,20],rounding=2,p1=[0,0]); // show 2020
			translate([-20,-21,58]) color("cyan") cuboid([24,25,StepperMountThickness],rounding=2,p1=[0,0]);
			translate([-20,-21,33.5]) color("plum") cuboid([24,25,StepperMountThickness],rounding=2,p1=[0,0]);
		}
		translate([35,6,12]) color("blue") rotate([90,0,0]) NEMA17_parallel_holes(8,8,StepperBossDiameter);
		translate([0,-7,32+StepperShaftOffset]) 2040ScrewHolesExo(screw5,1);
		translate([-3,-16,StepperMountThickness-2]) color("gray") cuboid([12,13,26],rounding=2,p1=[0,0]);
		translate([-10,-7,30]) color("red") cylinder(h=40,d=screw5);
		translate([-10,-7,61]) color("blue") cylinder(h=5,d=screw5hd);
		translate([-10,-7,30]) color("lightblue") cylinder(h=5,d=screw5hd);
		translate([22,5,45]) color("purple") hull() {
			rotate([90,0,0]) cylinder(h=10,d=20);
			translate([20,5,0]) rotate([90,0,0]) cylinder(h=10,d=20);
		}
	}
	translate([1,-5.5,-15]) color("green") rotate([0,0,24]) 
		cuboid([54.5,StepperMountThickness,StepperMountThickness],rounding=2,p1=[0,0]);
	translate([1,-5.5,55]) color("lightgray") rotate([0,0,24])
		cuboid([54.5,StepperMountThickness,StepperMountThickness],rounding=2,p1=[0,0]);
	translate([0,16,-15]) color("red") rotate([0,-22,0])
		cuboid([StepperMountThickness,StepperMountThickness,52],rounding=2,p1=[0,0]);
	translate([0,-5,-15]) color("darkgray") rotate([0,-22,0])
		cuboid([StepperMountThickness,StepperMountThickness,52],rounding=2,p1=[0,0]);
	if(DoTab) {
		translate([-20,20,58]) color("green") rotate([90,0,0]) cylinder(h=LayerThickness,d=20); // tab
		translate([-20,20,32]) color("plum") rotate([90,0,0]) cylinder(h=LayerThickness,d=20); // tab
		//translate([21,20,-4]) color("white") rotate([90,0,0]) cylinder(h=LayerThickness,d=8); // tab
		//translate([49,20,22]) color("blue") rotate([90,0,0]) cylinder(h=LayerThickness,d=8); // tab
		//translate([21,20,22]) color("cyan") rotate([90,0,0]) cylinder(h=LayerThickness,d=8); // tab
		//translate([49,20,-4]) color("purple") rotate([90,0,0]) cylinder(h=LayerThickness,d=8); // tab
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////

module XIdlerExo2020(IdlerScrew=Yes5mmInsert(Use5mmInsert),DoTab=1) {
	difference() {
		union() {
			translate([-3,-2,0]) color("blue") cuboid([27,22,StepperMountThickness],rounding=2,p1=[0,0]);
			translate([-5,StepperMountThickness-3.5,0]) color("darkgray") rotate([46,0,0])
				cuboid([StepperMountThickness,28,StepperMountThickness],rounding=2,p1=[0,0]);
			translate([20,StepperMountThickness-3.5,0]) color("white") rotate([46,0,0])
				cuboid([StepperMountThickness,28,StepperMountThickness],rounding=2,p1=[0,0]);
			translate([-35,20-StepperMountThickness,0]) color("plum")
				cuboid([59,StepperMountThickness,23],rounding=2,p1=[0,0]);
			translate([20,-2,-19]) color("gray") cuboid([StepperMountThickness,22,23],rounding=2,p1=[0,0]);
			translate([-StepperMountThickness-1,-2,-19]) color("lightgray") 
				cuboid([StepperMountThickness,22,23],rounding=2,p1=[0,0]);
			translate([-2,StepperMountThickness+16,-18]) color("purple") rotate([90,-60,0])
				cuboid([StepperMountThickness,37,StepperMountThickness],rounding=2,p1=[0,0]);
		}
		translate([10,10.5,0]) rotate([0,-90,0]) 2040ScrewHolesExo(screw5,1);
		translate([-(ExoSlideThickness+4+F625ZZ_dia/2),25,F625ZZ_dia/2+4]) rotate([90,0,0]) color("red")
		cylinder(h=20,d=IdlerScrew);
		translate([-10,10,-8]) rotate([0,90,0]) color("gray") cylinder(h=20,d=screw5);
		translate([22,10,-8]) rotate([0,90,0]) color("darkgray") cylinder(h=5,d=screw5hd);
		translate([12,10,-8]) rotate([0,90,0]) color("plum") cylinder(h=20,d=screw5);
		translate([-8,10,-8]) color("green") rotate([0,90,0]) cylinder(h=5,d=screw5hd);
	}
	if(DoTab) {
		translate([23,20,-20]) color("green") rotate([90,0,0]) cylinder(h=LayerThickness,d=25); // tab
		translate([-3,20,-20]) color("plum") rotate([90,0,0]) cylinder(h=LayerThickness,d=25); // tab
	
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////

module 2040ScrewHolesExo(Screw=screw5,JustOne=0) {
	translate([-5,0,0]) color("cyan") rotate([0,90,0]) cylinder(h=15,d=Screw);
	if(!JustOne) translate([-5,0,20]) color("plum") rotate([0,90,0]) cylinder(h=15,d=Screw);
	if(Screw==screw5) {
		translate([3,0,0]) color("plum") rotate([0,90,0]) cylinder(h=15,d=screw5hd);
		if(!JustOne) translate([3,0,20]) color("cyan") rotate([0,90,0]) cylinder(h=5,d=screw5hd);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module XEndHorizontalBeltEnds() {
	translate([25,30,20]) rotate([-90,0,90]) MotorMountH();
	translate([-12,8,20]) rotate([90,180,0]) XIdlerH();
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BeltCarriageMount(MountingScrewHoles=1) {
	difference() {
		color("cyan") cuboid([55,49.3,20],rounding=2);
		translate([0,0,8]) color("plum") cuboid([40,53,15],rounding=1);
		translate([-27.5,-24.5,-20]) {
			if(MountingScrewHoles) {
				translate([14,3.5,5]) TopMountBeltHoles(screw3); // mounting screw
				translate([14,45.5,5]) TopMountBeltHoles(screw3); // mounting screw
				translate([14,3.5,-6]) TopMountBeltHoles(screw3hd); // countersink
				translate([14,45.5,-6]) TopMountBeltHoles(screw3hd); // countersink
			}
			translate([-35,26,15.5]) color("red") rotate([0,90,0])
				cylinder(h=130,d=Yes5mmInsert(Use5mmInsert)); // belt mount screw
			color("red") hull() { // plastic reduction
				translate([26,24.75,-2]) cylinder(h=25,d=28);
				translate([30,24.75,-2]) cylinder(h=25,d=28);
			}
		}
	}
	translate([-20,15,-5.95]) color("darkgray") cube([40,9,LayerThickness]);
	translate([-20,-24,-5.95]) color("white") cube([40,10,LayerThickness]);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////

module BeltMount(OnePiece=0) {
	translate([0,20,14]) rotate([-90,0,0]) {
		difference() {
			translate([0,17,0]) {
				translate([-3,0,0]) Loop1(); // motor side
				translate([3,0,0]) Loop2();  // idler side
			}
			BeltMountScrew();
		}
		translate([-20,19,6]) rotate([90,0,0]) printchar("Motor",3,5);
		translate([60,19,12]) rotate([90,0,0]) printchar("Idler",3,5);
		if(OnePiece)
			translate([-22.25,17,20]) color("gray") cuboid([100.25,17,4],rounding=2,p1=[0,0]); // one piece bletmount
		else {
			translate([-22.25,17,20]) color("gray") cuboid([35,17,4],rounding=2,p1=[0,0]); // individual pieces
			translate([43,17,20]) color("plum") cuboid([35,17,4],rounding=2,p1=[0,0]);
			translate([10,34,22]) color("darkgray") rotate([90,0,0]) cylinder(h=LayerThickness,d=20); // tab
			translate([45,34,22]) color("white") rotate([90,0,0]) cylinder(h=LayerThickness,d=20); // tab
		}
		difference() {
			translate([-22.25,17,16]) color("green") cuboid([22,17,8],rounding=2,p1=[0,0]);
			translate([-35,26,14.5]) color("red") rotate([0,90,0]) cylinder(h=130,d=screw5);
			BeltMountScrew();
		}
		difference() {
			translate([55,17,16]) color("khaki") cuboid([23,17,8],rounding=2,p1=[0,0]);
			translate([-35,26,14.5]) color("red") rotate([0,90,0]) cylinder(h=130,d=screw5);
			BeltMountScrew();
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BeltMountScrew() {
	translate([-35,26,14.5]) color("red") rotate([0,90,0]) cylinder(h=130,d=screw5);
	translate([-26,26,14.5]) color("blue") rotate([0,90,0]) cylinder(h=5,d=screw5hd);
	translate([77,26,14.5]) color("gray") rotate([0,90,0]) cylinder(h=5,d=screw5hd);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Loop1() { // motor side
	translate([0,0,35]) rotate([-90,0,0]) {
		difference() {
			translate([-19.25,15,0]) color("plum") cuboid([22,33,17],rounding=2,p1=[0,0]);
			translate([-20,35.5,0]) {
				translate([0,0,-1]) beltLoop();
				translate([0,0,2]) color("blue") beltLoop();
			}
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////

module Loop2() { // idler side
	translate([0,0,35]) rotate([90,0,0]) {
		difference() {
			translate([52,-44,-17]) color("white") cuboid([23,33,17],rounding=2,p1=[0,0]);
			translate([75,-31.5,0]) {
				translate([0,0,-11]) rotate([0,0,180]) beltLoop();
				translate([0,0,-14]) rotate([0,0,180]) color("blue") beltLoop();
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
		union() {
			color("red") cuboid([65,StepperMountThickness,60],rounding=2,p1=[0,0]);
			translate([0,-18,0]) color("blue") cuboid([StepperMountThickness,22,77],rounding=2,p1=[0,0]);
		}
		translate([32,6,28]) color("blue") rotate([90,0,0]) NEMA17_parallel_holes(8,15);
		translate([0,-7,32+StepperShaftOffset]) 2040ScrewHoles(screw5);
		translate([-3,-14,StepperMountThickness+8]) color("gray") cuboid([12,13,26],rounding=2,p1=[0,0]);
	}
	translate([1,-2,-3]) color("green") rotate([0,0,20]) 
		cuboid([54.5,StepperMountThickness,StepperMountThickness],rounding=2,p1=[0,0]);
	translate([1,-2,53]) color("pink") rotate([0,0,20])
		cuboid([54.5,StepperMountThickness,StepperMountThickness],rounding=2,p1=[0,0]);
	translate([0,16,70]) color("darkgray") rotate([0,20,0])
		cuboid([54.5,StepperMountThickness,StepperMountThickness],rounding=2,p1=[0,0]);
	translate([1,20,72]) color("green") rotate([90,0,0]) cylinder(h=LayerThickness,d=25); // tab
}

///////////////////////////////////////////////////////////////////////////////////////////////////////

module 2040ScrewHoles(Screw=screw5,JustOne=0) {
	translate([-5,0,0]) color("cyan") rotate([0,90,0]) cylinder(h=15,d=Screw);
	if(!JustOne) translate([-5,0,20]) color("plum") rotate([0,90,0]) cylinder(h=15,d=Screw);
	if(Screw==screw5) {
		translate([3,0,0]) color("plum") rotate([0,90,0]) cylinder(h=5,d=screw5hd);
		if(!JustOne) translate([3,0,20]) color("cyan") rotate([0,90,0]) cylinder(h=5,d=screw5hd);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////

module XIdlerH(IdlerScrew=Yes5mmInsert(Use5mmInsert)) {
	difference() {
		union() {
			union() {
				translate([1,-2,0]) color("cyan") cuboid([47,22,StepperMountThickness],rounding=2,p1=[0,0]);
				translate([5,20-StepperMountThickness,18.5]) color("green") rotate([0,25,0])
					cuboid([45,StepperMountThickness,StepperMountThickness],rounding=2,p1=[0,0]);
				translate([1,StepperMountThickness-3.5,0]) color("darkgray") rotate([46,0,0])
					cuboid([StepperMountThickness,26,StepperMountThickness],rounding=2,p1=[0,0]);
				translate([45,20,2]) color("red") rotate([90,0,0]) cylinder(h=LayerThickness,d=25); // tab
				translate([-24,20-StepperMountThickness,0]) color("plum")
					cuboid([35,StepperMountThickness,23],rounding=2,p1=[0,0]);
			}
		}
		translate([30,10.5,0]) rotate([0,-90,0]) 2040ScrewHoles(screw5);
		translate([-14,25,F625ZZ_dia/2+5]) rotate([90,0,0]) color("red") cylinder(h=20,d=IdlerScrew);
	}
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
				translate([2,20,0]) cuboid([5,20,5],rounding=2,p1=[0,0]);
			}
			translate([10,30,-3]) 2020ScrewHoles(1);
			translate([50,10,-3]) 2020ScrewHoles();
			translate([50,30,-3]) rotate([0,0,90]) 2020ScrewHoles(1);
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////

module 2020ScrewHoles(Two=0) {
	color("darkgray") cylinder(h=10,d=screw5);
	translate([0,0,6.5]) color("white") cylinder(h=5,d=screw5hd);
	if(Two) {
		translate([0,0,6.5]) color("white") cylinder(h=5,d=screw5hd);
		translate([20,0,0]) color("gray") cylinder(h=10,d=screw5);
		translate([20,0,6.5]) color("lightgray") cylinder(h=5,d=screw5hd);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////

module printchar(String,Height=1.5,Size=4,Font="Liberation Sans",Color="coral") { // print something
	color(Color) linear_extrude(height = Height) text(String, font = Font,size=Size);
}

/////////////////////////////////////////////////////////////////////////////////////////////////