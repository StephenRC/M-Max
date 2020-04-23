///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Extruder_Mount.scad - variable file for the CXY-MGNv2, a corexy with mgn12 rails
// created: 5/16/2019
// last modified: 5/16/19
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 5/16/19	- Created from CoreXY-X-Carriage.scad
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <MMAX_h.scad>
Use3mmInserts=1;
include <BrassFunctions.scad>
use <SensorAndFanMounts.scad>
///////////////////////////////////////////////////////////////////////////////////////////////////////////
$fn=75;
TestLoop=0; // 1 = have original belt clamp mount hole visible
LoopHoleOffset=28;	// distance between the belt lopp mounting holes (same as in belt_holder.scad)
LoopHOffset=0;		// shift horizontal the belt loop mounting holes
LoopVOffset=-2;		// shift vertical the belt loop mounting holes
LoopHeight = 20;
MountThickness=5;
//---------------------------------------------------------------------------------------------------------------
e3dv6 = 36.5;		// hole for e3dv6 with fan holder
shifttitanup = 2.5;	// move motor +up/-down
shifthotend = 0;	// move hotend opening front/rear
shifthotend2 = -20;	// move hotend opening left/right
spacing = 17; 		// ir sensor bracket mount hole spacing
shiftir = -20;	// shift ir sensor bracket mount holes
shiftblt = 10;	// shift bltouch up/down
shiftprox = 5;	// shift proximity sensor up/down
//-----------------------------------------------------------------------------------------
// info from irsensorbracket.scad
//-----------------------------------
hotend_length = 50; // 50 for E3DV6
board_overlap = 2.5; // amount ir borad overlap sensor bracket
irboard_length = 17 - board_overlap; // length of ir board less the overlap on the bracket
ir_gap = 0;		// adjust edge of board up/down
//-------------------------------------------------------
psensord = 19;	// diameter of proximity sensor
psensornut = 28; // size of proximity sensor nut
//-----------------------------------------------------------------------------------------
ir_height = (hotend_length - irboard_length - ir_gap) - irmount_height;	// height of the mount

//////////////////////////////////////////////////////////////////////////////////////////////////////////

