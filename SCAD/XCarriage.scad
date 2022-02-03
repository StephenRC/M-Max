///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// XCarriage - x carriage for M-Max using makerslide
// created: 2/3/2014
// last modified: 1/29/22
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// https://creativecommons.org/licenses/by-sa/4.0/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 9/2/18	- Original file modified for MMAX, extruder plate and top mounting belt removed
// 12/10/18	- Changed to loop type bel holder on carraiage
// 5/6/19	- Added carriage_v2() from corexy-x-carriage.scad
// 4/9/20	- Added ability to use 3mm brass inseerts
// 8/8/20	- Renamed Carriage_v2() to Carriage(), add use of 5mm insertes in Carriage()
// 9/16/20	- Added a complete version of the xcarraige and extruder with the belt mount
// 10/17/20	- Changed the extruder mount to allow dual titan aeros
// 11/15/20	- Changed mounting holes to pick form Aero mount (4) and non Aero (5),
//			  Adjusted m5 countersink on front carriage to clear Aero mount M3 brass inserts
// 1/9/21	- Added mount holes on top for a wirechain
// 2/21/21	- Added two M4 holes into carriage for mounting of the exoslide BMG adapter
// 4/6/21	- Began BOSL2 conversion
// 1/25/22	- Now broken
// 1/29/22	- BOSL2 and fixed broken modules
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// uses http://www.thingiverse.com/thing:211344 for the y belt
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <MMAX_h.scad>
include <inc/Brassinserts.scad>
use <TitanAero.scad>
use <HorizontalXBeltDrive.scad>
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Use3mmInsert=1;
Use4mmInsert=1;
Use5mmInsert=1;
LargeInsert=1;
//Tshift=0;	// shift titan knob clearance notch
BeltShift=10; // move belt holder up/down
BeltHoleShift=5; // move belt holder up/down
VerticalCarriageWidth=37.2;
HorizontallCarriageHeight=20;
LayerThickness=0.3;
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//xcar(1,1,1);
//cableholder();
//Carriage(); // front
//Carriage(0,0,1,0,0,1); // rear
//XCarriageWithExtruder(1,1);
XCarriageFullAssemblySingle(1,0,1,0,35);  // StepperLength 35 (pancake) or 45
//XCarriageFullAssemblyDual(1,1,0,35);
//XCarriageFullAssemblyNoExtruder(1,1,0,1,1);

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module XCarriageFullAssemblySingle(Titan,Stiffner=0,DoTab=0,AeroMount=0,StepperLength=45) {
	if(StepperLength==35)
		translate([-6,StepperLength-61,-10]) rotate([0,0,90]) SingleAero(1,1,1,StepperLength,0,1);
	else if(StepperLength==45)
		translate([-6,StepperLength-81,-10]) rotate([0,0,90]) SingleAero(0,1,1,StepperLength,0,1);
	if(Stiffner) translate([45.8,-13,40]) color("blue") cuboid([10,10,10],rounding=2,p1=[0,0]); // connect extruder top to xcarriage
	translate([0,0,1]) rotate([90,0,0]) Carriage(0,0,0,0,0,0); // rear
	translate([0,41.3,1]) rotate([90,0,0]) Carriage(0,0,1,0,0,0); // rear
	translate([-34,4.15,-3]) {
		difference() {
			union() {
				translate([35,16.5,90]) rotate([180,0,0]) BeltCarriageMount(0);
				translate([12,-wall-0.15,80]) color("red") cuboid([10,wall,13],rounding=2,p1=[0,0]);
				translate([12,33.15,80]) color("pink") cuboid([10,wall,13],rounding=2,p1=[0,0]);
				translate([52.5,-wall-0.15,80]) color("blue") cuboid([10,wall,13],rounding=2,p1=[0,0]);
				translate([52,33.15,80]) color("green") cuboid([10,wall,13],rounding=2,p1=[0,0]);
			}
			translate([16,-10,70]) color("khaki") rotate([0,-45,0]) cuboid([10,55,25],rounding=2,p1=[0,0]);
			translate([52,-10,78]) color("gray") rotate([0,45,0]) cuboid([10,55,25],rounding=2,p1=[0,0]);
			translate([20,0,90]) WirechainMount();
		}
		//difference() {
			translate([15,0,89.5]) color("gray") cube([40,40,LayerThickness]);
		//	translate([20,0,85]) WirechainMount();
		//}
	}
	// make rear xcarriage bottom level with front
	translate([-37.5,37.3,-14]) color("black") cuboid([VerticalCarriageWidth*2+0.6,wall,10],rounding=2,p1=[0,0]);
	// neaten up exterude mount to xcarriage
	translate([-37.5,-wall+4,-14]) color("white") cuboid([VerticalCarriageWidth*2+0.6,wall,8.5],rounding=2,p1=[0,0]);
	translate([-53,15,-14]) Brace(1);
	if(DoTab) {
		translate([-37,41,-14]) color("green") cylinder(h=LayerThickness,d=20);
		translate([35,41,-14]) color("plum") cylinder(h=LayerThickness,d=20);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module WirechainMount(Screw=screw5) {
	color("red") cylinder(h=20,d=Yes5mmInsert(Use5mmInsert));
	translate([30,0,0]) color("blue") cylinder(h=20,d=Yes5mmInsert(Use5mmInsert));
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module XCarriageFullAssemblyNoExtruder(Titan,ExtruderMountType=1,Stiffner=0,DoTab=0,AeroMount=0) {
	translate([0.25,0,1]) rotate([90,0,0]) Carriage(Titan,0,0,1,AeroMount,0); // front
	if(Stiffner) translate([45.8,-13,40]) color("blue") cuboid([10,10,10],rounding=2,p1=[0,0]); // connect extruder top to xcarriage
	translate([0,41.3,1]) rotate([90,0,0]) Carriage(0,0,1,0,0,0); // rear
	difference() {
		union() {
			translate([0,20.65,85]) rotate([180,0,0]) BeltCarriageMount(0);
			translate([-25,-4,70]) color("red") cuboid([10,wall,18],rounding=2,p1=[0,0]);
			translate([-25,37.3,70]) color("pink") cuboid([10,wall,18],rounding=2,p1=[0,0]);
			translate([15,-4,70]) color("blue") cuboid([10,wall,18],rounding=2,p1=[0,0]);
			translate([15,37.3,70]) color("green") cuboid([10,wall,18],rounding=2,p1=[0,0]);
		}
		translate([-20,-7,61]) color("khaki") rotate([0,-45,0]) cuboid([10,55,25]);
		translate([14,-7,69]) color("gray") rotate([0,45,0]) cuboid([10,55,25]);
		translate([-16,1.5,80]) WirechainMount();
	}
	if(DoTab) {
		translate([-37,3.5,-10]) difference() {
			union() {
				translate([2,-4,1]) color("gray") cylinder(h=LayerThickness,d=20);
				translate([72,-3,1]) color("black") cylinder(h=LayerThickness,d=20);
			}
			if(!AeroMount)
				translate([37,-3.5,30]) rotate([90,0,0]) ExtruderMountHolesFn(Yes3mmInsert(Use3mmInsert),25);
			else 
				translate([29,-3.5,30]) rotate([90,0,0]) ExtruderMountHolesFn4(Yes3mmInsert(Use3mmInsert),25);
		}
		translate([-38,41,-9]) color("green") cylinder(h=LayerThickness,d=20);
		translate([35,41,-9]) color("plum") cylinder(h=LayerThickness,d=20);
	}
	translate([-20,-2,84.5]) color("gray") cube([40,40,LayerThickness]);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module XCarriageFullAssemblyDual(Titan,ExtruderMountType=1,Stiffner=0,StepperLength=45,DoTab=1) {
	difference() {
		translate([0.25,0,1]) rotate([90,0,0]) Carriage(Titan,0,0); // front
		translate([23,0,90]) WirechainMount();
	}
	if(StepperLength==35)
		translate([16,StepperLength-61,-10]) rotate([0,0,90]) TitanDual(0,1,1,StepperLength,0,1);
	
	else if(StepperLength==45)
		translate([16,StepperLength-81,-10]) rotate([0,0,90]) TitanDual(0,1,1,StepperLength);
	if(Stiffner) translate([45.8,-13,40]) color("blue") cuboid([10,10,10],rounding=2,p1=[0,0]); // connect extruder top to xcarriage
	translate([0,41.3,1]) rotate([90,0,0]) Carriage(0,0,1); // rear
	translate([-35,4.15,-3]) {
		difference() {
			union() {
				translate([35,16.5,90]) rotate([180,0,0]) BeltCarriageMount(0);
				translate([12,-wall-0.15,80]) color("red") cuboid([10,wall,13],rounding=2,p1=[0,0]);
				translate([12,33.15,80]) color("pink") cuboid([10,wall,13],rounding=2,p1=[0,0]);
				translate([52.5,-wall-0.15,80]) color("blue") cuboid([10,wall,13],rounding=2,p1=[0,0]);
				translate([52,33.15,80]) color("green") cuboid([10,wall,13],rounding=2,p1=[0,0]);
				translate([15,0,89.5]) color("gray") cube([40,40,LayerThickness]);
			}
			translate([16,-10,70]) color("khaki") rotate([0,-45,0]) cuboid([10,55,25],rounding=2,p1=[0,0]);
			translate([52,-10,78]) color("gray") rotate([0,45,0]) cuboid([10,55,25],rounding=2,p1=[0,0]);
			translate([20,0,90]) WirechainMount();
		}
	}
	translate([-37.5,37.3,-14]) color("black") cuboid([VerticalCarriageWidth*2+0.6,wall,10],rounding=2,p1=[0,0]);
	translate([-53,15,-14]) Brace(1,1);
	if(DoTab) {
		translate([-37,41,-14]) color("green") cylinder(h=LayerThickness,d=20);
		translate([35,41,-14]) color("plum") cylinder(h=LayerThickness,d=20);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module XCarriageWithExtruder(Titan,DoRear=1) {
	translate([0,-15,1]) rotate([-180,0,0]) Carriage(Titan,0,0); // front
	translate([-85,30,0]) rotate([0,0,90]) Single(1,35);//Extruder(1,5,1);
	if(DoRear) translate([0,10,-wall/2]) Carriage(0,0,1); // rear
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module xcar(WhichOne=0,Titan=0,Aero=0) // makerslide
{
	//if($preview) %translate([-100,-100,-5]) cube([200,200,5]);
	if(WhichOne==0) { // front,rear,beltholder
		translate([80,0,0]) Carriage(Titan,0,1,0); // rear
		Carriage(Titan,0,0,1,Aero,1);//Titan,0,1,1); // front
		//translate([-60,20,]) Belt_Holder();
	} else if(WhichOne==1) { // front
		Carriage(Titan,0,0,1,Aero,1); // front
	} else if(WhichOne==2) { // rear,beltholder
		translate([-10,-90,0]) Carriage(0,0,1); // rear
		//translate([15,20,]) Belt_Holder();
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Carriage(Titan=0,Tshift=0,Rear=0,ExtMount=0,AeroMount=0,TopBeltMount=1) { // extruder side
	echo("ExtMount:",ExtMount);
	difference() {
		union() {
			translate([0,40,0]) color("cyan") cuboid([VerticalCarriageWidth,height+2,wall],rounding=2,except_edges=BACK);
			if(!Rear) {
				color("blue") cuboid([HorizontallCarriageWidth,HorizontallCarriageHeight,wall],rounding=2,except_edges=FRONT);
			} else {
				color("blue") cuboid([HorizontallCarriageWidth,HorizontallCarriageHeight,wall],rounding=2);
			}
			translate([VerticalCarriageWidth/2-2,8,0]) rotate([0,0,45]) color("red") cuboid([10,10,wall],rounding=2);
			translate([VerticalCarriageWidth/2-36,8,0]) rotate([0,0,45]) color("yellow") cuboid([10,10,wall],rounding=2);
		}
		if(ExtMount) {
			if(AeroMount) 
				translate([-8,30,0]) ExtruderMountHolesFn4(Yes3mmInsert(Use3mmInsert),25);
			else
				translate([0,30,0]) ExtruderMountHolesFn(Yes3mmInsert(Use3mmInsert),25);
		}
		// wheel holes
		if(!Rear) { // top wheel hole, if rear, don't bevel it
			translate([-10,10,0]) { // exoslide BMG bracket
				translate([0,0,-5]) color("purple") cylinder(h=15,d=Yes4mmInsert(Use4mmInsert));
				translate([20,0,-5]) color("lavender") cylinder(h=15,d=Yes4mmInsert(Use4mmInsert));
			}
			translate([0,TopHoleSeperation,-5]) color("red") hull() { // top wheel
				// bevel the countersink to get easier access to adjuster
				translate([0,0,3]) cylinder(h = depth+10,d = screw5hd/2);
				translate([0,0,10]) cylinder(h = depth,d = screw5hd+20);
			}
			// wheel adjuster
			translate([0,TopHoleSeperation,-10]) color("blue") cylinder(h = depth+10,d=adjuster);
			// bottom hole clearance
			translate([-37,-10,-10]) {
				translate([BottomTwoHolesSeperation/2+HorizontallCarriageWidth/2,-TopHoleSeperation/2+42,12.5])
					color("gray") cylinder(h = depth+10,d=screw_hd);
				translate([-BottomTwoHolesSeperation/2+HorizontallCarriageWidth/2,-TopHoleSeperation/2+42,12.5])
					color("green") cylinder(h = depth+10,d=screw_hd);
				//translate([VerticalCarriageWidth,TopHoleSeperation/2+42,-10]) color("blue") cylinder(h = depth+10,d=screw5);
				translate([BottomTwoHolesSeperation/2+HorizontallCarriageWidth/2,-TopHoleSeperation/2+42,-10])
					color("yellow") cylinder(h = depth+20,d=screw5);
				translate([-BottomTwoHolesSeperation/2+HorizontallCarriageWidth/2,-TopHoleSeperation/2+42,-10])
					color("purple") cylinder(h = depth+20,d=screw5);
			}
		} else { // rear carraige
			// top whell hole
			translate([0,TopHoleSeperation+10,-10]) color("blue") cylinder(h = depth+10,d=screw5);
			// bottom hole clearance
			translate([-37,-10,-10]) {
				translate([BottomTwoHolesSeperation/2+HorizontallCarriageWidth/2,-TopHoleSeperation/2+42,-10])
					color("yellow") cylinder(h = depth+20,d=screw5);
				translate([-BottomTwoHolesSeperation/2+HorizontallCarriageWidth/2,-TopHoleSeperation/2+42,-10])
					color("purple") cylinder(h = depth+20,d=screw5);
			}
		}
		translate([0,height/2-5,-wall]) color("gray") hull() { // reduce usage of filament
			cylinder(h = wall+10, r = 6);
			translate([0,-35,0]) cylinder(h = wall+10, r = 6);
		}
		//if(!Titan || Rear) translate([37.5,34,0]) CarriageMount(); // 4 mounting holes for an extruder
		// screw holes to mount extruder plate
		//if(!Rear) translate([37.5,42,4]) ExtruderMountHolesFn(Yes3mmInsert(),25);
		// screw holes in top
		if(TopBeltMount) translate([0,40,0]) TopMountBeltHoles(Yes3mmInsert());
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BeltHeads() { // belt mounting holes
	//translate([0,-BeltShift,0])
	Belt_Mount_Holes(screw3hd);
}

/////////////////////////////////////////////////////////////////////////////////////////

module Belt_Mount_Holes(Screw=screw3) { // four mounting holes for using seperate mounting extruder brcket
	// lower
	translate([mount_seperation/2,-height/4 + BeltHoleShift,-5]) color("black") cylinder(h = wall+10, d = Screw,$fn = 50);
	translate([-mount_seperation/2,-height/4 + BeltHoleShift,-5])	color("blue") cylinder(h = wall+10, d = Screw,$fn = 50);
	// upper
	translate([mount_seperation/2,-height/4 + BeltHoleShift + mount_seperation,-5])
		color("red") cylinder(h = wall+10, d = Screw,$fn = 50);
	translate([-mount_seperation/2,-height/4 + BeltHoleShift + mount_seperation,-5])
		color("plum") cylinder(h = wall+10, d = Screw,$fn = 50);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module servo()
{		// mounting holes
		translate([extruder/2-12,-heightE/2 - 1.8*wall,heightE - extruder_back - servo_spacing/2 - servo_offset])
			rotate([0,90,0]) color("red") cylinder(h = ExtruderThickness+screw_depth,r = screw2/2,$fn=50);
		translate([extruder/2-12,-heightE/2 - 1.8*wall,heightE - extruder_back + servo_spacing/2 - servo_offset])
			rotate([0,90,0]) color("blue") cylinder(h = ExtruderThickness+screw_depth,r = screw2/2,$fn=50);
		translate([-extruder/2-22,-heightE/2 - 1.8*wall,heightE - extruder_back + servo_spacing/2 - servo_offset])
			rotate([0,90,0]) color("gray") cylinder(h = ExtruderThickness+screw_depth,r = screw2/2,$fn=50);
		translate([-extruder/2-22,-heightE/2 - 1.8*wall,heightE - extruder_back - servo_spacing/2 - servo_offset])
			rotate([0,90,0]) color("black") cylinder(h = ExtruderThickness+screw_depth,r = screw2/2,$fn=50);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module fan()
{		// mounting holes
		translate([-extruder/2-22,-heightE/2 - 1.8*wall,heightE - extruder_back - fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("black") cylinder(h = ExtruderThickness+screw_depth,r = screw2/2,$fn=50);
		translate([-extruder/2-22,-heightE/2 - 1.8*wall,heightE - extruder_back + fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("gray") cylinder(h = ExtruderThickness+screw_depth,r = screw2/2,$fn=50);
		translate([extruder/2-10,-heightE/2 - 1.8*wall,heightE - extruder_back + fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("blue") cylinder(h = ExtruderThickness+screw_depth,r = screw2/2,$fn=50);
		translate([extruder/2-10,-heightE/2 - 1.8*wall,heightE - extruder_back - fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("red") cylinder(h = ExtruderThickness+screw_depth,r = screw2/2,$fn=50);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module notch_bottom()
{
	translate([0,-height/2,-0.5]) color("plum") cube([HorizontallCarriageWidth+1,wall,wall+2], true);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module print_support()
{
	difference() {
		translate([0,-height/2-1.45,1.05]) color("gray") cube([HorizontallCarriageWidth,extruder_nozzle_size,wall+2], true);
		translate([0,-height/2-1.3,0.5]) color("yellow") cube([HorizontallCarriageWidth/2-ps_spacer,1,wall+4], true);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module belt_drive() // something to attach the x-axis belt
{
	difference() {
		color("cyan") cuboid([44,48,wall],1,center=true);
		// mounting screw holes
		translate([-(HorizontallCarriageWidth/4-5),-(25 - wall/2),-9]) rotate([0,0,0]) color("red") cylinder(h = 15, r = screw3/2, $fn = 50);
		translate([HorizontallCarriageWidth/4-5,-(25 - wall/2),-9]) rotate([0,0,0]) color("blue") cylinder(h = 15, r = screw3/2, $fn = 50);
		translate([HorizontallCarriageWidth/4-5,25 - wall/2,-9]) rotate([0,0,0]) color("gray") cylinder(h = 15, r = screw3/2, $fn = 50);
		translate([-(HorizontallCarriageWidth/4-5),25 - wall/2,-9]) rotate([0,0,0]) color("black") cylinder(h = 15, r = screw3/2, $fn = 50);
		// belt clamp mounting holes
		translate([18,6,-7]) rotate([0,0,0]) color("plum") cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([18,-6,-7]) rotate([0,0,0]) color("pink") cylinder(h = 2*wall, r = screw3/2,$fn=50);
		// belt clamp mounting holes
		translate([-18,6,-7]) rotate([0,0,0]) color("yellow") cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([-18,-6,-7]) rotate([0,0,0]) color("lime") cylinder(h = 2*wall, r = screw3/2,$fn=50);
	}
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module belt() // belt mount plate or if MkrSld: top plate
{
	belt_drive(1);
	translate([30,-10,0]) belt_clamp(1);
	translate([43,-10,0]) belt_clamp(1);
	translate([30,15,0]) belt_adjuster();
	translate([43,5,0]) belt_anvil();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module belt_clamp(Nuts)
{
	difference() {
		translate([0,0,-wall/2+1.5]) color("red") cuboid([8,19,3],1,center=true);
		translate([0,6,-5]) color("cyan") cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([0,-6,-5]) color("gray") cylinder(h = 2*wall, r = screw3/2,$fn=50);
		if(Nuts) {
			translate([0,6,-2]) color("gray") rotate([0,0,0]) nut(m3_nut_diameter,3);
			translate([0,-6,-2]) color("cyan") rotate([0,0,0]) nut(m3_nut_diameter,3);
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module belt_adjuster()
{
	difference() {
		translate([0,0,-wall/2+4.5]) color("blue") cuboid([8,19,9],1,center=true);
		translate([0,0,5]) color("gray") cube([11,7,3.5],true);
		translate([0,6,-5]) color("black") cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([0,-6,-5]) color("red") cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([-5,0,-0.45]) rotate([0,90,0]) color("yellow") cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([-6,0,-0.45]) rotate([0,90,0]) color("cyan") nut(m3_nut_diameter,3);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module belt_anvil()
{
	translate([0,0,-3]) rotate([0,0,90]) difference() {
		rotate([0,90,0]) color("plum") cylinder(h = 9, r = 4, $fn= 100);
		translate([3,0,-6]) color("gray") cube([15,10,10],true);
		translate([4.5,0,-3]) color("blue") cylinder(h = 5, r = screw3/2,$fn = 50);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module SensorMount(Shift=0) { // four mounting holes for mounting of sensor brackets
	// lower
	translate([mount_seperation/2,-height/4 + mount_height+Shift,-5]) color("cyan") cylinder(h = wall+10, r = screw4/2,$fn = 50);
	translate([-mount_seperation/2,-height/4+ mount_height+Shift,-5]) color("blue") cylinder(h = wall+10, r = screw4/2,$fn = 50);
	// upper
	translate([mount_seperation/2,-height/4 + mount_height + mount_seperation+Shift,-5]) color("red")
		cylinder(h = wall+10, r = screw4/2,$fn = 50);
	translate([-mount_seperation/2,-height/4+ mount_height + mount_seperation+Shift,-5]) color("gray")
		cylinder(h = wall+10, r = screw4/2,$fn = 50);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module cableholder() {
	difference() {
		color("red") cuboid([15,10,3],rounding=1,p1=[0,0]);
		translate([7.5,5,-5]) color("plum") cylinder(h=10,d=screw3);
		translate([7.5,5,2]) color("khaki") cylinder(h=10,d=screw3hd);
	}
	difference() {
		translate([1,5,3]) rotate([0,90,0]) color("blue") cylinder(h=13,d=8);
		translate([-3,5,3]) rotate([0,90,0]) color("cyan") cylinder(h=15,d=4);
		translate([-2,-2,-3]) color("gray") cube([20,15,5]);
		translate([2.5,0,3]) color("black") cube([10,10,5]);
		translate([7.5,5,2]) color("khaki") cylinder(h=10,d=screw3hd);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TopMountBeltHoles(Screw=Yes3mmInsert()) {
	translate([HorizontallCarriageWidth/4-5,height/2+2,0]) rotate([90,0,0]) color("red") cylinder(h = 20, d = Screw);
	translate([-(HorizontallCarriageWidth/4-5),height/2+2,0]) rotate([90,0,0]) color("blue") cylinder(h = 20, d = Screw);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ExtruderMountHolesFn(Screw=Yes3mmInsert(Use3mmInsert),Length=20) {
		// screw holes to mount extruder plate
		translate([0,-20,0]) rotate([90,0,0]) color("gray") cylinder(h = Length, d = Screw);
		translate([HorizontallCarriageWidth/2-5,-20,0]) rotate([90,0,0]) color("green") cylinder(h = Length, d = Screw);
		translate([-(HorizontallCarriageWidth/2-5),-20,0]) rotate([90,0,0]) color("khaki") cylinder(h = Length, d = Screw);
		translate([HorizontallCarriageWidth/4-2,-20,0]) rotate([90,0,0]) color("lightgray") cylinder(h = Length, d = Screw);
		translate([-(HorizontallCarriageWidth/4-2),-20,0]) rotate([90,0,0]) color("plum") cylinder(h = Length, d = Screw);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ExtruderMountHolesFn4(Screw=Yes3mmInsert(Use3mmInsert),Length=20,Fragments=100) {
		// screw holes to mount extruder plate
		translate([0,-20,0]) rotate([90,0,0]) color("indigo") cylinder(h = Length, d = Screw);
		translate([HorizontallCarriageWidth/2-5,-20,0]) rotate([90,0,0]) color("red") cylinder(h = Length, d = Screw);
		//translate([-(HorizontallCarriageWidth/2-5),-20,0]) rotate([90,0,0]) color("white") cylinder(h = Length, d = Screw);
		translate([HorizontallCarriageWidth/4-2,-20,0]) rotate([90,0,0]) color("pink") cylinder(h = Length, d = Screw);
		translate([-(HorizontallCarriageWidth/4-2),-20,0]) rotate([90,0,0]) color("cyan") cylinder(h = Length, d = Screw);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module CarriageMount(Screw=screw4) { // four mounting holes for using seperate mounting extruder brcket
	// lower
	translate([mount_seperation/2,-height/4 + mount_height,-5]) color("black") cylinder(h = wall+10, d = Screw,$fn = 50);
	translate([-mount_seperation/2,-height/4+ mount_height,-5])	color("blue") cylinder(h = wall+10, d = Screw,$fn = 50);
	// upper
	translate([mount_seperation/2,-height/4 + mount_height + mount_seperation,-5])
		color("red") cylinder(h = wall+10, d = Screw,$fn = 50);
	translate([-mount_seperation/2,-height/4+ mount_height + mount_seperation,-5])
		color("plum") cylinder(h = wall+10, d = Screw,$fn = 50);
}

////////////////////end of x-carriage.scad////////////////////////////////////////////////////////////////////////////
