///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MMAX-X-Carriage - x carriage for makerslide
// created: 2/3/2014
// last modified: 4/9/2020
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 9/2/18	- Original file modified for MMAX, extruder plate and top mounting belt removed
// 12/10/18	- Changed to loop type bel holder on carraiage
// 5/6/19	- Added carriage_v2() from corexy-x-carriage.scad
// 4/9/20	- Added ability to use 3mm brass inseerts
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// uses http://www.thingiverse.com/thing:211344 for the y belt
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <MMAX_h.scad>
Use3mmInsert=1;
include <BrassFunctions.scad>
use <ybeltclamp.scad>
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Tshift=0;	// shift titan knob clearance notch
BeltShift=10; // move belt holder up/down
BeltHoleShift=5; // move belt holder up/down
VerticalCarriageWidth=37.2;
HorizontallCarriageHeight=20;
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

xcar(0,1);
//cableholder();
//Belt_Holder();
//Carriage_v2(); // front; Titan=0,Tshift=0,Rear=0
//Carriage_v2(0,0,0,0,0,1); // rear

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module xcar(WhichOne=0,Titan=0) // makerslide version
{
	if($preview) %translate([-100,-100,-5]) cube([200,200,5]);
	if(WhichOne==0) { // front,rear,beltholder
		translate([-10,-90,0]) Carriage_v2(); // rear
		rotate([0,0,180]) Carriage_v2(Titan,0,1); // front
		translate([-60,20,]) Belt_Holder();
	} else if(WhichOne==1) { // front
		Carriage_v2(Titan,0,0); // front
	} else if(WhichOne==2) { // rear,beltholder
		translate([-10,-90,0]) Carriage_v2(0,0,1); // rear
		translate([15,20,]) Belt_Holder();
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Carriage_v2(Titan=0,Tshift=0,Rear=0) { // extruder side
	difference() {
		union() {
			translate([VerticalCarriageWidth/2,0,0]) color("cyan") cubeX([VerticalCarriageWidth,height,wall],1);
			color("blue") cubeX([HorizontallCarriageWidth,HorizontallCarriageHeight,wall],1);
			translate([VerticalCarriageWidth/2+2,12,0]) rotate([0,0,45]) color("red") cubeX([10,10,wall],1);
			translate([VerticalCarriageWidth/2+35,12,0]) rotate([0,0,45]) color("yellow") cubeX([10,10,wall],1);
		}
		// wheel holes
		if(!Rear) { // top wheel hole, if rear, don't bevel it
			translate([VerticalCarriageWidth,TopHoleSeperation+10,0]) color("red") hull() { // top wheel
				// bevel the countersink to get easier access to adjuster
				translate([0,0,3]) cylinder(h = depth+10,r = screw_hd/2);
				translate([0,0,10]) cylinder(h = depth,r = screw_hd/2+11);
			}
		} else
			translate([VerticalCarriageWidth,TopHoleSeperation/2+42,3]) color("lightgray") cylinder(h = depth+10,r = screw_hd/2);
		translate([VerticalCarriageWidth,TopHoleSeperation/2+42,-10]) color("blue") cylinder(h = depth+10,r = adjuster/2);
		translate([BottomTwoHolesSeperation/2+HorizontallCarriageWidth/2,-TopHoleSeperation/2+42,-10]) color("yellow")
			cylinder(h = depth+10,r = screw/2);
		translate([-BottomTwoHolesSeperation/2+HorizontallCarriageWidth/2,-TopHoleSeperation/2+42,-10]) color("purple")
			cylinder(h = depth+10,r = screw/2);
		translate([BottomTwoHolesSeperation/2+HorizontallCarriageWidth/2,-TopHoleSeperation/2+42,3]) color("gray")
			cylinder(h = depth+10,r = screw_hd/2);
		translate([-BottomTwoHolesSeperation/2+HorizontallCarriageWidth/2,-TopHoleSeperation/2+42,3]) color("green")
			cylinder(h = depth+10,r = screw_hd/2);
		translate([38,height/2+8,-wall/2]) color("gray") hull() { // reduce usage of filament
			cylinder(h = wall+10, r = 6);
			translate([0,-40,0]) cylinder(h = wall+10, r = 6);
		}
		if(!Titan || Rear) translate([37.5,34,0]) CarriageMount(); // 4 mounting holes for an extruder
		// screw holes to mount extruder plate
		translate([37.5,44,4]) ExtruderMountHolesFn(Yes3mmInsert(),25);
		// screw holes in top
		translate([38,45,4]) TopMountBeltHoles(Yes3mmInsert());
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BeltHeads() { // belt mounting holes
	//translate([0,-BeltShift,0])
	Belt_Mount_Holes(screw3hd);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Belt_Holder() {
	union() {
		difference() {
			translate([-8,-15,0]) color("plum") cubeX([40.5,50,5],1);
			translate([12,16,0]) Belt_Mount_Holes();
			translate([12,16,9.5]) BeltHeads();
		}
		difference() {
			translate([-7,-BeltShift,4.5]) beltClamp();
			translate([12,16,7]) Belt_Mount_Holes();
			translate([12,16,9.5]) BeltHeads();
		}
	}
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
		color("cyan") cubeX([44,48,wall],1,center=true);
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
		translate([0,0,-wall/2+1.5]) color("red") cubeX([8,19,3],1,center=true);
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
		translate([0,0,-wall/2+4.5]) color("blue") cubeX([8,19,9],1,center=true);
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
		color("red") cubeX([15,10,3],1);
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
	translate([HorizontallCarriageWidth/4-5,height/2+2,0]) rotate([90,0,0]) color("red") cylinder(h = GetHoleLen3mm(Screw), d = Screw);
	translate([-(HorizontallCarriageWidth/4-5),height/2+2,0]) rotate([90,0,0]) color("blue") cylinder(h = GetHoleLen3mm(Screw), d = Screw);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ExtruderMountHolesFn(Screw=Yes3mmInsert(),Length=GetHoleLen3mm(),Fragments=100) {
		// screw holes to mount extruder plate
		translate([0,-20,0]) rotate([90,0,0]) color("blue") cylinder(h = Length, d = Screw, $fn=Fragments);
		translate([HorizontallCarriageWidth/2-5,-20,0]) rotate([90,0,0]) color("red") cylinder(h = Length, d = Screw, $fn=Fragments);
		translate([-(HorizontallCarriageWidth/2-5),-20,0]) rotate([90,0,0]) color("black") cylinder(h = Length, d = Screw, $fn=Fragments);
		translate([HorizontallCarriageWidth/4-2,-20,0]) rotate([90,0,0]) color("gray") cylinder(h = Length, d = Screw, $fn=Fragments);
		translate([-(HorizontallCarriageWidth/4-2),-20,0]) rotate([90,0,0]) color("cyan") cylinder(h = Length, d = Screw, $fn=Fragments);
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