TitanExtruderPlatform(5,1,1); // 1st arg:(0,1)BLTouch;(2)Proximity;(3)dc42's ir sensor;(4) all; (5) none
//ExtruderPlatform(2);

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TitanExtruderPlatform(recess=3,InnerSupport=0,MountingHoles=1) { // extruder platform for e3d titan with (0,1)BLTouch or
	difference() {										// (2)Proximity or (3)dc42's ir sensor
		translate([-37.5,-42,-wall/2]) 
			color("cyan") cubeX([HorizontallCarriageWidth+shifthotend2/1.3,heightE+13,wall],2); // extruder side
		if(MountingHoles) ExtruderMountHoles(screw3);
        E3Dv6Hole();
 		 // remove some under the motor
		translate([20+shifthotend2,-5,-10]) color("pink") cylinder(h=20,d=23.5);
	    translate([0,-5,wall/2]) color("purple") fillet_r(2,23/2,-1,$fn);	// round top edge
	    translate([0,-5,-wall/2]) color("purple") rotate([180]) fillet_r(2,23/2,-1,$fn);	// round bottom edge
	    
		translate([-15,20,44]) rotate([90,0,0]) FanMountHoles(YesInsert3mm()); // fan adapter mounting holes
		if(!Use3mmInserts) translate([16,0,0]) rotate([90,0,0]) FanNutHoles(screw3t,0);
		//translate([-50,0,44.5]) rotate([90,0,90]) FanMountHoles(YesInsert3mm()); // mounting holes for bltouch & prox sensor
		translate([-10,70,0]) IRMountHoles(YesInsert3mm()); // mounting holes for irsensor bracket
	}
	difference() {
	if(InnerSupport!=2) 
		translate([shifthotend2,-32,0]) rotate([90,0,90]) TitanMotorMount(0,0,InnerSupport);
	else
		translate([shifthotend2,-32,0]) rotate([90,0,90]) TitanMotorMount(0,0,1);
	
		translate([-50,0,44.5]) rotate([90,0,90]) FanMountHoles(); // mounting holes for bltouch & prox sensor
		translate([-10,0,0]) IRMountHoles(screw3); // mounting holes for irsensor bracket
	}
	if(recess != 5) {
		if(recess == 0 || recess == 1) translate([-13,40,-wall/2]) BLTouchMount(recess,shiftblt); // BLTouch mount
		if(recess == 2) translate([10,45,-wall/2]) ProximityMount(shiftprox); // mount proximity sensor
		if(recess == 3) { // ir mount
			translate([0,33,-wall/2]) difference() {
				IRAdapter(0,ir_height);
				translate([25,4,40]) rotate([90,0,0]) IRMountHoles(YesInsert3mm());
			}
		}
		if(recess==4) {
			translate([-50,37,-wall/2]) BLTouchMount(0,shiftblt); // BLTouch mount
			translate([39,55,-wall/2]) ProximityMount(shiftprox); // mount proximity sensor
			translate([10,35,-wall/2]) difference() { // ir mount
				IRAdapter(0,ir_height);
				translate([25,4,40]) rotate([90,0,0]) IRMountHoles(YesInsert3mm());
			}
		}
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module E3Dv6Hole() {
		// hole for e3dv6, shifted to front by 11mm
		translate([-15.5+shifthotend2,-18+shifthotend,-10]) color("pink") cylinder(h=20,d=e3dv6);
		// round top edge
	    translate([-15.5+shifthotend2,-18+shifthotend,wall/2]) color("purple") fillet_r(2,e3dv6/2,-1,$fn);
		// round bottom edge
	    translate([-15.5+shifthotend2,-18+shifthotend,-wall/2]) rotate([180]) color("purple") fillet_r(2,e3dv6/2,-1,$fn);
}
    
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ExtruderMountHoles(Screw=screw3) {		// screw holes to mount extruder plate
	if(Screw==screw3) {
		translate([0,30-wall/2,-10]) color("red") cylinder(h = 25, d = Screw);
		translate([HorizontallCarriageWidth/2-5,30-wall/2,-10]) color("white") cylinder(h = 25, d = Screw);
		translate([-(HorizontallCarriageWidth/2-5),30-wall/2,-10]) color("blue") cylinder(h = 25, d = Screw);
		translate([HorizontallCarriageWidth/4-2,30-wall/2,-10]) color("green") cylinder(h = 25, d = Screw);
		translate([-(HorizontallCarriageWidth/4-2),30-wall/2,-10]) color("purple") cylinder(h = 25, d = Screw);
	}
	if(Screw==screw5) {
		translate([-(HorizontallCarriageWidth/2-5),30-wall/2,-10]) color("blue") cylinder(h = 25, d = Screw);
		translate([-(HorizontallCarriageWidth/4-10),30-wall/2,-10]) color("red") cylinder(h = 25, d = Screw);
		translate([HorizontallCarriageWidth/4-2,30-wall/2,-10]) color("green") cylinder(h = 25, d = Screw);
	}
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
			translate([extruder/2+2,-heightE/2+14,-8]) cylinder(h = depthE+10,r = screw4/2);
			translate([extruder/2-4,-heightE/2+14,-8]) cylinder(h = depthE+10,r = screw4/2);
		}
		color("gray") hull() {
			translate([-extruder/2+4,-heightE/2+14,-8]) cylinder(h = depthE+10,r = screw4/2);
			translate([-extruder/2-2,-heightE/2+14,-8]) cylinder(h = depthE+10,r = screw4/2);
		}
		translate([0,26,41+wall/2]) rotate([90,0,0]) FanMountHolesPlatform(screw3,1,0);
		translate([0,-6,0.6]) rotate([0,0,90]) IRMountHoles(screw3);
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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TitanMotorMount(WallMount=0,Screw=screw4,InnerSupport=1) {
	difference() {	// motor mount
		translate([-1,0,0]) color("red") cubeX([54,60+shifttitanup,5],2);
		translate([25,35+shifttitanup,-1]) rotate([0,0,45]) color("purple") NEMA17_x_holes(8, 2);
		translate([15,5,0]) cylinder(h=wall*2,d=20); // hotend cooling hole
	    translate([15,5,0]) color("purple") rotate([180]) fillet_r(2,10,-1,$fn);	// hotend side
	    translate([15,5,5]) color("purple") fillet_r(2,10,-1,$fn);	// motor side
	}
	difference() { // front support
		translate([-1,24,-48]) color("blue") rotate([60,0,0]) cubeX([4,60,60],2);
		translate([-3,-30,-67]) cube([7,90,70]);
		translate([-3,-67,-45]) cube([7,70,90]);
	}
	if(WallMount) {
		difference() { // rear support
			translate([52,0,0]) color("cyan") cubeX([4,45+shifttitanup,45],2);
			// lower mounting screw holes
			translate([40,15,11]) rotate([0,90,0]) color("cyan") cylinder(h=20,d=Screw);
			translate([40,15,11+mount_seperation]) rotate([0,90,0])  color("blue") cylinder(h=20,d=Screw);
			if(Screw==screw4) { // add screw holes for horizontal extrusion
				translate([40,15+mount_seperation,34]) rotate([0,90,0]) color("red") cylinder(h=20,d=Screw);
				translate([40,15+mount_seperation,34-mount_seperation]) rotate([0,90,0])  color("pink") cylinder(h=20,d=Screw);
			}
		}
	} else {
		if(InnerSupport) {
			difference() { // rear support
				translate([49,24,-48]) rotate([60]) color("cyan") cubeX([4,60,60],2);
				translate([47,0,-67]) cube([7,70,70]);
				translate([47,-70,-36]) cube([7,70,70]);
			}
		}
	}
}

