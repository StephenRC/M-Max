///////////////////////////////////////////////////////////////////////////////////////////////////////////
// M-MAX-LED-Strip-Holder.scad -  hold a led strip
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Created: 8/23/2018
// Last Update: 8/27/18
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 8/27/18	- Added a 45 degree floor for the led strip
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <inc/cubeX.scad>
include <inc/screwsizes.scad>
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
$fn=100;
////////////////////////////////////////////////////////////////////////////////////////////////////////////

//strip(300);
//translate([20,0,-4]) endclamp();
//translate([43,40,-4]) mirror() endclamp();
snapin(200);

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module strip(Length=300) {
	color("blue") cubeX([4,Length,20],2);
	difference() {
		color("red") cubeX([20,Length,4],2);
		translate([10,10,-2]) color("cyan") cylinder(h=10,d=screw5);
		translate([10,10,2]) color("plum") cylinder(h=10,d=screw5hd);
		translate([10,Length-10,-2]) color("pink") cylinder(h=10,d=screw5);
		translate([10,Length-10,2]) color("gold") cylinder(h=10,d=screw5hd);
	}
	45filler(Length);
}

module 45filler(Length) {
		translate([0,20,10]) rotate([0,45,0]) color("white") cubeX([15,Length-40,4],2);
}

/////////////////////////////////////////////////////////////////////////////////////////

module endclamp() {
	difference() {
		translate([4,0,4]) color("gray") cubeX([15,15,4],2);
		translate([11,7,-2]) color("pink") cylinder(h=10,d=screw5);
		translate([11,7,6]) color("gold") cylinder(h=10,d=screw5hd);
		translate([12,23,9]) rotate([90,0,0]) color("silver") cylinder(h=20,d=5);
		translate([12,26,9]) rotate([90,0,0]) color("silver") cylinder(h=10,d=10);
	}
	difference() {
		translate([12,33,9]) rotate([90,0,0]) color("black") cylinder(h=20,d=15);
		translate([4,10,-1.5]) color("gray") cube([20,24,6]);
		translate([-1,18,8.2+2]) rotate([0,45,0]) color("yellow") cube([20,24,8]); // 8.2 Z is angled surface
		translate([12,23,9]) rotate([90,0,0]) color("silver") cylinder(h=20,d=5);
		translate([12,26,9]) rotate([90,0,0]) color("silver") cylinder(h=10,d=10);
	}
}

module snapin(Length=10) {
// slot is: 6mm wide x 2mm thick
	difference() {
		color("cyan") hull() {
			translate([1.5,0,3]) cube([4,Length,1]);
			translate([0.2,0,0]) cube([6.6,Length,1]);
		}
		tieholes(Length);
		translate([3,-5,-2]) cube([1,Length+10,10]);
	}
	difference() {
		translate([1.5,0,-3]) color("yellow") cube([4,Length,3]);
		translate([3,-5,-4]) cube([1,Length+10,10]);
		tieholes(Length);
	}
	difference() {
		translate([-6,0,-5.5]) color("gray") cubeX([20,Length,3],2);
		tieholes(Length);
	}
	difference() {
		translate([-6.84,0,-4.4]) rotate([0,45,0]) color("red") cubeX([15.5,Length,14.5],2);
		translate([-15,-5,-5]) color("blue") cubeX([40,Length+10,20],2);
		tieholes(Length);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////

module tieholes(Length) {
	if(Length <= 10) {
		translate([-20,Length/2,-4.5]) rotate([0,90,0]) color("black") cylinder(h=50,d=3.5);
	}
	if(Length > 10) {
		translate([-20,10,-4.5]) rotate([0,90,0]) color("black") cylinder(h=50,d=3);
		translate([-20,Length-10,-4.5]) rotate([0,90,0]) color("blue") cylinder(h=50,d=3.5);
	}
	if(Length > 30) {
			translate([-20,Length/2,-4.5]) rotate([0,90,0]) color("pink") cylinder(h=50,d=3.5);
	}
	if(Length > 100) {
			translate([-20,Length/4+4,-4.5]) rotate([0,90,0]) color("gray") cylinder(h=50,d=3.5);
			translate([-20,3*Length/4-4,-4.5]) rotate([0,90,0]) color("plum")cylinder(h=50,d=3.5);
	}
}

///////////////////// end of LEDStripHolder.scad ///////////////////////////////////////////////////////////////