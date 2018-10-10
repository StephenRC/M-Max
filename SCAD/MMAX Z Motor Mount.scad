///////////////////////////////////////////////////////////////////////////////////////////////////////
// MMAX Z Motor Mount.scad -  shift the z motor mount from original postion
///////////////////////////////////////////////////////////////////////////////////////////////////////
// Created: 8/21/2018
// Last Update: 8/26/18
///////////////////////////////////////////////////////////////////////////////////////////////////////
// 8/21/18	- From https://www.thingiverse.com/thing:28876, this file is based on the Z MOTOR MOUNT.stl
// 8/26/18	- Fixed nema17 location
///////////////////////////////////////////////////////////////////////////////////////////////////////
use <inc/cubeX.scad>
include <inc/nema17.scad>
include <inc/screwsizes.scad>
$fn=100;
///////////////////////////////////////////////////////////////////////////////////////////////////////
// vars
b_width = 90;
b_length = 100;
thickness = 5.5;
/////////////////////////////////////////////////////////////////////////////////////////

twomounts(0,0,47);	// 46 shifts it to the end
//onemount(0,0,47);		// 0 places it at the original postion
						// negative numbers need the support to be adjusted manually

/////////////////////////////////////////////////////////////////////////////////////////////////////


module OldMount() {  // overlay old one to get the positions and sizes right
	if($preview) %import("original stl/Z MOTOR MOUNT.stl");
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
module twomounts(X=0,Y=0,Z=0) { // two mounts
	onemount(X,Y,Z);
	translate([100,0,0]) onemount(X,Y,Z);
}
 
///////////////////////////////////////////////////////////////////////////////////////////////////////

module onemount(X=0,Y=0,Z=-52.75) { // just one mount
	OldMount();
	base(X,Y,-Z-52.75,New); // Z=-52.75 for original position
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module base(X=0,Y=0,Z=0) { // mkes the motor mount holder
	difference() {
		color("skyblue") cubeX([b_width,b_length,thickness],2);
		baseholes(X,Y,Z);
	}
	NEMA_Holder(X,Y,Z);
	supports(X,Y,Z);
	sidebase(X,Y,Z);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module sidebase(X=0,Y=0,Z=0) { // prevent the base from flexing in between the 2020 pieces
	translate([X+14.5,Y+5,0.5]) color("firebrick") cubeX([thickness,b_length-6,20],2);
	translate([X+b_width-21.5,Y+5,0.5]) color("seashell") cubeX([thickness,b_length-6,20],2);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module baseholes(X=0,Y=0,Z=0) { // moke the holes in the base
	color("red") translate([8,10,-thickness/2]) cylinder(h=thickness*2,d=screw5); // mounting screw hole to frame
	color("blue") translate([8,10,thickness-1.5]) cylinder(h=thickness*2,d=screw5hd);
	color("blue") translate([b_width-8,10,-thickness/2]) cylinder(h=thickness*2,d=screw5); // mounting screw hole to frame
	color("red") translate([b_width-8,10,thickness-1.5]) cylinder(h=thickness*2,d=screw5hd);
	color("black") translate([b_width-8,b_length-10,-thickness/2]) cylinder(h=thickness*2,d=screw5); // mounting screw hole to frame
	color("white") translate([b_width-8,b_length-10,thickness-1.5]) cylinder(h=thickness*2,d=screw5hd);
	color("lightgray") translate([8,b_length-10,-thickness/2]) cylinder(h=thickness*2,d=screw5); // mounting screw hole to frame
	color("gray") translate([8,b_length-10,thickness-1.5]) cylinder(h=thickness*2,d=screw5hd);
	innerhole(X,Y,Z); // inner hole
	color("blue") translate([8,10,thickness-1]) cylinder(h=thickness*2,d=screw5hd);
	color("powderblue") hull() { // left side notch
		color("cyan") hull() {
			translate([9,24,-thickness/2]) color("cyan") cylinder(h=thickness*2,d=10);
			translate([-5,24,-thickness/2]) color("powderblue") cylinder(h=thickness*2,d=10);
		}
		color("turquoise") hull() {
			translate([-5,b_length-25,-thickness/2]) color("turquoise") cylinder(h=thickness*2,d=10);
			translate([9,b_length-25,-thickness/2]) color("aquamarine") cylinder(h=thickness*2,d=10);
		}
	}
	color("plum") hull() { // rigth side notch
		color("turquoise") hull() {
			translate([b_width+2,25,-thickness/2]) color("turquoise") cylinder(h=thickness*2,d=10);
			translate([b_width-9,25,-thickness/2]) color("plum")cylinder(h=thickness*2,d=10);
		}
		color("yellowgreen") hull() {
			translate([b_width+2,b_length-25,-thickness/2]) color("yellowgreen") cylinder(h=thickness*2,d=10);
			translate([b_width-9,b_length-25,-thickness/2]) color("limegreen") cylinder(h=thickness*2,d=10);
		}
	}
	color("cyan") hull() { // bottom slot
		translate([30,10,-thickness/2]) color("cyan") cylinder(h=thickness*2,d=10);
		translate([b_width-30,10,-thickness/2]) color("cyan") cylinder(h=thickness*2,d=10);
	}
	color("pink") hull() { // top slot
		translate([30,b_length-10,-thickness/2]) color("cyan") cylinder(h=thickness*2,d=10);
		translate([b_width-30,b_length-10,-thickness/2]) color("cyan") cylinder(h=thickness*2,d=10);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module supports(X=0,Y=0,Z=0) { // the angled supports
	difference() {
		translate([14.5,-Z-55,-10]) rotate([45,0,0]) color("gold") cubeX([thickness,90,10],2);
		translate([13,-Z-70,-25]) color("ivory") cube([thickness*2,40,40]);
		translate([12,-Z-3,26]) color("gray") cube([thickness*2,20,40]);
		
	}
	translate([b_width-38,0,0]) difference() {
		translate([16.5,-Z-55,-10]) rotate([45,0,0]) color("lightcoral") cubeX([thickness,90,10],2);
		translate([13.5,-Z-70,-25]) color("cyan") cube([thickness*2,40,40]);
		translate([12.5,-Z-3,26]) color("pink") cube([thickness*2,20,40]);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module NEMA_Holder(X=0,Y=0,Z=0) { // part that the motor mounts to
	difference() {
		NEMA17(X,Y,Z);
		//innerhole(X,Y,Z);
		color("pink") hull() { // notch below the motor
			translate([X+b_width/2-8.5,Y+b_length/2-Z-47,1]) rotate([90,0,0]) cylinder(h=thickness*2,d=29);
			translate([X+b_width/2+8.6,Y+b_length/2-Z-47,1]) rotate([90,0,0]) cylinder(h=thickness*2,d=29);
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module NEMA17(X=0,Y=0,Z=0) { // maker the holes to hold the motor
	rotate([90,0,0]) difference() {
		translate([X+14.6,Y+0.5,Z]) color("red") cubeX([b_width-30.7,b_length-39,thickness],2);
		translate([X+45,Y+33.5,Z-1]) rotate([0,0,45]) color("white") NEMA17_x_holes(7, 2);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module innerhole(X=0,Y=0,Z=0) { // the big hole in the middle of the base
	color("hotpink") hull() { // inner hole
		hull() {
			translate([b_width/2-8,b_length/2+15,-thickness/2]) cylinder(h=thickness*2,d=30);
			translate([b_width/2-8,b_length/2-15,-thickness/2]) cylinder(h=thickness*2,d=30);
		}
		hull() {
			translate([b_width/2+8,Y+b_length/2+15,-thickness/2]) cylinder(h=thickness*2,d=30);
			translate([b_width/2+8,Y+b_length/2-15,-thickness/2]) cylinder(h=thickness*2,d=30);
		}
	}
}

///////////////// end of msmax_shift_z_motor_mount.scad //////////////////////////////////////////////