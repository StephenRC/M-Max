/////////////////////////////////////////////////////////
// yBeltClamp.scad
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Based on https://www.thingiverse.com/thing:1381533
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 11/29/20	- Separated out the modules
///////////////////////////////////////////////////////////
// https://creativecommons.org/licenses/by-sa/3.0/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

include <bosl2/std.scad>
include <inc/screwsizes.scad>

LayerThickness=0.3;

$fn=32 * 4;


platformHeight = 41.3; //clearance between y carriage and belt. Default 15.5mm fits for my Prusa i3. 

module frame(){
    color("cyan") hull(){
        translate([7,8,0]) rotate([0,0,30]) cylinder(10,8,8,$fn=6);
        translate([31,8,0]) rotate([0,0,30]) cylinder(10,8,8,$fn=6);
    }
}

module beltLoop(){
    difference(){
        color("red") hull(){
            translate([6.5,1,0]) cylinder(h = 12, r1 = 1.2, r2 = 1.2);
            translate([13.5,5.5,0]) cylinder(h = 12, r1 = 5.5, r2 = 5.5);
        }
        hull(){
            translate([9,2.5,0]) cylinder(h = 12, r1 = 1, r2 = 1);
            translate([13.5,5.5,0]) cylinder(h = 12, r1 = 4, r2 = 4);
        }
    }
    color("pink") cube([8,2.5,12]);
}

module beltOpening(){
    beltLoop();
    translate([38,0,0]) mirror([1,0,0]) beltLoop();
    translate([17.5,2.5,0]) color("green") cube([3,8,12]);
    translate([19,7,0]) rotate([0,0,45]) cube([4,4,12]);
}

module beltClamp(){
     difference(){
        frame();
        translate([0,6.5,3]) beltOpening();
        }
}

module platform(){
    difference(){
		union() {
			color("green") hull() {
				translate([8.5,platformHeight-6,0]) color("green") cuboid([33,5,15],rounding=2,p1=[0,0]);
				translate([-2.5,0,0]) color("cyan") cuboid([55,5,15],rounding=2,p1=[0,0]);
			}
		}
		translate([25,7,15]) color("lightgray") hull() { // reduce plastic
			cuboid([40,5,20],rounding=2);
			translate([0,platformHeight-16]) cuboid([20,5,20],rounding=2);
		}
		translate([4,-1,6]) rotate([-90,0,0]) color("red") cylinder(h=30, d=screw5);
        translate([46,-1,6]) rotate([-90,0,0]) color("blue") cylinder(h=30, d=screw5);
		translate([4,3,6]) rotate([-90,0,0]) color("red") cylinder(h=platformHeight+10, d=screw5hd);
        translate([46,3,6]) rotate([-90,0,0]) color("blue") cylinder(h=platformHeight+10, d=screw5hd);
 	}
}

translate([6,platformHeight-6.5,0]) beltClamp();
platform();
