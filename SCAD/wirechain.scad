// wirechain.scad
// created: 10/11/2018
// last pdate: 10/11/18
////////////////////////////////////////////////////////////////////////////////////////////////////////
// 10/11/18	- Uses thingiverse https://www.thingiverse.com/thing:2354864
//			  Anet_A8_extruder_End_Cable_Chain.stl, AnetA8_Ybed_Thin_Wall_Cable_Chain.stl,
//			  OpenCableChainX4.stl
//
////////////////////////////////////////////////////////////////////////////////////////////////////////
use <inc/cubex.scad>
include <inc/screwsizes.scad>
$fn=100;
////////////////////////////////////////////////////////////////////////////////////////////////////////

if($preview) %translate([-50,-50,-5]) cube([200,200,5]);
//opencablechain();
allmounts(screw3,screw3hd);
//x_axis(screw3,screw3hd);
//z_axis(screw3,screw3hd);

//////////////////////////////////////////////////////////////////////////////////////////////////////

module opencablechain() {
	import("OpenCableChainX4.stl");
	translate([0,60,0]) import("OpenCableChainX4.stl");
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

module allmounts(Screw=screw3,ScrewH=screw3hd) {
	x_axis(Screw,ScrewH);
	z_axis(Screw,ScrewH);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////

module x_axis(Screw=screw3,ScrewH=screw3hd) {
	mount1(Screw,ScrewH);
	translate([40,10,-7]) rotate([90,0,0])
		mount2(Screw,ScrewH);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////

module z_axis(Screw=screw3,ScrewH=screw3hd) {
	translate([-30,0,0]) mount3(Screw,ScrewH);
	translate([65,10,-7]) rotate([90,0,0]) mount4(Screw,ScrewH);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////

module mount1(Screw=screw3,ScrewH=screw3hd) {
	difference() {
		import("Anet_A8_extruder_End_Cable_Chain.stl");
		translate([0,-19,0]) color("gray") cube([50,50,50]);
		translate([-26.85,0,0]) color("lightgray") cube([50,50,50]);
		translate([22,25,13.29]) color("black") cube([10,10,10]);
	}
	difference() {
		translate([22.5,12,0]) color("blue") cubeX([23.5,20,5],1);
		translate([34.5,22,-5]) color("red") cylinder(h=10,d=Screw);
		translate([34.5,22,2.5]) color("pink") cylinder(h=10,d=ScrewH);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////

module mount2(Screw=screw3,ScrewH=screw3hd) {
	difference() {
		import("AnetA8_Ybed_Thin_Wall_Cable_Chain.stl");
		translate([-31.6,-25,-1]) color("lightgray") cube([50,50,50]);
		translate([16,-23.09,-2]) color("yellow") cube([25,30,25]);
	}
	bracket2(Screw,ScrewH);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////

module mount3(Screw=screw3,ScrewH=screw3hd) {
	translate([0,0,2.9]) difference() {
		import("Anet_A8_extruder_End_Cable_Chain.stl");
		translate([0,-19,0]) color("gray") cube([50,50,50]);
		translate([-26.85,0,0]) color("lightgray") cube([50,50,50]);
		translate([22,25,13.29]) color("black") cube([10,10,10]);
	}
	difference() {
		translate([22.5,12,0]) color("blue") cubeX([23.5,35,5],1);
		translate([34.5,22,-5]) color("red") cylinder(h=10,d=Screw);
		translate([34.5,22,2.5]) color("pink") cylinder(h=10,d=ScrewH);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

module mount4(Screw=screw3,ScrewH=screw3hd) {
	translate([21,2,35]) rotate([0,90,0]) difference() {
		import("AnetA8_Ybed_Thin_Wall_Cable_Chain.stl");
		translate([-31.6,-25,-1]) color("lightgray") cube([50,50,50]);
		translate([16,-23.09,-2]) color("yellow") cube([25,30,25]);
	}
	bracket4(Screw,ScrewH);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////

module bracket2(Screw=screw3,ScrewH=screw3hd) {
	translate([18.25,6.9,-63]) color("pink") cubeX([19,5,65],1);
	difference() {
		translate([18.25,7,-63]) color("gold") cubeX([19,20,5,],1);
		translate([28,18,-67]) color("red") cylinder(h=10,d=Screw);
		translate([28,18,-60.5]) color("pink") cylinder(h=10,d=ScrewH);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////

module bracket4(Screw=screw3,ScrewH=screw3hd) {
	translate([18.25,6.9,-63]) color("pink") cubeX([19,5,80],1);
	difference() {
		translate([18.25,7,-63]) color("gold") cubeX([19,20,5],1);
		translate([28,18,-67]) color("red") cylinder(h=10,d=Screw);
		translate([28,18,-60.5]) color("pink") cylinder(h=10,d=ScrewH);
	}
}
////////////////// end of wirechain.scad ///////////////////////////////////////////////////////////////
