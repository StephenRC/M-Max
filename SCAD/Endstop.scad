/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Optical-Endstop.scad
// created: 9/30/2018
// last update: 12/20/18
////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 12/20/18	- Thickened makerslide mount
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Note: not all plastics block IR, you may need to paint the flag
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
include <inc/cubex.scad>
$fn=100;
layer=0.2;
////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Optical endstop
//X_flag();	// defaults to 35 long, 15 high
//translate([40,20,0]) rotate([90,0,0]) // rotate to make it printable without supports
//	X_ms_optical(screw5);

// microswitch endstop
//rotate([0,90,0]) // rotate to make it printable without supports
	X_ms_microswitch(screw5);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module X_flag(Length=35,Height=15) {
	difference() {
		color("cyan") cubeX([Length,10,2],1);
		flag_mounting_hole();
	}
	difference() {
		color("red") cubeX([10,10,Height],1);
		flag_mounting_hole();
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

module flag_mounting_hole() {
	translate([5,5,-5]) color("blue") cylinder(h=25,d=screw3);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module X_ms_optical(Screw=screw5hd) {
	difference() { // angled section between mount and switch bar
		translate([0,0,1]) color("red") hull() {
			translate([0,21,10]) cubeX([screw5hd+1,8,1],1);
			translate([0,0,37]) cubeX([screw5hd+1,4,1],1);
		}
		angled_ziptie_hole();
	}
	ms_mount(Screw); // mount to makerslide		
	difference() { // horizontal bar
		translate([-48,0,37]) color("blue") cubeX([60,4,10],1);
		color("ivory") hull() { // zip tie slot
			translate([-25,(screw5hd+1)/2,42]) rotate([90,0,0]) cylinder(h=20,d=screw3+0.5);
			translate([5,(screw5hd+1)/2,42]) rotate([90,0,0]) cylinder(h=20,d=screw3+0.5);
		}
		optical_switch_screw_holes();
		optical_notch();
	}
	difference() { // switch mount
		translate([-48,0,37]) color("plum") cubeX([20,4,30],1);
		optical_switch_screw_holes();
		optical_notch();
	}
	ms_notch(Screw);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ms_mount(Screw=screw5) {
	difference() { // mount to makerslide		
		translate([0,25,10]) color("yellow") cubeX([screw5hd+1,21,6],1);
		translate([6,40,5]) color("blue") cylinder(h=20,d=Screw);
		angled_ziptie_hole();
		if(Screw == screw3) translate([6,40,15.5]) color("gray") cylinder(h=20,d=screw3hd); // countersinks
		if(Screw == screw5) translate([6,40,15.5]) color("gray") cylinder(h=20,d=screw5hd);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module X_ms_microswitch(Screw=screw5) {
	difference() { // angled section between mount and switch bar
		translate([0,0,1]) color("red") hull() {
			translate([0,21,10]) cubeX([screw5hd+1,8,1],1);
			translate([0,0,42]) cubeX([screw5hd+1,4,1],1);
		}
		angled_ziptie_hole();
	}
	translate([0,0,35]) color("cyan") cubeX([screw5hd+1,1,10],1);
	ms_mount(Screw); // mount to makerslide		
	translate([46,34,-0.3]) rotate([0,0,90]) ms_notch(Screw);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module angled_ziptie_hole() {  // a ziptie slot in the angled part
	color("gray") hull() {
		translate([6,(screw5hd+1)+5,38]) rotate([110,0,0]) cylinder(h=20,d=screw3+0.5); // zip tie hole
		translate([6,(screw5hd+1)+15,18]) rotate([110,0,0]) cylinder(h=20,d=screw3+0.5); // zip tie hole
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ms_notch(Screw) { // adds a boss to prevent the optical mount from rotating in the makerslide
	translate([0,37.5,9.2]) difference() {
		color("cyan") cubeX([screw5hd+1,5,2],1); // boss
		if(Screw == screw3) // make big enough for the 3mm post-install nut in the boss
			translate([(screw5hd+1)/2,2.5,-5]) color("gray") cylinder(h=10,d=8.1);
		if(Screw == screw5) // 5mm screw hole in the boss
			translate([(screw5hd+1)/2,2.5,-5]) color("gray") cylinder(h=10,d=screw5);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module optical_switch_screw_holes() {
	translate([-44,(screw5hd+1)/2,41]) rotate([90,0,0]) color("pink") cylinder(h=20,d=screw3+0.5);
	translate([-44,(screw5hd+1)/2,61]) rotate([90,0,0]) color("red") cylinder(h=20,d=screw3+0.5);
	translate([-32,(screw5hd+1)/2,41]) rotate([90,0,0]) color("black") cylinder(h=20,d=screw3+0.5);
	translate([-32,(screw5hd+1)/2,61]) rotate([90,0,0]) color("white") cylinder(h=20,d=screw3+0.5);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module optical_notch() {
	translate([-46,0,43.5]) color("black") cube([16,5,15]);
}


///////////////// end of optical_enstop.scad ///////////////////////////////////////////////////////////////////

