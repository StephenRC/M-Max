///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// x-carriage - x carriage for makerslide
// created: 2/3/2014
// last modified: 12/10/2018
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 9/2/18	- Original file modified for MMAX, extruder plate and top mounting belt removed
// 12/10/18	- Changed to loop type bel holder on carraiage
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// uses http://www.thingiverse.com/thing:211344 for the y belt
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <MMAX_h.scad>
use <ybeltclamp.scad>
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Tshift=0;	// shift titan knob clearance notch
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//xcar(1);
//cableholder();
Belt_Holder();

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module xcar(Both) // makerslide version
{
	if($preview) %translate([-100,-100,-9]) cube([200,200,5]);
	if(Both) {
		carriage_rear();
		translate([60,0,0]) rotate([0,0,180]) carriage();
		translate([-60,0,-4]) Belt_Holder();
		//translate([23,0,0]) cableholder();
	} else
		carriage();
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module carriage() { // wheel side
	difference() {
		color("cyan") cubeX([width,height,wall],2,center=true); // makerslide side
		notch_bottom(); // not really needed here, used to make part the same size as the lm8uu version
		// wheel holes
		color("red") hull() { // bevel the countersink to get easier access to adjuster
			translate([0,tri_sep/2,-1]) cylinder(h = depth+10,r = screw_hd/2,$fn=50);
			translate([0,tri_sep/2,10]) cylinder(h = depth,r = screw_hd/2+11,$fn=50);
		}
		translate([0,tri_sep/2,-10]) color("blue") cylinder(h = depth+10,r = adjuster/2,$fn=50);
		translate([dual_sep/2,-tri_sep/2,-10]) color("black") cylinder(h = depth+10,r = screw/2,$fn=50);
		translate([-dual_sep/2,-tri_sep/2,-10]) color("gold") cylinder(h = depth+10,r = screw/2,$fn=50);
		translate([dual_sep/2,-tri_sep/2,0]) color("plum") cylinder(h = depth+10,r = screw_hd/2,$fn=50);
		translate([-dual_sep/2,-tri_sep/2,0]) color("khaki") cylinder(h = depth+10,r = screw_hd/2,$fn=50);
		color("pink") hull() { // side notch
			translate([width/2-9,height,-5]) cylinder(h = wall+5, r = 10,$fn=50);
			translate([width/2-9,-height/8,-5]) cylinder(h = wall+5, r = 10,$fn=50);
			translate([width/2,height,-5]) cylinder(h = wall+5, r = 10,$fn=50);
			translate([width/2,-height/8,-5]) cylinder(h = wall+5, r = 10,$fn=50);
		}
		color("blue") hull() { // side notch
			translate([-(width/2-9),height,-5]) cylinder(h = wall+5, r = 10,$fn=50);
			translate([-(width/2-9),-height/8,-5]) cylinder(h = wall+5, r = 10,$fn=50);
			translate([-(width/2),height,-5]) cylinder(h = wall+5, r = 10,$fn=50);
			translate([-(width/2),-height/8,-5]) cylinder(h = wall+5, r = 10,$fn=50);
		}
		color("gray") hull() { // reduce usage of filament
			translate([0,height/8,-wall]) cylinder(h = wall+10, r = 6,$fn=50);
			translate([0,-height/4,-wall]) cylinder(h = wall+10, r = 6,$fn=50);
		}
		// screw holes to mount extruder plate
		translate([0,-20,0]) rotate([90,0,0]) color("blue") cylinder(h = 25, r = screw2/2, $fn = 50);
		translate([width/2-5,-20,0]) rotate([90,0,0]) color("red") cylinder(h = 25, r = screw2/2, $fn = 50);
		translate([-(width/2-5),-20,0]) rotate([90,0,0]) color("black") cylinder(h = 25, r = screw2/2, $fn = 50);
		translate([width/4-2,-20,0]) rotate([90,0,0]) color("gray") cylinder(h = 25, r = screw2/2, $fn = 50);
		translate([-(width/4-2),-20,0]) rotate([90,0,0]) color("cyan") cylinder(h = 25, r = screw2/2, $fn = 50);
		//translate([-20,10+Tshift,2]) color("yellow") color("cyan") cylinder(h=5,d=30,$fn=100); // Titan thumbwheel notch
		extruder_mount(-10); // mounting holes for an extruder
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module carriage_rear() { // back plate for the belt mount; non-wheel side
	difference() {
		color("cyan") cubeX([width,height,wall],2,center=true); // makerslide side
		// wheel holes
		translate([0,tri_sep/2,-10]) color("blue") cylinder(h = depth+10,r = adjuster/2,$fn=50);
		translate([dual_sep/2,-tri_sep/2,-10]) color("red") cylinder(h = depth+10,r = screw/2,$fn=50);
		translate([-dual_sep/2,-tri_sep/2,-10]) color("yellow") cylinder(h = depth+10,r = screw/2,$fn=50);
		color("gray") hull() { // bevel the countersink to get easier access to nut
			translate([0,tri_sep/2,-1]) cylinder(h = depth+10,r = screw_hd/2,$fn=50);
			translate([0,tri_sep/2,10]) cylinder(h = depth,r = screw_hd/2+11,$fn=50);
		}
		color("black") hull() { // bevel the countersink to get easier access to nut
			translate([dual_sep/2,-tri_sep/2,0]) cylinder(h = depth+10,r = screw_hd/2,$fn=50);
			translate([dual_sep/2,-tri_sep/2,10]) cylinder(h = depth+10,r = screw_hd/2+11,$fn=50);
		}
		color("plum") hull() { // bevel the countersink to get easier access to nut
			translate([-dual_sep/2,-tri_sep/2,0]) cylinder(h = depth+10,r = screw_hd/2,$fn=50);
			translate([-dual_sep/2,-tri_sep/2,10]) cylinder(h = depth+10,r = screw_hd/2+11,$fn=50);
		}
		color("blue") hull() { // side notch
			translate([width/2-9,height,-5]) cylinder(h = wall+5, r = 10,$fn=50);
			translate([width/2-9,-height/8,-5]) cylinder(h = wall+5, r = 10,$fn=50);
			translate([width/2,height,-5]) cylinder(h = wall+5, r = 10,$fn=50);
			translate([width/2,-height/8,-5]) cylinder(h = wall+5, r = 10,$fn=50);
		}
		color("pink") hull() { // side notch
			translate([-(width/2-9),height,-5]) cylinder(h = wall+5, r = 10,$fn=50);
			translate([-(width/2-9),-height/8,-5]) cylinder(h = wall+5, r = 10,$fn=50);
			translate([-(width/2),height,-5]) cylinder(h = wall+5, r = 10,$fn=50);
			translate([-(width/2),-height/8,-5]) cylinder(h = wall+5, r = 10,$fn=50);
		}
		Belt_Mount_Holes(screw3t);
		// reduce usage of filament
		translate([0,-height/3.5,-wall]) color("pink") cylinder(h = wall+10, r = 12,$fn=50); // a big hole near bottom
		translate([0,3,-wall]) color("gray") cylinder(h = wall+10, r = 8,$fn=50); // a hole under the belt holder
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Belt_Mount_Holes(Screw=screw3) { // belt mounting holes (may need to be moved up or down)
	translate([beltw/2,belth+beltadjust,-wall]) color("red") cylinder(h = 2*wall, r = Screw/2, $fn=50);
	translate([-(beltw/2),belth+beltadjust,-wall]) color("blue") cylinder(h = 2*wall, r = Screw/2, $fn=50);
	translate([beltw/2,beltadjust,-wall]) color("yellow") cylinder(h = 2*wall, r = Screw/2, $fn=50);
	translate([-(beltw/2),beltadjust,-wall]) color("plum") cylinder(h = 2*wall, r = Screw/2, $fn=50);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Belt_Holder() {
	difference() {
		translate([-8,0,0]) color("plum") cubeX([40.5,34,5],2);
		translate([12,16,0]) Belt_Mount_Holes();
	}
	translate([-7,9,4.5]) beltClamp();
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module servo()
{		// mounting holes
		translate([extruder/2-12,-heightE/2 - 1.8*wall,heightE - extruder_back - servo_spacing/2 - servo_offset])
			rotate([0,90,0]) color("red") cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);
		translate([extruder/2-12,-heightE/2 - 1.8*wall,heightE - extruder_back + servo_spacing/2 - servo_offset])
			rotate([0,90,0]) color("blue") cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);
		translate([-extruder/2-22,-heightE/2 - 1.8*wall,heightE - extruder_back + servo_spacing/2 - servo_offset])
			rotate([0,90,0]) color("gray") cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);
		translate([-extruder/2-22,-heightE/2 - 1.8*wall,heightE - extruder_back - servo_spacing/2 - servo_offset])
			rotate([0,90,0]) color("black") cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module fan()
{		// mounting holes
		translate([-extruder/2-22,-heightE/2 - 1.8*wall,heightE - extruder_back - fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("black") cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);
		translate([-extruder/2-22,-heightE/2 - 1.8*wall,heightE - extruder_back + fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("gray") cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);
		translate([extruder/2-10,-heightE/2 - 1.8*wall,heightE - extruder_back + fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("blue") cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);
		translate([extruder/2-10,-heightE/2 - 1.8*wall,heightE - extruder_back - fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("red") cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50);

		//translate([-extruder/2,-heightE/2 - 1.8*wall+2,heightE - extruder_back]) // metal extruder cooling fan mount
			//rotate([0,0,0]) cylinder(h = depthE+screw_depth,r = screw2/2,$fn=50); // one screw hole in front
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module notch_bottom()
{
	translate([0,-height/2,-0.5]) color("plum") cube([width+1,wall,wall+2], true);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module print_support()
{
	difference() {
		translate([0,-height/2-1.45,1.05]) color("gray") cube([width,extruder_nozzle_size,wall+2], true);
		translate([0,-height/2-1.3,0.5]) color("yellow") cube([width/2-ps_spacer,1,wall+4], true);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module belt_drive() // something to attach the x-axis belt
{
	difference() {
		color("cyan") cubeX([44,48,wall],1,center=true);
		// mounting screw holes
		translate([-(width/4-5),-(25 - wall/2),-9]) rotate([0,0,0]) color("red") cylinder(h = 15, r = screw3/2, $fn = 50);
		translate([width/4-5,-(25 - wall/2),-9]) rotate([0,0,0]) color("blue") cylinder(h = 15, r = screw3/2, $fn = 50);
		translate([width/4-5,25 - wall/2,-9]) rotate([0,0,0]) color("gray") cylinder(h = 15, r = screw3/2, $fn = 50);
		translate([-(width/4-5),25 - wall/2,-9]) rotate([0,0,0]) color("black") cylinder(h = 15, r = screw3/2, $fn = 50);
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

module extruder_mount(Shift=0) { // four mounting holes for mounting of sensor brackets
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

////////////////////end of x-carriage.scad////////////////////////////////////////////////////////////////////////////
