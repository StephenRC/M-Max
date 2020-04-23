///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Extruder.scad (copied from CoreXY-XCarraige.scad
// created: 2/3/2014
// last modified: 4/7/2020
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 1/12/16 - added bevel on rear carriage for x-stop switch to ride up on
// 1/21/16 - added Prusa i3 style extruder mount to carriage and put it into a seperate module
// 3/6/16  - added BLTouch mounting holes, sized for the tap for 3mm screws (centered behind hotend)
// 5/24/16 - adjusted carriage for i3(30mm) style mount by making it a bit wider
//			 added a proximity sensor option
// 6/27/16 - added corexy belt holder
// 7/2/16  - new file from x-carraige.scad and removed everything not needed for corexy
//			 one belt clamp set per side
// 7/3/16  - added tappable mounting holes for the endstopMS.scad holders
//			 added all() to print everything
//			 added third wall to the belt holder frame (it broke without one)
//			 added assembly info
// 7/17/16 - adjusted proximity sensor position
// 8/1/16  - added note on extruder plate & proximity sensor
// 9/11/16 - added irsensor bracket to extruder plate
// 9/16/16 - added combined rear carriage & belt holder
// 9/26/16 - design for using the E3D Titan
// 10/25/16 - added Titan mount for AL extruder plate and for mounting right on x-carraige using mount_seperation
// 11/29/16 - made titanmotor expand up/down with shiftitanup variable
// 12/18/16 - on the titan extruder plate, the titan was shifted towards the hotend side by 20mm to make the
//			  adjusting screw easier to get to.  Also, began adding color to parts for easier editing.
// 12/22/16 - changed z probe mounts and mounting for TitanExtruderPlatform() extruder plate
// 12/23/16 - cleaned up some code and fixed the screw hole sizes in prox_adapter() & iradapter()
// 12/27/16 - fixed fan mount screw holes on TitanExtruderPlatform()
// 1/8/17	- changed side mounting holes of titan3(), shifted up to allow access to lower mouting holes when
//			  assembled
// 1/9/17	- made TitanExtruderPlatform() able to be used as the titan bowden mount
// 7/9/18	- added a rounded bevel around the hotend clearance hole to the titan mount using corner-tools.scad
//			  and fixed the rear support to be rounded in TitanExtruderPlatform() and removed some unecessary code
//			  added rounded hole under motor to titan3() and fixed mounting holes
// 7/12/18	- Noticed the plate was not setup for a 200x200 bed
// 8/19/18	- Dual Titanmount is in DualTitan.scad, OpenSCAD 2018.06.01 for $preview, which is used to make sure
//			  a 200x200 bed can print multiple parts.
// 8/20/18	- Added a carridge and belt only for DualTitan.scad, redid the modules for the other setups
// 12/8/18	- Changed belt clamp from adjusting type to solid (stepper motors are adjustable)
//			  Added preview color to belt modules
//			  Added x-carriage belt drive loop style
// 12/10/18	- Edited carriage() and carriagebelt() to not use center=true for the cubeX[]
// 1/26/19	- Edited BLTouchMount() to use cubeX() for recess hole and have mounting holes defined in BLTouchMount()
//			  at fan spacing. Removed servo mounting holes. Added one piece titan direct mount on x carriage
// 1/31/18	- Fixed/added a few mounting holes
//			  Adjusted fan adapter position on TitanExtruderPlatform()
//			  Changed titan2() name to TitanExtruderBowdenMount()
//			  Removed titan3()
//			  Ziptie hole on BLTouchMount()
// 2/12/19	- Moved BeltHolder.scad into here.  Renamed BeltHolder.scad height to LoopHeight.
// 2/21/19	- Fixed bevel hole access to adjuster on carraige plate in carriagebelt()
// 2/23/19	- Combined carriagebelt() into carriage(), bug fixes, removed unused modules, renamed modules for a better
//			  description of what they do
// 3/9/19	- Added a m3 nut holder on the titanextrudermount() at the end since tapping that hole may not be strong enough
// 4/20/19	- Added a nut holder on the proximity sensor holder.
// 4/23/19	- Added nut holders for fan/sensor mount on titanextrudermount()
// 5/4/19	- Added v2 of carriage(), a simpler squared off version made with cubeX()
// 5/26/19 	- Added nut holes for the extruder & belt mounts on the Carriage();
// 5/28/18	- Rounded the corner fillers between the bottom and vertical parts of the carriage
// 6/14/19	- Added a third version of the carriage with belt as a single part
// 7/2/19	- Adjusted beltloop belt position
// 7/19/19	- Added a mirror version of the titan extruder platform, so that the adjusting screw faces the front
// 8/4/19	- Made nut holes on carriage_v2 and ExtruderPlateMount through holes
// 8/5/19	- extruderplatemount() to allow mirrored version to work
// 8/7/19	- Widened tha pc blower fan adapter mounting holes
// 10/10/19	- Added ability to add/remove led ring mount with the needed spacer
// 3/8/20	- Added ability to use 3mm brass inserts on carriage_v2() and carriage_v3(), The var Use3mmInsert enables it
// 4/7/20	- Changed 3mmBrassInsert to screw3in (dia), 3mmBrasssInsertlen to screw3inl; now in screwsizes.scad
//			  Added ability for other modules that use 3mm nut to able to use the 3mm brass inserts
// 4/11/20	- Renamed some variables and have the all in one x-carriages put together correctly,
//			  BeltLoopHolder() now uses a for loop
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// What rides on the x-axis is separate from the extruder plate
// The screw2 holes must be drilled with a 2.5mm drill for a 3mm tap or to allow a 3mm to be screwed in without tapping
// I used 3x16mm cap head screws to mount the extruder plate to the carriage
// ---------------------------------------------------------
// PLA can be used for the carriage & belt parts
// ---------------------------------------------------------
// Extruder plate use ABS or better if you have a hotend that gets hot at it's mounting.
// for example: using an E3Dv6, PLA will work fine, since it doesn't get hot at the mount.
// ---------------------------------------------------------
// Belt clamp style: Assemble both belt clamps before mounting on x-carriage, leave loose enough to install belts
// The four holes on top are for mounting an endstopMS.scad holder, tap them with a 5mm tap.
// ---------------------------------------------------------
// For the loop belt style: tap holes or brass inserts for 3mm and mount two belt holders, it's in belt_holder.scad
//----------------------------------------------------------
// If the extruder plate is used with an 18mm proximity sensor, don't install the center mounting screw, it gets
// in the way of the washer & nut.
//-----------------------------------------------------------
// Changed to using a front & rear carriage plate with the belt holder as part of it.  The single carriage plate
// wasn't solid enough, the top started to bend, loosening the hold the wheels had on the makerslide
//-----------------------------------------------------------
// To use rear carriage belt in place of the belt holder, you need three M5x50mm, three 7/8" nylon M5 spacers along
// with the three makerslide wheels, three M5 washers, three M5 nuts, two M3x16mm screws
//-----------------------------------------------------------
// corner-tools.scad fillet_r() doesn't show in preview
//////////////////////////////////////////////////////////////////////////////////////////////////////////
include <MMAX_h.scad>
use <ybeltclamp.scad>	// modified https://www.thingiverse.com/thing:863408
use <inc/corner-tools.scad>
Use3mmInsert=1; // set to 1 to use 4mm brass inserts
//Use4mmInsert=0; // set to 1 to use 4mm brass inserts
//Use5mmInsert=0; // set to 1 to use 4mm brass inserts
include <brassfunctions.scad>
//-------------------------------------------------------------------------------------------------------------
$fn=75;
TestLoop=0; // 1 = have original belt clamp mount hole visible
LoopHoleOffset=28;	// distance between the belt loop mounting holes (same as in belt_holder.scad)
LoopHOffset=0;		// shift horizontal the belt loop mounting holes
LoopVOffset=-2;		// shift vertical the belt loop mounting holes
MountThickness=5;
BeltSpacing=7;
BeltMSSpacing=10;
BeltWidth=6;
LoopHeight = 18;
VerticalCarriageWidth = 37.2;
HorizontalCarriageHeigth = 20;
//---------------------------------------------------------------------------------------------------------------
E3Dv6 = 36.5;			// hole for E3Dv6 with fan holder
ShiftTitanUp = 2.5;		// move motor +up/-down
ShiftHotend = 0;		// move hotend opening front/rear
ShiftHotend2 = -20;		// move hotend opening left/right
Spacing = 17; 			// ir sensor bracket mount hole spacing
ShiftIR = -20;			// shift ir sensor bracket mount holes
ShiftBLTouch = 10;		// shift bltouch up/down
ShiftProximity = 5;		// shift proximity sensor up/down
ShiftProximityLR = 3;	// shift proximity sensor left/right
//-----------------------------------------------------------------------------------------
// info from irsensorbracket.scad
//-----------------------------------
HotendLength = 50;	// 50 for E3Dv6
BoardOverlap = 2.5; // amount ir board overlaps sensor bracket
IRBoardLength = 17 - BoardOverlap; // length of ir board less the overlap on the bracket
IRGap = 0;			// adjust edge of board up/down
//-----------------------------------------------------------------------------------------
HeightIR = (HotendLength - IRBoardLength - IRGap) - irmount_height;	// height of the mount
//---------------------------------------------------------------------------------------------------------
LEDLight=1; // print LED ring mounting with spacer
LEDSpacer=8;
//============================================================================================================
// copied from CoreXY-XCarraige.scad
width = 75;		// width of back/front/extruder plates
dual_sep = BottomTwoHolesSeperation; // distance between bottom two wheels
tri_sep = TopHoleSeperation;	// distance between bottom two wheels and top wheel
widthE = width;	// extruder plate width
depthE = wall;	// thickness of the extruder plate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//ExtruderPlateMount(2,2); 	// 1st arg: 0 - old style hotend mount, 1 - drill guide for old style, 2 - titan/E3Dv6 mount
							//			3 - combo of 2 and x-carriage
							// 2nd arg: 0 | 1 bltouch, 2 - round proxmity, 3 - dc42's ir sensor, 4 - all, 5 - None
