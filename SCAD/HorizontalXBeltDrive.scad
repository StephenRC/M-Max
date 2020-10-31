///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// HorizontalXBeltDrive.scad - belt drive on top of the 2040
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Created: 9/23/2020
// Last Update: 9/23/20
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 5/23/20	- Added X axis motor mount and idler mount that go at the ends of the makerslide
// 5/23/20	- Added abilty to print more that one MotorMount and to print a left, right or both of the ZCarriage
//			  Added support bars to XIdler, ZCarrige can now use a TR8 or a Musumi MTSS8 nut
// 7/2/20	- Added a horzintal stepper motor mount and idler
// 7/9/20	- Added a belt clamp for the x-carriage
// 7/18/20	- Added an endstop holder for the X axis, copied from the X axis one for CXY-MSv1
// 8/1/20	- Added X endstop that mounts on the rail side of makerslide
// 9/16/20	- Added var for no mounting screw holes in BeltAttachment()
// 9/23/20	- Split from MGNMS2040XEndsEndstops.scad
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <mmax_h.scad>
include <inc/NEMA17.scad>
use <inc/cubeX.scad>
use <yBeltClamp.scad>
include <inc/brassinserts.scad>
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
$fn=100;
Use2mmInsert=1;
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

//XEndHorizontalBeltEnds();
//AxisBrace(4); // arg is Quanity
//AxisBrace(4,65,0); // arg is Quanity; args 2&3 are X,Y
//XEndStop(10,0,8,screw2,8,0); // black microswitch inline mount
//XEndStop(9.7,0,8,screw2,8,0); // green microswitch inline mount
//XEndStop(22,10,8,Yes3mmInsert(UseLarge3mmInsert),screw5,11.5); // CN0097
//YEndStop(9.7,0,8,Yes2mmInsert(Use2mmInsert),screw5,2.3,1); // green microswitch
//YEndStop(10,0,8,Yes2mmInsert(Use2mmInsert),screw5,2.3,1); // Black microswitch
//YEndStop(22,10,8,Yes3mmInsert(UseLarge3mmInsert),screw5,11.5); // CN0097
//BeltAttachment(1,0,1); //DoBelt=0,OnePiece=0,MountingScrewHoles=1
BeltAttachment(0,0,1); //DoBelt=0,OnePiece=0,MountingScrewHoles=1
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module YEndStop(Sep,DiagOffset,Offset,ScrewS,ScrewM=screw5,Adjust,MS=0) {
	if(ScrewS==screw2t) {
		difference() {
			union() {
				color("red") cubeX([22,33,5],2);
				color("purple") cubeX([5,20,17+Adjust],2);
			}
			YEndStopExtrusionMountingHole(Sep,DiagOffset,Offset,ScrewS,ScrewM,Adjust);
			if(MS) translate([-10,-2,0]) rotate([0,45,0]) color("black") cube([10,40,10]);
		}
	}
	if(ScrewS==Yes3mmInsert(UseLarge3mmInsert)) {
		difference() {
			union() {
				color("blue") cubeX([22,33,5],2);
				color("cyan") cubeX([5,33,18+Adjust],2);
			}
			YEndStopExtrusionMountingHole(Sep,DiagOffset,Offset,ScrewS,ScrewM,Adjust);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module YEndStopExtrusionMountingHole(Sep,DiagOffset,Offset,ScrewS,ScrewM,Adjust) {
	translate([12,8,-2]) color("white") cylinder(h=10,d=ScrewM);
	translate([0,-1,0]) EndStopScrewHoles(Sep,DiagOffset,Offset,ScrewS,Adjust);
	translate([12,23,-2]) color("cyan") cylinder(h=10,d=ScrewM);
	translate([0,-1,0]) EndStopScrewHoles(Sep,DiagOffset,Offset,ScrewS,Adjust);
	if(ScrewM==screw5) {
		translate([12,8,4]) color("cyan") cylinder(h=8,d=screw5hd);
		translate([12,23,4]) color("pink") cylinder(h=8,d=screw5hd);
	}
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module EndStopScrewHoles(Sep,DiagOffset,Offset,ScrewT,Adjust) {
	// screw holes for switch
	translate([0,0,Adjust]) {
		rotate([0,90,0]) {		
			translate([-(Switch_ht-Offset), SwitchShift, -2]) {
				color("purple") cylinder(h = 11, r = ScrewT/2, center = false, $fn=100);
			}
		}
		rotate([0,90,0]) {
			translate(v = [-(Switch_ht-Offset)+DiagOffset, SwitchShift+Sep, -2]) {
				color("black") cylinder(h = 11, r = ScrewT/2, center = false, $fn=100);
			}
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module XEndHorizontalBeltEnds() {
	translate([25,30,20]) rotate([-90,0,90]) MotorMountH();
	translate([-12,28,20]) rotate([90,180,0]) XIdlerH();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module XEndStop(EndStopType=0,Side=0) {
	if(EndStopType==0) translate([17,-62,0]) XEndStop(22,10,8,Yes3mmInsert(UseLarge3mmInsert),8,Side);
	else if(EndStopType==1) translate([17,-62,0]) XEndStop(10,0,8,screw2,8,Side); // black microswitch inline mount
	else if(EndStopType==2) translate([17,-62,0]) XEndStop(9.7,0,8,screw2,8,Side); // black microswitch inline mount
}

///////////////////////////////////////////////////////////////////////////////////////////////////

module XEndStop(Sep,DiagOffset,Offset,ScrewS,Adjust,Side) {
	base(Sep,DiagOffset,Offset,ScrewS,Adjust);
	mount(screw5,Side);
}

////////////////////////////////////////////////////////////////////////////////

module mount(Screw=screw5,Side=0) {
	difference() {
		union() {
			color("cyan") cubeX([22,HolderWidth,Switch_thk2],1);
			if(Side==0) translate([Screw/2-3,23,Switch_thk2-1]) color("red") cubeX([22,6,2],1); // slot align
			if(Side==1) translate([Screw/2-3,3,Switch_thk2-1]) color("blue") cubeX([22,6,2],1); // slot align
		}
		translate([10,6,-1])  color("red") cylinder(h=Switch_thk2*2,d=Screw);
		translate([10,26,-1])  color("green") cylinder(h=Switch_thk2*2,d=Screw);
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

//////////////////////////////////////////////////////////////////////////////////////////////////////

module BeltAttachment(DoBelt=0,OnePiece=0,MountingScrewHoles=1) { // must print on side with supports from bed only
	if(DoBelt) BeltMount(OnePiece);
	else CarriageMount(MountingScrewHoles);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////

module CarriageMount(MountingScrewHoles=1) {
	rotate([180,0,0]) {
		difference() {
			color("cyan") cubeX([55,49.3,20],2);
			translate([8,-2,-1]) color("plum") cubeX([40,53,11],1);
			if(MountingScrewHoles) {
				translate([14,3.5,5]) TopMountBeltHoles(screw3); // mounting screw
				translate([14,45.5,5]) TopMountBeltHoles(screw3); // mounting screw
				translate([14,3.5,14]) TopMountBeltHoles(screw3hd); // countersink
				translate([14,45.5,14]) TopMountBeltHoles(screw3hd); // countersink
			}
			translate([-35,26,14.5]) color("red") rotate([0,90,0]) cylinder(h=130,d=Yes5mmInsert(Use5mmInsert)); // belt mount screw
			color("red") hull() { // plastic reduction
				translate([26,24.75,-2]) cylinder(h=25,d=28);
				translate([30,24.75,-2]) cylinder(h=25,d=28);
			}
		}
		translate([8,1,13.7]) color("black") cube([40,9,LayerThickness]);
		translate([8,39,13.7]) color("white") cube([40,10,LayerThickness]);
	}
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
			translate([-22.25,17,20]) color("gray") cubeX([100.25,17,4],2); // one piece bletmount
		else {
			translate([-22.25,17,20]) color("gray") cubeX([35,17,4],2); // individual pieces
			translate([43,17,20]) color("plum") cubeX([35,17,4],2);
		}
		difference() {
			translate([-22.25,17,16]) color("green") cubeX([22,17,8],2);
			translate([-35,26,14.5]) color("red") rotate([0,90,0]) cylinder(h=130,d=screw5);
			BeltMountScrew();
		}
		difference() {
			translate([55,17,16]) color("khaki") cubeX([23,17,8],2);
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

module Loop1() {
	translate([0,0,35]) rotate([-90,0,0]) {
		difference() {
			translate([-19.25,15,0]) color("plum") cubeX([22,33,17],2);
			translate([-20,34,0]) beltLoop();
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

module XIdlerH(IdlerScrew=Yes5mmInsert(Use5mmInsert)) {
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

module AxisBrace(Qty=1,X=0,Y=0) {
	for(x = [0 : Qty-1]) {
		translate([X,x*65+Y,0]) difference() {
			color("blue") hull() {
				translate([40,0,0]) cubeX([20,60,5],2);
				translate([2,20,0]) cubeX([1,20,5],2);
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

//////////////////////////////////////////////////////////////////////////////////////////////////

module printchar(String,Height=1.5,Size=4,Font="Liberation Sans",Color="coral") { // print something
	color(Color) linear_extrude(height = Height) text(String, font = Font,size=Size);
}

///////////////////// end of mgn.scad ////////////////////////////////////////////////////////////////////////////