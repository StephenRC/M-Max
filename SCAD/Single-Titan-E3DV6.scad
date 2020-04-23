///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Single Titan - titan and wades mounts
// created: 2/3/2014
// last modified: 4/7/2020
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 1/12/16 - added bevel on rear carriage for x-stop switch to ride up on
//////////////////////////////////////////////////////////////////////////////////////////////////////////
include <MMAX_h.scad>
use <ybeltclamp.scad>	// modified https://www.thingiverse.com/thing:863408
use <inc/corner-tools.scad>
use <SensorAndFanMounts.scad>
//-------------------------------------------------------------------------------------------------------------
ShiftTitanUp = 2.5;		// move motor +up/-down
ShiftHotend = 0;		// move hotend opening front/rear
ShiftHotend2 = -20;		// move hotend opening left/right
Spacing = 17; 			// ir sensor bracket mount hole spacing
ShiftIR = -20;			// shift ir sensor bracket mount holes
ShiftBLTouch = 10;		// shift bltouch up/down
ShiftProximity = 5;		// shift proximity sensor up/down
ShiftProximityLR = 3;	// shift proximity sensor left/right
HotendLength = 50;	// 50 for E3Dv6
BoardOverlap = 2.5; // amount ir board overlaps sensor bracket
IRBoardLength = 17 - BoardOverlap; // length of ir board less the overlap on the bracket
IRGap = 0;			// adjust edge of board up/down
HeightIR = (HotendLength - IRBoardLength - IRGap) - irmount_height;	// height of the mount
//---------------------------------------------------------------------------------------------------------
LEDLight=1; // print LED ring mounting with spacer
LEDSpacer=8;
//==================================================================================================
Use3mmInsert=1; // set to 1 to use 3mm brass inserts

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

ExtruderPlateMount(2,5);	// arg1: extruderplatform type
							// 0 - flat plate platform for a Wades type extruder
							// 1 - extruder plat drill guide for using flat plate of aluminum
							// 2 - mirrored titan extruder platform
							// 3 - titan extruder platform
							// arg2: sensor type
							// 0 = BLTouch with top mounting, no recess
							// 1 - BLT9ouch with bottom mount in recess
							// 2 - proximity sensor hole in psensord size
							// 3 - dc42's ir sensor
							// 4 - all sensors
							// 5 or higher - none

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function GetHoleLen(Screw) =	(Screw==screw3in) ? screw3inl*2.5 : ExtruderThickness+screw_depth;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function YesInsert() = (Use3mmInsert==1) ? screw3in : screw3;

/////////////////////////////////////////////////////////////////////////////////////////