MirrorTitanExtruderPlatform(5,0,1,0);
//TitanCarriage(1,5,0);	// 1st arg: 0: not used
						// 2ng arg: 0 - bltouch thru hole mount; 1 - bltouch surface mount; 2 - proximity sensor
						// 			3 - dc42's ir sensor; 4 - all; 5 - none (default)
						// 3rd arg: 0-no belt attachment; 1 add belt attachment

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ExtruderPlateMount(Extruder=0,Sensor=0) {
	//if($preview) %translate([-100,-100,-5]) cube([200,200,1]);
	if(Extruder == 0)
		ExtruderPlatform(Sensor);	// for BLTouch: 0 = top mounting through hole, 1 - bottom mount in recess
							// 2 - proximity sensor hole in psensord size
							// 3 - dc42's ir sensor
	if(Extruder == 1) {			// 4 or higher = none
		// drill guide for using an AL plate instead of a printed one
		rotate([0,0,90]) ExtruderPlateDrillGuide();
	}
	if(Extruder == 2) // titan/E3Dv6 combo
		//rotate([0,0,-90]) // not needed with mirror version
			MirrorTitanExtruderPlatform(Sensor,1,1,1);
	if(Extruder == 3)
		TitanCarriage();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module partial() {
	//if($preview) %translate([-100,-100,-1]) cube([200,200,1]); // parts may not be on the preview plate
	//ExtruderPlatform(0);	// for BLTouch: 0 & 1, 2 is proximity, 3 is dc42 ir sensor, 4- none
	//translate([-50,0,0]) CarriageBeltDrive(1);	// 1 - belt loop style
	//ExtruderPlateDrillGuide();	// drill guide for using an AL plate instead of a printed one
	//wireclamp();
	//MirrorTitanExtruderPlatform(5,1,1,1); // reverse the platform to have the titan adjusting screw to the front
	//TitanExtruderPlatform(5,1,1); // reverse the platform to have the titan adjusting screw to the front
	//TitanExtruderPlatform(5,1,1);	// 1st arg: extruder platform for e3d titan with (0,1)BLTouch or
									// (2)Proximity or (3)dc42's ir sensor
									// 4 - all sensor brackets; 5 - no sensor brackets
									// 2nd arg: InnerSupport ; 3rd arg: Mounting Holes
	//TitanCarriage(); // one piece titan/E3Dv6 on x-carriage + belt drive holder
	//TitanExtruderBowdenMount(); // right angle titan mount to 2020 for bowden
	//TitanMotorMount(0);
	//ProximityMount(ShiftProximity);
	//mirror([1,1,0]) ProximityMount(ShiftProximity);
	//BLTouchMount(0,ShiftBLTouch);
	//BLTouchMount(0); // makes hole for bltouch mount
	//BeltLoopHolder(2);
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
		TitanExtruderPlatform(recess,InnerSupport,MountingHoles);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TitanCarriage(One=0,Sensor=5,Belt=0,FrontCarriage=1,MountHole=1) {
	//if($preview) %translate([-80,-20,-1]) cube([200,200,1]);
	difference() {
		translate([16.5,0,2]) color("blue") cubeX([5,60+ShiftTitanUp,wall+7],2);
		translate([dual_sep/2+width/2,-tri_sep/2+42,4]) color("yellow") cylinder(h = depth+10,d = screw5hd); // right hole
		translate([-dual_sep/2+width/2,-tri_sep/2+42,4]) color("purple") cylinder(h = depth+10,d = screw5hd); // left hole
	}
	translate([36.5,0,31]) rotate([-90,0,0]) // this puts the titan mount on the carriage
			TitanExtruderPlatform(5,0,1); // with no sensor, it's added next
	translate([0,100,0]) DoSensorBracket(Sensor);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module DoSensorBracket(Sensor) { // (0,1)BLTouch or (2)Proximity or (3)dc42's ir sensor
								 // 4 - all sensor brackets; 5 - no sensor brackets
	if(Sensor == 0 || Sensor == 1) BLTouchMount(Sensor,ShiftBLTouch); // BLTouch mount
	if(Sensor == 2) ProximityMount(ShiftProximity); // mount proximity sensor
	if(Sensor == 3) { // ir mount
		difference() {
			IRAdapter(0,HeightIR);
			translate([25,4,50]) rotate([90,0,0]) IRMountHoles(YesInsert3mm());
		}
	}
	if(Sensor==4) { // all sensor mounts
		BLTouchMount(0,ShiftBLTouch); // BLTouch mount
		translate([10,-65,0]) rotate([0,0,90]) ProximityMount(ShiftProximity); // mount proximity sensor
		translate([-20,-20,0]) difference() { // ir mount
			IRAdapter(0,HeightIR);
			translate([25,4,50]) rotate([90,0,0]) IRMountHoles(YesInsert3mm());
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module NutAccessHole(Nut=1) {
	if(!Nut) {
		translate([dual_sep/2+width/2,-tri_sep/2+42,3]) color("gray") cylinder(h = depth+10,d = screw5hd); // right
		translate([-dual_sep/2+width/2,-tri_sep/2+42,3]) color("green") cylinder(h = depth+10,d = screw5hd); // left
	} else {
		translate([dual_sep/2+width/2,-tri_sep/2+42,3]) color("gray") nut(nut5,10); // right
		translate([-dual_sep/2+width/2,-tri_sep/2+42,3]) color("green")  nut(nut5,10); // left
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module CarriageExtruderPlateNuts(){
	if(YesInsert3mm() == screw3) {
		translate([5,HorizontalCarriageHeigth+3,nut3/2+1]) rotate([90,0,0]) color("black") nut(nut3,5);
		translate([widthE/2,HorizontalCarriageHeigth-10,nut3/2+1]) rotate([90,0,0]) color("white") nut(nut3,5);
		translate([widthE-5,HorizontalCarriageHeigth+3,nut3/2+1]) rotate([90,0,0]) color("gray") nut(nut3,5);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TopMountBeltHoles(Screw=screw3in) {
	ScrewL=GetHoleLen3mm(Screw);
	echo(ScrewL);
	translate([width/4-6,height/2+2,0]) rotate([90,0,0]) color("red") cylinder(h = ScrewL, d = Screw);
	translate([-(width/4-5),height/2+2,0]) rotate([90,0,0]) color("blue") cylinder(h = ScrewL, d = Screw);
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TopMountBeltNuts(Nut=nut3) {
	translate([13,-3,-5]) color("gray") hull() {
		translate([width/2,height,nut3/2]) rotate([90,0,0]) nut(nut3,3);
		translate([width/2,height,nut3/2+12]) rotate([90,0,0]) nut(nut3,3);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BeltDriveNotch(Belt=1) {
	if(Belt) {
		difference() {
			color("pink") hull() {
				translate([15,height-10,1]) rotate([0,90,0]) cylinder(h=VerticalCarriageWidth+10,d=screw3);
				translate([15,height-6,1]) rotate([0,90,0]) cylinder(h=VerticalCarriageWidth+10,d=screw3);
			}
			translate([22,height-13,-3]) color("plum") cube([30,10,10]);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ExtruderMountHolesFn(Screw=screw3,Fragments=100,All=0) {
	translate([0,-15,0]) rotate([90,0,0]) color("red") cylinder(h = 35, d = Screw, $fn = Fragments); // center
	translate([width/2-5,-15,0]) rotate([90,0,0]) color("blue") cylinder(h = 35, d = Screw, $fn = Fragments); //right
	translate([-(width/2-5),-15,0]) rotate([90,0,0]) color("black") cylinder(h = 35, d = Screw, $fn = Fragments); // left
	if(All) {
		translate([width/4-2,-15,0]) rotate([90,0,0]) color("purple") cylinder(h = 35, d = Screw, $fn = Fragments);
		translate([-(width/4-2),-15,0]) rotate([90,0,0]) color("gray") cylinder(h = 35, d = Screw, $fn = Fragments);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanMountHoles(Screw=screw3in,Left=1) {	// fan mounting holes
	ScrewL=GetHoleLen3mm(Screw);
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

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ExtruderPlatform(recess=0) // bolt-on extruder platform
{							// used for extruder mount via a wades extruder style
	difference() {
		color("red") cubeX([widthE,heightE,wall],radius=2,center=true); // extruder side
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
		translate([width/2-5,30-wall/2,-10]) color("blue") cylinder(h = 25, r = screw3/2, $fn = 50);
		translate([-(width/2-5),30-wall/2,-10]) color("pink") cylinder(h = 25, r = screw3/2, $fn = 50);
		translate([width/4-2,30-wall/2,-10]) color("black") cylinder(h = 25, r = screw3/2, $fn = 50);
		translate([-(width/4-2),30-wall/2,-10]) color("lightblue") cylinder(h = 25, r = screw3/2, $fn = 50);
		// extruder mounting holes
		color("black") hull() {
			translate([extruder/2+2,-heightE/2+14,-8]) cylinder(h = depthE+10,r = screw4/2);
			translate([extruder/2-4,-heightE/2+14,-8]) cylinder(h = depthE+10,r = screw4/2);
		}
		color("gray") hull() {
			translate([-extruder/2+4,-heightE/2+14,-8]) cylinder(h = depthE+10,r = screw4/2);
			translate([-extruder/2-2,-heightE/2+14,-8]) cylinder(h = depthE+10,r = screw4/2);
		}
		translate([0,26,41+wall/2]) rotate([90,0,0]) FanMountHoles(YesInsert3mm());
		translate([0,-6,0.6]) rotate([0,0,90]) IRMountHoles(YesInsert3mm());
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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module NotchBottom()
{
	translate([38,-2,4]) cube([width+1,wall,wall+2], true);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module CarriageBeltDrive(Loop=0,DoRearWall=1) {
	difference() {	// base
		translate([-3,-0,0]) color("cyan") cubeX([47,40,wall],2);
		if(!Loop && (YesInsert3mm() == screw3)) {
			hull() {	// belt clamp nut access slot
				translate([-4,belt_adjust,8]) rotate([0,90,0]) color("red") nut(m3_nut_diameter,14); // make room for nut
				translate([-4,belt_adjust,4]) rotate([0,90,0]) color("blue") nut(m3_nut_diameter,14); // make room for nut
			}
			color("gray") hull() {	// belt clamp nut access slot
				translate([31,belt_adjust,8]) rotate([0,90,0]) nut(m3_nut_diameter,14);
				translate([31,belt_adjust,4]) rotate([0,90,0]) nut(m3_nut_diameter,14);
			}
		}
		// mounting screw holes to x-carriage plate
		if(DoRearWall) {
			translate([6,wall/2,-1]) rotate([0,0,0]) color("blue") cylinder(h = 15, r = screw3/2, $fn = 50);
			translate([6+(width/4+8.5),wall/2,-1]) rotate([0,0,0]) color("black") cylinder(h = 15, r = screw3/2, $fn = 50);
		}
		color("white") hull() { // plastic reduction
			translate([21,16,-5]) cylinder(h= 20, r = 8);
			translate([21,25,-5]) cylinder(h= 20, r = 8);
		}
		 // mounting holes for an endstop holder & wire chain
		translate([4,13,-5]) color("khaki") cylinder(h= 20, r = screw5t/2);
		translate([4,33,-5]) color("plum") cylinder(h= 20, r = screw5t/2);
		translate([37,13,-5]) color("gold") cylinder(h= 20, r = screw5t/2);
		translate([37,33,-5]) color("red") cylinder(h= 20, r = screw5t/2);
	}
	translate([1,2,7.8]) color("black") cube([44,37,layer]);

	difference() {	// right wall
		difference() {
			translate([-wall/2-1,0,0]) color("yellow") cubeX([wall-2,40,35],2);
			translate([-23,-4,31]) rotate([0,40,0]) color("lightgray") cube([20,60,20]);
		}
		if(!Loop) {
			translate([-wall/2-2,belt_adjust,27]) rotate([0,90,0]) color("red") cylinder(h = 2*wall, r = screw3/2);
			translate([-wall/2-2,belt_adjust,4]) rotate([0,90,0]) color("cyan") cylinder(h = 2*wall, r = screw3/2);
			translate([-0.5,belt_adjust,27]) rotate([0,90,0]) color("blue") nut(m3_nut_diameter,3);
			translate([-0.5,belt_adjust,4]) rotate([0,90,0]) color("gray") nut(m3_nut_diameter,3);
		} else BeltLoopHolderMountingHoles();
		if(TestLoop) // add one of belt clamp holes for adjusting the belt loop holder mounting holes
			translate([-wall/2-2,belt_adjust,4]) rotate([0,90,0]) color("cyan") cylinder(h = 2*wall, r = screw3/2);
	}
	if(!Loop) BeltMountingHoleBump(0);
	difference() {	// left wall
		translate([36+wall/2,0,0]) color("pink") cubeX([wall-2,40,31],2);
		translate([35,-4,34]) rotate([0,50,0]) color("red") cube([20,60,20]);
		if(!Loop) {
			translate([32,belt_adjust,4]) rotate([0,90,0]) color("red") cylinder(h = 2*wall, r = screw3/2);
			translate([32,belt_adjust,27]) rotate([0,90,0]) color("cyan") cylinder(h = 2*wall, r = screw3/2);
			translate([38.5,belt_adjust,4]) rotate([0,90,0]) color("blue") nut(m3_nut_diameter,3);
			translate([38.5,belt_adjust,27]) rotate([0,90,0]) color("gray") nut(m3_nut_diameter,3);
		} else {
			BeltLoopHolderMountingHoles();
		}
	}
	if(DoRearWall) {
		difference() {	// rear wall - adds support to walls holding the belts
			translate([-wall/2+1,42-wall,0]) color("gray") cubeX([47,wall-2,belt_adjust],2);
			translate([4,33,-5]) color("blue") cylinder(h= 25, r = screw5/2);	// clearance for endstop screws
			translate([37,33,-5]) color("red") cylinder(h= 25, r = screw5/2);
			if(Loop) BeltLoopHolderMountingHoles();
		}
	} else { // fillers
		difference() {
			union() {
				translate([-3,0,4]) color("black") cubeX([10,wall,30],2);
				translate([35,0,4]) color("gray") cubeX([10,wall,30],2);
				translate([-5,wall+28,4]) color("white") cubeX([10,wall+7,30],2);
				translate([36,wall+28,4]) color("plum") cubeX([10,wall+7,30],2);
				translate([-5,wall+27.5,0]) color("blue") cubeX([51,wall+7.5,15],2);
				translate([-2,wall-8,2.7]) color("azure") cube([45,wall,5.5]);
			}
			translate([1,wall+27,wall]) color("green") cube([39,8,50]);
			translate([-23,-4,31]) rotate([0,40,0]) color("lightgray") cube([20,60,20]);
			translate([35,-4,34]) rotate([0,50,0]) color("blue") cube([20,60,20]);
		BeltLoopHolderMountingHoles();
		}
	}
	if(!Loop) BeltMountingHoleBump(1);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BeltLoopHolderMountingHoles() { // for beltholder
	// pink side
	translate([35,8+LoopHOffset,17+LoopVOffset]) rotate([0,90,0])
		color("black") cylinder(h = GetHoleLen3mm(), d=YesInsert3mm());
	translate([35,4+LoopHoleOffset+LoopHOffset,17+LoopVOffset]) rotate([0,90,0])
		color("white") cylinder(h = GetHoleLen3mm(), d=YesInsert3mm());
	// yellow side
	translate([-10,8+LoopHOffset,17+LoopVOffset]) rotate([0,90,0])
		color("plum") cylinder(h = 2*wall, r = screw3t/2);
	translate([-10,4+LoopHoleOffset+LoopHOffset,17+LoopVOffset]) rotate([0,90,0])
		color("gray") cylinder(h = 2*wall, r = screw3t/2);
	if(YesInsert3mm() == screw3in) {
		translate([-30,8+LoopHOffset,17+LoopVOffset]) rotate([0,90,0])
			color("black") cylinder(h = GetHoleLen3mm(), d=YesInsert3mm());
		translate([-30,4+LoopHoleOffset+LoopHOffset,17+LoopVOffset]) rotate([0,90,0])
			color("white") cylinder(h = GetHoleLen3mm(), d=YesInsert3mm());
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BeltMountingHoleBump(Bump) { // add a little plastic at the belt clamp screw holes at the edge
	if(Bump) {
		difference() {	
			translate([40,belt_adjust,27]) rotate([0,90,0]) color("cyan") cylinder(h = wall-2, r = screw3+0.5);
			translate([32,belt_adjust,27]) rotate([0,90,0]) color("red") cylinder(h = 2*wall, r = screw3/2);
			translate([38.5,belt_adjust,27]) rotate([0,90,0]) color("gray") nut(m3_nut_diameter,3);
		}
	} else {
		difference() {	
			translate([-wall/2-1,belt_adjust,27]) rotate([0,90,0]) color("cyan") cylinder(h = wall-2, r = screw3+0.5);
			translate([-wall/2-2,belt_adjust,27]) rotate([0,90,0]) color("red") cylinder(h = 2*wall, r = screw3/2);
			translate([-0.5,belt_adjust,27]) rotate([0,90,0]) color("gray") nut(m3_nut_diameter,3);
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BeltAdjuster() {
	difference() {
		translate([-1,0,0]) color("blue") cubeX([9,30,9],2);
		translate([-1.5,5.5,7]) color("red") cube([11,7,3.5]);
		translate([-1.5,16.5,7]) color("cyan") cube([11,7,3.5]);
		translate([4,3,-5]) color("white") cylinder(h = 2*wall, r = screw3/2);
		translate([4,26,-5]) color("plum") cylinder(h = 2*wall, r = screw3/2);
		translate([-5,9,4.5]) rotate([0,90,0]) color("gray") cylinder(h = 2*wall, r = screw3/2);
		translate([-2,9,4.5]) rotate([0,90,0]) color("black") nut(m3_nut_diameter,3);
		translate([-5,20,4.5]) rotate([0,90,0]) color("khaki") cylinder(h = 2*wall, r = screw3/2);
		translate([7,20,4.5]) rotate([0,90,0]) color("gold") nut(m3_nut_diameter,3);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BeltAnvil()
{
	translate([0,0,-3]) rotate([0,0,90]) difference() {
		rotate([0,90,0]) cylinder(h = 9, r = 4, $fn= 100);
		translate([3,0,-6]) cube([15,10,10],true);
		translate([4,0,-3]) cylinder(h = 5, r = screw3/2,$fn = 50);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Belt_RoundClamp() { // something round to let the belt smoothly move over when using the tensioner screw
	rotate([0,90,90]) difference() {
		cylinder(h = 30, r = 4, $fn= 100);
		translate([-6,0,3]) rotate([0,90,0])cylinder(h = 15, r = screw3/2,$fn = 50);
		translate([-6,0,26]) rotate([0,90,0])cylinder(h = 15, r = screw3/2,$fn = 50);
		translate([4.5,0,8]) cube([2,8,45],true); // flatten the top & bottom
		translate([-4.5,0,8]) cube([2,8,45],true);
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module CarridgeMount(Screw=screw4) { // four mounting holes for using seperate mounting extruder brcket
	// lower
	translate([mount_seperation/2,-height/4 + mount_height,-5]) color("black") cylinder(h = wall+10, d = Screw,$fn = 50);
	translate([-mount_seperation/2,-height/4+ mount_height,-5]) color("blue") cylinder(h = wall+10, d = Screw,$fn = 50);
	// upper
	translate([mount_seperation/2,-height/4 + mount_height + mount_seperation,-5])
		color("red") cylinder(h = wall+10, d = Screw,$fn = 50);
	translate([-mount_seperation/2,-height/4+ mount_height + mount_seperation,-5])
		color("plum") cylinder(h = wall+10, d = Screw,$fn = 50);
}

////////////////////////////////////////////////////////////////////

module ExtruderPlateDrillGuide() { // for drilling 1/8" 6061 in place of a printed extruder plate
	// Use the printed extruder plate as a guide to making an aluminum version
	difference() {
		color("cyan") cube([width,wall,wall],true);
		// screw holes to mount extruder plate
		translate([0,10,0]) rotate([90,0,0]) color("red") cylinder(h = 25, r = screw3/2, $fn = 50);
		translate([width/2-5,10,0]) rotate([90,0,0]) color("blue") cylinder(h = 25, r = screw3/2, $fn = 50);
		translate([-(width/2-5),10,0]) rotate([90,0,0]) color("black") cylinder(h = 25, r = screw3/2, $fn = 50);
		translate([width/4-2,10,0]) rotate([90,0,0]) color("gray") cylinder(h = 25, r = screw3/2, $fn = 50);
		translate([-(width/4-2),10,0]) rotate([90,0,0]) color("yellow") cylinder(h = 25, r = screw3/2, $fn = 50);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module IRAdapter(Top,Taller=0) {  // ir sensor bracket stuff is from irsensorbracket.scad
	difference() {
		color("plum") cubeX([irmount_width,irmount_height+Taller,irthickness],2); // mount base
		ReduceIR(Taller);
		IRMountingHoles(Taller);
		RecessIR(Taller);
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

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TitanTensionHole() {
	color("pink") cylinder(h=10,d=20);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BeltClamps(Clamps=0,Loop=0) // belt clamps
{
	if(Clamps && !Loop) {
		translate([-35,-10,-0.5]) color("red") Belt_RoundClamp();
		translate([-50,-10,-4.5]) color("blue") BeltAdjuster();
		translate([-45,-40,0]) color("black") BeltAnvil();
		translate([-35,25,-0.5]) color("cyan") Belt_RoundClamp();
		translate([-50,25,-4.5]) color("purple") BeltAdjuster();
		translate([-45,-25,0]) color("gray") BeltAnvil();
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TitanExtruderPlatform(recess=3,InnerSupport=0,MountingHoles=1) { // extruder platform for e3d titan with (0,1)BLTouch or
	difference() {										// (2)Proximity or (3)dc42's ir sensor
		union() {
			translate([-37.5+17,-42,-wall/2])
				color("cyan") cubeX([widthE+ShiftHotend2/1.3-17,heightE+13,wall],2); // extruder side
			translate([14,21,-wall/2]) color("plum") cubeX([25,10,wall],2);
			translate([-38,21,-wall/2]) color("blue") cubeX([25,10,wall],2);
		}
		if(MountingHoles) ExtruderMountHoles(screw3);
 		if(LEDLight) LEDRingMount();		 // remove some under the motor
		translate([20+ShiftHotend2,-5,-10]) color("pink") cylinder(h=20,d=23.5);
	    translate([0,-5,wall/2]) color("purple") fillet_r(2,23/2,-1,$fn);	// round top edge
	    translate([0,-5,-wall/2]) color("purple") rotate([180]) fillet_r(2,23/2,-1,$fn);	// round bottom edge
	    
		
		translate([-50,0,44.5]) rotate([90,0,90]) FanMountHoles(YesInsert3mm()); // mounting holes for bltouch & prox sensor
		translate([-10,70,0]) IRMountHoles(YesInsert3mm()); // mounting holes for irsensor bracket
		translate([-10,20,45]) rotate([90,0,0]) PCFanMounting(screw3);
		if(!Use3mmInsert) translate([15,15,0]) rotate([90,0,0]) PCFanNutHoles(nut3);

	}
	if(LEDLight) translate([0,0,-4]) ScrewSpacer(LEDSpacer,screw5);
	difference() {
		translate([ShiftHotend2,-32,0]) rotate([90,0,90]) TitanMotorMount(0,0,InnerSupport);
		translate([-50,0,44.5]) rotate([90,0,90]) FanMountHoles(YesInsert3mm()); // mounting holes for bltouch & prox sensor
	}
	if(recess != 5) {
		if(recess == 0 || recess == 1) translate([-13,40,-wall/2]) BLTouchMount(recess,ShiftBLTouch); // BLTouch mount
		if(recess == 2) translate([10,45,-wall/2]) ProximityMount(ShiftProximity); // mount proximity sensor
		if(recess == 3) { // ir mount
			translate([0,33,-wall/2]) difference() {
				IRAdapter(0,HeightIR);
				translate([25,4,40]) rotate([90,0,0]) IRMountHoles(YesInsert3mm());
			}
		}
		if(recess==4) {
			translate([-50,37,-wall/2]) BLTouchMount(0,ShiftBLTouch); // BLTouch mount
			translate([39,55,-wall/2]) ProximityMount(ShiftProximity); // mount proximity sensor
			translate([10,35,-wall/2]) difference() { // ir mount
				IRAdapter(0,HeightIR);
				translate([25,4,40]) rotate([90,0,0]) IRMountHoles(YesInsert3mm());
			}
		}
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
		rotate([0,90,0]) color("pink") cylinder(h = depthE+screw_depth,d = Screw);
	translate([-extruder/2+35,-heightE/2 - 1.8*wall,heightE - extruder_back + fan_spacing/2 + fan_offset])
		rotate([0,90,0]) color("skyblue") cylinder(h = depthE+screw_depth,d = Screw);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PCFanNutHoles(Nut=nut3) {	// fan mounting holes
	translate([0,-10,0]) rotate([0,90,0]) color("blue") hull() {	// nut trap for fan
		nut(nut3,3);
		translate([0,18,0]) nut(nut3,3);
	}
	translate([0,-10,PCfan_spacing-15]) rotate([0,90,0]) color("plum") hull() {	// nut trap for fan
		nut(nut3,3);
		translate([0,18,0]) nut(nut3,3);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module E3Dv6Hole() {
		// hole for E3Dv6, shifted to front by 11mm
	hull() {
		translate([-15.5+ShiftHotend2,-18+ShiftHotend,-10]) color("pink") cylinder(h=20,d=E3Dv6);
		translate([-15.5+ShiftHotend2,5+ShiftHotend,-10]) color("pink") cylinder(h=20,d=E3Dv6);
	}
		// round top edge
	    //translate([-15.5+ShiftHotend2,-18+ShiftHotend,wall/2]) color("purple") fillet_r(2,E3Dv6/2,-1,$fn);
		// round bottom edge
	    //translate([-15.5+ShiftHotend2,-18+ShiftHotend,-wall/2]) rotate([180]) color("purple") fillet_r(2,E3Dv6/2,-1,$fn);

}
    
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ProximityMount(Shift) {
	translate([ShiftProximityLR,0,0]) difference() {
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
		if(Type==0) translate([35,0,bltdepth-2]) BLTouchMountHole(Type); // blt body hole
		if(Type==1) translate([35,0,bltdepth+3]) BLTouchMountHole(Type); // no blt body hole
	}
	difference() {
		translate([-1,26,0]) color("cyan") cubeX([56,5,5+Shift],2);
		BLTouchBracketMountHoles(Shift);
		translate([52,35,Shift]) rotate([90,0,0]) color("gold") cylinder(h=20,d=screw3+0.5); // a ziptie hole
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BLTouchMountHole(Ver=0) { // BLTouch mount
	if(Ver == 0) {
		translate([-bltl/2,bltw/2,bltdepth]) { // hole for BLTouch
			// it needs to be deep enough for the retracted pin not to touch bed
			color("red") cubeX([bltl,bltw,wall],2);
		}
		translate([-bltl/2+8,bltw/2,-5]) color("blue") cube([bltd,bltd+2,wall*2]); // hole for BLTouch
		translate([bltouch/2,16,-10]) color("cyan") cylinder(h=25,r=screw2/2);
		translate([-bltouch/2,16,-10]) color("purple") cylinder(h=25,r=screw2/2);
	} else { // mounting holes only
		translate([bltouch/2,16,-10]) color("cyan") cylinder(h=25,r=screw2/2);
		translate([-bltouch/2,16,-10]) color("purple") cylinder(h=25,r=screw2/2);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BLTouchBracketMountHoles(Shift) {
	translate([4,33,Shift]) color("black") hull() { // free end, slot it bit
		translate([-0.5,0,0]) rotate([90,0,0]) cylinder(h=20,d=screw3);
		translate([0.5,0,0]) rotate([90,0,0]) cylinder(h=20,d=screw3);
	}
	translate([19,35,Shift]) color("plum") rotate([90,0,0]) color("plum") cylinder(h=20,d=screw3); // center
	translate([4+fan_spacing,33,Shift]) rotate([90,0,0]) color("gray") cylinder(h=20,d=screw3); // under bltouch
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module IRBracketMountHoles(Shift) {
	translate([4,33,Shift]) color("black") rotate([90,0,0]) cylinder(h=20,d=screw3);
	translate([19,35,Shift]) color("plum") rotate([90,0,0]) color("plum") cylinder(h=20,d=screw3); // center
	translate([4+fan_spacing,33,Shift]) rotate([90,0,0]) color("gray") cylinder(h=20,d=screw3);
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TitanExtruderBowdenMount() { // extruder bracket for e3d titan to mount on a AL extruder plate
	difference() {
		translate([0,0,0]) cubeX([40,53,5],2); // extruder side
		translate([20,28,-10]) cylinder(h=20,d=20); // remove some plastic under the motor
		translate([10,10,-1]) cylinder(h=20,d=screw4); // mounting screw hole
		translate([30,10,-1]) cylinder(h=20,d=screw4); // mounting screw hole
		translate([10,45,-1]) cylinder(h=20,d=screw4); // mounting screw hole
		translate([30,45,-1]) cylinder(h=20,d=screw4); // mounting screw hole
	}
	translate([0,1,0]) rotate([90,0,90]) TitanMotorMount();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ExtruderMountHoles(Screw=screw3,All=0) {		// screw holes to mount extruder plate
	if(Screw==screw3) {
		translate([0,30-wall/2,-10]) color("red") cylinder(h = 25, d = Screw); // center
		translate([width/2-5,30-wall/2,-10]) color("white") cylinder(h = 25, d = Screw); // right
		translate([-(width/2-5),30-wall/2,-10]) color("lightblue") cylinder(h = 25, d = Screw); // left
		if(All) {
			translate([width/4-2,30-wall/2,-10]) color("green") cylinder(h = 25, d = Screw); // 2nd from right
			translate([-(width/4-2),30-wall/2,-10]) color("purple") cylinder(h = 25, d = Screw); // 2nd from left
		}
	}
	if(Screw==screw5) {
		translate([-(width/2-5),30-wall/2,-10]) color("lightblue") cylinder(h = 25, d = Screw);
		translate([-(width/4-10),30-wall/2,-10]) color("red") cylinder(h = 25, d = Screw);
		translate([width/4-2,30-wall/2,-10]) color("green") cylinder(h = 25, d = Screw);
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

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module IRMountHoles(Screw=screw3) // ir screw holes for mounting to extruder plate
{
	if(Use3mmInsert) {
		translate([Spacing+ShiftIR+ShiftHotend,-107,0]) rotate([90,0,0]) color("blue")
			cylinder(h=screw3inl*2,d=screw3in);
		translate([Spacing+ShiftIR+ShiftHotend,-45,0]) rotate([90,0,0]) color("red") cylinder(h=3*(depthE+screw_depth),d=Screw);
	} else {
		translate([Spacing+ShiftIR+ShiftHotend,-45,0]) rotate([90,0,0]) color("red") cylinder(h=3*(depthE+screw_depth),d=Screw);
		translate([-3,-108.5,5]) rotate([0,90,90]) color("red") hull() {	// nut trap for sensor
			rotate([0,0,0]) nut(nut3,3);
			translate([18,0,0]) rotate([0,0,0]) nut(nut3,3);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////

module BeltLoopHolder(Quanity=1) {
	for(a=[0:Quanity-1]) {
		difference() {
			translate([a*-30,0,BeltMSSpacing-BeltWidth]) color("blue") cubeX([23,16,LoopHeight],1);
			translate([a*-30-1,3,-2]) beltLoop(); // lower
			translate([a*-30-1,3,BeltMSSpacing+BeltSpacing-1]) beltLoop(); // upper
		}
		translate([a*-30+19,-8,0]) BeltLoopMountingBlock();
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////

module BeltLoopMountingBlock() {
	difference() {
		translate([0,0,BeltMSSpacing-BeltWidth]) color("pink") cubeX([MountThickness,32,LoopHeight],1);
		translate([-5,LoopHoleOffset,BeltMSSpacing+BeltWidth/2]) rotate([0,90,0]) color("red") cylinder(h=LoopHeight,d=screw3);
		translate([-17,LoopHoleOffset,BeltMSSpacing+BeltWidth/2]) rotate([0,90,0]) color("plum") cylinder(h=LoopHeight,d=screw3hd);
		translate([-5,4,BeltMSSpacing+BeltWidth/2]) rotate([0,90,0]) color("blue") cylinder(h=LoopHeight,d=screw3);
		translate([-17,4,BeltMSSpacing+BeltWidth/2]) rotate([0,90,0]) color("red") cylinder(h=LoopHeight,d=screw3hd);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module roundedinner() {
	rotate([0,0,-45]) {
		difference() {
			translate([0,0,0]) color("red") cube([10,10,wall]);
			translate([5,11.9,-2]) color("blue") cylinder(h=wall+5,d=12);
			translate([5,12,wall]) fillet_r(1.5,6,-1,100);
			translate([5,12,0]) rotate([0,180,0]) fillet_r(1.5,6,-1,100);
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////

module ScrewSpacer(Length=10,Screw=screw5) {
	difference() {
		color("blue") cylinder(h=Length,d=Screw*2,$fn=100);
		translate([0,0,-2]) color("red") cylinder(Length+4,d=Screw,$fn=100);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////

//function GetHoleLen3mm(Screw) =	(Screw==screw3in) ? screw3inl*2.5 : depthE+screw_depth;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//function YesInsert3mm() = (Use3mmInsert==1) ? screw3in : screw3;

///////////////////end of x-carriage.scad////////////////////////////////////////////////////////////////////////////
