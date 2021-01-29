/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//	XWirechain.scad
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// created 1/7/2021
// last update 1/9/21
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 1/9/21	- Added vertical wirechain - length need adjusting when the wirechain for the vertical has arrived
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
include <inc/brassinserts.scad>
include <inc/cubex.scad>
$fn=100;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Use3mmInsert=1;
WirechainMountOffset=30;
Thickness=5;
WCEndOffset=11.5-3;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

XWirechain();  // both
//WCXCarriage();
//WCXEnd();
//WCXBottomZ();

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module WCXBottomZ() {
	difference() {
		union() {
			color("cyan") cubeX([21,20,Thickness],2);
			color("pink") cubeX([Thickness,20,65],2);
		}
		translate([11,10,-5]) color("red") cylinder(h=Thickness*3,d=screw5);
		translate([11,10,4]) color("blue") cylinder(h=Thickness,d=screw5hd);
		translate([-5,6,58]) rotate([90,0,90]) WCEndMount();
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module XWirechain() {
	WCXCarriage();
	translate([-20,0,Thickness]) rotate([-90,0,0]) WCXEnd();
	translate([0,20,0]) rotate([0,-90,-90]) WCXBottomZ();
}

/////////////////////////////////////////////////////////////////////////////////////////

module MakerslideNotch() {
	rotate([45,0,0]) color("black") cube([50,10,10]);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module WCXEnd() {
	difference() {
		union() {
			color("cyan") cubeX([15,Thickness,95],2);
			translate([-5,-45,90]) color("gray") cubeX([20,50,Thickness],2);
			translate([-5,-55,55]) color("lightgray") cubeX([20,60,Thickness],2);
			translate([-5,-55,75]) color("black") cubeX([20,60,Thickness],2);
			translate([-5,-45,75]) color("green") cubeX([20,Thickness,20],2);
			translate([-5,-55,55]) color("blue") cubeX([20,Thickness,25],2);
	
		}
		translate([7,10,10]) rotate([90,0,0]) color("white") cylinder(h=Thickness*3,d=screw5);
		translate([7,0.5,10]) rotate([90,0,0]) color("black") cylinder(h=Thickness,d=screw5hd);
		translate([0,9,33]) MakerslideNotch();
		translate([1,-35,88]) rotate([90,0,0]) WCEndMount();
		translate([5,-45,74]) rotate([90,90,0]) WCEndMount();
	}
	difference() {
		translate([1.5,3,40]) color("red") rotate([0,90,0]) cylinder(h=12,d=10);
		translate([0,2,33]) color("gray") cube([15,15,15]);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module WCXCarriage() {
	difference() {
		union() {
			color("cyan") cubeX([50,15,Thickness],2);
			translate([15,0,0]) color("gray") cubeX([20,Thickness,15],2);
		}
		translate([20.5,7,10]) rotate([90,0,0]) WCEndMount();
		translate([10,7,-5]) BracketMount();
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module WCEndMount(Screw=Yes3mmInsert(Use3mmInsert)) {
	color("plum") cylinder(h=Thickness*3,d=Screw);
	translate([WCEndOffset,0,0]) color("purple") cylinder(h=Thickness*3,d=Screw);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BracketMount() {
	color("red") cylinder(h=Thickness*3,d=screw5);
	translate([0,0,8]) color("blue") cylinder(h=Thickness,d=screw5hd);
	translate([30,0,0]) color("blue") cylinder(h=Thickness*3,d=screw5);
	translate([30,0,8]) color("red") cylinder(h=Thickness,d=screw5hd);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////