module ExtruderPlateMount(Extruder=0,Sensor=0) {
	//if($preview) %translate([-100,-100,-5]) cube([200,200,1]);
	if(Extruder == 0)
		ExtruderPlatform(Sensor);	// for BLTouch: 0 = top mounting through hole, 1 - bottom mount in recess
									// 2 - proximity sensor hole in psensord size
									// 3 - dc42's ir sensor
	if(Extruder == 1) {				// 4 or higher = none
		// drill guide for using an AL plate instead of a printed one
		rotate([0,0,90]) ExtruderPlateDrillGuide();
	}
	if(Extruder == 2) // titan/E3Dv6 combo
			MirrorTitanExtruderPlatform(Sensor,1,1,1);
	if(Extruder == 3) // titan/E3Dv6 combo
			MirrorTitanExtruderPlatform(Sensor,1,1);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ExtruderPlatform(recess=0) // bolt-on extruder platform
{							// used for extruder mount via a wades extruder style
	difference() {
		color("red") cubeX([HorizontallCarriageWidth,heightE,wall],radius=2,center=true); // extruder side
		if(recess == 2) {
			translate([0,-height/3-6,0]) { // extruder notch
				color("blue") minkowski() {
					cube([25,60,wall+5],true);
					cylinder(h = 1,r = 5);
				}
			}
		} else {
			translate([0,-height/3,0]) { // extruder notch
				color("pink") minkowski() {
					cube([25,60,wall+5],true);
					cylinder(h = 1,r = 5);
				}
			}
		}
		// screw holes to mount extruder plate
		translate([0,30-wall/2,-10]) color("gray") cylinder(h = 25, r = screw3/2, $fn = 50);
		translate([HorizontallCarriageWidth/2-5,30-wall/2,-10]) color("blue") cylinder(h = 25, r = screw3/2, $fn = 50);
		translate([-(HorizontallCarriageWidth/2-5),30-wall/2,-10]) color("pink") cylinder(h = 25, r = screw3/2, $fn = 50);
		translate([HorizontallCarriageWidth/4-2,30-wall/2,-10]) color("black") cylinder(h = 25, r = screw3/2, $fn = 50);
		translate([-(HorizontallCarriageWidth/4-2),30-wall/2,-10]) color("lightblue") cylinder(h = 25, r = screw3/2, $fn = 50);
		// extruder mounting holes
		color("black") hull() {
			translate([extruder/2+2,-heightE/2+14,-8]) cylinder(h = ExtruderThickness+10,r = screw4/2);
			translate([extruder/2-4,-heightE/2+14,-8]) cylinder(h = ExtruderThickness+10,r = screw4/2);
		}
		color("gray") hull() {
			translate([-extruder/2+4,-heightE/2+14,-8]) cylinder(h = ExtruderThickness+10,r = screw4/2);
			translate([-extruder/2-2,-heightE/2+14,-8]) cylinder(h = ExtruderThickness+10,r = screw4/2);
		}
		translate([0,26,41+wall/2]) rotate([90,0,0]) FanMountHoles(YesInsert());
		translate([0,-6,0.6]) rotate([0,0,90]) IRMountHoles(YesInsert());
		if(recess != 4) {
			BLTouch_Holes(recess);
			if(recess == 2) { // proximity sensor
				translate([0,10,-6]) color("pink") cylinder(h=wall*2,r=psensord/2);
			}
		}
	}
	if(recess == 3) { // dc42's ir sensor mount
		translate([irmount_width/2,5,0]) rotate([90,0,180]) IRAdapter();
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TitanExtruderPlatform(recess=3,InnerSupport=0,MountingHoles=1) { // extruder platform for e3d titan with (0,1)BLTouch or
	difference() {										// (2)Proximity or (3)dc42's ir sensor
		union() {
			translate([-37.5+17,-42,-wall/2])
				color("cyan") cubeX([HorizontallCarriageWidth+ShiftHotend2/1.3-17,heightE+13,wall],2); // extruder side
			translate([14,21,-wall/2]) color("plum") cubeX([25,10,wall],2);
			translate([-38,21,-wall/2]) color("blue") cubeX([25,10,wall],2);
		}
		//if(MountingHoles && YesInsert()==screw3)
		ExtruderMountHoles(screw3);
 		if(LEDLight) LEDRingMount();		 // remove some under the motor
		translate([20+ShiftHotend2,-5,-10]) color("pink") cylinder(h=20,d=23.5);
	    translate([0,-5,wall/2]) color("purple") fillet_r(2,23/2,-1,$fn);	// round top edge
	    translate([0,-5,-wall/2]) color("purple") rotate([180]) fillet_r(2,23/2,-1,$fn);	// round bottom edge
	    
		
		translate([-50,0,44.5]) rotate([90,0,90]) FanMountHoles(YesInsert()); // mounting holes for bltouch & prox sensor
		translate([-10,70,0]) IRMountHoles(YesInsert()); // mounting holes for irsensor bracket
		translate([-10,20,45]) rotate([90,0,0]) PCFanMounting(screw3);
		if(!Use3mmInsert) translate([15,15,0]) rotate([90,0,0]) PCFanNutHoles(nut3);

	}
	if(LEDLight) translate([0,0,-4]) ScrewSpacer(LEDSpacer,screw5);
	difference() {
		translate([ShiftHotend2,-32,0]) rotate([90,0,90]) TitanMotorMount(0,0,InnerSupport);
		translate([-50,0,44.5]) rotate([90,0,90]) FanMountHoles(YesInsert()); // mounting holes for bltouch & prox sensor
	}
	if(recess != 5) {
		if(recess == 0 || recess == 1) translate([-13,40,-wall/2]) BLTouchMount(recess,ShiftBLTouch); // BLTouch mount
		if(recess == 2) translate([10,45,-wall/2]) ProximityMount(ShiftProximity); // mount proximity sensor
		if(recess == 3) { // ir mount
			translate([0,33,-wall/2]) difference() {
				IRAdapter(0,HeightIR);
				translate([25,4,40]) rotate([90,0,0]) IRMountHoles(YesInsert());
			}
		}
		if(recess==4) {
			translate([-50,37,-wall/2]) BLTouchMount(0,ShiftBLTouch); // BLTouch mount
			translate([39,55,-wall/2]) ProximityMount(ShiftProximity); // mount proximity sensor
			translate([10,35,-wall/2]) difference() { // ir mount
				IRAdapter(0,HeightIR);
				translate([25,4,40]) rotate([90,0,0]) IRMountHoles(YesInsert());
			}
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module MirrorTitanExtruderPlatform(recess=3,InnerSupport=0,MountingHoles=1,Mirror=0) {
	echo(recess);
	if(Mirror) {
		mirror([1,1,0]) {// reverse the platform to have the titan adjusting screw to the front
			rotate([0,0,90]) TitanExtruderPlatform(5,InnerSupport,MountingHoles);
			if(recess==2) /*rotate([0,180,90])*/ translate([10,45,-wall/2]) ProximityMount(ShiftProximity); 
		}
	} else {
		echo("MTEP");
		TitanExtruderPlatform(recess,InnerSupport,MountingHoles);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanMountHoles(Screw=screw3in,Left=1) {	// fan mounting holes
	ScrewL=GetHoleLen(Screw);
	if(Left) {
		translate([-extruder/2-22,-heightE/2 - 1.8*wall,heightE - extruder_back + fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("blue") cylinder(h = ScrewL*2,d = Screw);
		translate([-extruder/2-22,-heightE/2 - 1.8*wall,heightE - extruder_back + fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("skyblue") cylinder(h = 2*ScrewL,d = Screw);
	} else { // one side fan mounting holes
		translate([-extruder/2+35,-heightE/2 - 1.8*wall,heightE - extruder_back - fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("pink") cylinder(h =ScrewL,d = Screw);
		translate([-extruder/2+35,-heightE/2 - 1.8*wall,heightE - extruder_back + fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("skyblue") cylinder(h = ScrewL,d = Screw);
		translate([-extruder/2+35,-heightE/2 - 1.8*wall,heightE - extruder_back - fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("pink") cylinder(h = ScrewL*2,d = Screw);
		translate([-extruder/2+35,-heightE/2 - 1.8*wall,heightE - extruder_back + fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("skyblue") cylinder(h = ScrewL*2,d = Screw);
	}
	if(Screw == screw3) {
		translate([-38.5,-50,52]) rotate([0,90,0]) color("blue") hull() {	// nut trap for fan
			nut(nut3,3);
			translate([0,18,0]) nut(nut3,3);
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanNutHoles(Nut=nut3,Left=1) {	// fan mounting holes
	translate([0,-10,0]) rotate([0,90,0]) color("blue") hull() {	// nut trap for fan
		nut(nut3,3);
		translate([0,18,0]) nut(nut3,3);
	}
	translate([0,-10,fan_spacing]) rotate([0,90,0]) color("plum") hull() {	// nut trap for fan
		nut(nut3,3);
		translate([0,18,0]) nut(nut3,3);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module IRMountHoles(Screw=screw3) // ir screw holes for mounting to extruder plate
{
	if(Use3mmInsert) {
		translate([Spacing+ShiftIR+ShiftHotend,-107,0]) rotate([90,0,0]) color("blue")
			cylinder(h=screw3inl*2,d=screw3in);
		translate([Spacing+ShiftIR+ShiftHotend,-45,0]) rotate([90,0,0]) color("red") cylinder(h=3*(ExtruderThickness+screw_depth),d=Screw);
	} else {
		translate([Spacing+ShiftIR+ShiftHotend,-45,0]) rotate([90,0,0]) color("red") cylinder(h=3*(ExtruderThickness+screw_depth),d=Screw);
		translate([-3,-108.5,5]) rotate([0,90,90]) color("red") hull() {	// nut trap for sensor
			rotate([0,0,0]) nut(nut3,3);
			translate([18,0,0]) rotate([0,0,0]) nut(nut3,3);
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BLTouch_Holes(recess=0) {
				if(recess == 1) {	// dependent on the hotend, for mounting under the extruder plate
				translate([-bltl/2+3,bltw/2+3,bltdepth]) color("cyan") minkowski() { // depression for BLTouch
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

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module LEDRingMount() {
	translate([30.5+ShiftHotend2,-24+ShiftHotend,-10]) color("gray") cylinder(h=20,d=screw5);	// mounting hole for a holder
	translate([30.5+ShiftHotend2,-24+ShiftHotend,2]) color("black") nut(nut5,5);				// with a 75mm circle led
	translate([30.5+ShiftHotend2,12.5+ShiftHotend,-10]) color("lightgray") cylinder(h=20,d=screw5);	// mounting hole holder
	translate([30.5+ShiftHotend2,12.5+ShiftHotend,2.5]) color("black") nut(nut5,5);				// with a 75mm circle led
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PCFanMounting(Screw=screw3) {
	if(Use3mmInsert) {
		translate([-extruder/2+54,-heightE/2 - 1.8*wall,heightE - extruder_back - PCfan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("red") cylinder(h = screw3inl*2,d = screw3in);
		translate([-extruder/2+54,-heightE/2 - 1.8*wall,heightE - extruder_back + fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("blue") cylinder(h = screw3inl*2,d = screw3in);
	}
	translate([-extruder/2+35,-heightE/2 - 1.8*wall,heightE - extruder_back - PCfan_spacing/2 + fan_offset])
		rotate([0,90,0]) color("pink") cylinder(h = ExtruderThickness+screw_depth,d = Screw);
	translate([-extruder/2+35,-heightE/2 - 1.8*wall,heightE - extruder_back + fan_spacing/2 + fan_offset])
		rotate([0,90,0]) color("skyblue") cylinder(h = ExtruderThickness+screw_depth,d = Screw);
}

////////////////////////////////////////////////////////////////////////////////////////////////////

module ScrewSpacer(Length=10,Screw=screw5) {
	difference() {
		color("blue") cylinder(h=Length,d=Screw*2,$fn=100);
		translate([0,0,-2]) color("red") cylinder(Length+4,d=Screw,$fn=100);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TitanMotorMount(WallMount=0,Screw=screw4,InnerSupport=1) {
	difference() {	// motor mount
		translate([-1,0,0]) color("red") cubeX([54,60+ShiftTitanUp,5],2);
		translate([25,35+ShiftTitanUp,-1]) rotate([0,0,45]) color("purple") NEMA17_x_holes(8, 2);
		color("blue") hull() {
			translate([14,5,0]) cylinder(h=wall*2,d=20); // hotend cooling hole
			translate([37,5,0]) cylinder(h=wall*2,d=20); // hotend cooling hole
		}
	}
	difference() { // front support
		translate([-1,24,-48]) color("blue") rotate([60,0,0]) cubeX([4,60,60],2);
		translate([-3,-30,-67]) cube([7,90,70]);
		translate([-3,-67,-45]) cube([7,70,90]);
		color("gray") hull() {
			translate([-4,10,wall-1]) rotate([0,90,0]) cylinder(h=10,d=screw5);;
			translate([-4,10,wall+13.5]) rotate([0,90,0]) cylinder(h=10,d=screw5);;
			translate([-4,35,wall-1]) rotate([0,90,0]) cylinder(h=10,d=screw5);;
		}
	}
	if(WallMount) {
		difference() { // front support
			translate([52,0,0]) color("cyan") cubeX([4,45+ShiftTitanUp,45],2);
			// lower mounting screw holes
			translate([40,15,11]) rotate([0,90,0]) color("cyan") cylinder(h=20,d=Screw);
			translate([40,15,11+mount_seperation]) rotate([0,90,0])  color("blue") cylinder(h=20,d=Screw);
			if(Screw==screw4) { // add screw holes for horizontal extrusion
				translate([40,15+mount_seperation,34]) rotate([0,90,0]) color("red") cylinder(h=20,d=Screw);
				translate([40,15+mount_seperation,34-mount_seperation]) rotate([0,90,0])  color("pink") cylinder(h=20,d=Screw);
			}
		}
	} else {
		if(!InnerSupport) {
			difference() { // rear support
				translate([49,24,-48]) rotate([60]) color("cyan") cubeX([4,60,60],2);
				translate([47,0,-67]) cube([7,70,70]);
				translate([47,-69,-36]) cube([7,70,70]);
				color("lightgray") hull() {
					translate([46,10,wall-1]) rotate([0,90,0]) cylinder(h=10,d=screw5);;
					translate([46,10,wall+13.5]) color("gray") rotate([0,90,0]) cylinder(h=10,d=screw5);;
					translate([46,35,wall-1]) color("gray") rotate([0,90,0]) cylinder(h=10,d=screw5);;
				}
			}
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ExtruderMountHoles(Screw=screw3,All=0) {		// screw holes to mount extruder plate
	if(Screw==screw3) {
		translate([0,30-wall/2,-10]) color("red") cylinder(h = 25, d = Screw); // center
		translate([HorizontallCarriageWidth/2-5,30-wall/2,-10]) color("white") cylinder(h = 25, d = Screw); // right
		translate([-(HorizontallCarriageWidth/2-5),30-wall/2,-10]) color("lightblue") cylinder(h = 25, d = Screw); // left
		if(All) {
			translate([HorizontallCarriageWidth/4-2,30-wall/2,-10]) color("green") cylinder(h = 25, d = Screw); // 2nd from right
			translate([-(HorizontallCarriageWidth/4-2),30-wall/2,-10]) color("purple") cylinder(h = 25, d = Screw); // 2nd from left
		}
	}
	if(Screw==screw5) {
		translate([-(HorizontallCarriageWidth/2-5),30-wall/2,-10]) color("lightblue") cylinder(h = 25, d = Screw);
		translate([-(HorizontallCarriageWidth/4-10),30-wall/2,-10]) color("red") cylinder(h = 25, d = Screw);
		translate([HorizontallCarriageWidth/4-2,30-wall/2,-10]) color("green") cylinder(h = 25, d = Screw);
	}
}

