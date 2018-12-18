///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Sensor-Mount-Alternative.scad - mount on the x-carriage ms plate
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// created 12/30/2016
// last update 11/13/18
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Use recessed blt_mount for shorter screws
// BLTouch holes are self threading to the nuts aren't needed for testing
// Use supplied BLTouch springs for some adjustment
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 1/3/16	- added ir version
// 7/9/18	- removed commented code
// 9/3/18	- Added a bltouch version, updated include to just MMAX_h.scad
// 9/6/18	- Fixed the Shift ability
// 11/13/18	- Adjusted supports for more clearance on the makerslide x-carriage.
//			  BLTouch flange mounts on top of the adapter.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <MMAX_h.scad>
$fn=100;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//rotate([0,-90,0]) 	// rotate to a printable position
//	prox_mount(0);		// arg is shift up/down
//rotate([0,-90,0])
//	ir_mount(0);		// arg is shift up/down
rotate([0,-90,0])
	blt_mount(1,16);	// 1st arg: 0-recessed, 1-not recesed
						// 2nd arg: Amount to shift the bltouch mount up/down
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module prox_mount(Shift) {
	difference() {
		translate([0,0,Shift]) color("red") cubeX([30,30,5],2);
		translate([15,12,-2]) color("olive") cylinder(h=wall*2,d=psensord,$fn=100); // proximity sensor hole
	}
	difference() {
		translate([0,25,-13]) color("pink") cubeX([30,5,17+Shift],2);
		translate([15,12,-10]) color("azure") cylinder(h=wall*2+Shift,d=psensord+8.5,$fn=100); // proximity sensor nut clearance
	}
	difference() {
		translate([0,25,-13]) color("blue") cubeX([40,26,5],2);
		translate([3,20,-10]) extmount();
	}
	support(Shift);
	support2(Shift);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module extmount() {		// screw holes to mount extruder plate
	translate([widthE/2-5,30-wall/2,-10]) color("white") cylinder(h = 25, r = screw3/2, $fn = 50);
	translate([widthE/4-2,30-wall/2,-10]) color("green") cylinder(h = 25, r = screw3/2, $fn = 50);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module support(Shift=0) {
	if(Shift > 0) {
		difference() {
		translate([0,32,-26]) rotate([50,0,0]) color("cyan") cubeX([5,20,25],2);
			translate([-1,8,-25]) color("gray") cube([7,20,30],2);
			translate([-1,22,-35]) color("black") cube([7,25,25],2);
		}
	} else {
		difference() {
			translate([0,32,-26+Shift]) rotate([50,0,0]) color("yellowgreen") cubeX([5,20,25],2);
			translate([-1,8,-29]) color("gray") cube([7,20,30],2);
			translate([-1,22,-45]) color("black") cube([7,30,35],2);
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module support2(Shift=0) {
	if(Shift > 0) {
		difference() {
			translate([25,32,-26]) rotate([50,0,0]) color("yellow") cubeX([5,20,25],2);
			translate([24,7,-20]) color("plum") cube([7,20,30],2);
			translate([24,22,-35]) color("silver") cube([7,25,25],2);
		}
	} else {
		difference() {
			translate([25,32,-26+Shift]) rotate([50,0,0]) color("brown") cubeX([5,20,25],2);
			translate([24,7,-20+Shift]) color("plum") cube([7,20,30],2);
			translate([24,22,-45]) color("silver") cube([7,25,35],2);
		}
	}

}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ir_mount(Shift) {
	translate([15,-5,Shift]) color("red") cubeX([15,35,5],2);
	translate([15,25,-13]) color("pink") cubeX([15,5,17+Shift],2);
	difference() {
		translate([15,25,-13]) color("blue") cubeX([26,26+Shift,5],2);
		translate([4,20,-10]) extmount();
	}
	translate([15.5,0,0]) support(Shift);
	support2(Shift);
	difference() {
		translate([15,-4,1+Shift]) color("plum") cubeX([15,5,9]);
		translate([3,-1.5,6+Shift]) color("gray") rotate([0,90,0]) cylinder(h=40,d=screw3t);
	}
	difference() {
		translate([15,hole2x-4,1+Shift]) color("gold") cubeX([15,5,8]);
		translate([3,hole2x-1.5,6+Shift]) color("black") rotate([0,90,0]) cylinder(h=40,d=screw3t);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module blt_mount(Type=0,Shift=0) {
	difference() {
		translate([15,-10,Shift]) color("red") cubeX([25,40,5],2);
		if(Type==0) translate([44,10,bltdepth+6+Shift]) rotate([0,0,90]) blt(Type); // recessed
		if(Type==1) translate([43,10,bltdepth+3+Shift]) rotate([0,0,90]) blt(Type); 
	}
	translate([15,25,-13]) color("pink") cubeX([25,5,17+Shift],2);
	difference() {
		translate([15,25,-13]) color("blue") cubeX([25,26,5],2);
		translate([3,20,-10]) extmount();
	}
	translate([15,0,0]) support(Shift);
	translate([10,0,0]) support2(Shift);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module blt(Ver=0) { // BLTouch mounts
	if(Ver == 0) {
		translate([-bltl/2+3,bltw/2+3,bltdepth]) minkowski() { // rounded corners for the depression for the BLTouch
			// it needs to be deep enough for the retracted pin not to touch bed
			color("red") cube([bltl-6,bltw-6,wall]);
			cylinder(h=1,r=3,$fn=100);
		}
		translate([-bltl/2+8,bltw/2,-5]) color("blue") cube([bltd,bltd+1,wall+3]); // through hole that fits the BLTouch
		translate([bltouch/2,16,-10]) color("cyan") cylinder(h=25,r=screw2/2,$fn=100);
		translate([-bltouch/2,16,-10]) color("purple") cylinder(h=25,r=screw2/2,$fn=100);
	}
	if(Ver == 1) {
		translate([-bltl/2+8,bltw/2,-5]) color("blue") cube([bltd,bltd+1,wall+3]); // through hole that fits the BLTouch
		translate([bltouch/2,16,-10]) color("cyan") cylinder(h=25,r=screw2/2,$fn=100);
		translate([-bltouch/2,16,-10]) color("purple") cylinder(h=25,r=screw2/2,$fn=100);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

