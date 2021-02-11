/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 40mmTo30mmFan.scad
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// created 2/7/21
// last update 2/11/21
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 2/11/21	- Aded an offset fan adapter
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
include <inc/cubex.scad>
include <inc/brassinserts.scad>
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
$fn=100;
40mmOffset=33;
30mmOffset=24;
40mmFanDiameter=40;
30mmFanDiameter=30;
40mmScrewOffset=3;
30mmScrewOffset=7.9;
LayerHeight=0.3;
Use3mmInsert=1;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//rotate([180,0,0]) FanAdapter();
rotate([180,0,0]) FanAdapterWithOffset();

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanAdapter(Thickness=5) {
	difference() {
		color("cyan") hull() {
			cubeX([40mmFanDiameter,40mmFanDiameter,1],2);
			translate([(40mmFanDiameter-30mmFanDiameter)/2,(40mmFanDiameter-30mmFanDiameter)/2,-Thickness])
				cubeX([30mmFanDiameter,30mmFanDiameter,1],2);
		}
		40mmMount(Thickness);
		30mmMount(Thickness);
		FanHole(Thickness);
	}
	SupportFor30mmMount(Thickness);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanAdapterWithOffset(Thickness=5) {
	difference() {
		color("cyan") hull() {
			cubeX([40mmFanDiameter,40mmFanDiameter,1],2);
			translate([-5,(40mmFanDiameter-30mmFanDiameter)/2,-Thickness])
				cubeX([30mmFanDiameter,30mmFanDiameter,1],2);
		}
		40mmMount(Thickness);
		translate([-10,0,0]) 30mmMount(Thickness);
		FanHoleWithOffset(Thickness);
	}
	SupportFor30mmMountWithOffset(Thickness);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module 40mmMount(Thickness) {
	translate([40mmScrewOffset,40mmScrewOffset,-Thickness*2.5]) color("red") cylinder(h=Thickness*4,d=Yes3mmInsert(Use3mmInsert));
	translate([40mmScrewOffset+40mmOffset,40mmScrewOffset,-Thickness*2.5]) color("blue")
		cylinder(h=Thickness*4,d=Yes3mmInsert(Use3mmInsert));
	translate([40mmScrewOffset+40mmOffset,40mmScrewOffset+40mmOffset,-Thickness*2.5]) color("plum")
		cylinder(h=Thickness*4,d=Yes3mmInsert(Use3mmInsert));
	translate([40mmScrewOffset,40mmScrewOffset+40mmOffset,-Thickness*2.5]) color("black")
		cylinder(h=Thickness*4,d=Yes3mmInsert(Use3mmInsert));
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module 30mmMount(Thickness) {
	translate([30mmScrewOffset,30mmScrewOffset,-Thickness*2.5]) color("red") cylinder(h=Thickness*4,d=screw2);
	translate([30mmScrewOffset+30mmOffset,30mmScrewOffset,-Thickness*2.5]) color("blue") cylinder(h=Thickness*4,d=screw2);
	translate([30mmScrewOffset+30mmOffset,30mmScrewOffset+30mmOffset,-Thickness*2.5]) color("plum")
		cylinder(h=Thickness*4,d=screw2);
	translate([30mmScrewOffset,30mmScrewOffset+30mmOffset,-Thickness*2.5]) color("black") cylinder(h=Thickness*4,d=screw2);
	translate([30mmScrewOffset,30mmScrewOffset,-Thickness]) color("black") cylinder(h=Thickness*4,d=screw3hd);
	translate([30mmScrewOffset+30mmOffset,30mmScrewOffset,-Thickness]) color("plum") cylinder(h=Thickness*4,d=screw3hd);
	translate([30mmScrewOffset+30mmOffset,30mmScrewOffset+30mmOffset,-Thickness]) color("blue") cylinder(h=Thickness*4,d=screw3hd);
	translate([30mmScrewOffset,30mmScrewOffset+30mmOffset,-Thickness]) color("white") cylinder(h=Thickness*4,d=screw3hd);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanHole(Thickness) {
	color("blue") hull() {
		translate([20,20,Thickness+2]) cylinder(h=1,d=39);
		translate([20,20,-Thickness-5]) cylinder(h=1,d=26);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanHoleWithOffset(Thickness) {
	color("blue") hull() {
		translate([20,20,Thickness+2]) cylinder(h=1,d=39);
		translate([9,20,-Thickness-5]) cylinder(h=1,d=23);
	}
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module SupportFor30mmMount(Thickness) {
	difference() {
		translate([30mmScrewOffset*2.5,30mmScrewOffset*2.5,-Thickness]) color("gray") cylinder(h=LayerHeight,d=30mmFanDiameter+11);
		translate([0,0,-Thickness*2]) rotate([45,0,0]) color("pink") cube([40mmFanDiameter,7,7]);
		translate([0,40,-Thickness*2]) rotate([45,0,0]) color("lightgray") cube([40mmFanDiameter,7,7]);
		translate([-5,0,-Thickness*1]) rotate([0,45,0]) color("purple") cube([7,40mmFanDiameter,7]);
		translate([35,0,-Thickness*1]) rotate([0,45,0]) color("khaki") cube([7,40mmFanDiameter,7]);
		FanHole(Thickness);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module SupportFor30mmMountWithOffset(Thickness) {
	difference() {
		translate([10,30mmScrewOffset*2.5,-Thickness-LayerHeight]) color("gray") cylinder(h=LayerHeight,d=30mmFanDiameter+11);
		translate([-5,0,-Thickness*2]) rotate([45,0,0]) color("pink") cube([40mmFanDiameter,7,7]);
		translate([-5,40,-Thickness*2]) rotate([45,0,0]) color("lightgray") cube([40mmFanDiameter,7,7]);
		translate([-11,0,-Thickness*1.5]) color("purple") cube([7,40mmFanDiameter,7]);
		translate([35,0,-Thickness]) rotate([0,45,0]) color("khaki") cube([7,40mmFanDiameter,7]);
		FanHoleWithOffset(Thickness);
		40mmMount(Thickness);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
