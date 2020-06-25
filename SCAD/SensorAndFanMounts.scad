/////////////////////////////////////////////////////////////////////////////////////////////////////
// SensorAndFanMounts.scad
/////////////////////////////////////////////////////////////////////////////////////////////////////
// created: 6/2/1019
// last update: 4/12/20
////////////////////////////////////////////////////////////////////////////////////////////////////
// 6/2/19	- Separated from single_titan_extruder_mount.scad
// 4/12/20	- Made the mount to extruder plate the same for Proximty & BLTouch
///////////////////////////////////////////////////////////////////////////////////////////////////
include <MMAX_h.scad>
use <fanduct_v2.scad>
/////////////////////////////////////////////////////////////////////////////////////////////////
psensornut = 28; // size of proximity sensor nut
FanSpacing = 32;			// hole spacing for a 40mm fan
PCfan_spacing = 47;//FanSpacing+15;
DuctLength=25; // set length of 50150 fan duct
Thickness = 6.5;
MHeight = 6;
MWidth = 60;
FHeight = 10;
MountingHoleHeight = 60; 	// screw holes may need adjusting when changing the front to back size
ExtruderOffset = 18;		// adjusts extruder mounting holes from front edge
Layer=0.3; // printed layer thickness
////////////////////////////////////////////////////////////////////////////////////////////////////

//ProximityMount(6); // arg is shift up/down (min:2)
BLTouchMount(0,10);
//IRAdapter(0,0);
//FanAndProximityMount(8); // arg is shift up/down (min:2) *** blocks e3dv6 fan ***

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanAndProximityMount(Shift) {
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
	translate([-20,27,0]) color("blue") cubeX([5,63,13+Shift],2);
	translate([-20,95,0]) rotate([0,0,-90]) Short_Motor_Version(1,6,25,6);
	
}

///////////////////////////////////////////////////////////////////////////

