/////////////////////////////////////////////////////////////////////////////////////////////////////
// SensorMounts.scad
/////////////////////////////////////////////////////////////////////////////////////////////////////
// created: 6/2/1019
// last update: 10/13/20
////////////////////////////////////////////////////////////////////////////////////////////////////
// 6/2/19	- Separated from single_titan_extruder_mount.scad
// 4/12/20	- Made the mount to extruder plate the same for Proximity & BLTouch
// 8/4/20	- Adjsuted the sensor mount holes to the extruder platform
// 8/17/20	- Copied and edited from M-Max and added an adjustable mount for dc42's ir sensor
// 8/30/20	- Added an adjustable BLTouch mount
// 10/13/20	- Finished adding use of brass inserts
///////////////////////////////////////////////////////////////////////////////////////////////////
include <MMAX_h.scad>
use <inc/corner-tools.scad>
use <fanduct_v3.scad>
include <brassinserts.scad>
/////////////////////////////////////////////////////////////////////////////////////////////////
// Fan mounts are for a 5150 blower fan
/////////////////////////////////////////////////////////////////////////////////////////////////
//*****************************************************
// adjustable mounts need guide rails 9/19/20
//*****************************************************
// set to 1 to use brass inserts
Use2p5mmInsert=1;
Use3mmInsert=1;
Use4mmInsert=1;
Use5mmInsert=1;
LargeInsert=1;
//----------------------------------------------------------------------------
psensornut = 28; 	// size of proximity sensor nut
FanSpacing = 32;	// hole spacing for a 40mm fan
PCfan_spacing = 47;	//FanSpacing+15;
DuctLength=25; 		// set length of 50150 fan duct
Thickness = 6.5;
MHeight = 6;
MWidth = 60;
FHeight = 10;
MountingHoleHeight = 60; 	// screw holes may need adjusting when changing the front to back size
ExtruderOffset = 18;		// adjusts extruder mounting holes from front edge
IRSpacing=spacing;
LayerThickness=0.3; // layer thickness
Spacing=17;
////////////////////////////////////////////////////////////////////////////////////////////////////

