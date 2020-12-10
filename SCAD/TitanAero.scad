///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// DualTitanAero - titan w/e3dv6 or titan aero
// created: 10/14/2020
// last modified: 11/15/20
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 1/12/16	- added bevel on rear carriage for x-stop switch to ride up on
// 5/30/20	- Added ability to use a Titan Aero on mirrored version
// 6/4/20	- Removed some unecessary code
// 8/2/20	- Edited for the CXY-MSv1 files
// 10/13/20	- Changed width of base to allow 42mm long stepper motor
// 10/14/20	- Converted to single to dual
// 11/14/20	- Made SingleAero() adjustable for different stepper lengths
// 11/15/20	- Made DualAero() adjustable for different stepper lengths
//////////////////////////////////////////////////////////////////////////////////////////////////////////
include <MMAX_h.scad>
include <inc/brassinserts.scad>
//-------------------------------------------------------------------------------------------------------------
Use3mmInsert=1; // set to 1 to use 3mm brass inserts
Use5mmInsert=1;
LargeInsert=1;
ExtruderThickness = wall;	// thickness of the extruder plate
Spacing = 17; 			// ir sensor bracket mount hole spacing
LayerThickness=0.3;
//---------------------------------------------------------------------------------------------------------
LEDLight=1; // print LED ring mounting with spacer
LEDSpacer=0;//8;  // length need for titan is 8; length need for aero is 0
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//DualAero(1,1,0,35,0); // 35 for e3d .9 degree short stepper
SingleAero(1,0,0,35,0,1); // e3d short stepper motor .9 degree with heatsink on end
translate([50,-38,0]) Brace(1);  // something to help with drooping over time

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Brace(DoTab=0) {
	difference() {
		union() {
			color("cyan") cubeX([55,4,5],1);
			translate([0,59,0]) color("blue") cubeX([55,4,5],1);
			color("red") cubeX([4,63,5],1);
		}
		translate([52,65,2.6]) color("plum") rotate([90,0,0]) cylinder(h=70,d=screw3);
	}
	if(DoTab) {
		translate([52,59,0]) color("black") cylinder(h=LayerThickness,d=20);
		translate([52,2,0]) color("gray") cylinder(h=LayerThickness,d=20);
		translate([2,59,0]) color("green") cylinder(h=LayerThickness,d=20);
		translate([2,2,0]) color("pink") cylinder(h=LayerThickness,d=20);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////

module DualAero(Mounting=1,DoTab=1,DoNotch=0,StepperLength=45,ShowLength=0) {
	TitanDual(Mounting,DoTab,DoNotch,StepperLength,ShowLength);
}

/////////////////////////////////////////////////////////////////////////////////////////

module SingleAero(Mounting=1,DoTab=1,DoNotch=0,StepperLength=45,ShowLength=0,BraceAttachment=0) {
	TitanSingle(Mounting,DoTab,DoNotch,StepperLength,ShowLength,BraceAttachment);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TitanDual(Mounting=1,DoTab=1,DoNotch=0,StepperLength=45,ShowLength=0) {
	// extruder platform for e3d titan with (0,1)BLTouch or (2)Proximity or (3)dc42's ir sensor
	if(ShowLength) %translate([-15,0,wall/2]) cube([StepperLength,10,10]); // check for room for the StepperLength
	difference() {
		DualBase(StepperLength);
		SensorAnd1LCMountDual();
	}
	if(LEDLight && LEDSpacer) translate([0,40,-4]) LED_Spacer(LEDSpacer,screw5);
	difference() {
		translate([-0.5,-32,0]) rotate([90,0,90]) TitanMotorMount();
		translate([-24,19,-2]) color("plum") cubeX([wall*2,36,wall],3); // clearance for hotend
		translate([-24,-25,-2]) color("pink") cubeX([wall*2,36,wall],3); // clearance for hotend
		SensorAnd1LCMountDual();
		if(DoNotch) {
			color("blue") hull() {
				translate([-22,33,55])cube([wall,10,1]); // cut out to allow motor be install after nount to xcarriage
				translate([-22,30.5,35]) cube([wall,15,1]);
			}
			color("green") hull() {
				translate([-22,-11.5,55])cube([wall,10,1]); // cut out to allow motor be install after nount to xcarriage
				translate([-22,-14.25,35]) cube([wall,15,1]);
			}
		}
	}
	if(DoTab) {
		translate([-17,59,-4]) color("green") AddTab();
		translate([-17,16,-4]) color("gray") AddTab();
		translate([-17,-29,-4]) AddTab();
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module SensorAnd1LCMountDual() {
	translate([-16,90,0]) SensorAnd1LCMounting(Yes3mmInsert(Use3mmInsert,LargeInsert)); // mounting holes for irsensor bracket
	translate([1,90,0]) SensorAnd1LCMounting(Yes3mmInsert(Use3mmInsert,LargeInsert)); // mounting holes for irsensor bracket
	translate([-16,175,0]) SensorAnd1LCMounting(Yes3mmInsert(Use3mmInsert,LargeInsert)); // mounting holes for irsensor bracket
	translate([1,175,0]) SensorAnd1LCMounting(Yes3mmInsert(Use3mmInsert,LargeInsert)); // mounting holes for irsensor bracket
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module DualBase(StepperLength=45) {
	union() {
		translate([StepperLength-5,0,0]) DualExtruderAttachment(Mounting=1);
		translate([-21,-33,-wall/2]) color("blue") cubeX([45,10,wall],1);
		translate([-21,10,-wall/2]) color("cyan") cubeX([45,10,wall],1); // middle
		translate([-21,54,-wall/2]) color("green") cubeX([45,10,wall],1);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module DualExtruderAttachment(Mounting=1) {
	difference() {
		translate([-20,-35,-wall/2]) color("lightgray") cubeX([20,HorizontallCarriageWidth+25,wall],1); // extruder side
		if(Mounting) translate([-5,16,10]) rotate([90,0,90]) ExtruderMountHoles();
		if(LEDLight) {
			translate([-37,0,0]) {
				translate([0,-16,0]) LEDRingMount();
				translate([0,41,0]) LEDRingMount();
			}
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TitanSingle(Mounting=1,DoTab=1,StepperNotch=0,StepperLength=45,ShowLength=0,BraceAttachment=0) {
	//single titan aero and should work with a titan with e3dv6
	if(ShowLength) %translate([-17,0,wall/2]) cube([StepperLength,10,10]); // check for room for the StepperLength
	difference() {
		SingleBase(StepperLength,Mounting);
		SensorAnd1LCMountSingle();
	}
	if(LEDLight && LEDSpacer) translate([0,40,-4]) LED_Spacer(LEDSpacer,screw5);
	difference() {
		translate([-0.5,-32,0]) rotate([90,0,90]) TitanMotorMountSingle();
		translate([-24,-25,-3]) color("plum") cubeX([wall*2,38,wall],3); // clearance for hotend
		SensorAnd1LCMountSingle();
		if(StepperNotch) color("green") hull() {
			translate([-22,-11.5,55])cube([wall,10,1]); // cut out to allow motor be install after nount to xcarriage
			translate([-22,-14.25,35]) cube([wall,15,1]);
		}
	}
	if(BraceAttachment) {
		translate([-14,21,52]) {
			difference() {
				color("blue") rotate([90,0,0]) cylinder(h=4,d=screw5hd+1);
				translate([0,1,0]) color("pink") rotate([90,0,0]) cylinder(h=6,d=Yes3mmInsert(Use3mmInsert,LargeInsert));
			}
		}
		translate([-14,-30,52]) {
			difference() {
				color("blue") rotate([90,0,0]) cylinder(h=4,d=screw5hd+1);
				translate([0,1,0]) color("pink") rotate([90,0,0]) cylinder(h=6,d=Yes3mmInsert(Use3mmInsert,LargeInsert));
			}
		}
	}
	if(DoTab) {
		translate([-17,16,-4]) color("gray") AddTab();
		translate([-17,-29,-4]) AddTab();
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module SingleBase(StepperLength=45,Mounting=1) {
	union() {
		translate([StepperLength-5,0,0]) ExtruderAttachment(Mounting);
		translate([-21,-35,-wall/2]) color("gray") cubeX([45,10,wall],1); // extruder side
		translate([-21,12,-wall/2]) color("black") cubeX([45,10,wall],1); // extruder side
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ExtruderAttachment(Mounting=1) {
	difference() {
		translate([-20,-35,-wall/2]) color("lightgray")
			cubeX([20,HorizontallCarriageWidth-18,wall],1); // extruder side
		if(Mounting) translate([-5,1,10]) rotate([90,0,90]) ExtruderMountHoles();
		if(LEDLight) translate([-38,-15,0]) LEDRingMount();
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module AddTab() {
	color("black") cylinder(h=LayerThickness,d=20);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module SensorAnd1LCMountSingle() {
	translate([-16,91,0]) SensorAnd1LCMounting(Yes3mmInsert(Use3mmInsert,LargeInsert)); // mounting holes for irsensor bracket
	translate([1,91,0]) SensorAnd1LCMounting(Yes3mmInsert(Use3mmInsert,LargeInsert)); // mounting holes for irsensor bracket
	translate([-16,130,0]) SensorAnd1LCMounting(Yes3mmInsert(Use3mmInsert,LargeInsert)); // mounting holes for irsensor bracket
	translate([1,130,0]) SensorAnd1LCMounting(Yes3mmInsert(Use3mmInsert,LargeInsert)); // mounting holes for irsensor bracket
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module SensorAnd1LCMounting(Screw=Yes3mmInsert(Use3mmInsert,LargeInsert)) // ir screw holes for mounting to extruder plate
{
	translate([Spacing,-107,0]) rotate([90,0,0]) color("blue") cylinder(h=20,d=Screw);
	translate([0,-107,0]) rotate([90,0,0]) color("red") cylinder(h=20,d=Screw);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module LEDRingMount(Screw=Yes5mmInsert(Use5mmInsert)) {
	// a mounting hole for a holder for 75mm circle led
	translate([25,2,-10]) color("white") cylinder(h=20,d=Screw);
	if(!Use5mmInsert) translate([30.5+ShiftHotend2,12.5+ShiftHotend,1.5]) color("black") nut(nut5,5);
}

////////////////////////////////////////////////////////////////////////////////////////////////////

module LED_Spacer(Length=10,Screw=screw5) {
	difference() {
		color("blue") cylinder(h=Length,d=Screw*2,$fn=100);
		translate([0,0,-2]) color("red") cylinder(Length+4,d=Screw,$fn=100);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TitanMotorMount() {
	difference() {	// motor mount
		translate([-1,0,-20.5]) color("red") cubeX([96,51,5],1);
		translate([25,27,-22]) rotate([0,0,45]) color("purple") NEMA17_x_holes(8,1);
		translate([70,27,-22]) rotate([0,0,45]) color("blue") NEMA17_x_holes(8,1);
	}
	translate([-50,0,-20]) TitanSupport();
	translate([42,0,-20]) TitanSupport();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TitanMotorMountSingle() {
	difference() {	// motor mount
		translate([-2,0,-20.5]) color("red") cubeX([55,51,5],1);
		translate([25,27,-22]) rotate([0,0,45]) color("purple") NEMA17_x_holes(8,1);
		//translate([70,27,-22]) rotate([0,0,45]) color("blue") NEMA17_x_holes(8,1);
	}
	translate([0,0,-20]) color("blue") TitanSupport();
	translate([-51,0,-20]) TitanSupport();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TitanSupport() {
	difference() { // rear support
		translate([49,47.5,-1.5]) rotate([50]) color("cyan") cubeX([4,6,69],1);
		translate([47,-1,-67]) color("gray") cube([7,70,70]);
		translate([47,-73,-26]) color("lightgray") cube([7,75,75]);
	}
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ExtruderMountHoles(Screw=screw3,All=1) {		// screw holes to mount extruder plate
	translate([0,0,0]) rotate([90,0,0]) color("blue") cylinder(h = 20, d = Screw);
	translate([HorizontallCarriageWidth/2-5,0,0]) rotate([90,0,0]) color("red") cylinder(h = 20, d = Screw);
	translate([-(HorizontallCarriageWidth/2-5),0,0]) rotate([90,0,0]) color("black") cylinder(h = 20, d = Screw);
	if(All) {	
		translate([HorizontallCarriageWidth/4-2,0,0]) rotate([90,0,0]) color("gray") cylinder(h = 20, d = Screw);
		translate([-(HorizontallCarriageWidth/4-2),0,0]) rotate([90,0,0]) color("cyan") cylinder(h = 20, d = Screw);
	}
}