module Short_Motor_Version(Duct=0,Move=0,Raise=0,Back=0,Offset=0) {
	FanBlowerMount(Move,Raise,Back);
	if(Duct) translate([0,12,0]) color("red") FanDuct_v3(DuctLength);
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BracketMount_v2(Move=0) {
	translate([3,10,FHeight/4+0.3]) rotate([90,0,0]) color("red") cylinder(h = 18,r = screw3/2,$fn=50);
	translate([3,1,FHeight/4+0.3]) rotate([90,0,0]) color("gray") cylinder(h = 18,r = screw3hd/2,$fn=50);
	translate([3+PCfan_spacing,10,FHeight/4+0.3]) rotate([90,0,0]) color("blue") cylinder(h = 18,r = screw3/2,$fn=50);
	translate([3+PCfan_spacing,1,FHeight/4+0.3]) rotate([90,0,0]) color("plum") cylinder(h = 18,r = screw3hd/2,$fn=50);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////

module FanBlowerMount(Move=0,Raise=0,Back=0,X=0,Y=0,Z=0,Spacer=0,Offset=0) {
	if(Spacer) {
		difference() {
			translate([Move+6,-30+Back,0]) color("gray") cubeX([21,21-Back,Raise+Z+5],1);
			RemoveForBlower(Move+6,Raise,Spacer);
			translate([Move+X,-14-Back+Y,Raise+Z]) rotate([0,90,0]) color("purple") cylinder(h=42,r=screw4/2,$fn=50);
			translate([Move+2,-40+Back,10]) rotate([-45,0,0]) color("black") cube([30,30,10]);
		}
		//difference() {
		//	translate([Move+6,Offset+2,0]) color("lightgray") cubeX([21,Offset,Thickness],1);
		//	translate([0,0,0.5]) BracketMount(Move);
		//	translate([5,-5-Offset,0]) color("plum") cube([30,20,20]);
		//}
	} else {
		difference() {
			translate([Move,-16+Back,0]) color("gray") cubeX([21,21-Back,Raise+4],2);
			RemoveForBlower(Move,Raise);
			translate([Move+X-3,-Back+Y,Raise+Z]) rotate([0,90,0]) color("purple") cylinder(h=42,r=screw4/2,$fn=50);
			translate([Move-5,-29+Back,9]) rotate([-45,0,0]) color("black") cube([30,30,10]);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module RemoveForBlower(Move=0,Raise=0,Spacer=0) {
	if(Spacer) {
		translate([Move+3,-57,-10]) color("yellow") cubeX([15,45,Raise*2],1);
		//translate([Move+3,-15.5,-17]) rotate([35,0,0]) color("lightgreen") cubeX([15,15,15],1);
	} else {
		translate([Move+3,-45,-10]) color("yellow") cubeX([15,45,Raise*2],1);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanMountHoles(Screw=screw3,Left=1) {	// fan mounting holes
	if(Left) {
		translate([-extruder/2-22,-heightE/2 - 1.8*wall,heightE - extruder_back - fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("pink") cylinder(h = 3*(ExtruderThickness+screw_depth),d = Screw);
		translate([-extruder/2-22,-heightE/2 - 1.8*wall,heightE - extruder_back + fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("skyblue") cylinder(h = 3*(ExtruderThickness+screw_depth),d = Screw);
	} else { // one side fan mounting holes
		translate([-extruder/2+35,-heightE/2 - 1.8*wall,heightE - extruder_back - fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("pink") cylinder(h = ExtruderThickness+screw_depth,d = Screw);
		translate([-extruder/2+35,-heightE/2 - 1.8*wall,heightE - extruder_back + fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("skyblue") cylinder(h = ExtruderThickness+screw_depth,d = Screw);

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
			rotate([0,90,0]) color("pink") cylinder(h = 3*(ExtruderThickness+screw_depth),d = Screw);
		translate([-extruder/2-22,-heightE/2 - 1.8*wall,heightE - extruder_back + fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("skyblue") cylinder(h = 3*(ExtruderThickness+screw_depth),d = Screw);
	} else { // one side fan mounting holes
		translate([-extruder/2+35,-heightE/2 - 1.8*wall,heightE - extruder_back - fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("pink") cylinder(h = ExtruderThickness+screw_depth,d = Screw);
		translate([-extruder/2+35,-heightE/2 - 1.8*wall,heightE - extruder_back + fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("skyblue") cylinder(h = ExtruderThickness+screw_depth,d = Screw);

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
	translate([spacing+shiftir+shifthotend,-25,0]) rotate([90,0,0]) color("red") cylinder(h=3*(ExtruderThickness+screw_depth),d=Screw);
	translate([shiftir+shifthotend,-25,0]) rotate([90,0,0]) color("blue") cylinder(h=3*(ExtruderThickness+screw_depth),d=Screw);
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

module IRBracketMountHoles(Shift,ScrewHD=0) {
	translate([4,33,Shift]) color("black") rotate([90,0,0]) cylinder(h=20,d=screw3);
	translate([19,35,Shift]) color("plum") rotate([90,0,0]) color("plum") cylinder(h=20,d=screw3); // center
	//translate([4+fan_spacing,33,Shift]) rotate([90,0,0]) color("gray") cylinder(h=20,d=screw3);

	if(ScrewHD) {
		translate([4,27,Shift]) color("black") rotate([90,0,0]) cylinder(h=20,d=screw3hd);
		translate([19,27,Shift]) color("plum") rotate([90,0,0]) color("plum") cylinder(h=20,d=screw3hd); // center
		//translate([4+fan_spacing,27,Shift]) rotate([90,0,0]) color("gray") cylinder(h=20,d=screw3hd);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ProximityMount(Shift=0) {
	difference() {
		translate([0,-2.5,0]) color("red") cubeX([32,32,8],2);
		translate([16,12,-2]) color("olive") cylinder(h=wall*2,d=psensord); // proximity sensor hole
		translate([16,12,4.5]) color("blue") cylinder(h=5,d=psensornut,$fn=6); // proximity nut
	}
	SensorMount(Shift);
	ProximityAngleSupport();
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////

module SensorMount(Shift=0) {
	difference() {
		translate([0,26,0]) color("cyan") cubeX([57,5,13+Shift],2);
		translate([4,0,8]) IRBracketMountHoles(Shift,1);
		translate([30,0,8]) IRBracketMountHoles(Shift,1);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ProximityAngleSupport() {
	translate([2,21,8]) {
		difference() {
			color("plum") cube([28,5,5]);
			translate([-1,0.5,4]) rotate([0,90,0]) color("pink") cylinder(h=35,d=10,$fn=100);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BLTouchMount(Type,Shift) {
	difference() {
		translate([-5,0,0]) color("salmon") cubeX([40,30,5],2);
		if(Type==0) translate([15,0,bltdepth+3]) BLTouch_Holes(Type);//BLTouchMountHole(Type); // blt body hole
		if(Type==1) translate([15,0,bltdepth+3]) BLTouch_Holes(Type);//BLTouchMountHole(Type); // no blt body hole
	}
	if(Type==1) BLTouchSupport();
	SensorMount(Shift);
	BLTouchAngleSupport();
	}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BLTouchSupport() {
	translate([0,7.5,4]) color("green") cube([bltl,bltw,Layer]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BLTouchAngleSupport() {
	translate([2,21,5]) {
		difference() {
			color("plum") cube([28,5,5]);
			translate([-1,0.5,4]) rotate([0,90,0]) color("pink") cylinder(h=35,d=10,$fn=100);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
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


