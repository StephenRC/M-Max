/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//	XWirechain.scad
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// created 1/7/2021
// last update 3/2/21
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 1/9/21	- Added vertical wirechain - length need adjusting when the wirechain for the vertical has arrived
// 2/11/21	- Added supoorts for the wirechain
// 2/15/21	- Added carriage wirechain mount for EXOSlide
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
include <inc/brassinserts.scad>
include <bosl2/std.scad>
$fn=100;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Use3mmInsert=1;
WirechainMountOffset=30;
Thickness=5;
WCEndOffset=11.5-3;
LayerThickness=0.3;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//XWirechain();  // both
//WCXCarriage();
//WCXEnd();
//WCXBottomZ();
//WCXCarriageEXOSlide();
//WCXEnd2020();
WCEXOSlide();

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module cubeX(size,Rounding) { // temp module
	cuboid(size,rounding=Rounding,p1=[0,0]);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module WCEXOSlide() {
	rotate([0,90,0])
		WCXEndEXO();
	translate([-25,10,10]) rotate([0,90,0])
		WCXCarriageEXOSlide();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module WCXCarriageEXOSlide(DoTab=1) {
	difference() {
		union() {
			translate([0,0,0]) color("cyan") cubeX([30,15,Thickness],2);
			translate([0,10,0]) color("blue") cubeX([30,Thickness,70],2);
			translate([0,10,65]) color("red") cubeX([30,85,Thickness],2);
			translate([0,90,45]) color("gray") cubeX([30,Thickness,25],2);
			translate([0,80,45]) color("white") cubeX([30,15,Thickness],2);
		}
		translate([11,20,58]) rotate([90,0,0]) WCEndMount();
		translate([4.5,7,-10]) EXOSlideMountHoles(screw4);
		//translate([0,62,63]) color("plum") hull() { // my need a hole for the bowden supply tube
		//	translate([8,0,0]) cylinder(h=10,d=6);
		//	translate([22,0,0]) cylinder(h=10,d=6);
		//}
	}
	//%translate([18,95,70]) rotate([90,0,0]) cylinder(h=36,d=6); // show the needed bowden hole postion
	if(DoTab) {
		translate([10,0,2]) EndSupport();
		translate([10,78,47]) EndSupport();
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module WCXEndEXO(DoTab=1) { // height may need changing
	difference() {
		union() {
			translate([0,0,-5]) color("cyan") cubeX([20,Thickness,100],2);
			translate([0,-45,90]) color("gray") cubeX([20,50,Thickness],2);
			translate([0,-55,55]) color("lightgray") cubeX([20,60,Thickness],2);
			translate([0,-55,75]) color("black") cubeX([20,60,Thickness],2);
			translate([-40,-45,75]) color("green") cubeX([60,Thickness,20],2);
			translate([0,-55,55]) color("blue") cubeX([20,Thickness,25],2);
	
		}
		translate([10,10,5]) rotate([90,0,0]) color("white") cylinder(h=Thickness*3,d=screw5);
		translate([10,0.5,5]) rotate([90,0,0]) color("black") cylinder(h=Thickness,d=screw5hd);
		translate([6,-35,88]) rotate([90,0,0]) WCEndMount();
		translate([10,-45,74]) rotate([90,90,0]) WCEndMount();
	}
	if(DoTab) translate([0,0,-3]) EndSupport();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module EXOSlideMountHoles(Screw=screw4) {
	color("red") cylinder(h=50,d=Screw);
	translate([20,0,0]) color("blue") cylinder(h=50,d=Screw);
	translate([40,0,0]) color("lightgray") cylinder(h=50,d=Screw);
	translate([60,0,0]) color("black") cylinder(h=50,d=Screw);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module WCXBottomZ() {
	difference() {
		union() {
			color("cyan") cubeX([21,20,Thickness],2);
			color("pink") cubeX([Thickness,20,65],2);
			translate([0,-40,45]) color("red") cubeX([Thickness,50,20],2);
		}
		translate([11,10,-5]) color("red") cylinder(h=Thickness*3,d=screw5);
		translate([11,10,4]) color("blue") cylinder(h=Thickness,d=screw5hd);
		translate([-5,6,58]) rotate([90,0,90]) WCEndMount();
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module XWirechain(DoTab=1) {
	WCXCarriage();
	translate([-5,105,0]) rotate([90,90,0]) WCXEnd(DoTab);
	translate([45,45,0]) rotate([0,-90,-90]) WCXBottomZ();
}

/////////////////////////////////////////////////////////////////////////////////////////

module MakerslideNotch() {
	rotate([45,0,0]) color("black") cube([50,10,10]);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module WCXEnd(DoTab=1) {
	difference() {
		union() {
			color("cyan") cubeX([20,Thickness,95],2);
			translate([0,-45,90]) color("gray") cubeX([20,50,Thickness],2);
			translate([0,-55,55]) color("lightgray") cubeX([20,60,Thickness],2);
			translate([0,-55,75]) color("black") cubeX([20,60,Thickness],2);
			translate([-40,-45,75]) color("green") cubeX([60,Thickness,20],2);
			translate([0,-55,55]) color("blue") cubeX([20,Thickness,25],2);
	
		}
		translate([10,10,10]) rotate([90,0,0]) color("white") cylinder(h=Thickness*3,d=screw5);
		translate([10,0.5,10]) rotate([90,0,0]) color("black") cylinder(h=Thickness,d=screw5hd);
		translate([-5,9,33]) MakerslideNotch();
		translate([6,-35,88]) rotate([90,0,0]) WCEndMount();
		translate([10,-45,74]) rotate([90,90,0]) WCEndMount();
	}
	difference() {
		translate([1,3,40]) color("red") rotate([0,90,0]) cylinder(h=17,d=10);
		translate([0,2,33]) color("gray") cube([25,15,15]);
	}
	if(DoTab) EndSupport();
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module EndSupport() {
	translate([20-LayerThickness,2,0]) rotate([0,90,0]) color("blue") cylinder(h=LayerThickness,d=20);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module WCXCarriage() {
	difference() {
		union() {
			color("cyan") cubeX([50,15,Thickness],2);
			translate([15,0,0]) color("gray") cubeX([20,Thickness,15],2);
			translate([15,10,0]) color("blue") cubeX([20,75,Thickness],2);
			translate([15,80,0]) color("red") cubeX([20,Thickness,15],2);
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