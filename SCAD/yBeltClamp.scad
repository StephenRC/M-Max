////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// yBeltClamp.scad -- https://www.thingiverse.com/thing:863408
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Last update: 6/2/2020
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 5/31/20	- Added ability to use 3mm brass inserts
// 6/2/20	- Added use of cubeX.scad
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
Use3mmInsert=1;
include <brassfunctions.scad>
include <inc/cubex.scad>

$fn=32 * 4;

platformHeight = 46; //clearance between y carriage and belt. Default 15.5mm fits for my Prusa i3. 

module beltClamp(){
    module frame(){
        color("white") hull(){
            translate([7,8,0]) rotate([0,0,30]) color("black") cylinder(10,8,8,$fn=6);
            translate([31,8,0]) rotate([0,0,30]) color("pink") cylinder(10,8,8,$fn=6);
        }
    }
    module beltLoop(){
        difference(){
            color("cyan") hull(){
                translate([6.5,1,0]) cylinder(h = 12, r1 = 1, r2 = 1);
                translate([13.5,5.5,0]) cylinder(h = 12, r1 = 5.5, r2 = 5.5);
            }
            color("purple") hull(){
                translate([9,2.5,0]) cylinder(h = 12, r1 = 1, r2 = 1);
                translate([13.5,5.5,0]) cylinder(h = 12, r1 = 4, r2 = 4);
            }
        }
        translate([-2,0,0]) color("red") cube([10,2,12]);
    }
    module beltOpening(){
        beltLoop();
        translate([38,0,0]) mirror([1,0,0]) beltLoop();
        translate([17.5,2.5,0]) color("gray")  cubeX([3,8,12],1);
        translate([19,7,0]) rotate([0,0,45]) color("lightgray") cubeX([4,4,12],1);
    }
    difference(){
        frame();
        translate([0,6.5,3]) beltOpening();
        }
}
module platform(){
    translate([8.5,0,-0]) color("blue") cubeX([33,platformHeight,10],2);
    difference(){
        translate([0,0,0]) color("khaki") cubeX([50,5,10],2);
        translate([4.5,-1,6]) rotate([-90,0,0]) color("white") cylinder(h=30, d=Yes3mmInsert(), $fn=10);
        translate([45.5,-1,6]) rotate([-90,0,0]) color("green") cylinder(h=30, d=Yes3mmInsert(), $fn=10);
    }
}
translate([6,platformHeight-6,0]) beltClamp();
%translate([5,0,7]) cube([5,platformHeight,5]); // current belt offset is 46
platform();