//ProximityMount(6); // arg is shift up/down (min:2)
//BLTouchMount(0,15,1);	// 1st arg:type; 2nd: shift -- Titan Aero w/v3.1 BLTouch thru mount
BLTouchMount(2,20,1);	// 1st arg:type; 2nd: shift -- Titan Aero w/v3.1 BLTouch underneath (add 5mm)
//BLTouchMount(0,14,1);	// 1st arg:type; 2nd: shift -- Titan Aero w/v1 BLTouch (metal pin)
//BLTouchMount(2,19,1);	// 1st arg:type; 2nd: shift -- Titan Aero w/v1 BLTouch (metal pin)
//BLTouchMount(0,10);	// 1st arg:type; 2nd: shift -- Titan w/E3Dv6
//IRAdapter(0,0);
// --- Titan with E3Dv6 ---
//AdjustableBLTMount(10,2,1); //Shift=0 (add to 10),Type=2,DoBase= 0 (no) : 1 (yes)
//AdjustableProximtyMount(20,1); //Shift=0,DoBase= 0 (no) : 1 (yes)
//AdjustableIRMount(0); // arg is to change length
// --- Titan Aero --- not tested
//AdjustableBLTMount(0,2,1); //Shift=0 (add to 10),Type=2,DoBase= 0 (no) : 1 (yes)
//AdjustableProximtyMount(5,0); //Shift=0,DoBase= 0 (no) : 1 (yes)
//AdjustableIRMount(-25,1); // arg is to change length

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

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module SensorMountHoles(Screw=screw3) // ir screw holes for mounting to extruder plate
{
	translate([Spacing,-107,0]) rotate([90,0,0]) color("blue") cylinder(h=20,d=Screw);
	translate([0,-107,0]) rotate([90,0,0]) color("red") cylinder(h=(20),d=Screw);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module IRAdapter(Top,Taller=0) {  // ir sensor bracket stuff is from irsensorbracket.scad
	difference() {
		color("plum") cubeX([irmount_width,irmount_height+Taller,irthickness],2); // mount base
		ReduceIR(Taller);
		IRMountingHoles(Taller);
		RecessIR(Taller);
		translate([24.5,4,45]) rotate([90,0,0]) SensorMountHoles(screw3);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module AdjustableIRMount(Shift=0,DoBase=0) {  // adjuster screw has spring between the parts and a lock nut on the bottom
	echo("dc42's IR");
	if(DoBase) AdjustSensorBaseMount();
	translate([33,-5,0]) rotate([90,0,0]) { // printable placement
		difference() {
			union() {
				color("pink") cubeX([irmount_width,4,55+Shift],2);
				translate([0,0,50+Shift]) color("plum") cubeX([irmount_width,15,5],2);
			}
			translate([-33,5,40+Shift]) AdjustHoles(screw3);
			translate([25,40,3]) SensorMountHoles(screw3);
			translate([0,-28,-5]) RecessIR(0);
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module AdjustSensorBaseMount() {
	difference(){  // base mount
		translate([0,-27,0]) SensorMount(0,3);
		AdjustHoles(Yes3mmInsert(Use3mmInsert,LargeInsert));
	}
	difference() { // reinforce for the nylock nut
		translate([46.5,3,0]) color("plum") cylinder(h=11,d=10);
		AdjustHoles(Yes3mmInsert(Use3mmInsert,LargeInsert));
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module AdjustableBLTMount(Shift=0,Type=2,DoBase=0) {  // adjuster screw has spring between the parts and a lock nut on the bottom
	echo("BLTouch");
	echo("type:",Type);
	if(DoBase) AdjustSensorBaseMount();
	translate([-5,0,0]) rotate([0,-90,0]) BLTMount(Shift,Type);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module AdjustableProximtyMount(Shift=0,DoBase=0) { // shift not used
	if(DoBase) translate([0,40,0]) AdjustSensorBaseMount();
	rotate([0,-90,0]) difference() {
		union() {
			color("red") cubeX([32,33,5],2);
			color("purple") cubeX([32,5,15+Shift],2);
			translate([0,-15,10+Shift]) color("cyan") cubeX([32,20,5],2);
			translate([0,-3,31]) rotate([-90,0,0]) ProximityAngleSupport();
			translate([0,8,-16+Shift]) rotate([90,0,0]) ProximityAngleSupport();
		}
		translate([-30,-11,5+Shift]) AdjustHoles(Yes3mmInsert(Use3mmInsert,LargeInsert),0);
		translate([16,18,-2]) color("olive") cylinder(h=wall*2,d=psensord); // proximity sensor hole
		translate([16,18,-3]) color("blue") cylinder(h=5,d=psensornut,$fn=6); // proximity nut
	}

}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BLTMount(Shift=0,Type=2) {
	difference() {
		union() {
			color("plum") cubeX([irmount_width+10,20,5],2);
			color("blue") cubeX([irmount_width+10,5,15+Shift],2);
			translate([0,-15,10+Shift]) color("green") cubeX([irmount_width+10,20,5],2);
		}
		translate([-28,9,-2]) AdjustHoles(screw3,0);
		translate([18,-23,10+Shift]) BLTouch_Holes(Type);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module AdjustHoles(Screw=Yes3mmInsert(Use3mmInsert,LargeInsert),DoNut=1) {
	translate([38,3,-2]) color("blue") rotate([0,0,0]) cylinder(h=20,d=Screw);
	translate([46.5,3,-2]) color("red") rotate([0,0,0]) cylinder(h=20,d=screw3);
	translate([55,3,-2]) color("green") rotate([0,0,0]) cylinder(h=20,d=Screw);
	if(DoNut) translate([46.5,3,-5]) color("black") cylinder(h=10,d=nut3,$fn=6);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module RecessIR(Taller=0) { // make space for the thru hole pin header
	translate([hole1x+5,hole1y+irrecess+(irmount_height/4)+Taller,irnotch_d]) color("cyan") cube([11.5,10,5]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ReduceIR(Taller=0) { // reduce plastic usage and gives somewhere for air to go if using an all-metal hotend w/fan
	translate([13.5,irmount_height-irreduce+Taller/2,-1]) color("teal") cylinder(h=10,r = irmount_width/4);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module IRMountingHoles(Taller=0) { // mounting screw holes for the ir sensor
	translate([hole1x+iroffset-1.5,irmounty+Taller,-5]) rotate([0,0,0]) color("black") cylinder(h=20,d=screw3);
	translate([hole2x+iroffset-1.5,irmounty+Taller,-5]) rotate([0,0,0]) color("white") cylinder(h=20,d=screw3);
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

module SensorMount(Shift=0,Thicker=0,Tab=0) {
	difference() {
		translate([0,26,0]) color("cyan") cubeX([60,5+Thicker,13+Shift],2);
		//translate([27,60,8+Shift]) SensorMountHoles(screw3);
		//translate([27,53,8+Shift]) IRMountHolesCS(screw3hd);
		translate([37,140,8+Shift]) SensorMountHoles(screw3);
		translate([37,134,8+Shift]) SensorMountHoles(screw3hd);
	}
	if(Tab) translate([58,28.5,0]) color("black") cylinder(h=LayerThickness,d=15);  // support tab
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

module BLTouchMount(Type,Shift,Tab) {
	difference() {
		translate([0,0,0]) color("salmon") cubeX([30,25,5],2);
		translate([15,-4,bltdepth+3]) BLTouch_Holes(Type);
	}
	if(Type==1) BLTouchSupport();
	translate([0,-5,0]) SensorMount(Shift,0,Tab);
	BLTouchAngleSupport();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BLTouchSupport() {
	translate([0,7.5,4]) color("green") cube([bltl,bltw,LayerThickness]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BLTouchAngleSupport() {
	translate([2,21,5]) {
		difference() {
			color("plum") cube([26,5,5]);
			translate([-1,0.5,4]) rotate([0,90,0]) color("pink") cylinder(h=35,d=10,$fn=100);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
module BLTouchBracketMountHoles(Shift) {
	translate([-15,0,Shift+44.5]) rotate([90,0,90]) FanMountHoles();
	translate([25,70,Shift]) SensorMountHoles(screw3);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BLTouch_Holes(recess=0,Screw=Yes2p5mmInsert(Use2p5mmInsert)) {
	if(recess == 2) {	// mounting screw holes only
		translate([bltouch/2,16,-10]) color("pink") cylinder(h=25,d=Screw);
		translate([-bltouch/2,16,-10]) color("black") cylinder(h=25,d=Screw);
		translate([bltouch/2-9,16,-10]) color("black") cylinder(h=25,d=screw5); // adjuster access
	}
	if(recess == 1) {	// dependent on the hotend, for mounting under the extruder plate
		translate([-bltl/2,bltw/2,bltdepth-6]) color("cyan") { // depression for BLTouch
			// it needs to be deep enough for the retracted pin not to touch bed
			cubeX([bltl,bltw,wall],2);
		}
		translate([bltouch/2,16,-10]) color("pink") cylinder(h=25,r=screw2/2);
		translate([-bltouch/2,16,-10]) color("black") cylinder(h=25,r=screw2/2);

	}
	if(recess == 0) {	// for mounting on top of the extruder plate
		translate([-bltl/2+8,bltw/2,-5]) color("blue") cubeX([bltd,bltd+2,wall+3],2); // hole for BLTouch
		translate([bltouch/2,16,-10]) color("pink") cylinder(h=25,r=screw2/2);
		translate([-bltouch/2,16,-10]) color("black") cylinder(h=25,r=screw2/2);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////