/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//	XWirechain.scad
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// created 1/7/2021
// last update 2/17/22
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// https://creativecommons.org/licenses/by-sa/4.0/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 1/9/21	- Added vertical wirechain - length need adjusting when the wirechain for the vertical has arrived
// 2/11/21	- Added supoorts for the wirechain
// 2/15/21	- Added carriage wirechain mount for EXOSlide
// 2/17/22	- Beefed them up, added wc slot holder for X direction, added amazon link
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// uses two https://www.amazon.com/gp/product/B07QVKL9VL
// 7mm x 7mm(Inner H x Inner W) Black Plastic Cable Wire Carrier Drag Chain 1M Length
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
include <inc/brassinserts.scad>
include <bosl2/std.scad>
$fn=100;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Use3mmInsert=1;
WirechainMountOffset=30;
Thickness=6;
WCEndOffset=11.5-3;
LayerThickness=0.3;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//WCXBottomZ();
//WCXEndEXO(1,0);
//WCXCarriageEXOSlide();
WCEXOSlide(); // all three brackets
// printed carriage on makerslide
//XWirechain();  // both
//WCXCarriage()
//WCXEnd();

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module WCEXOSlide() {
	rotate([0,90,0]) WCXEndEXO();
	translate([-25,10,10]) rotate([0,90,0]) WCXCarriageEXOSlide();
	translate([25,30,-20]) rotate([0,-90,0]) WCXBottomZ();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module WCXCarriageEXOSlide(DoTab=1) {
	difference() {
		union() {
			translate([0,0,0]) color("cyan") cuboid([30,15,Thickness],rounding=2,p1=[0,0]);
			translate([0,10,0]) color("blue") cuboid([30,Thickness,70],rounding=2,p1=[0,0]);
		}
		translate([11,20,58]) rotate([90,0,0]) WCEndMount();
		translate([4.5,7,-10]) EXOSlideMountHoles(screw4);
	}
	if(DoTab) {
		translate([10,0,2]) EndSupport();
		translate([10,10,68]) color("red") EndSupport();
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module WCXEndEXO(DoTab=1) { // height may need changing
	difference() {
		union() {
			translate([0,0,-5]) color("cyan") cuboid([20,Thickness*1.5,105],rounding=2,p1=[0,0]);
			translate([0,-46,94]) color("gray") cuboid([20,50,Thickness],rounding=2,p1=[0,0]);
			translate([0,-55,55]) color("lightgray") cuboid([20,60,Thickness],rounding=2,p1=[0,0]);
			translate([0,-55,75]) color("white") cuboid([20,60,Thickness],rounding=2,p1=[0,0]);
			translate([-10,-45,88]) color("green") cuboid([60,Thickness,24],rounding=2);
			translate([0,-55,55]) color("blue") cuboid([20,Thickness,25],rounding=2,p1=[0,0]);
			color("khaki") hull() {
				translate([10,-10,59]) cuboid([Thickness-1,30,Thickness-2],rounding=2);
				translate([10,2,13]) cuboid([Thickness-1,Thickness-1,Thickness-2],rounding=2);
			}
			translate([15,-6,38]) color("purple") cuboid([10,17,LayerThickness]); // support for above
			translate([-22,-50,80.5]) {
				difference() {
					union() {
						%translate([0,-4,8]) cuboid([5,13,15]); // show wire chain size
						translate([0,0,0]) color("purple") hull() {
							translate([0,-3.5,17.5]) cyl(h=Thickness-2,d=25,rounding=2);
							translate([0,8,17.5]) cyl(h=Thickness-2,d=35,rounding=2);
						}
						translate([0,0,-1.5]) color("white") hull() {
							translate([0,-3.5,0]) cyl(h=Thickness-2,d=25,rounding=2);
							translate([0,8,0]) cyl(h=Thickness-2,d=35,rounding=2);
						}
					}
					translate([0,-12.5,18]) color("pink") cyl(h=10,d=screw3); // hold down
					translate([0,-12.5,0]) color("green") cyl(h=10,d=Yes3mmInsert(Use3mmInsert)); // hold down
					translate([0,21,7.5]) color("gold") cuboid([40,30,30]);
				}
			}
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
			color("cyan") cuboid([21,20,Thickness],rounding=2,p1=[0,0]);
			color("pink") cuboid([Thickness,20,80],rounding=2,p1=[0,0]);
			translate([0,-40,60]) color("red") cuboid([Thickness,50,20],rounding=2,p1=[0,0]);
			translate([12.5,-38,70]) color("blue") cuboid([25,Thickness-1,20],rounding=2); // circuit breaker mount
		}
		translate([11,10,-5]) color("red") cylinder(h=Thickness*3,d=screw5);
		translate([11,10,4]) color("blue") cylinder(h=Thickness,d=screw5hd);
		translate([-5,6,70]) rotate([90,0,90]) WCEndMount();
		translate([14,-38,70]) rotate([90,0,0]) color("gold") cyl(h=20,d=11.5); // circuit breaker mount
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
			color("cyan") cuboid([20,Thickness,95],rounding=2,p1=[0,0]);
			translate([0,-45,90]) color("gray") cuboid([20,50,Thickness],rounding=2,p1=[0,0]);
			translate([0,-55,55]) color("lightgray") cuboid([20,60,Thickness],rounding=2,p1=[0,0]);
			translate([0,-55,75]) color("black") cuboid([20,60,Thickness],rounding=2,p1=[0,0]);
			translate([-40,-45,75]) color("green") cuboid([60,Thickness,20],rounding=2,p1=[0,0]);
			translate([0,-55,55]) color("blue") cuboid([20,Thickness,25],rounding=2,p1=[0,0]);
	
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
			color("cyan") cuboid([50,15,Thickness],rounding=2,p1=[0,0]);
			translate([15,0,0]) color("gray") cuboid([20,Thickness,15],rounding=2,p1=[0,0]);
			translate([15,10,0]) color("blue") cuboid([20,75,Thickness],rounding=2,p1=[0,0]);
			translate([15,80,0]) color("red") cuboid([20,Thickness,15],rounding=2,p1=[0,0]);
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