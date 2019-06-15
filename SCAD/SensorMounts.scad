/////////////////////////////////////////////////////////////////////////////////////////////////////
// SensorMounts.scad
/////////////////////////////////////////////////////////////////////////////////////////////////////
// created: 6/2/1019
// last update: 6/2/19
////////////////////////////////////////////////////////////////////////////////////////////////////
// 6/2/19	- Separated from single_titan_extruder_mount.scad
///////////////////////////////////////////////////////////////////////////////////////////////////
include <MMAX_h.scad>
/////////////////////////////////////////////////////////////////////////////////////////////////
psensornut = 28; // size of proximity sensor nut
////////////////////////////////////////////////////////////////////////////////////////////////////

ProximityMount(8); // arg is shift up/down (min:2)
//BLTouchMount(1,10);
//IRAdapter(0,0);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanMountHoles(Screw=screw3,Left=1) {	// fan mounting holes
	if(Left) {
		translate([-extruder/2-22,-heightE/2 - 1.8*wall,heightE - extruder_back - fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("pink") cylinder(h = 3*(depthE+screw_depth),d = Screw);
		translate([-extruder/2-22,-heightE/2 - 1.8*wall,heightE - extruder_back + fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("skyblue") cylinder(h = 3*(depthE+screw_depth),d = Screw);
	} else { // one side fan mounting holes
		translate([-extruder/2+35,-heightE/2 - 1.8*wall,heightE - extruder_back - fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("pink") cylinder(h = depthE+screw_depth,d = Screw);
		translate([-extruder/2+35,-heightE/2 - 1.8*wall,heightE - extruder_back + fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("skyblue") cylinder(h = depthE+screw_depth,d = Screw);

	}
	translate([-38,-44.5,20]) rotate([0,90,0]) color("plum") nut(nut3,5);	// nut trap for fan
	translate([-38.5,-44.5,52]) rotate([0,90,0]) color("blue") hull() {	// nut trap for fan
		nut(nut3,2.55);
		translate([0,8,0]) nut(nut3,2.5);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanMountHolesPlatform(Screw=screw3,Left=1) {	// fan mounting holes
	if(Left) {
		translate([-extruder/2-22,-heightE/2 - 1.8*wall,heightE - extruder_back - fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("pink") cylinder(h = 3*(depthE+screw_depth),d = Screw);
		translate([-extruder/2-22,-heightE/2 - 1.8*wall,heightE - extruder_back + fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("skyblue") cylinder(h = 3*(depthE+screw_depth),d = Screw);
	} else { // one side fan mounting holes
		translate([-extruder/2+35,-heightE/2 - 1.8*wall,heightE - extruder_back - fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("pink") cylinder(h = depthE+screw_depth,d = Screw);
		translate([-extruder/2+35,-heightE/2 - 1.8*wall,heightE - extruder_back + fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("skyblue") cylinder(h = depthE+screw_depth,d = Screw);

	}
	//if(Nuts) {
	//	translate([-38,-44.5,20]) rotate([0,90,0]) color("plum") nut(nut3,5);	// nut trap for fan
	//	translate([-38.5,-44.5,52]) rotate([0,90,0]) color("blue") hull() {	// nut trap for fan
	//		nut(nut3,2.55);
	//		translate([0,8,0]) nut(nut3,2.5);
	//	}
	//}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanNutHoles(Nut=nut3,Left=1) {	// fan mounting holes
	rotate([0,90,0]) color("blue") hull() {	// nut trap for fan
		nut(nut3,2.55);
		translate([0,8,0]) nut(nut3,2.5);
	}
	translate([0,0,fan_spacing]) rotate([0,90,0]) color("plum") hull() {	// nut trap for fan
		nut(nut3,2.55);
		translate([0,8,0]) nut(nut3,2.5);
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module IRMountHoles(Screw=screw3) // ir screw holes for mounting to extruder plate
{
	translate([spacing+shiftir+shifthotend,-25,0]) rotate([90,0,0]) color("red") cylinder(h=3*(depthE+screw_depth),d=Screw);
	translate([shiftir+shifthotend,-25,0]) rotate([90,0,0]) color("blue") cylinder(h=3*(depthE+screw_depth),d=Screw);
		translate([-3,-108.5,8]) rotate([0,90,90]) color("red") hull() {	// nut trap for sensor
			rotate([0,0,0]) nut(nut3,2.55);
			translate([8,0,0]) rotate([0,0,0]) nut(nut3,2.55);
		}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module IRAdapter(Top,Taller=0) {  // ir sensor bracket stuff is from irsensorbracket.scad
	difference() {
		color("plum") cubeX([irmount_width,irmount_height+Taller,irthickness],2); // mount base
		ReduceIR(Taller);
		IRMountingHoles(Taller);
		RecessIR(Taller);
		translate([24.5,4,45]) rotate([90,0,0]) IRMountHoles(screw3);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module RecessIR(Taller=0) { // make space for the thru hole pin header
	translate([hole1x+3,hole1y+irrecess+(irmount_height/4)+Taller,irnotch_d]) color("cyan") cube([15.5,10,5]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ReduceIR(Taller=0) { // reduce plastic usage and gives somewhere for air to go if using an all-metal hotend w/fan
	translate([13.5,irmount_height-irreduce+Taller/2,-1]) color("teal") cylinder(h=10,r = irmount_width/4);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module IRMountingHoles(Taller=0) // mounting screw holes for the ir sensor
{
	translate([hole1x+iroffset-1.5,irmounty+Taller,-5]) rotate([0,0,0]) color("black") cylinder(h=20,r=screw3/2);
	translate([hole2x+iroffset-1.5,irmounty+Taller,-5]) rotate([0,0,0]) color("white") cylinder(h=20,r=screw3/2);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module IRBracketMountHoles(Shift) {
	translate([4,33,Shift]) color("black") rotate([90,0,0]) cylinder(h=20,d=screw3);
	translate([19,35,Shift]) color("plum") rotate([90,0,0]) color("plum") cylinder(h=20,d=screw3); // center
	translate([4+fan_spacing,33,Shift]) rotate([90,0,0]) color("gray") cylinder(h=20,d=screw3);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ProximityMount(Shift) {
	difference() {
		translate([-1,-2.5,0]) color("red") cubeX([32,32,8],2);
		translate([15,12,-2]) color("olive") cylinder(h=wall*2,d=psensord); // proximity sensor hole
		translate([15,12,4.5]) color("blue") cylinder(h=5,d=psensornut,$fn=6); // proximity nut
	}
	difference() {
		translate([-20,26,0]) color("cyan") cubeX([63,5,13+Shift],2);
		translate([-20,0,8]) IRBracketMountHoles(Shift);
		translate([37,35,Shift+8]) rotate([90,0,0]) color("gold") cylinder(h=20,d=screw3+0.5); // a ziptie hole
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BLTouchMount(Type,Shift) {
	difference() {
		translate([15,0,0]) color("salmon") cubeX([40,30,5],2);
		if(Type==0) translate([35,0,bltdepth+3]) BLTouch_Holes(Type);//BLTouchMountHole(Type); // blt body hole
		if(Type==1) translate([35,0,bltdepth+3]) BLTouch_Holes(Type);//BLTouchMountHole(Type); // no blt body hole
	}
	difference() {
		translate([-1,26,0]) color("cyan") cubeX([56,5,5+Shift],2);
		BLTouchBracketMountHoles(Shift);
		translate([52,35,Shift]) rotate([90,0,0]) color("gold") cylinder(h=20,d=screw3+0.5); // a ziptie hole
	}
}

module BLTouchBracketMountHoles(Shift) {
	translate([-15,0,Shift+44.5]) rotate([90,0,90]) FanMountHoles();
	 translate([25,70,Shift]) IRMountHoles(Screw=screw3);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BLTouch_Holes(recess=0) {
	if(recess == 1) {	// dependent on the hotend, for mounting under the extruder plate
		translate([-bltl/2+3,bltw/2+2.5,bltdepth-4]) color("cyan") minkowski() { // depression for BLTouch
			// it needs to be deep enough for the retracted pin not to touch bed
			cube([bltl-6,bltw-6,wall]);
			cylinder(h=1,r=3);
		}
		translate([-bltl/2+8,bltw/2,-5]) color("blue") cube([bltd,bltd+1,wall+3]); // hole for BLTouch
		translate([bltouch/2,16,-10]) color("pink") cylinder(h=25,r=screw2/2);
		translate([-bltouch/2,16,-10]) color("black") cylinder(h=25,r=screw2/2);
	}
	if(recess == 0) {	// for mounting on top of the extruder plate
		translate([-bltl/2+8,bltw/2,-5]) color("blue") cube([bltd,bltd+1,wall+3]); // hole for BLTouch
		translate([bltouch/2,16,-10]) color("pink") cylinder(h=25,r=screw2/2);
		translate([-bltouch/2,16,-10]) color("black") cylinder(h=25,r=screw2/2);
	}
}


